//
//  MomentRequestModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 15/04/25.
//


import Foundation

struct MomentRequestModel: Codable {
    let statusCode: Int?
    let message: String?
    let status: String?
    let data: [TaskUserData]?
}

struct TaskUserData: Codable {
    let taskId: String?
    let taskName: String?
    let appliedUsers: [AppliedUser]?
}

struct AppliedUser: Codable {
    let id,role,time,createdAt,taskId: String?
    let gender: String?
    let latitude: String?
    let longitude: String?
    let name,message,requestId: String?
    let profilePhoto: String?
    let distance,overallAverage: Double?
    let taskCompleted: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case gender,role,distance,time,message,requestId,createdAt,taskCompleted,taskId,overallAverage
        case latitude
        case longitude
        case name
        case profilePhoto = "profile_photo"
    }
    
    // Custom decoding to safely handle numbers or strings for latitude/longitude
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? container.decode(String.self, forKey: .id)
        gender = try? container.decode(String.self, forKey: .gender)
        name = try? container.decode(String.self, forKey: .name)
        role = try? container.decode(String.self, forKey: .role)
        time = try? container.decode(String.self, forKey: .time)
        message = try? container.decode(String.self, forKey: .message)
        requestId = try? container.decode(String.self, forKey: .requestId)
        createdAt = try? container.decode(String.self, forKey: .createdAt)
        distance = try? container.decode(Double.self, forKey: .distance)
        profilePhoto = try? container.decode(String.self, forKey: .profilePhoto)
        taskId = try? container.decode(String.self, forKey: .taskId)
        overallAverage = try? container.decode(Double.self, forKey: .overallAverage)
        taskCompleted = try? container.decode(Int.self, forKey: .taskCompleted)
        
        // Handle latitude/longitude that may come as String or Number
        if let latDouble = try? container.decode(Double.self, forKey: .latitude) {
            latitude = String(latDouble)
        } else {
            latitude = try? container.decode(String.self, forKey: .latitude)
        }
        
        if let lonDouble = try? container.decode(Double.self, forKey: .longitude) {
            longitude = String(lonDouble)
        } else {
            longitude = try? container.decode(String.self, forKey: .longitude)
        }
    }
}
