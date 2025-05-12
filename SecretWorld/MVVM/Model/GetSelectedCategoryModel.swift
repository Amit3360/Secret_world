//
//  GetSelectedCategoryModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 28/02/24.
//

import Foundation
// MARK: - GetSelectedCategoryModel
struct GetSelectedCategoryModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetCategoryData?
}

// MARK: - DataClass
struct GetCategoryData: Codable {
    let userservice: [Userservices]?
}

// MARK: - Userservice
struct Userservices: Codable {
    let id, name: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}
