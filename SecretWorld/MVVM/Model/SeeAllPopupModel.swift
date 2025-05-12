//
//  SeeAllPopupModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 15/04/24.
//

import Foundation
// MARK: - SeeAllPopupModel
struct SeeAllPopupModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: PopupData?
}

// MARK: - DataClass
struct PopupData: Codable {
    let totalPages: Int?
    let data: [GetAllPopupsData]?
}

// MARK: - Datum
struct GetAllPopupsData: Codable {
    let id, name: String?
    let businessLogo: String?
    let user: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case businessLogo = "business_logo"
        case user, rating
    }
}

