//
//  CreateUserFunctionModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 23/12/24.
//

import Foundation

import Foundation
// MARK: - CreateUserFunctionModel
struct CreateUserFunctionModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: CreateUserFunctionData?
}

// MARK: - DataClass
struct CreateUserFunctionData: Codable {
    let data:Functions?
}


