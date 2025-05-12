//
//  MyPopUpModel.swift
//  SecretWorld
//
//  Created by meet sharma on 20/05/24.
//

import Foundation
import GoogleMaps

// Step 1: Define your Codable model
struct MyModel: Codable {
    // Store necessary information about the marker
    var latitude: Double
    var longitude: Double


    // Provide custom initialization from GMSMarker
    init(marker: GMSMarker?) {
        self.latitude = marker?.position.latitude ?? 0
        self.longitude = marker?.position.longitude ?? 0

    }

    // Define CodingKeys for the properties
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude

    }

    // Create a method to create a GMSMarker from the stored information
    func createMarker() -> GMSMarker {
        let position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let marker = GMSMarker(position: position)
        // Customize marker properties if needed
        return marker
    }
}

// Step 2: Save your Codable model to UserDefaults
func saveModelToUserDefaults(model: [MyModel]) {
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(model)
        UserDefaults.standard.set(data, forKey: "myModel")
    } catch {
        print("Error encoding model: \(error.localizedDescription)")
    }
}

// Step 3: Retrieve your Codable model from UserDefaults
func retrieveModelFromUserDefaults() -> [MyModel]? {
    if let data = UserDefaults.standard.data(forKey: "myModel") {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode([MyModel].self, from: data)
            return model
        } catch {
            print("Error decoding model: \(error.localizedDescription)")
        }
    }
    return nil
}
