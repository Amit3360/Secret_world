//
//  GetMOmentDetailModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 10/04/25.
//

import Foundation

struct GetMOmentDetailModel: Codable {
    let status: String?
    let message: String?
    let statusCode: Int?
    let data: MomentData?
}

struct MomentData: Codable {
    let _id: String?
    let usertype: String?
    let name: String?
    let title,place,address: String?
    let userId:userDetailzz?
    let startDate: String?
    let tasks: [MomentTask]?
    let description: String?
    let startTime: String?
    let lat,ownerReview: Double?
    let long: Double?
    let location: MomentLocation?
    let type: String?
    let paymentStatus,paymentMethod: Int?
    let initialComPercentage: Int?
    let comPercentage: Int?
    let commission: Double?
    let hitCount: Int?
    let participants,totalParticipants: Int?
    let status: Int?
    let isDeleted: Bool?
    let isCompleted: Bool?
    let CompletedByOwner: Bool?
    let hitStats: [String]?
    let createdAt: String?
    let updatedAt: String?
    let __v: Int?
}

struct MomentTask: Codable {
    let appliedParticipantsList: [Participantz]?
    let id: String?
    let amount: Int?
    let barterProposal: String?
    let durationInMinutes: Int?
    let endTime: String?
    let isCompleted: Bool?
    let paymentTerms: Int?
    let perPersonAmount: Double?
    let personAccepted: Int?
    let personNeeded: Int?
    let reviews: [ReviewDataa]?
    let role: String?
    let roleInstruction: String?
    let roleType: Int?
    let startTime: String?
    let taskDuration: String?
    let taskPaymentMethod: Int?
    let taskStatus: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case amount
        case barterProposal
        case durationInMinutes
        case endTime
        case isCompleted
        case paymentTerms
        case perPersonAmount
        case personAccepted
        case personNeeded
        case reviews
        case role
        case roleInstruction
        case roleType
        case startTime
        case taskDuration
        case taskPaymentMethod
        case taskStatus,appliedParticipantsList
    }
}
struct Participantz: Codable {
    let id: String?
    let gender: String?
    let name: String?
    let profilePhoto: String?
    let role: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case gender
        case name
        case profilePhoto = "profile_photo"
        case role
    }
}

struct ReviewDataa: Codable {
    var _id: String?
    let rating: Rating?
    var businessUser: BusinessUserData?
    var comment,media: String?
    var createdAt: String?
    var overallAverage: Double?
    var taskId: String?
}
struct Rating: Codable {
    let attitude: Int?
    let communication: Int?
    let quality: Int?
    let reliability: Int?
    let speed: Int?
}


struct BusinessUserData: Codable {
    var _id: String?
    var name: String?
    var profilePhoto: String?
    
    enum CodingKeys: String, CodingKey {
        case _id, name
        case profilePhoto = "profile_photo"
    }
}

struct userDetailzz: Codable {
    let id: String?
    let gender: String?
    let name: String?
    let profilePhoto: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case gender
        case name
        case profilePhoto = "profile_photo"
    }
}

struct MomentLocation: Codable {
    let type: String?
    let exactLocation:Bool?
    let coordinates: [Double]?
}
