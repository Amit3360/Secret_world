//
//  AllBusinessModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/03/24.
//

import Foundation


// MARK: - AllBusinessModel
struct AllBusinessModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetBusinessesData?
}

// MARK: - DataClass
struct GetBusinessesData: Codable {
    let business: [Businesseess]?
    let reviews: [Reviewess]?
}

// MARK: - Business
struct Businesseess: Codable {
    let id: String?
    let price: Int?
    let users: UsersData?
    let userCategories: UserCategoriesess?
    let openingHours: [OpeningHourrre]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case price, users, userCategories, openingHours
    }
}

// MARK: - OpeningHour
struct OpeningHourrre: Codable {
    let day: String?
    let status: String?
    let starttime, endtime: String?
}


// MARK: - UserCategories
struct UserCategoriesess: Codable {
    let categoryName: String?
    let userSubCategories: [String]?
}

// MARK: - Users
struct UsersData: Codable {
    let businessname: String?
    let businessID, coverPhoto: String?
    let place: String?
    let latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case businessname
        case businessID = "business_id"
        case coverPhoto = "cover_photo"
        case place, latitude, longitude
    }
}

// MARK: - Review
struct Reviewess: Codable {
    let id, userID, businessUserID, comment: String?
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
