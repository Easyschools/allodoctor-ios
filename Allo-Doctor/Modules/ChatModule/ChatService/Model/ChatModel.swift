//
//  ChatModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/01/2025.
//

import Foundation
struct FirstMessage: Codable {
    var receiver_id: Int
    var message: String
    var support_type:String
}
struct ChatMessage: Codable {
    var id: String
    var senderId: String
    var senderName: String
    var message: String
    var timestamp: String
}
struct ChatResponse: Codable {
//    let status: String
    let message: String?
    let chatID: String?
    let messageID: String?
    let senderID: Int?
    let receiverID: Int?

    enum CodingKeys: String, CodingKey {
//        case status
        case message
        case chatID = "chat_id"
        case messageID = "message_id"
        case senderID = "sender_id"
        case receiverID = "receiver_id"
    }
}



struct ChatResponses: Codable {
    let senderId: String? // Make it optional
    let content: String?
    let message: String?
    let timestamp: String?
    let attachment: String?
}

enum chatType:String {
    case doctorType = "doctor_customer_service"
    case customerServiceType = "customer_service"
}


////
////  ChatModel.swift
////  Allo-Doctor
////
////  Created by Abdallah ismail on 02/01/2025.
////
//
//import Foundation
//import UIKit
//
//struct FirstMessage: Codable {
//    var receiver_id: Int
//    var message: String
//    var chat_id: String?
//    var support_type:String
//}
//
//struct FirstAttachment: Codable {
//    var receiver_id: Int
//    var attachment: Data
//    var support_type:String
//}
//
//struct ChatMessage: Codable {
//    var id: String
//    var senderId: String
//    var senderName: String
//    var message: String?
//    var attachment: String?
//    var chatId: String
//    var timestamp: String
//}
//
//struct ChatAttachment:  Codable {
//    var id: String
//    var senderId: String
//    var senderName: String
//    var attachment: Data
//    var timestamp: String
//}
//struct ChatResponse: Codable {
////    let status: String
//    let message: String?
//    let chatID: String?
//    let messageID: String?
//    let senderID: Int?
//    let receiverID: Int?
//    let attachmentUrl: String?
//
//    enum CodingKeys: String, CodingKey {
////        case status
//        case message
//        case chatID = "chat_id"
//        case messageID = "message_id"
//        case senderID = "sender_id"
//        case receiverID = "receiver_id"
//        case attachmentUrl = "attachment_url"
//
//    }
//}
//
//
//struct ChatResponses: Codable {
//    let senderId: String? // Make it optional
//    let content: String?
//    let message: String?
//    let chatId: String?
//    let attachmentUrl: String?
//    let timestamp: String?
//}
//
//enum chatType:String {
//    case doctorType = "doctor_customer_service"
//    case customerServiceType = "customer_service"
//}
