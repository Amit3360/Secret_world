//
//  GetServiceDetailUserModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/03/24.
//

import Foundation

// MARK: - GetServiceDetailUserModel
struct GetServiceDetailUserModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetServiceDataaa?
}

// MARK: - DataClass
struct GetServiceDataaa: Codable {
    let id, serviceName, description: String?
    let price: Double?
    let discount:Double?
    let serviceImages: [String]?
    let userCategoriesIDS, userSubcategoriesIDS: [String]?
    let userID: String?
    let status: Int?
    let subcategories: [Subcategoryz]
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let userCategories: UserCategoriese?
    let user: ServiceProvider?
    let reviews: [ReviewService]?
    let rating,actualPrice: Double?
   

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case serviceName, description, price, serviceImages,discount
        case userCategoriesIDS = "userCategories_ids"
        case userSubcategoriesIDS = "userSubcategories_ids"
        case userID = "user_id"
        case status, isDeleted, createdAt, updatedAt, userCategories, user, reviews, rating,actualPrice,subcategories
    }
}
// MARK: - Subcategory Model
struct Subcategoryz: Codable {
    let id: String
    let subcategoryName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case subcategoryName
    }
}
// MARK: - Review
struct ReviewService: Codable {
    let id: String?
    let starCount: Double?
    let comment: String?
    let media: String?
    let createdAt: String?
    let user: ReviewUser?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case starCount, comment, media, createdAt, user
    }
}

// MARK: - ReviewUser
struct ReviewUser: Codable {
    let name: String?
    let profilePhoto,id: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
    }
}

// MARK: - DataUser
struct ServiceProvider: Codable {
    let name: String?
    let profilePhoto: String?
    let mobile: Int?
    let place: String?
    let latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case profilePhoto = "profile_photo"
        case mobile, place, latitude, longitude
    }
}

// MARK: - UserCategories
struct UserCategoriese: Codable {
    let id, categoryName: String?
    let userSubCategories: [UserSubCategoryyy]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case categoryName, userSubCategories
    }
}

// MARK: - UserSubCategory
struct UserSubCategoryyy: Codable {
    let id, subcategoryName: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case subcategoryName
    }
}


