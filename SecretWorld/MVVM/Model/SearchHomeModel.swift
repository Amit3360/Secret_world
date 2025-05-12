//
//  SearchHomeModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 21/02/25.
//

import Foundation

// MARK: - SearchHomeModel
struct SearchHomeModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: SearchHomeData?
}

// MARK: - DataClass
struct SearchHomeData: Codable {
    let data: [HomeSearch]?
}

// MARK: - Datum
struct HomeSearch: Codable {
    let tasks:[TaskSearch]?
    let id: String?
    let name: String?
    let profilePhoto: String?
    let businessname: String?
    let businessID: String?
    let coverPhoto: String?
    let place,address: String?
    let latitude, longitude: Double?
    let category: CategoryType?
    let status: Int?
    let buserservices: BuserservicesSearch?
    let userRating: Double?
    let userRatingCount: Int?
    let openingHours: [OpeningHourSearch]?
    let type: String?
    let userID, title, startDate, endDate: String?
    let serviceName: String?
    let skills: [SkillsCategory]?
    let serviceDuration: String?
    let lat, long: Double?
    let image: String?
    let paymentStatus: Int?
    let participants: Int?
    let price: Double?
    let about: String?
    let isDeleted, isCompleted: Bool?
    let seen, isReady: Int?
    let participantsList:[Participantzz]?
    let appliedStatus: String?
    let endSoon: Bool?
    let locationType: String?
    let myGigs: Bool?
    let deals: String?
    let businessLogo: String?
    let description: String?
    let categoryType, hitCount: Int?
//    let addProducts: [Int]?
    let user: User?
    let myPopUp: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
        case businessname
        case businessID = "business_id"
        case coverPhoto = "cover_photo"
        case place, latitude, longitude, category, status, buserservices
        case userRating = "UserRating"
        case userRatingCount
        case openingHours = "opening_hours"
        case type
        case userID = "userId"
        case title, startDate, endDate, serviceName, skills, serviceDuration, lat, long, image, paymentStatus, participants, price, about, isDeleted, isCompleted, seen, isReady, participantsList, appliedStatus, endSoon, locationType, myGigs, deals,address
        case businessLogo = "business_logo"
        case description, categoryType, hitCount, user, myPopUp,tasks
    }
}

// MARK: - Buserservices
struct BuserservicesSearch: Codable {
    let id, serviceName, description: String?
    let price: Double?
    let discount: Int?
    let serviceImages: [String]?
    let userCategoriesIDS: [String]?
    let userSubcategoriesIDS: [String]?
    let userID: String?
    let status: Int?
    let isDeleted: Bool?
    let hitCount: Int?
    let hitStats: [HitStatSearch]?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case serviceName, description, price, discount, serviceImages
        case userCategoriesIDS = "userCategories_ids"
        case userSubcategoriesIDS = "userSubcategories_ids"
        case userID = "user_id"
        case status, isDeleted, hitCount, hitStats, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - HitStat
struct HitStatSearch: Codable {
    let date: String?
    let count: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case date, count
        case id = "_id"
    }
}

enum CategoryUnion: Codable {
    case categoryElement(CategoryElement)
    case integer(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(CategoryElement.self) {
            self = .categoryElement(x)
            return
        }
        throw DecodingError.typeMismatch(CategoryUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CategoryUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .categoryElement(let x):
            try container.encode(x)
        case .integer(let x):
            try container.encode(x)
        }
    }
}

// MARK: - CategoryElement
struct CategoryElement: Codable {
    let id, name, type, functionID: String?
    let status: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, type
        case functionID = "function_id"
        case status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - OpeningHour
struct OpeningHourSearch: Codable {
    let id, day, starttimef, starttime: String?
    let endtimef, endtime, userID: String?
    let status: Int?
    let isDeleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case day, starttimef, starttime, endtimef, endtime
        case userID = "user_id"
        case status, isDeleted, createdAt, updatedAt
        case v = "__v"
    }
}
// MARK: - Task
struct TaskSearch: Codable, Equatable {
    let role: String?
    let characterName: String?
    let castType: String?
    let paymentTerms: Int?
    let paymentMethod: Int?
    let amount: Int?
    let perPersonAmount: Double?
    let taskDuration: String?
    let startTime: String?
    let endTime: String?
    let personNeeded: Int?
    let personAccepted: Int?
    let whatToDO: String?
    let whatToNot: String?
    let barterProposal: String?
    let _id: String?
}
enum TypeEnum: String, Codable {
    case business = "business"
    case gig = "gig"
    case popUp = "popUp"
}

// MARK: - User
struct UserSearch: Codable {
    let name: String?
}
