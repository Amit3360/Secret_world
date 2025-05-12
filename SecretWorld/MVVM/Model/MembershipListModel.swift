//
//  MembershipListModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 09/05/25.
//

import Foundation

// MARK: - MembershipListModel

struct MembershipListModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: MembershipListData?
}

// MARK: - MembershipListData
struct MembershipListData: Codable {
    let data: [MembershipData]?
    let page, limit, totalCount, totalPages: Int?
}

// MARK: - MembershipData
struct MembershipData: Codable {
    let id, userID, name: String?
    let isActive: Bool?
    let plans: [Plan]?
    let services: [ServiceMembership]?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case name, isActive, plans, services
        case v = "__v"
    }
}

// MARK: - Plan
struct Plan: Codable {
    let type: String?
    let price: Double?
    let benefits, id: String?

    enum CodingKeys: String, CodingKey {
        case type, price, benefits
        case id = "_id"
    }
}

// MARK: - Service
struct ServiceMembership: Codable {
    let serviceID, name: String?

    enum CodingKeys: String, CodingKey {
        case serviceID = "serviceId"
        case name
    }
}
