//
//  UserSelfReviewDetails.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/05/25.
//

import Foundation
struct UserSelfReviewDetails: Codable {
    let statusCode: Int?
    let status: String?
    let message: String?
    let data: ReviewDatas?
}

struct ReviewDatas: Codable {
    let averageRatings: AverageRatings?
}

struct AverageRatings: Codable {
    let id,selfReview: String?
    let avgAttitude: Double?
    let avgCommunication: Double?
    let avgQuality: Double?
    let avgReliability: Double?
    let avgSpeed: Double?
    let overallAverage: Double?
    let totalReviews: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case avgAttitude, avgCommunication, avgQuality, avgReliability, avgSpeed, overallAverage, totalReviews,selfReview
    }
}
