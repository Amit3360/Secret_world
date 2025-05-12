//
//  OtpVerifyModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 14/02/24.
//

import Foundation
// MARK: - OtpVerifyModel
struct OtpVerifyModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetUserDataa?
}

// MARK: - DataClass
struct GetUserDataa: Codable {
    let user: UserDetaill?
}

// MARK: - User
struct UserDetaill: Codable {
    let location: String?
    let id, role: String?
    let name, otp, profilePhoto: String?
    let countrycode: String?
    let mobile: Int?
    let updateMobile, usertype, businessname, businessID: String?
    let coverPhoto, gender, dob, about: String?
    let place: String?
    let interests, specialization, dietary, openingHours: [String]?
    let services: [String]?
    let profileStatus, latitude, longitude: Int?
    let logintype, socialNo, socialID, socialType: String?
    let deviceID, deviceType, deviceName, accountID: String?
    let fcmToken: String?
    let isMobileVerified, isNotification, isApproved, isVerified: Bool?
    let loginStatus, isBlocked, isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?
    let loginOtp, loginOtpExpiryTime: String?

    enum CodingKeys: String, CodingKey {
        case location
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
        case latitude, longitude, logintype, socialNo
        case socialID = "socialId"
        case socialType
        case deviceID = "deviceId"
        case deviceType, deviceName, accountID, fcmToken, isMobileVerified, isNotification, isApproved, isVerified, loginStatus, isBlocked, isDeleted, createdAt, updatedAt
        case v = "__v"
        case loginOtp, loginOtpExpiryTime
    }
}
