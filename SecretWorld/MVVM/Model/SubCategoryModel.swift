//
//  SubCategoryModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 30/01/25.
//

import Foundation

// MARK: - SubCategoryModel
struct SubCategoryModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: SubCategoryData?
}

// MARK: - SubCategoryData
struct SubCategoryData: Codable {
    let subcategorylist: [Subcategory]?
}

// MARK: - Subcategory
struct Subcategory: Codable {
    let id: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}
