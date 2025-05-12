//
//  CompleteGigRequestModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/04/24.
//

import Foundation
// MARK: - CompleteGigRequestModel
struct CompleteGigRequestModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: [GetRequestData]?
}

// MARK: - Datum
struct GetRequestData: Codable {
    let applyuserID, gigID, name: String?
    let profilePhoto: String?
    let gender: String?
    let review: ReviewData?
    enum CodingKeys: String, CodingKey {
        case applyuserID = "applyuserId"
        case gigID = "gigId"
        case name
        case profilePhoto = "profile_photo"
        case gender
        case review
    }
    
}
struct ReviewData: Codable {
    let id: String?
    let comment: String?
    let isDeleted: Bool?
    let isReview: Bool?
    let media: String?
    let starCount: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case comment
        case isDeleted
        case isReview
        case media
        case starCount
    }
}
