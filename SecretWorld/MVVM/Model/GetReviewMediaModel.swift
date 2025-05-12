//
//  GetReviewMediaModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/05/25.
//

import Foundation

// MARK: - Welcome
struct GetReviewMediaModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: MediaData?
}

// MARK: - DataClass
struct MediaData: Codable {
    let page, limit, totalPages: Int?
    let reviewMedia: [ReviewMedia]?
}

// MARK: - ReviewMedia
struct ReviewMedia: Codable {
    let id: String?
    let media,comment: String?
    let rating: Ratingg?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case media,rating,comment
    }
}
// MARK: - Rating Fields
struct Ratingg: Codable {
    let attitude: Double?
    let communication: Double?
    let quality: Double?
    let reliability: Double?
    let speed: Double?
}
