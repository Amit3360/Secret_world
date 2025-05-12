//
//  getAppliedGigModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/03/24.
//

import Foundation
// MARK: - getAppliedGigModel
struct getAppliedGigModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: getAppliedGigData?
}
struct getAppliedGigData: Codable {
    let gigs:[GetAppliedData]?
    let totalPages:Int?
}
// MARK: - Datum
struct GetAppliedData: Codable {
    let id: String?
    let status,review,paymentStatus: Int?
    let message: String?
    let gig: GigDett?
    let user: UserDett?
    let rating: Double?
    let category:Category?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status, message, gig, user, rating, review,paymentStatus,category
    }
}

// MARK: - Gig
struct GigDett: Codable {
    let id, usertype, title: String?
    let image: String?
    let price: Double?
    let category:Category?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case usertype, title, image, price,category
    }
}

// MARK: - User
struct UserDett: Codable {
    let id, name, usertype: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, usertype
    }
}
