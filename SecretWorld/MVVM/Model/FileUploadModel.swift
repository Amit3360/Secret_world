//
//  FileUploadModel.swift
//  SecretWorld
//
//  Created by Ideio Soft on 08/04/25.
//

import Foundation

// MARK: - FileUploadModel
struct FileUploadModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: FileUploadData?
}

// MARK: - FileUploadData
struct FileUploadData: Codable {
    let imageUrls: [String]?
}
