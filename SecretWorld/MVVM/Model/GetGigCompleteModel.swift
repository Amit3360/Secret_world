//
//  GetGigCompleteModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/03/24.
//

import Foundation
// MARK: - GetGigCompleteModel
struct GetGigCompleteModel: Codable {
    let status: String?
    let message: CompleteGigData?
    let statusCode: Int?
}

// MARK: - Message
struct CompleteGigData: Codable {
    let gigDetails: GigDetails?
}

// MARK: - GigDetails
struct GigDetails: Codable {
    let id, userID, applyuserID, gigID: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case applyuserID = "applyuserId"
        case gigID = "gigId"
        case status, createdAt, updatedAt
        case v = "__v"
    }
}
