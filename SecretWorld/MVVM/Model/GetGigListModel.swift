//
//  GetGigListModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 08/03/24.
//

import Foundation
// MARK: - GetGigListModel
struct GetGigListModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetGigData?
}

// MARK: - DataClass
struct GetGigData: Codable {
    let response: [GigDetail]?
    let totalPages:Int?
}

// MARK: - Response
struct GigDetail: Codable {
    let id, userID, usertype, name: String?
       let title: String?
       let place: String?
       let lat, long: Double?
       let type: String?
       let image: String?
       let participants: String?
       let review,paymentStatus: Int?
       let about: String?
       let isDeleted: Bool?
       let createdAt, updatedAt: String?
       let v, rating,price: Double?

       enum CodingKeys: String, CodingKey {
           case id = "_id"
           case userID = "userId"
           case usertype, name, title, place, lat, long, type, image, participants, price, about, isDeleted, createdAt, updatedAt
           case v = "__v"
           case rating, review,paymentStatus
       }
   }
