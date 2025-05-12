//
//  PloicyTermModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 13/02/24.
//

import Foundation
// MARK: - PloicyTermModel
struct PloicyTermModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetPolicyTermData?
}

// MARK: - WelcomeData
struct GetPolicyTermData: Codable {
    let data: DataData?
}

// MARK: - DataData
struct DataData: Codable {
    let id, content, type: String?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content, type, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}
