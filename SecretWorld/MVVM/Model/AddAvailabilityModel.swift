//
//  AddAvailabilityModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/02/24.
//

import Foundation
struct AddAvailabilityModel:Codable{
    var day = ""
    var startTime = ""
    var endTime = ""
    var isStatus = false
    enum CodingKeys:String,CodingKey{
        case day,startTime,endTime,isStatus
    }
}
