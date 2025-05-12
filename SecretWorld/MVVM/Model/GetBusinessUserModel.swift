//
//  GetBusinessUserModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 12/02/24.
//

import Foundation
// MARK: - GetBusinessUserModel
struct GetBusinessUserModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetBusinessUserDetail?
}

// MARK: - DataClass
struct GetBusinessUserDetail: Codable {
    let userProfile: UserProfiles?
    let serviceCount, gigCount,userRatingCount,postedPopup: Int?
    let UserRating:Double?
    let businessDeals:[businessDeals]?
    let reviews: [Reviewwe]?
}

// MARK: - Review
struct Reviewwe: Codable {
    let id: String?
    let userID: UserID?
    let businessUserID, comment: String?
    let media: String?
    let starCount: Double?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case businessUserID = "businessUserId"
        case comment, media, starCount, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - UserID
struct UserID: Codable {
    let id, name: String?
    let profilePhoto: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
    }
}

// MARK: - UserProfile
struct UserProfiles: Codable {
    let id, name: String?
    let profilePhoto: String?
    let mobile,category: Int?
    let businessname: String?
    let coverPhoto: String?
    let gender, about, place: String?
    let services: [Service]?
    let deals:[String]?
    let dob: String?
    let isVerified:Bool?
    let latitude,longitude:Double?
    let openingHours: [OpeningHourr]?
    let typesOfCategoryDetails:[String]?
    let businessDeals:[businessDeals]?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name,category,isVerified,latitude,longitude
        case profilePhoto = "profile_photo"
        case mobile, businessname
        case coverPhoto = "cover_photo"
        case gender, about, place
        case services = "Services"
        case dob,deals,typesOfCategoryDetails
        case openingHours = "opening_hours"
        case businessDeals
    }
}

// MARK: - OpeningHour
struct OpeningHourr: Codable {
    let id, day, starttime, endtime: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case day, starttime, endtime
    }
}

struct businessDeals:Codable{
    let title:String?
    let bUserServicesIds:[String]?
    enum CodingKeys:String, CodingKey{
        case title,bUserServicesIds
    }
                    
}
// MARK: - Service
struct Service: Codable {
    let id, name: String?
    let subservicesIDS: [String]?
    let status: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case subservicesIDS = "subservices_ids"
        case status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}

