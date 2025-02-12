//
//  ChatViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/12/2024.
//

import Foundation
import Combine
import FirebaseDatabase
import FirebaseAuth

class ChatViewModel {
    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private let apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    private let database = Database.database().reference()
    
    // Published Properties
    @Published var messages: [ChatResponses] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var favData: Favourites?
    
    // State
    private var currentChatId: String?
    private var messageListener: DatabaseHandle?
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
    
    // MARK: - Firebase Chat Methods
    func listenToChatMessages(chatId: String) {
        // Remove existing listener if any
        removeMessageListener()
        
        currentChatId = chatId
        isLoading = true
        
        // Create a reference to the chat messages
        let chatRef = database.child("chats").child(chatId).child("messages")
        
        // Add listener for new messages
        messageListener = chatRef.observe(.childAdded) { [weak self] snapshot in
            guard let self = self,
                  let messageData = snapshot.value as? [String: Any] else {
                print("Failed to parse message data")
                return
            }
            
            do {
                // Convert dictionary to JSON data
                let jsonData = try JSONSerialization.data(withJSONObject: messageData)
                // Decode the message
                let message = try JSONDecoder().decode(ChatResponses.self, from: jsonData)
                
                DispatchQueue.main.async {
                    self.messages.append(message)
                    self.isLoading = false
                    print ( self.messages.count)
                }
            } catch {
                print("Error decoding message: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = error
                }
            }
        }
        
        // Handle cancellation and error callbacks
        chatRef.observe(.value) { [weak self] snapshot in
            self?.isLoading = false
        } withCancel: { [weak self] error in
            self?.isLoading = false
            self?.error = error
            print("Error listening to messages: \(error)")
        }
    }


    
    func sendMessage(_ message: String) {
        guard let chatId = currentChatId else { return }
        
        let messageRef = database.child("chats").child(chatId).child("messages").childByAutoId()
        
        let newMessage = ChatMessage(
            id: messageRef.key ?? UUID().uuidString,
            senderId: "162",
            senderName: Auth.auth().currentUser?.uid ?? "unknown",
            message:message, timestamp: ""
        )
        
        do {
            // Convert message to dictionary
            let messageData = try JSONEncoder().encode(newMessage)
            guard let dictionary = try JSONSerialization.jsonObject(with: messageData) as? [String: Any] else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create message dictionary"])
            }
            
            // Save message to Firebase
            messageRef.setValue(dictionary) { [weak self] error, _ in
                if let error = error {
                    self?.error = error
                    print("Error sending message: \(error)")
                }
            }
        } catch {
            self.error = error
            print("Error encoding message: \(error)")
        }
    }
    
    func removeMessageListener() {
        if let listener = messageListener,
           let chatId = currentChatId {
            database.child("chats").child(chatId).child("messages").removeObserver(withHandle: listener)
            messageListener = nil
        }
    }
    
    // MARK: - API Methods
//    func postFirstMessage(request: ChatResponse) {
//        isLoading = true
//        
//        let router = APIRouter.postMessage
//        apiClient.postData(to: router.url, body: request, as: ChatResponses.self)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.isLoading = false
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    self?.error = error
//                    print("Error: \(error)")
//                }
//            }, receiveValue: { [weak self] response in
//                self?.listenToChatMessages(chatId: response.chatID)
//            })
//            .store(in: &cancellables)
//    }
    
    // MARK: - Cleanup
    func cleanup() {
        removeMessageListener()
        cancellables.removeAll()
    }
    
    deinit {
        cleanup()
    }
}

// MARK: - Helper Methods
extension ChatViewModel {
    func markMessageAsRead(_ messageId: String) {
        guard let chatId = currentChatId else { return }
        
        let messageRef = database.child("chats").child(chatId).child("messages").child(messageId)
        messageRef.updateChildValues(["read": true]) { [weak self] error, _ in
            if let error = error {
                self?.error = error
                print("Error marking message as read: \(error)")
            }
        }
    }
    
//    func getMessageHistory(limit: UInt = 50) {
//        guard let chatId = currentChatId else { return }
//        
//        let chatRef = database.child("chats").child(chatId).child("messages")
//        chatRef.queryOrderedByKey().queryLimited(toLast: limit).observeSingleEvent(of: .value) { [weak self] snapshot in
//            guard let messageList = snapshot.value as? [String: [String: Any]] else { return }
//            
//            let decoder = JSONDecoder()
//            var messages: [ChatMessage] = []
//            
//            for (_, messageData) in messageList {
//                do {
//                    let jsonData = try JSONSerialization.data(withJSONObject: messageData)
//                    let message = try decoder.decode(ChatMessage.self, from: jsonData)
//                    messages.append(message)
//                } catch {
//                    print("Error decoding message history: \(error)")
//                }
//            }
//            
//            DispatchQueue.main.async {
//                self?.messages = messages.sorted { $0.timestamp < $1.timestamp }
//            }
//        }
//    }
}
extension ChatViewModel{
    func navBack(){
        coordinator?.navigateBack()
    }
}
