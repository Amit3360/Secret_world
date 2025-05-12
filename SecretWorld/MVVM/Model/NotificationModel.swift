//
//  NotificationModel.swift
//  SecretWorld
//
//  Created by meet sharma on 28/05/24.
//

import Foundation

// MARK: - NotificationModel
struct NotificationModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: NotificationData?
}

// MARK: - NotificationData
struct NotificationData: Codable {
    let notifications: [Notifications]?
}

// MARK: - Notification
struct Notifications: Codable {
    var id, userID, message, title, gigUser, popUpUser,momentUser: String?
    let status: String?
    var messageDate: Date?
    let isRead, allClear: Bool?
    var popUpId,momentId, createdAt, updatedAt, serviceId: String?
    let v: Int?
    let highlights: [String?]?  // Allowing nullable values inside the array
    let gigId, businessId: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case message, gigUser, title, status, isRead, allClear, createdAt, updatedAt, messageDate, highlights, popUpId, gigId, serviceId, businessId, popUpUser,momentId,momentUser
        case v = "__v"
    }
    
    init(id: String?, userID: String?, message: String?, title: String?, status: String?, isRead: Bool?, allClear: Bool?, createdAt: String?, messageDate: String?, updatedAt: String?, v: Int?, highlights: [String?]?, popUpId: String?, gigId: String?, businessId: String?, popUpUser: String?) {
        self.id = id
        self.userID = userID
        self.message = message
        self.createdAt = createdAt
        self.title = title
        self.status = status
        self.isRead = isRead
        self.allClear = allClear
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.v = v
        self.highlights = highlights
        self.message = message
        self.popUpId = popUpId
        self.gigId = gigId
        self.popUpUser = popUpUser
        self.businessId = businessId
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let messageDate = messageDate, let date = dateFormatter.date(from: messageDate) {
            self.messageDate = date
        } else {
            self.messageDate = nil // Safely handle invalid dates instead of crashing
        }
    }
}
