//
//  Country.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/01/24.
//

import Foundation
struct Place: Codable {
    let name: String
    let address: String
}

class GooglePlacesAPI {
//    private static let apiKey = "AIzaSyBV343YslRWhvjzOoV9DgUE9Ik1m1If75I"
    
    private static let apiKey = "AIzaSyB8Jo13V8hcS7wKGuRsDbNgM9Fp6TAnCeE"
    private static let baseURL = "https://maps.googleapis.com/maps/api/place/textsearch/json"

    static func getCountriesAndCities(completion: @escaping (Swift.Result<[Place], Error>) -> Void) {
        let input = ""
        let types = "locality"
        let components = "country:IN"

        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "input", value: input),
            URLQueryItem(name: "types", value: types),
            URLQueryItem(name: "components", value: components),
            URLQueryItem(name: "key", value: apiKey)
        ]

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let placesResponse = try decoder.decode([Place].self, from: data)
                completion(.success(placesResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
