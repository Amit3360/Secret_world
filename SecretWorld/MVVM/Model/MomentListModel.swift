//
//  MomentListModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 10/04/25.
//

import Foundation

struct MomentListModel: Codable {
    let status: String?
    let message: String?
    let statusCode: Int?
    let data: MomentListData?  // <-- Changed from [MomentsList]
}

struct MomentListData: Codable {
    let moments: [MomentsList]?
    let totalPages: Int?
}

struct MomentsList: Codable {
    let _id: String?
    let userId, startDate, startTime: String?
    let name: String?
    let title,place: String?
    let tasks: [TaskDetail]?
    let lat: Double?
    let long: Double?
    let type: String?
    let paymentStatus: Int?
    let participants: Int?
}

struct TaskDetail: Codable {
    let role: String?
    let characterName: String?
    let castType: String?
    let paymentTerms: Int?
    let paymentMethod: Int?
    let taskDuration: String?
    let startTime: String?
    let endTime: String?
    let personNeeded: Int?
    let whatToDO: String?
    let whatToNot: String?
    let barterProposal: String?
    let _id: String?
}
