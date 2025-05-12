//
//  ItemDiscountModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 24/04/25.
//

import Foundation

// MARK: - ItemDiscountModel
struct ItemDiscountModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: ItemDiscountData?
}

// MARK: - DataClass
struct ItemDiscountData: Codable {
    let discounts: [ItemDiscount]?
}

// MARK: - Discount
struct ItemDiscount: Codable {
    let id: String?
    let discountType, discount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case discountType, discount
    }
}
