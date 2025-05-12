//
//  GetDealsModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 05/02/25.
//

import Foundation

// MARK: - GetDealsModel
struct GetDealsModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: [GetDealsData]?
}

// MARK: - Datum
struct GetDealsData: Codable {
    let id, userID: String?
    let bUserServicesIds: [BUserServicesID]?
    let title, description: String?
    let discountPercentage: Int?
    let validTo: String?
    let status: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case bUserServicesIds = "bUserServicesIds"
        case title, description, discountPercentage, validTo, status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - BUserServicesID
struct BUserServicesID: Codable {
    let id, serviceName, description: String?
    let price, discount: Int?
    let serviceImages: [String]?
    let userCategoriesIDS: [String]?
    let userSubcategoriesIDS: [String]?
    let userID: String?
    let status: Int?
    let isDeleted: Bool?
    let hitCount: Int?
    let hitStats: [HitStat]?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case serviceName, description, price, discount, serviceImages
        case userCategoriesIDS = "userCategories_ids"
        case userSubcategoriesIDS = "userSubcategories_ids"
        case userID = "user_id"
        case status, isDeleted, hitCount, hitStats, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - HitStat
struct HitStat: Codable {
    let date: String?
    let count: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case date, count
        case id = "_id"
    }
}
