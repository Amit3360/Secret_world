//
//  TransactionModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 05/09/24.
//

import Foundation
// MARK: - TransactionModel
struct TransactionModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetTransationData?
}

// MARK: - DataClass
struct GetTransationData: Codable {
    let transactionLogs: [TransactionLog]?
}

// MARK: - TransactionLog
struct TransactionLog: Codable {
    let id, transactionID: String?
    let amount: Double?
    let currency: String?
    let type: String?
    let userID: String?
    let isRefund: Bool?
    let status,checkStatus: Int?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case transactionID = "transactionId"
        case amount, currency, type
        case userID = "userId"
        case isRefund, status, createdAt, updatedAt,checkStatus
        case v = "__v"
    }
}
