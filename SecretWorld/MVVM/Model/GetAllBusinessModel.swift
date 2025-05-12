//
//  GetAllBusinessModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 08/03/24.
//

import Foundation
// MARK: - GetAllBusinessModel
struct GetAllBusinessModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetAllBusinessData?
}

// MARK: - DataClass
struct GetAllBusinessData: Codable {
    let business: [Businessdet]?
    let reviews: [Reviewss]?
}

// MARK: - Business
struct Businessdet: Codable {
    let id: String?
    let price: Int?
    let users: Usersdetail?
    let userCategories: UserCategorieses?
    let openingHours: [OpeningHourres]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case price, users, userCategories, openingHours
    }
}

// MARK: - OpeningHour
struct OpeningHourres: Codable {
    let day: String?
    let status: String?
    let starttime, endtime: String?
}

// MARK: - UserCategories
struct UserCategorieses: Codable {
    let categoryName: String?
    let userSubCategories: [String]?
}

// MARK: - Users
struct Usersdetail: Codable {
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
struct Reviewss: Codable {
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
