//
//  FilterTypeModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 13/01/25.
//

import Foundation

// MARK: - FilterTypeModel
struct FilterTypeModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: FilterTypeData?
}

// MARK: - FilterTypeData
struct FilterTypeData: Codable {
    let data: [TypeData]?
    let totalPages: Int?
}

// MARK: - Datum
struct TypeData: Codable {
    let id, name, type, functionID: String?
    let status: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, type
        case functionID = "function_id"
        case status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}
