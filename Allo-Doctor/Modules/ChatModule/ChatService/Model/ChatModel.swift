//
//  ChatModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/01/2025.
//

import Foundation

// MARK: - FirstMessage

struct FirstMessage: Codable {
    var receiver_id: Int
    var message: String
    var support_type: String
}

// MARK: - ChatMessage

struct ChatMessage: Codable {
    var receiver_id : Int
    var sender_id: String
    var sender_name: String
    var chat_id: String?
    var message: String?
    var support_type: String
}

// MARK: - ChatResponse

struct ChatResponse: Codable {
    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        message = try? container.decode(String.self, forKey: .message)
        chatID = try? container.decode(String.self, forKey: .chatID)
        messageID = try? container.decode(String.self, forKey: .messageID)
        senderID = try? container.decode(Int.self, forKey: .senderID)
        receiverID = try? container.decode(Int.self, forKey: .receiverID)
        // Try to decode as String, else set nil
        if let urlString = try? container.decode(String.self, forKey: .attachmentUrl) {
            attachmentUrl = urlString
        } else {
            attachmentUrl = nil
        }
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
//        case status
        case message
        case chatID = "chat_id"
        case messageID = "message_id"
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case attachmentUrl = "attachment_url"
    }

//    let status: String
    let message: String?
    let chatID: String?
    let messageID: String?
    let senderID: Int?
    let receiverID: Int?
    let attachmentUrl: String?
}

// MARK: - ChatResponses

struct ChatResponses: Codable {
    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Try decode senderId as String
        if let str = try? container.decode(String.self, forKey: .senderId) {
            senderId = str
        }
        // If not string, try Int and convert
        else if let intVal = try? container.decode(Int.self, forKey: .senderId) {
            senderId = String(intVal)
        } else {
            senderId = nil
        }

        content = try? container.decode(String.self, forKey: .content)
        message = try? container.decode(String.self, forKey: .message)
        timestamp = try? container.decode(String.self, forKey: .timestamp)
        attachment = try? container.decode(String.self, forKey: .attachment)
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case senderId = "sender_id" 
        case content
        case message
        case timestamp
        case attachment
    }

    let senderId: String?
    let content: String?
    let message: String?
    let timestamp: String?
    let attachment: String?
}

// MARK: - chatType

enum chatType: String {
    case doctorType = "doctor_customer_service"
    case customerServiceType = "customer_service"
}
