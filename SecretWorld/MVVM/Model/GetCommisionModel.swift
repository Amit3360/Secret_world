//
//  GetCommisionModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/09/24.
//

import Foundation
// MARK: - GetCommisionModel
struct GetCommisionModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetComissionData?
}

// MARK: - DataClass
struct GetComissionData: Codable {
    let result: Result?
}

// MARK: - Result
struct Result: Codable {
    let id, commission: String?
    let type: Int?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case commission, type, createdAt, updatedAt
        case v = "__v"
    }
}
