//
//  GetBusinessServiceModel.swift
//  SecretWorld
//
//  Created by meet sharma on 22/02/24.
//

import Foundation

// MARK: - GetBusinessServiceModel
struct GetBusinessServiceModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetBusinessServiceData?
}

// MARK: - GetBusinessServiceData
struct GetBusinessServiceData: Codable {
    let totalPages:Int?
    let service: [ServiceDetail]?
    let user: Userrr?
    let review, gigs: [String]?
}

// MARK: - Service
struct ServiceDetail: Codable {
    let _id, serviceName, description: String?
    let discount: Double?
    let rating,actualPrice,price:Double?
    let serviceImages: [String]?
    let userID, categoryName: String?
    let userSubCategories: [selectedServiceCategories]?

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case serviceName, description, price, rating, serviceImages,discount
        case userID = "user_id"
        case categoryName, userSubCategories,actualPrice
    }
}

// MARK: - User
struct Userrr: Codable {
    let id, name: String?
    let profilePhoto: String?
    let mobile: Int?
    let place: String?
    let latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
        case mobile, place, latitude, longitude
    }
}

struct selectedServiceCategories:Codable{
    let id, name: String?
    let service_id,service_name: String?
    let status: Int?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case service_id, service_name, status, updatedAt
    }
}
