//
//  CountryListModel.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/01/24.
//

import Foundation
// MARK: - CountryListModel
struct CountryListModel: Codable {
    let id: Int?
    let name, iso3, iso2, numericCode: String?
    let phoneCode, capital, currency, currencyName: String?
    let currencySymbol, tld, native, region: String?
    let regionID, subregion, subregionID, nationality: String?
    let timezones: [Timezone]?
    let translations: Translations?
    let latitude, longitude, emoji, emojiU: String?
    let states: [State]?

    enum CodingKeys: String, CodingKey {
        case id, name, iso3, iso2
        case numericCode = "numeric_code"
        case phoneCode = "phone_code"
        case capital, currency
        case currencyName = "currency_name"
        case currencySymbol = "currency_symbol"
        case tld, native, region
        case regionID = "region_id"
        case subregion
        case subregionID = "subregion_id"
        case nationality, timezones, translations, latitude, longitude, emoji, emojiU, states
    }
}

// MARK: - State
struct State: Codable {
    let id: Int?
    let name, stateCode, latitude, longitude: String?
    let type: String?
    let cities: [City]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case stateCode = "state_code"
        case latitude, longitude, type, cities
    }
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name, latitude, longitude: String?
}

// MARK: - Timezone
struct Timezone: Codable {
    let zoneName: String?
    let gmtOffset: Int?
    let gmtOffsetName, abbreviation, tzName: String?
}

// MARK: - Translations
struct Translations: Codable {
    let kr, ptBR, pt, nl: String?
    let hr, fa, de, es: String?
    let fr, ja, it, cn: String?
    let tr: String?

    enum CodingKeys: String, CodingKey {
        case kr
        case ptBR = "pt-BR"
        case pt, nl, hr, fa, de, es, fr, ja, it, cn, tr
    }
}

typealias Welcome = [CountryListModel]
