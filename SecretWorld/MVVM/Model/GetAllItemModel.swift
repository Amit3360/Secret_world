//
//  GetAllItemModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 30/04/25.
//

import Foundation


// MARK: - Welcome
struct GetAllItemModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetAllItemData?
}

// MARK: - DataClass
struct GetAllItemData: Codable {
    let allItems: [AllItem]?
}

// MARK: - AllItem
struct AllItem: Codable {
    let popupID: String?
    let item: Item?

    enum CodingKeys: String, CodingKey {
        case popupID = "popupId"
        case item
    }
}

// MARK: - Item
struct Item: Codable {
    let itemName, itemCategory: String?
    let sellingType, stockType: Int?
    let image: [String]?
    let description: String?
    let isHide: Bool?
    let discountType: Int?
    let id: String?
    let discount,totalStock,sellingPrice:Double?
    let soldItems: Double?

    enum CodingKeys: String, CodingKey {
        case itemName, itemCategory, sellingType, totalStock, stockType, sellingPrice, image, description, isHide, discount, discountType
        case id = "_id"
        case soldItems
    }
}
