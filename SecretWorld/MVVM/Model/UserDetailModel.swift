//
//  UserDetailModel.swift
//  SecretWorld
//
//  Created by meet sharma on 22/04/24.
//

import Foundation

struct UserDetailModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: UserDetailData?
}

// MARK: - DataClass
struct UserDetailData: Codable {
    let userProfile: UserProfileDetail?
}

// MARK: - UserProfile
struct UserProfileDetail: Codable {
    let id, name,nickName: String?
    let profilePhoto: String?
    let usertype, gender: String?
    let isOnline, blockedByUser, userBlocked: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
        case usertype, gender, isOnline, blockedByUser, userBlocked,nickName
    }
}
