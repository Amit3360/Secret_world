//
//  GetServiceModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 01/02/24.
//

import Foundation


// MARK: - GetServiceModel
struct GetServiceModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetServiceData?
}

// MARK: - DataClass
struct GetServiceData: Codable {
    let servicelist: [Servicelist]?
}

// MARK: - Servicelist
struct Servicelist: Codable {
    let id, name: String?
    let subservicesIDS: [String]?
    let status: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case subservicesIDS = "subservices_ids"
        case status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}
