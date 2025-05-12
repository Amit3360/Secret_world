//
//  GetWalletAmountModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/09/24.
//

import Foundation
// MARK: - GetWalletAmountModel
struct GetWalletAmountModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetWalletData?
}

// MARK: - DataClass
struct GetWalletData: Codable {
    let checkWallet: CheckWallet?
}

// MARK: - CheckWallet
struct CheckWallet: Codable {
    let id, userID, transactionID: String?
    let amount: Double?
    let type: String?
    let status,requestAmount: Int?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case transactionID = "transactionId"
        case amount, requestAmount, type, status, createdAt, updatedAt
        case v = "__v"
    }
}
