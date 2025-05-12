//
//  GetSubServiceModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/04/25.
//

import Foundation

struct GetSubServiceModel: Codable {
    let status: String?
    let message: SubServiceData?
    let statusCode: Int?
}

struct SubServiceData: Codable {
    let name: String?
    let status: Int?
    let isDeleted: Bool?
    let type: Int?
    let id: String?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case name, status, isDeleted, type
        case id = "_id"
        case createdAt, updatedAt
        case v = "__v"
    }
}
