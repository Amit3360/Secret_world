//
//  UploadImageModel.swift
//  SecretWorld
//
//  Created by meet sharma on 16/04/24.
//

import Foundation

// MARK: - UploadImageModel
struct UploadImageModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: ImageData?
}

// MARK: - DataClass
struct ImageData: Codable {
    let imageUrls: [String]?
}
