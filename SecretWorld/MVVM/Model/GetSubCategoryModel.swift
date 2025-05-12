//
//  GetSubCategoryModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 05/02/24.
//

import Foundation
// MARK: - GetSubCategoryModel
struct GetSubCategoryModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetSubCategoryData?
}

// MARK: - DataClass
struct GetSubCategoryData: Codable {
    let subcategorylist: [Subcategorylist]?
}

// MARK: - Subcategorylist
struct Subcategorylist: Codable {
    let id, name: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}
