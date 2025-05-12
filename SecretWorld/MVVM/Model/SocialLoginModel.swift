//
//  SocialLoginModel.swift
//  SecretWorld
//
//  Created by meet sharma on 30/04/24.
//

import Foundation
// MARK: - SocialLoginModel
struct SocialLoginModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: SocialLoginData?
}

// MARK: - DataClass
struct SocialLoginData: Codable {
    let token: String?
    let user: UserSocial?
}

// MARK: - User
struct UserSocial: Codable {
    let id, role, name: String?
    let otp: Int?
    let profilePhoto: String?
    let countrycode, mobile, updateMobile: String?
    let usertype: String?
    let businessname, businessID, coverPhoto, gender: String?
    let dob, about, place: String?
    let interests, specialization, dietary, openingHours: [String]?
    let services: [String]?
    let profileStatus: Int?
    let location: Location?
    let latitude, longitude: Double?
    let logintype, socialNo: String?
    let socialID, socialType: String?
    let deviceID, deviceType, deviceName, accountID: String?
    let fcmToken: String?
    let isMobileVerified, isNotification, isApproved, isVerified: Bool?
    let loginStatus, isBlocked, isDeleted, isOnline: Bool?
    let blockedUsers, blockedByUsers: [String]?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case role, name, otp
        case profilePhoto = "profile_photo"
        case countrycode, mobile, updateMobile, usertype, businessname
        case businessID = "business_id"
        case coverPhoto = "cover_photo"
        case gender, dob, about, place
        case interests = "Interests"
        case specialization = "Specialization"
        case dietary = "Dietary"
        case openingHours = "opening_hours"
        case services
        case profileStatus = "profile_status"
        case location, latitude, longitude, logintype, socialNo
        case socialID = "socialId"
        case socialType
        case deviceID = "deviceId"
        case deviceType, deviceName, accountID, fcmToken, isMobileVerified, isNotification, isApproved, isVerified, loginStatus, isBlocked, isDeleted, isOnline, blockedUsers, blockedByUsers, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - Location
struct Location: Codable {
    let type: String?
    let coordinates: [Int]?
}
