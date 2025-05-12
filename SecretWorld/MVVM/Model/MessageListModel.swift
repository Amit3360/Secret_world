//
//  MessageListModel.swift
//  SecretWorld
//
//  Created by meet sharma on 15/04/24.
//

import Foundation

// MARK: - MessageListModel
struct MessageListModel: Codable {
    let messages: [MessageList]?
    let senderID: String?

    enum CodingKeys: String, CodingKey {
        case messages
        case senderID = "senderId"
    }
}

// MARK: - MessageList
struct MessageList: Codable {
    let id: String?
    let groupID: String?
    let media: [String]?
    let createdAt: String?
    let unreadCount: Int?
    let recipient: RecipientData?
    let group: Group?
    let isRead: Int?
    let isPin: Bool?
    let isMute:Bool?
    let isUserMuted:Bool?
    let isUserPinned:Bool?
    let isArchive:Bool?
    let isUserArchived:Bool?
    let message: String?
    let name: String?
    let image: String?
    let sender: RecipientData?
    let type:String?
    let isMoment:Bool?
    let typeId:String?
    let typeName:String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case groupID = "groupId"
        case media, createdAt, unreadCount, recipient, group, isRead, message, name, image, sender,isPin,isMute,isArchive,type,isUserMuted,isUserPinned,typeId,typeName,isUserArchived,isMoment
    }
}

// MARK: - Group
struct Group: Codable {
    let name: String?
    let participantsNames: [String]?
}

// MARK: - Recipient
struct RecipientData: Codable {
    let id, name: String?
    let isOnline:Bool?
    let profilePhoto: String?
    let role:String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name,isOnline,role
        case profilePhoto = "profile_photo"
    }
}
