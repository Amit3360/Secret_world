//
//  ItirenaryModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 03/01/25.
//

import Foundation



// MARK: - Welcome
struct ItirenaryModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: ItirenaryData?
}

// MARK: - DataClass
struct ItirenaryData: Codable {
    let items: Int?
    let itineraryCountsByDate: [ItineraryCountsByDate]?
    let itineraries: [Itinerary]?
}

// MARK: - Itinerary
struct Itinerary: Codable {
    let earning: Double?
    let lat, long: Double?
    let itineraryRepeat: String?
    let notes: String?
    let urgent, notificationSent: Bool?
    let id: String?
    let userID: String?
    let gigID, title, description: String?
    let location: String?
    let reminderTime: String?
    let status: String?
    let createdAt, updatedAt: String?
    let v: Int?
    let endTime: String?
    let type: Int?

    enum CodingKeys: String, CodingKey {
        case earning, lat, long
        case itineraryRepeat = "repeat"
        case notes, urgent, notificationSent
        case id = "_id"
        case userID = "userId"
        case gigID = "gigId"
        case title, description, location, reminderTime, status, createdAt, updatedAt
        case v = "__v"
        case endTime, type
    }
}


// MARK: - ItineraryCountsByDate
struct ItineraryCountsByDate: Codable {
    let date: String?
    let count: Int?
}
