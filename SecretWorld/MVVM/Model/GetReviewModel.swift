//
//  GetReviewModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 05/03/24.
//

import Foundation
// MARK: - GetReviewModel
struct GetReviewModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetReviewData?
}

// MARK: - DataClass
struct GetReviewData: Codable {
    let reviews: [Review]?
}

// MARK: - Review
struct Review: Codable {
    let userId, comment: String?
    let media: String?
    let starCount: Double?
    let createdAt, id, name, place: String?
    let latitude, longitude: Double?
    let profilePhoto: String?

    enum CodingKeys: String, CodingKey {
//        case userID = "userId"
        case comment, media, starCount, createdAt,userId
        case id = "_id"
        case name, place, latitude, longitude
        case profilePhoto = "profile_photo"
    }
}

