//
//  AppliedMomentsModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 18/04/25.
//

import Foundation
// MARK: - AppliedMomentsModel
struct AppliedMomentsModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: MomentsData?
}

// MARK: - DataClass
struct MomentsData: Codable {
    let moments: [MomentElement]?
    let totalPages, currentPage, totalCount: Int?
}

// MARK: - Moment
struct MomentElement: Codable {
    let id, userID, usertype, name: String?
    let title, startDate, utcStartDate, endDate: String?
    let tasks: [Taskz]?
    let description, startTime: String?
    let lat, long: Double?
    let location: Locationn?
    let place, type: String?
    let paymentStatus, initialCOMPercentage, comPercentage: Int?
    let commission: Double?
    let hitCount, participants, totalParticipants, status: Int?
    let isDeleted, isCompleted, isCancelled, completedByOwner: Bool?
    let paymentTerms, paymentMethod: Int?
    let hitStats: [String]?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case usertype, name, title, startDate, utcStartDate, endDate, tasks, description, startTime, lat, long, location, place, type, paymentStatus
        case initialCOMPercentage = "initialComPercentage"
        case comPercentage, commission, hitCount, participants, totalParticipants, status, isDeleted, isCompleted, isCancelled
        case completedByOwner = "CompletedByOwner"
        case paymentTerms, paymentMethod, hitStats, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - Location
struct Locationn: Codable {
    let type: String?
    let coordinates: [Double]?
    let exactLocation: Bool?
}

// MARK: - Task
struct Taskz: Codable {
    let role, characterName, castType: String?
    let amount: Int?
    let perPersonAmount: Double?
    let taskDuration, startTime, endTime: String?
    let personNeeded, personAccepted: Int?
    let whatToDO, whatToNot, barterProposal, id: String?

    enum CodingKeys: String, CodingKey {
        case role, characterName, castType, amount, perPersonAmount, taskDuration, startTime, endTime, personNeeded, personAccepted, whatToDO, whatToNot, barterProposal
        case id = "_id"
    }
}

