//
//  CommonModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//

import Foundation

// MARK: - CommonModel
struct CommonModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let otp,momentId,message: String?
    let url,paymentUrl: String?
}
