//
//  GetBServiceDetailModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/02/24.
//

import Foundation
// MARK: - GetBServiceDetailModel
struct GetBServiceDetailModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetServiceDetailDataa?
}

// MARK: - DataClass
struct GetServiceDetailDataa: Codable {
    let service: [Servicess]?
    let allservices: [Allservice]?
    let serviceCount: Int?
    let user: Userer?
    let review: [String]?
    let gigs: [Gigss]?
}

// MARK: - Allservice
struct Allservice: Codable {
    let id,serviceName: String?
    let price: Int?
    let serviceImages: [String]?
    let userCategories: UserCategories?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case serviceName, price, serviceImages, userCategories, rating
    }
}
// MARK: - Gig
struct Gigss: Codable {
    let id, userID, usertype, name: String?
    let title, place: String?
    let lat, long: Double?
    let type: String?
    let image: String?
    let participants: String?
    let price: Int?
    let about: String?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v, rating, review: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case usertype, name, title, place, lat, long, type, image, participants, price, about, isDeleted, createdAt, updatedAt
        case v = "__v"
        case rating, review
    }
}
// MARK: - UserCategories
struct UserCategories: Codable {
    let id, categoryName: String?
    let userSubCategories: [UserSubCategory]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case categoryName, userSubCategories
    }
}

// MARK: - UserSubCategory
struct UserSubCategory: Codable {
    let id, subcategoryName: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case subcategoryName
    }
}

// MARK: - Service
struct Servicess: Codable {
    let id, serviceName, description: String?
    let price: Int?
    let serviceImages: [String]?
    let userCategoriesIDS, userSubcategoriesIDS: [String]?
    let userID: String?
    let status,review: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?
    let userCategories: UserCategories?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case serviceName, description, price, serviceImages
        case userCategoriesIDS = "userCategories_ids"
        case userSubcategoriesIDS = "userSubcategories_ids"
        case userID = "user_id"
        case status, isDeleted, createdAt, updatedAt
        case v = "__v"
        case userCategories, rating,review
    }
}

// MARK: - User
struct Userer: Codable {
    let id, name: String?
    let profile_photo: String?
    let mobile: Int?
    let businessname: String?
    let coverPhoto: String?
    let gender, about, place: String?
    let latitude, longitude: Double?
    let dob: String?
    let openingHours: [OpeningHourrr]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profile_photo = "profile_photo"
        case mobile, businessname
        case coverPhoto = "cover_photo"
        case gender, about, place, latitude, longitude, dob
        case openingHours = "opening_hours"
    }
}

// MARK: - OpeningHour
struct OpeningHourrr: Codable {
    let id, day, starttime, endtime: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case day, starttime, endtime
    }
}

