//
//  SearchAllModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 17/04/24.
//

import Foundation

// MARK: - SearchAllModel
struct SearchAllModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetSearchData?
}

// MARK: - DataClass
struct GetSearchData: Codable {
    let data: [SearchList]?
    let totalPages: Int?
}

// MARK: - Datum
struct SearchList: Codable {
    let id, name: String?
    let profilePhoto: String?
    let businessname: String?
    let businessID, coverPhoto: String?
    let place: String?
    let latitude, longitude: Double?
    let status: Int?
    let categoryName: [String]?
    let userRating: Double?
    let userRatingCount: Int?
    let openingHours: [OpeningHourez]?
    let type: String?
    let userID: UserIDUnion?
    let usertype: Usertype?
    let title: String?
    let lat, long: Double?
    let image: String?
    let participants: String?
    let price: Int?
    let about: String?
    let isDeleted, isCompleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?
    let businessLogo: String?
    let description: String?
    let addProducts: [AddProductez]?
    let startDate, endDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
        case businessname
        case businessID = "business_id"
        case coverPhoto = "cover_photo"
        case place, latitude, longitude, status, categoryName
        case userRating = "UserRating"
        case userRatingCount
        case openingHours = "opening_hours"
        case type
        case userID = "userId"
        case usertype, title, lat, long, image, participants, price, about, isDeleted, isCompleted, createdAt, updatedAt
        case v = "__v"
        case businessLogo = "business_logo"
        case description, addProducts, startDate, endDate
    }
}

// MARK: - AddProduct
struct AddProductez: Codable {
    let productName: String?
    let price: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case productName, price
        case id = "_id"
    }
}

enum UserIDUnion: Codable {
    case string(String)
    case userIDClass(UserIDClass)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(UserIDClass.self) {
            self = .userIDClass(x)
            return
        }
        throw DecodingError.typeMismatch(UserIDUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for UserIDUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .userIDClass(let x):
            try container.encode(x)
        }
    }
}

struct OpeningHourez: Codable {
    let day, starttime, endtime: String?
}


// MARK: - UserIDClass
struct UserIDClass: Codable {
    let id, name: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

enum Usertype: String, Codable {
    case bUser = "b_user"
    case businessUser = "business_user"
    case user = "user"
}
