//
//  GetPopupsListModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 12/04/24.
//

import Foundation
// MARK: - GetPopupsListModel
struct GetPopupsListModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetPopupsData?
}

// MARK: - DataClass
struct GetPopupsData: Codable {
    let popups: [Popup]?
    let totalPages: Int?
}

// MARK: - Popup
struct Popup: Codable {
    let id, userID, name, place: String?
    let usertype: String?
    let businessLogo: String?
    let description: String?
    let addProducts: [AddProductz]?
    let lat, long: Double?
    let startDate, endDate: String?
    let status,requests: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v,categoryType: Int?
    let deals:String?
    let rating:Double?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case name, place, usertype
        case businessLogo = "business_logo"
        case description, addProducts, lat, long, startDate, endDate, status, isDeleted, createdAt, updatedAt,rating,requests,deals,categoryType
        case v = "__v"
    }
}

// MARK: - AddProduct
struct AddProductz: Codable {
    let productName: String?
    let price: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case productName, price
        case id = "_id"
    }
}
