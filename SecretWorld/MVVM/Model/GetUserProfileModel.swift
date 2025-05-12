//
//  GetUserProfileModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 09/02/24.
//

import Foundation

// MARK: - GetUserProfileModel
struct GetUserProfileModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: UserProfileData?
}

// MARK: - DataClass
struct UserProfileData: Codable {
    let postedGig, appliedGig,postedPopup: Int?
    let reviews: [Reviewwes]?
    let rating: Double?
    let userProfile: UserProfile?
}

// MARK: - Review
struct Reviewwes: Codable {
    let id: String?
    let userID: UserIDe?
    let gigID, businessUserID, comment: String?
    let media: String?
    let starCount: Double?
    let isDeleted, isReview: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case gigID = "gigId"
        case businessUserID = "businessUserId"
        case comment, media, starCount, isDeleted, isReview, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - UserID
struct UserIDe: Codable {
    let id, name: String?
    let profilePhoto: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
    }
}

// MARK: - UserProfile
struct UserProfile: Codable {
    let id, name: String?
    let profilePhoto: String?
    let mobile: Int?
    let gender, about, place,city,country,zipCode: String?
    let Interests: [Interest]?
    let Dietary: [DietaryPreference]?
    let Specialization: [Specialization]?
    let latitude, longitude: Double?
    let dob: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
        case mobile, gender, about, place
        case latitude, longitude, dob,Interests,Specialization,Dietary,zipCode,country,city
    }
}

struct Interest: Codable {
    let _id: String?
    let name: String?
    let type: String?
    let function_id: String?
    let status: Int?
    let isDeleted: Bool?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case name, type, function_id, status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}

struct DietaryPreference: Codable {
    let _id: String?
    let name: String?
    let type: String?
    let function_id: String?
    let status: Int?
    let isDeleted: Bool?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case name, type, function_id, status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}

struct Specialization: Codable {
    let _id: String?
    let name: String?
    let type: String?
    let function_id: String?
    let userId: String?
    let status: Int?
    let isDeleted: Bool?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case name, type, function_id, userId, status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}

