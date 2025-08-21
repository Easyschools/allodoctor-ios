//
//  ChatViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/12/2024.
//

import Combine
import FirebaseAuth
import FirebaseDatabase
import Foundation

// MARK: - ChatViewModel

class ChatViewModel {
    // MARK: - Properties

    var coordinator: HomeCoordinatorContact?
    private let apiClient: APIClient
    private var cancellables: Set<AnyCancellable> = .init()
    private var sendMessageTask: Task<Void, Never>?
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
        print("sui chat id\(chatId)")

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

                print("the response from firebase ")
                dump(message)
                DispatchQueue.main.async {
                    self.messages.append(message)
                    self.isLoading = false
                    print(self.messages.count)
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
        chatRef.observe(.value) { [weak self] _ in
            self?.isLoading = false
        } withCancel: { [weak self] error in
            self?.isLoading = false
            self?.error = error
            print("Error listening to messages: \(error)")
        }
    }

    func sendMessage(message: String?, attachment: Data?) {
        sendMessageToServer(message: message, attachment: attachment)
    }

    private func sendFirstMessage(_ message: String) {
        let receiverId = UserDefaultsManager.sharedInstance.getUserId() ?? 0
        let request = FirstMessage(
            receiver_id: receiverId,
            message: message,
            support_type: chatType.rawValue
        )
        postFirstMessage(request: request)
    }

    private func sendMessageToServer(message: String?, attachment: Data?) {
        // cancel any previously running send task
        sendMessageTask?.cancel()

        // start a new send task
        sendMessageTask = Task { [weak self] in
            guard let self = self else { return }

            let receiverId = UserDefaultsManager.sharedInstance.getUserId() ?? 0

            let newMessage = ChatMessage(
                receiver_id: receiverId,
                sender_id: self.currentUserId,
                sender_name: Auth.auth().currentUser?.displayName ?? "no there user name ",
                chat_id: self.currentChatId,
                message: message,
                support_type: self.chatType.rawValue
            )

            // mark loading on main actor
            await MainActor.run { self.isLoading = true }

            var imageKey: String? = nil
            var fileName: String? = nil
            if attachment != nil {
                imageKey = "attachment"
                fileName = "photo.png"
            }

            print("new chat of request \n")
            dump(newMessage)

            let router = APIRouter.postMessage

            do {
                // call async version (will use multipart when imageData is non-nil)
                let response: ChatResponse = try await self.apiClient.postDataAsync(
                    to: router.url,
                    body: newMessage,
                    as: ChatResponse.self,
                    imageKey: imageKey,
                    imageData: attachment,
                    fileName: fileName
                )

                // handle success on main actor
                await MainActor.run {
                    self.isLoading = false
                    print("response of send to server is\n")
                    dump(response)

                    if let chatId = response.chatID, self.currentChatId == nil {
                        self.currentChatId = chatId
                        self.isFirstMessage = false
                        self.listenToChatMessages(chatId: chatId)
                    }
                }
            } catch is CancellationError {
                // task was cancelled — stop loading but don't treat as error
                await MainActor.run {
                    self.isLoading = false
                }
                print("sendMessageToServer: cancelled")
            } catch {
                // network or decoding error
                await MainActor.run {
                    self.isLoading = false
                    self.error = error
                }
                print("sendMessageToServer error:", error)
            }
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
        guard let chatId = currentChatId else {
            return
        }

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
