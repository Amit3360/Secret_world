//
//  GetSubServiceLIst.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 15/02/24.
//

import Foundation

// MARK: - GetSubServiceLIst
struct GetSubServiceLIst: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetSubServiceData?
}

// MARK: - DataClass
struct GetSubServiceData: Codable {
    let subservicelist: [Subservicelist]?
}

// MARK: - Subservicelist
struct Subservicelist: Codable {
    let id, name, createdAt, updatedAt: String?
    let service: Service?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, createdAt, updatedAt, service
    }
}
