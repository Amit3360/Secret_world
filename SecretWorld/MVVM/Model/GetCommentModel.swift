//
//  GetCommentModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/05/25.
//

import Foundation

// MARK: - Welcome
struct GetCommentModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: CommentsData?
}

// MARK: - DataClass
struct CommentsData: Codable {
    let page, limit, totalPages: Int?
    let reviewComments: [ReviewComment]?
}

// MARK: - ReviewComment
struct ReviewComment: Codable {
    let id, comment: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case comment
    }
}
