//
//  CreateAccountModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/01/24.
//

import Foundation
// MARK: - CreateAccountModel
struct CreateAccountModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetUserData?
}

// MARK: - DataClass
struct GetUserData: Codable {
    let user: User?
}

// MARK: - User
struct User: Codable {
    let id, role, name: String?
    let profilePhoto: String?
    let countrycode: String?
    let mobile,profile_status: Int?
    let usertype, dob: String?
    let latitude, longitude: Double?
    let logintype, fcmToken: String?
    let isMobileVerified, isBlocked, isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?
    let loginOtp, loginOtpExpiryTime: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case role, name
        case profilePhoto = "profile_photo"
        case countrycode, mobile, usertype,profile_status, dob, latitude, longitude, logintype, fcmToken, isMobileVerified, isBlocked, isDeleted, createdAt, updatedAt
        case v = "__v"
        case loginOtp, loginOtpExpiryTime
    }
}
