//
//  AnalyticsModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 06/01/25.
//

import Foundation
// MARK: - AnalyticsModel

struct AnalyticsModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: AnalyticsData?
}

// MARK: - DataClass
struct AnalyticsData: Codable {
    let hitCounts: [HitCountHitCount]?
    let totalCount: Int?
    let profile_photo:String?
}


// MARK: - HitCountHitCount
struct HitCountHitCount: Codable {
    let date: String?
    let count: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case date, count
        case id = "_id"
    }
}
