//
//  CheckMomentAddModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 23/04/25.
//

import Foundation
// MARK: - Welcome
struct CheckMomentAddModel: Codable {
    let status, message,paymentUrl: String?
    let isPriceChanged: Bool?
    let highlights: [String]?
    let statusCode: Int?
}
