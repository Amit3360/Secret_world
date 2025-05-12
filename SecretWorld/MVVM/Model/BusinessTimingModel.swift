//
//  BusinessTimingModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 02/02/24.
//

import Foundation

struct BusinessTimingModel:Codable{
    var day = ""
    var starttime = ""
    var endtime = ""
    var status = "0"
    enum CodingKeys:String,CodingKey{
        case day,starttime,endtime,status
    }
}
