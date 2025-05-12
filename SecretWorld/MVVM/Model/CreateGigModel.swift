//
//  CreateGigModel.swift
//  SecretWorld
//
//  Created by meet sharma on 21/05/24.
//

import Foundation

// MARK: - CreateGigModel
struct CreateGigModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: CreateGigData?
}

// MARK: - CreateGigData
struct CreateGigData: Codable {
      let commissionPercent: String?
     let gigID: String?
    let commission:String?
     let url: String?

     enum CodingKeys: String, CodingKey {
         case commission, commissionPercent
         case gigID = "gigId"
         case url
     }
}
