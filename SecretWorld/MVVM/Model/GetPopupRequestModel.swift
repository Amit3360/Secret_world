//
//  GetPopupRequestModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 15/04/24.
//

import Foundation
// MARK: - GetPopupRequestModel
struct GetPopupRequestModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetPopupRequestData?
}

// MARK: - DataClass
struct GetPopupRequestData: Codable {
    let popuprequests: [Popuprequest]?
    let totalPages: Int?
}

// MARK: - Popuprequest
struct Popuprequest: Codable {
    let id, userID: String?
    let applyuserID: ApplyuserIDz?
    let popupID: String?
    let status: Int?
    let message, createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case applyuserID = "applyuserId"
        case popupID = "popupId"
        case status, message, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - ApplyuserID
struct ApplyuserIDz: Codable {
    let id, name: String?
    let profilePhoto: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
    }
}
