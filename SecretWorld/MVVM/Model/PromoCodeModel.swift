//
//  PromoCodeModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 09/04/24.
//

import Foundation
// MARK: - PromoCodeModel
struct PromoCodeModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: [GetUserPromoCodeData]?
}

// MARK: - GetUserPromoCodeData
struct GetUserPromoCodeData: Codable {
    let discount: Int?
    let id, gigID, applyuserID: String?
    let status: Int?
    let isUsed: Bool?
    let promoCode, expiryTime, createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case discount
        case id = "_id"
        case gigID = "gigId"
        case applyuserID = "applyuserId"
        case status, isUsed, promoCode, expiryTime, createdAt, updatedAt
        case v = "__v"
    }
}
