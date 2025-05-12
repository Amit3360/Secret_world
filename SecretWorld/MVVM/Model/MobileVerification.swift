//
//  MobileVerification.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//

import Foundation

// MARK: - MobileVerification
struct MobileVerification: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetVerficationdata?
}

// MARK: - DataClass
struct GetVerficationdata: Codable {
    let token, otp: String?
    let newUser: NewUser?
}

// MARK: - NewUser
struct NewUser: Codable {
    let id, role, name: String?
    let otp: String?
    let profilePhoto: String?
    let countrycode: String?
    let mobile: Int?
    let usertype, businessname: String?
    let businessID, coverPhoto: String?
    let dob, about, place: String?
    let interests, specialization, dietary: [String]?
    let openingHours, services: [String]?
    let profileStatus: Int?
    let latitude, longitude: Double?
    let logintype, socialNo, socialID, socialType: String?
    let deviceType, deviceName, accountID: String?
    let deviceID: [String]?
    let fcmToken: String?
    let isMobileVerified, isNotification, isApproved, isBlocked: Bool?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?
    let loginOtp, loginOtpExpiryTime: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case role, name, otp
        case profilePhoto = "profile_photo"
        case countrycode, mobile, usertype, businessname
        case businessID = "business_id"
        case coverPhoto = "cover_photo"
        case dob, about, place
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
        case deviceType, deviceName, accountID, fcmToken, isMobileVerified, isNotification, isApproved, isBlocked, isDeleted, createdAt, updatedAt
        case v = "__v"
        case loginOtp, loginOtpExpiryTime
    }
}
