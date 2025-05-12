//
//  GetBUserGigsModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 11/03/24.
//

import Foundation
// MARK: - GetBUserGigsModel
struct GetBUserGigsModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: [GigsDetailData]?
}

// MARK: - Datum
struct GigsDetailData: Codable {
    let id, userID, name, title: String?
    let place: String?
    let lat, long: Double?
    let type: String?
    let image: String?
    let participants: String?
    let price,review: Int?
    let about: String?
    let rating:Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case name, title, place, lat, long, type, image, participants, price, about,review,rating
    }
}
