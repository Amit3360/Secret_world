//
//  VerificationStatusModel.swift
//  SecretWorld
//
//  Created by meet sharma on 21/02/24.
//

import Foundation

// MARK: - Welcome
struct VerificationStatusModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: VerificationStatusData?
}

// MARK: - DataClass
struct VerificationStatusData: Codable {
    let verificationStatus: Int?
}
