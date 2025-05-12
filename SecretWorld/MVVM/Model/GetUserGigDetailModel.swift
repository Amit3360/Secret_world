//
//  GetUserGigDetailModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 12/03/24.
//

import Foundation

// MARK: - GetUserGigDetailModel
struct GetUserGigDetailModel: Codable {
    let status: String?
    let message: String?
    let statusCode: Int?
    let data: GetUserGigData?
}

// MARK: - DataClass
struct GetUserGigData: Codable {
    let id: String?
    let status: Int?
    let applyuserID: String?
    let promoCodes: PromoCodes?
    let gig: Giges?
    let appliedParticipants: Int?
    let reviews: [Reviews]?
    let isReview: Bool?
    let rating: Double?
    let role:String?
    let participantsList: [Participantzz]? // Added participants list
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case applyuserID = "applyuserId"
        case promoCodes, gig, appliedParticipants, rating, reviews, isReview, participantsList,role
    }
}

// MARK: - Gig
struct Giges: Codable {
    let usertype: String?
    let name: String?
    let title: String?
    let timeStatus:String?
    let avoidDescription:String?
    let place: String?
    let skills: [CategoryUser]?
    let tools: [String]?
    let serviceDuration: String?
    let serviceName: String?
    let startDate: String?
    let lat: Double?
    let long: Double?
    let type: String?
    let image: String?
    let participants: Int?
    let totalParticipants: Int?
    let price: Double?
    let about: String?
    let createdAt: String?
    let updatedAt: String?
    let user: UserDetailses?
    let distance:Double?
    let startTime:String?
    let category:CategoryUser?
    let isCancellation:Int?
    let safetyTips:String?
    let description:String?
    let dressCode:String?
    let paymentMethod:Int?
    let paymentStatus:Int?
    let paymentTerms:Int?
    let experience:String?
    let address:String?
    let availability:Int?
    let rating:Int?
    enum CodingKeys: String, CodingKey {
        case usertype, name, title, place, serviceDuration, serviceName, startDate
        case lat, long, type, image, participants, totalParticipants, price, about, createdAt, updatedAt, user,distance,startTime,category,skills,tools,isCancellation,safetyTips,description,dressCode,paymentMethod,paymentStatus,paymentTerms,experience,address,avoidDescription,availability,timeStatus,rating
    }
}

// MARK: - User
struct UserDetailses: Codable {
    let id: String?
    let name: String?
    let gender: String?
    let role:String?
    let profilePhoto: String?
    let averageRating:AverageRatingType?
    enum CodingKeys: String, CodingKey {
        case id, name, gender,averageRating,role
        case profilePhoto = "profile_photo"
    }
}

// MARK: - PromoCodes
struct PromoCodes: Codable {
    let id: String?
    let gigID: String?
    let applyuserID: String?
    let status: Int?
    let discount: Int?
    let isViewed: Bool?
    let isUsed: Bool?
    let promoCode: String?
    let expiryTime: String?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case gigID = "gigId"
        case applyuserID = "applyuserId"
        case status, discount, isViewed, isUsed, promoCode, expiryTime, createdAt, updatedAt
        case v = "__v"
    }
}

struct CategoryUser: Codable {
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
struct Reviews: Codable {
    let id: String?
    let comment: String?
    let starCount: Double?
    let media: String?
    let createdAt: String?
    let updatedAt: String?
    let user: UserDetailses?
}

// MARK: - Participant
struct Participantzz: Codable {
    let gender: String?
    let id: String?
    let name: String?
    let profilePhoto: String?

    enum CodingKeys: String, CodingKey {
        case gender, id, name
        case profilePhoto = "profile_photo"
    }
}

// Handle both String and Double for averageRating
enum AverageRatingType: Codable {
    case string(String)
    case double(Double)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(AverageRatingType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid type for averageRating"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}
