//
//  BGigDetailModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 11/03/24.
//
import Foundation

// MARK: - BGigDetailModel
struct BGigDetailModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetGigDetailData?
}

// MARK: - DataClass
struct GetGigDetailData: Codable {
    let id, name, title, startDate: String?
    let startTime, serviceName, experience, address: String?
    let paymentTerms, paymentMethod: Int?
    let skills: [Category]?
    let tools: [String]?
    let dressCode: String?
    let participantsList:[Participantzz]?
    let personNeeded,availability: Int?
    let description, safetyTips,avoidDescription: String?
    let isCancellation: Int?
    let serviceDuration, place: String?
    let lat, long: Double?
    let type: String?
    let timeStatus:String?
    let image: String?
    let paymentStatus: Int?
    let participants, totalParticipants: Int?
    let status: Int?
    let about: String?
    let user: UserDetailes?
    let appliedParticipants: Int?
    let category: Category?
    let distance,price: Double?
    let reviews: [ReviewGigBuser]?
 
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, title, startDate, startTime, serviceName, experience, address, paymentTerms, paymentMethod, skills, tools, dressCode, personNeeded, description, safetyTips, isCancellation, serviceDuration, place, lat, long, type, image, paymentStatus, participants, totalParticipants, price, status, about, user, appliedParticipants, category, distance, reviews,participantsList,avoidDescription,availability,timeStatus
    }
}

// MARK: - Category
struct Category: Codable {
    let id, name, type, functionID: String?
    let status: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, type
        case functionID = "function_id"
        case status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}
// MARK: - Review
struct ReviewGigBuser: Codable {
    let id, gigID, businessUserID: String?
    let comment: String?
    let userID: User?
    let media: String?
    let starCount: Double?
    let isDeleted, isReview: Bool?
    let createdAt, updatedAt: String?
    let v: Int?
    let user: UserDetailes?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case gigID = "gigId"
        case businessUserID = "businessUserId"
        case comment, media, starCount, isDeleted, isReview, createdAt, updatedAt,user
        case v = "__v"
    }
}

// MARK: - User
struct UserDetailes: Codable {
    let id, name, gender: String?
    let profilePhoto: String?
    let lat, long: Double?
    let averageRating:String?
    let role:String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, gender
        case profilePhoto = "profile_photo"
        case lat, long,averageRating,role
    }
}
