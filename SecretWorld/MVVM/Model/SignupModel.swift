//
//  SignupModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 01/02/24.
//

import Foundation
struct SignupModel: Codable {
    var about = ""
    var place = ""
    var lat = Double()
    var long = Double()
    var interests = [String]()
    var specialization = [String]()
    var dietary = [String]()
    
    enum CodingKeys: String, CodingKey {
        case about,place,lat,long
    }
}
struct InterestId: Codable{
    var id = ""
    
    enum CodingKeys: String, CodingKey {
        case id
    }
}
struct SpecializeIds: Codable{
    var id = ""
    
    enum CodingKeys: String, CodingKey {
        case id
    }
}
struct DietaryId: Codable{
    var id = ""
    
    enum CodingKeys: String, CodingKey {
        case id
    }
}
