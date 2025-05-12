//
//  BankAccountDetailModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 05/09/24.
//

import Foundation
// MARK: - BankAccountDetailModel
struct BankAccountDetailModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: GetBankData?
}

// MARK: - DataClass
struct GetBankData: Codable {
    let externalAccounts: ExternalAccounts?
}

// MARK: - ExternalAccounts
struct ExternalAccounts: Codable {
    let object: String?
    let data: [BankAccountDetailData]?
    let hasMore: Bool?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case object, data
        case hasMore = "has_more"
        case url
    }
}

// MARK: - Datum
struct BankAccountDetailData: Codable {
    let id, object, account, accountHolderName: String?
    let accountHolderType: String?
    let accountType: String?
    let availablePayoutMethods: [String]?
    let bankName, country, currency: String?
    let defaultForCurrency: Bool?
    let financialAccount: String?
    let fingerprint: String?
    let futureRequirements: Requirements?
    let last4: String?
    let metadata: Metadata?
    let requirements: Requirements?
    let routingNumber, status: String?

    enum CodingKeys: String, CodingKey {
        case id, object, account
        case accountHolderName = "account_holder_name"
        case accountHolderType = "account_holder_type"
        case accountType = "account_type"
        case availablePayoutMethods = "available_payout_methods"
        case bankName = "bank_name"
        case country, currency
        case defaultForCurrency = "default_for_currency"
        case financialAccount = "financial_account"
        case fingerprint
        case futureRequirements = "future_requirements"
        case last4, metadata, requirements
        case routingNumber = "routing_number"
        case status
    }
}

// MARK: - Requirements
struct Requirements: Codable {
    let currentlyDue, errors, pastDue, pendingVerification: [String]?

    enum CodingKeys: String, CodingKey {
        case currentlyDue = "currently_due"
        case errors
        case pastDue = "past_due"
        case pendingVerification = "pending_verification"
    }
}
// MARK: - Metadata
struct Metadata: Codable {
}
