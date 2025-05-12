//
//  GetServiceCategoryModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 05/02/24.
//

import Foundation
// MARK: - GetServiceCategoryModel
struct GetServiceCategoryModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetCategoriesData?
}

// MARK: - DataClass
struct GetCategoriesData: Codable {
    let userservice: [Userservice]?
}

// MARK: - Userservice
struct Userservice: Codable {
    let id, categoryName, serviceID: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case categoryName
        case serviceID = "service_id"
    }
}
