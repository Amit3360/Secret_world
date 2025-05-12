//
//  ReportReasonModel.swift
//  SecretWorld
//
//  Created by meet sharma on 24/04/24.
//

import Foundation

// MARK: - ReportReasonModel
struct ReportReasonModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: ReportReasonData?
}

// MARK: - ReportReasonData
struct ReportReasonData: Codable {
    let reports: [Report]?
}

// MARK: - Report
struct Report: Codable {
    let id, reason: String?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case reason, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}
