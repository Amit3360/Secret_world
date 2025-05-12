//
//  ItemCategoryModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 24/04/25.
//

import Foundation


// MARK: - ItemCategoryModel
struct ItemCategoryModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: ItemCategoryData?
}

// MARK: - DataClass
struct ItemCategoryData: Codable {
    let categories: [CategoryList]?
}

// MARK: - Category
struct CategoryList: Codable {
    let id, name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}
