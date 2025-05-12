//
//  HomeModel.swift
//  SecretWorld
//
//  Created by meet sharma on 22/04/24.
//

import Foundation


// MARK: - HomeModel
struct HomeModel: Codable {
    let data: HomeData?
}

// MARK: - HomeData
struct HomeData: Codable {
    let filteredItems: [FilteredItem]?
    let paymentStatus: Int?
    let completedGigs: [CompletedGig]?
    let notificationsCount: Int?
}

// MARK: - CompletedGig
struct CompletedGig: Codable {
    let id, userID, usertype, name: String?
    let title, place: String?
    let lat, long: Double?
    let type: String?
    let image: String?
    let paymentStatus: Int?
    let participants: IntOrString?
    let totalParticipants: IntOrString?

  //  let totalParticipants,participants: Int?
    let price, status,appliedStatus: Int?
    let about: String?
    let isDeleted, isCancelled, isCompleted: Bool?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case usertype, name, title, place, lat, long, type, image, paymentStatus, participants, totalParticipants, price, status, about, isDeleted, isCancelled, isCompleted, createdAt, updatedAt,appliedStatus
        case v = "__v"
    }
}


// MARK: - FilteredItem
struct FilteredItem: Codable,Equatable {
    let tasks: [Task]?
    let id, userID: String?
    let name: String?
    let title: String?
    let place,address: String?
    let deals:String?
    let endSoon:Bool?
    let lat, long: Double?
    let latitude, longitude: Double?
    let type: String?
    let image: String?
    let categoryName:String?
    let paymentStatus,userRatingCount: Int?
    let participants: Int?
    let status,appliedStatus,isReady: Int?
    let about: String?
    let isDeleted, isCompleted: Bool?
    let seen: Int?
    let price:Double?
    let locationType,groupId: String?
    let myGigs: Bool?
    let profilePhoto: String?
    let businessname: String?
    let businessID, coverPhoto: String?
    let openingHours: [OpeningHourHome]?
    let businessLogo: String?
    let description: String?
    let addProducts: [AddProductHome]?
    let user: UserDetailz?
    let startDate, endDate: String?
    let myPopUp: Bool?
    let categoryType:Int?
    let category: CategoryType?
    let UserRating: Double?
    let skills: [SkillsCategory]?
    let serviceDuration:String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case name, title, place, lat, long, type, image, paymentStatus, participants, price, status, about, isDeleted, isCompleted, seen, locationType, myGigs,appliedStatus,isReady,groupId,userRatingCount,UserRating,categoryName,user,latitude,longitude,deals,endSoon,skills,category,categoryType,serviceDuration,address,tasks
        case profilePhoto = "profile_photo"
        case businessname
        case businessID = "business_id"
        case coverPhoto = "cover_photo"
        case openingHours = "opening_hours"
        case businessLogo = "business_logo"
        case description, addProducts, startDate, endDate, myPopUp
      
    }
}
// MARK: - Task
struct Task: Codable, Equatable {
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

struct SkillsCategory: Codable,Equatable {
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

enum CategoryType: Codable,Equatable {
    static func == (lhs: CategoryType, rhs: CategoryType) -> Bool {
        return true
    }
    
    case intValue(Int)
    case objectValue(Category)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .intValue(intValue)
        } else if let objectValue = try? container.decode(Category.self) {
            self = .objectValue(objectValue)
        } else {
            throw DecodingError.typeMismatch(
                CategoryType.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Category type mismatch")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .intValue(let int):
            try container.encode(int)
        case .objectValue(let object):
            try container.encode(object)
        }
    }
}

// MARK: - AddProduct
struct AddProductHome: Codable ,Equatable{
    let productName: String?
    let price: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case productName, price
        case id = "_id"
    }
}
// MARK: - User
struct UserDetailz: Codable,Equatable {
    let name: String?
}
// MARK: - OpeningHour
struct OpeningHourHome: Codable ,Equatable{
    let day: String?
    let starttime, endtime: String?
}
struct IntOrString: Codable {
    let value: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            value = intVal
        } else if let stringVal = try? container.decode(String.self),
                  let intFromString = Int(stringVal) {
            value = intFromString
        } else {
            value = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = value {
            try container.encode(value)
        } else {
            try container.encodeNil()
        }
    }
}
