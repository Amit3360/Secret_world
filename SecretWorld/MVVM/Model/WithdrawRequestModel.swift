//
//  WithdrawRequestModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/09/24.
//

import Foundation
// MARK: - WithdrawRequestModel
struct WithdrawRequestModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: WithdrawalRequestData?
}

// MARK: - DataClass
struct WithdrawalRequestData: Codable {
    let withdrawalRequest: WithdrawalRequest?
}

// MARK: - WithdrawalRequest
struct WithdrawalRequest: Codable {
    let userID, walletID: String?
    let requestAmount: Int?
    let status, adminComment, id, createdAt: String?
    let updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case walletID = "walletId"
        case requestAmount, status, adminComment
        case id = "_id"
        case createdAt, updatedAt
        case v = "__v"
    }
}

