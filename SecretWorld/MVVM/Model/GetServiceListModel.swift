//
//  GetServiceListModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 15/02/24.
//

import Foundation
// MARK: - GetServiceListModel
struct GetServiceListModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetServiceListData?
}

// MARK: - DataClass
struct GetServiceListData: Codable {
    let servicelist: [Servicelists]?
}

// MARK: - Servicelist
struct Servicelists: Codable {
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
