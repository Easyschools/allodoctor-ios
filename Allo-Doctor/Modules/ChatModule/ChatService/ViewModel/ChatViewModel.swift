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
    @Published var chatType: chatType
    
    // State
    private var currentChatId: String?
    private var messageListener: DatabaseHandle?
    private var isFirstMessage: Bool = true
    private var isFirstAttachment: Bool = true

    private var photoUrl = ""
    private let currentUserId = Auth.auth().currentUser?.uid ?? "162"
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), chatType: chatType) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.chatType = chatType
    }
    
    // MARK: - Firebase Chat Methods
    func listenToChatMessages(chatId: String) {
        // Remove existing listener if any
        removeMessageListener()

        currentChatId = chatId
        isLoading = true
        print("sui chat id listen------\(chatId)")

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
                print(message,self.messages.last?.chatId ?? "non chat id")
                DispatchQueue.main.async {
                    self.messages.append(message)
                    self.isLoading = false
                    print(self.messages.count)

                 //   print("load image::::::::: \(message.attachmentUrl ?? "no attachment ")")
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
        if isFirstMessage {
            // Send first message via API
            sendFirstMessage(message)
        } else {
            // Send subsequent messages to Firebase
            sendMessageToFirebase(message)
        }
    }

    func sendAttachment(_ data: Data) {
        if isFirstAttachment {
            // Send first message via API
            sendFirstAttachment(data)
        } else {
            // Send subsequent messages to Firebase
            sendAttachmentToFirebase(photoUrl)
        }
    }



    private func sendFirstMessage(_ message: String) {
        let receiverId = UserDefaultsManager.sharedInstance.getUserId() ?? 0
        let request = FirstMessage(
            receiver_id: receiverId,
            message: message,
            support_type: self.chatType.rawValue
        )
        
        postFirstMessage(request: request)
    }

    private func sendFirstAttachment(_ data: Data) {
        let receiverId = UserDefaultsManager.sharedInstance.getUserId() ?? 0
        
        let request = FirstAttachment(
            receiver_id: receiverId,
            attachment: data,
            support_type: self.chatType.rawValue
        )

        postFirstAttachment(request: request)
    }



    private func sendMessageToFirebase(_ message: String) {
        guard let chatId = currentChatId else { return }
        
        let messageRef = database.child("chats").child(chatId).child("messages").childByAutoId()
        
        let newMessage = ChatMessage(
            id: messageRef.key ?? UUID().uuidString,
            senderId: currentUserId,
            senderName: Auth.auth().currentUser?.displayName ?? "",
            message: message,
            timestamp: String(Date().timeIntervalSince1970)
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


    private func sendAttachmentToFirebase(_ attachmentUrl: String) {
        guard let chatId = currentChatId else { return }

        let messageRef = database.child("chats").child(chatId).child("messages").childByAutoId()

        let newMessage = ChatMessage(
            id: messageRef.key ?? UUID().uuidString,
            senderId: currentUserId,
            senderName: Auth.auth().currentUser?.displayName ?? "",
            attachmentUrl: attachmentUrl,
            timestamp: String(Date().timeIntervalSince1970)
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
    func postFirstMessage(request: FirstMessage) {
        isLoading = true
        
        let router = APIRouter.postMessage
        apiClient.postData(to: router.url, body: request, as: ChatResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                // Update chat ID from response and start listening
                if let chatId = response.chatID {
                    self?.currentChatId = chatId
                    self?.isFirstMessage = false
                    self?.listenToChatMessages(chatId: chatId)
                }
            })
            .store(in: &cancellables)
    }

    func postFirstAttachment(request: FirstAttachment) {
        isLoading = true

        let router = APIRouter.postMessage

        apiClient.postData(to:router.url, body: request, as: ChatResponse.self, imageKey: "attachment", imageData: request.attachment, fileName: "photo.png")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] response in

               // print(response)
                // Update chat ID from response and start listening
                if let chatId = response.chatID {
                    self?.currentChatId = chatId
                    self?.isFirstMessage = false

                    self?.photoUrl = response.attachmentUrl ?? ""
                    self?.sendAttachmentToFirebase(self?.photoUrl ?? "")
                    print("the image is : \(self?.photoUrl)")
                    self?.listenToChatMessages(chatId: chatId)
                }

            })
            .store(in: &cancellables)
    }


    // MARK: - Helper Methods
    func isCurrentUserMessage(_ message: ChatResponses) -> Bool {
        // Debug logging to see what's happening
        print("🔍 Debug - Current User ID: \(currentUserId)")
        print("🔍 Debug - Message Sender ID: \(message.senderId ?? "nil")")
        print("🔍 Debug - UserDefaults ID: \(UserDefaultsManager.sharedInstance.getUserId() ?? 0)")
        
        // If senderId is nil or empty, it's a received message (from support/doctor)
        guard let senderId = message.senderId, !senderId.isEmpty else {
            return false
        }
        
        // Check if it's the current user's ID
        if senderId == currentUserId {
            return true

        }

        print("\nchat id is \(senderId) equal? \(currentUserId)")

        // Check against UserDefaults ID (convert to string for comparison)
        let userIdFromDefaults = String(UserDefaultsManager.sharedInstance.getUserId() ?? 0)
        if senderId == userIdFromDefaults {
            return true
        }
        
        return false
    }
    
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
}

extension ChatViewModel {
    func navBack() {
        coordinator?.navigateBack()
    }
}
