//
//  GroupChatModel.swift
//  SecretWorld
//
//  Created by meet sharma on 29/05/24.
//

import Foundation

// MARK: - GroupChatModel
struct GroupChatModel: Codable {
    let isReady,profileHide,completeGig: Int?
    var groupChatDetails: [GroupChatDetail]?
    
    enum CodingKeys: String, CodingKey {
        case isReady, groupChatDetails,profileHide,completeGig
    }
}

struct GroupChatDetail: Codable {
    let id, message: String?
    let group: GroupChat?
    let media: [String]?
    var createdAt: String?
    let gig: GigGroup?
    let sender, receiver: Receiver?
    var messageDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case message, createdAt, group, gig, receiver, messageDate, sender, media
    }
    
    init(id: String?, message: String?, createdAt: String?, messageDate: String?, group: GroupChat?, gig: GigGroup?, receiver: Receiver?, sender: Receiver?, media: [String]?) {
        self.id = id
        self.createdAt = createdAt
        self.group = group
        self.gig = gig
        self.receiver = receiver
        self.message = message
        self.sender = sender
        self.media = media
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let messageDate = messageDate, let date = dateFormatter.date(from: messageDate) {
            self.messageDate = date
        } else {
            self.messageDate = nil
        }
    }
}

// MARK: - GigGroup
struct GigGroup: Codable {
    let _id:String?
    let title: String?
    let image: String?
}

// MARK: - GroupChat
struct GroupChat: Codable {
    
    let id, name: String?
    let participantDetails: [Receiver]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, participantDetails
    }
}

// MARK: - Receiver
struct Receiver: Codable {
    let id, name: String?
    let profilePhoto: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
    }
}
