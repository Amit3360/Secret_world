//
//  UserFunctionsModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/01/24.
//

import Foundation
// MARK: - UserFunctionsModel
struct UserFunctionsModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetUserFunctionsData?
}

// MARK: - DataClass
struct GetUserFunctionsData: Codable {
    let data: [Functions]?
}

// MARK: - Datum
struct Functions: Codable {
    let _id, name, type, functionID: String?
    let status: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case name, type
        case functionID = "function_id"
        case status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}
