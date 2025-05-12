//
//  BankAccountsModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/09/24.
//

import Foundation
// MARK: - BankAccountsModel
struct BankAccountsModel: Codable {
    let message: String?
    let bankAccount: GetBankAccountData?
}

// MARK: - BankAccount
struct GetBankAccountData: Codable {
    let id, object, accountHolderName, accountHolderType: String?
    let accountType: String?
    let bankName, country, currency, customer: String?
    let fingerprint, last4: String?
    let metadata: String?
    let routingNumber, status: String?

    enum CodingKeys: String, CodingKey {
        case id, object
        case accountHolderName = "account_holder_name"
        case accountHolderType = "account_holder_type"
        case accountType = "account_type"
        case bankName = "bank_name"
        case country, currency, customer, fingerprint, last4, metadata
        case routingNumber = "routing_number"
        case status
    }
}
