//
//  GetUserExploreModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/03/24.
//

import Foundation

// MARK: - GetUserExploreModel
struct GetUserExploreModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetExploreData?
}

// MARK: - DataClass
struct GetExploreData: Codable {
    let business: [Business]?
    let gigs: [Gig]?
    let temporaryStores: [TemporaryStores]?

    enum CodingKeys: String, CodingKey {
        case business, gigs
        case temporaryStores = "TemporaryStores"
    }
}
// MARK: - Popup
struct TemporaryStores: Codable {
    let id, usertype: String?
    let businessLogo,name: String?
    let description: String?
    let addProducts: [AddProduct]?
    let userId: PopupUser?
    let lat, long: Double?
    let startDate, endDate: String?
    let status: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case usertype
        case businessLogo = "business_logo"
        case description, addProducts, lat, long, startDate, endDate, status, isDeleted, createdAt, updatedAt,name,userId
        case v = "__v"
    }
}
struct PopupUser: Codable {
       let id: String?
       let name: String?
   }
// MARK: - AddProduct
struct AddProduct: Codable {
    let productName: String?
    let price: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case productName, price
        case id = "_id"
    }
}

// MARK: - Business
struct Business: Codable {
    let id, name: String?
    let profilePhoto: String?
    let businessname: String?
    let businessID, coverPhoto: String?
    let place: String?
    let openingHours: [OpeningHours]?
    let latitude, longitude: Double?
    let status: Int?
    let categoryName: [String]?
    let userRating: Double?
    let userRatingCount: Int?
    let distance: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
        case businessname
        case businessID = "business_id"
        case coverPhoto = "cover_photo"
        case place
        case openingHours = "opening_hours"
        case latitude, longitude, status, categoryName
        case userRating = "UserRating"
        case userRatingCount, distance
    }
}

// MARK: - OpeningHour
struct OpeningHours: Codable {
    let day, starttime, endtime: String?
}

// MARK: - Gig
struct Gig: Codable {
    let id, userID, usertype, name: String?
    let title, place: String?
    let lat, long,UserRating: Double?
    let type: String?
    let image: String?
    let participants: String?
    let price: Double?
    let about: String?
    let isDeleted, isCompleted: Bool?
    let createdAt, updatedAt: String?
    let v,userRatingCount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case usertype, name, title, place, lat, long, type, image, participants, price, about, isDeleted, isCompleted, createdAt, updatedAt,userRatingCount,UserRating
        case v = "__v"
    }
}
