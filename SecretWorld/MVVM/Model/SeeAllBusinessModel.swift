//
//  SeeAllBusinessModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 26/03/24.
//

import Foundation
// MARK: - SeeAllBusinessModel
struct SeeAllBusinessModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetAllBusinessDataa?
}

// MARK: - DataClass
struct GetAllBusinessDataa: Codable {
    let business: [Businessss]?
    let totalPages:Int?

    enum CodingKeys: String, CodingKey {
        case business,totalPages
    }
}

// MARK: - Business
struct Businessss: Codable {
    let id, name: String?
    let profilePhoto: String?
    let businessname: String?
    let businessID, coverPhoto: String?
    let place: String?
    let openingHours: [OpeningHourrs]?
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
        case latitude, longitude, status, categoryName,openingHours
        case userRating = "UserRating"
        case userRatingCount, distance
    }
}

// MARK: - OpeningHour
struct OpeningHourrs: Codable {
    let day, starttime, endtime: String?
}

