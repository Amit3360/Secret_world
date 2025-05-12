//
//  GetUserParticipantsModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 12/03/24.
//

import Foundation

// MARK: - GetUserParticipantsModel
struct GetUserParticipantsModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: [GetParticipantsData]?
}

// MARK: - Datum
struct GetParticipantsData: Codable {
    let id, userID: String?
    let applyuserID: ApplyuserID?
    let gigID: String?
    let status: Int?
    let message, createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case applyuserID = "applyuserId"
        case gigID = "gigId"
        case status, message, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - ApplyuserID
struct ApplyuserID: Codable {
    let id, name: String?
    let profilePhoto: String?
    let gender: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
        case gender
    }
}


