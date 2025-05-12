//
//  SelfReviewModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 01/05/25.
//

import Foundation

struct SelfReviewModel: Codable {
    let statusCode: Int?
    let status: String?
    let message: String?
    let data: SelfReviewData?
}

struct SelfReviewData: Codable {
    let review: Reviewz?
}

struct Reviewz: Codable {
    let id: String?
    let name: String?
    let profilePhoto: String?
    let selfReview: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
        case selfReview
    }
}
