//
//  GetHelpCenterModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 13/02/24.
//

import Foundation
// MARK: - GetHelpCenterModel
struct GetHelpCenterModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetHelpCenterData?
}

// MARK: - DataClass
struct GetHelpCenterData: Codable {
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id, question, answer, type: String?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case question, answer, type, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}
