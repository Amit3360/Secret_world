//
//  SelectCityVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//

import UIKit
import GooglePlaces
class SelectCityVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet var txtFldCity: UITextField!
    @IBOutlet var vwShadow: UIView!
    
    //MARK: - VARIBALES
    var cityName:String?
    var shortCityName:String?
    var callBack:((_ cityName:String?,_ lat:Double?,_ long:Double?,_ zipCode:String?,_ country:String?,_ placeName:String?)->())?
    var latitude = Double()
    var longitude = Double()
    var zipcode:String?
    var placeName:String?
    var country:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        txtFldCity.text = cityName
        print("shortCityName:--\(shortCityName ?? "")")
        vwShadow.layer.cornerRadius = 25
        vwShadow.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupOverlayView()
    }
    func setupOverlayView() {
        vwShadow = UIView(frame: self.view.bounds)
        vwShadow.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        vwShadow.addGestureRecognizer(tapGesture)
        self.view.insertSubview(vwShadow, at: 0)
    }
    @objc func overlayTapped() {
        self.dismiss(animated: true)
    }
    
    //MARK: - BUTTON ACTIONso
    @IBAction func actionSave(_ sender: UIButton) {
        if txtFldCity.text  == ""{
            showSwiftyAlert("", "Select city", false)
        }else{
            self.dismiss(animated: true)
            callBack?(cityName,latitude,longitude, zipcode,country,placeName)
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
}

//MARK: - GMSAutocompleteViewControllerDelegate
extension SelectCityVC: GMSAutocompleteViewControllerDelegate {
//    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Store latitude & longitude
        if place.coordinate.latitude.description.count != 0 {
            self.latitude = place.coordinate.latitude
        }
        if place.coordinate.longitude.description.count != 0 {
            self.longitude = place.coordinate.longitude
        }
        txtFldCity.text = place.formattedAddress
        
        // Extract Place Name (Primary Name)
        let placeName = place.name

        // Extract City Name, ZIP Code, and Country
        var cityName: String?
        var stateName: String?
        var zipCode: String?
        var countryName: String?
        
        if let addressComponents = place.addressComponents {
            for component in addressComponents {
                if component.types.contains("locality") {
                    cityName = component.name // Primary way to get city
                } else if component.types.contains("administrative_area_level_1") && cityName == nil {
                    stateName = component.name // Fallback if 'locality' is not available
                } else if component.types.contains("postal_code") {
                    zipCode = component.name
                } else if component.types.contains("country") {
                    countryName = component.name
                }
            }
        }
        
        // Fallback: If city is not found, use state name
        self.cityName = cityName ?? stateName
        self.zipcode = zipCode
        self.country = countryName
        self.placeName = placeName

        print("Place Name: \(placeName ?? "Not Found")")
        print("City Name: \(self.cityName ?? "Not Found")") // Ensuring it prints correctly
        print("ZIP Code: \(zipCode ?? "Not Found")")
        print("Country: \(countryName ?? "Not Found")")
        
        dismiss(animated: true, completion: nil)
    }
    // Function to fetch ZIP Code from Lat-Long
    func getZipCodeFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let placemark = placemarks?.first {
                print("placemark:-",placemark)
                let postalCode = placemark.postalCode
                print("ZIP Code: \(postalCode ?? "Not Found")")
                completion(postalCode)
            } else {
                completion(nil)
            }
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate

extension SelectCityVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFldCity {
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            
            let filter = GMSAutocompleteFilter()
            filter.countries = [shortCityName ?? ""]
            acController.autocompleteFilter = filter
            
            present(acController, animated: true, completion: nil)
        }
    }
}
