//
//  GetGroupParticipantModel.swift
//  SecretWorld
//
//  Created by meet sharma on 03/06/24.
//

import Foundation
// MARK: - Welcome
struct GetGroupParticipantModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetGroupParticipantData?
}

// MARK: - DataClass
struct GetGroupParticipantData: Codable {
    let participants: [Participant]?
}

// MARK: - Participant
struct Participant: Codable {
    let role, name: String?
    let otp: String?
    let profilePhoto: String?
    let countrycode: String?
    let mobile: Int?
    let updateMobile: String?
    let usertype: String?
    let businessname: String?
    let businessID, coverPhoto: String?
    let gender, dob, about, place: String?
    let status: Int?
    let interests, specialization, dietary, openingHours: [String]?
    let services: [String]?
    let profileStatus: Int?
    let location: LocationGroup?
    let latitude, longitude: Double?
    let logintype, socialNo, socialID, socialType: String?
    let deviceID: DeviceID?
    let deviceType: String?
    let deviceName, accountID, fcmToken: String?
    let customerID: String?
    let isMobileVerified, isNotification, isApproved, isVerified: Bool?
    let loginStatus, isBlocked, isDeleted, isOnline: Bool?
    let blockedUsers, blockedByUsers: [String]?
    let createdAt, updatedAt: String?
    let v: Int?
    let loginOtp, loginOtpExpiryTime, token: String?

    enum CodingKeys: String, CodingKey {
        case role, name, otp
        case profilePhoto = "profile_photo"
        case countrycode, mobile, updateMobile, usertype, businessname
        case businessID = "business_id"
        case coverPhoto = "cover_photo"
        case gender, dob, about, place, status
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
        case deviceType, deviceName, accountID, fcmToken
        case customerID = "customerId"
        case isMobileVerified, isNotification, isApproved, isVerified, loginStatus, isBlocked, isDeleted, isOnline, blockedUsers, blockedByUsers, createdAt, updatedAt
        case v = "__v"
        case loginOtp, loginOtpExpiryTime, token
    }
}
enum DeviceID: Codable {
    case anythingArray([String])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .anythingArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(DeviceID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DeviceID"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .anythingArray(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Location
struct LocationGroup: Codable {
    let type: String?
    let coordinates: [Double]?
}


//// MARK: - GetGroupParticipantModel
//struct GetGroupParticipantModel: Codable {
//    let data: GetGroupParticipantData?
//    let statusCode: Int?
//    let status: String?
//    let message: String?
//}
//
//// MARK: - DataClass
//struct GetGroupParticipantData: Codable {
//    let participants: [Participant]?
//}
//
//
//// MARK: - ParticipantsDatum
//struct Participant: Codable {
//    let id, role, name: String?
//    let otp: Int?
//    let profilePhoto: String?
//    let countrycode: String?
//    let mobile: Int?
//    let updateMobile: String?
//    let usertype: String?
//    let businessname: String?
//    let businessID, coverPhoto: String?
//    let gender, dob, about, place: String?
//    let interests, specialization, dietary, openingHours: [String]?
//    let services: [String]?
//    let profileStatus: Int?
//    let location: LocationGroup?
//    let latitude, longitude: Double?
//    let logintype, socialNo, socialID, socialType: String?
//    let deviceType: String?
//    let deviceID: [String]?
//    let deviceName, accountID, fcmToken: String?
//    let customerID: String?
//    let isMobileVerified, isNotification, isApproved, isVerified: Bool?
//    let loginStatus, isBlocked, isDeleted, isOnline: Bool?
//    let blockedUsers, blockedByUsers: [String]?
//    let createdAt, updatedAt: String?
//    let v: Int?
//    let loginOtp, loginOtpExpiryTime, token: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case role, name, otp
//        case profilePhoto = "profile_photo"
//        case countrycode, mobile, updateMobile, usertype, businessname
//        case businessID = "business_id"
//        case coverPhoto = "cover_photo"
//        case gender, dob, about, place
//        case interests = "Interests"
//        case specialization = "Specialization"
//        case dietary = "Dietary"
//        case openingHours = "opening_hours"
//        case services
//        case profileStatus = "profile_status"
//        case location, latitude, longitude, logintype, socialNo
//        case socialID = "socialId"
//        case socialType
//        case deviceID = "deviceId"
//        case deviceType, deviceName, accountID, fcmToken
//        case customerID = "customerId"
//        case isMobileVerified, isNotification, isApproved, isVerified, loginStatus, isBlocked, isDeleted, isOnline, blockedUsers, blockedByUsers, createdAt, updatedAt
//        case v = "__v"
//        case loginOtp, loginOtpExpiryTime, token
//    }
//}
//
//// MARK: - Location
//struct LocationGroup: Codable {
//    let type: String?
//    let coordinates: [Double]?
//}
