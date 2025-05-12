//
//  GetAllGigsListModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 13/03/24.
//

import Foundation

// MARK: - GetAllGigsListModel
struct GetAllGigsListModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetGigsListData?
}

// MARK: - DataClass
struct GetGigsListData: Codable {
    let gigs: [Gigess]?
    let totalPages: Int?
}

// MARK: - Gig
struct Gigess: Codable {
    let id, title: String?
    let image: String?
    let reviewCount,paymentStatus,status: Int?
    let user: UserDet?
    let category: Category?
    let avgStarCount,price: Double?
    let gigrequests: [Gigrequest]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, image, price, user, avgStarCount, reviewCount, gigrequests,paymentStatus,status,category
    }
}

// MARK: - Gigrequest
struct Gigrequest: Codable {
    let id, userID, applyuserID, gigID: String?
    let status: Int?
    let message, createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case applyuserID = "applyuserId"
        case gigID = "gigId"
        case status, message, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - User
struct UserDet: Codable {
    let id, name: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

