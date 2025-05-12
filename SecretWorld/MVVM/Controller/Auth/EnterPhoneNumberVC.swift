//
//  EnterPhoneNumberVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit
import CountryPickerView


class EnterPhoneNumberVC: UIViewController {
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var lblTitleWhtsUrNumber: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var countryPickerVw: CountryPickerView!
    @IBOutlet var txtFldMobileNumber: UITextField!
    
    // MARK: - variables
    var isComing = false
    var viewModel = AuthVM()
    let countriesPhoneNumbers: [(country: String, minDigits: Int, maxDigits: Int)] = [
        ("Afghanistan",9,9),
        ("Albania",3,9),
        ("Algeria",8,9),
        ("American Samoa",10,10),
        ("Andorra",6,9),
        ("Angola",9,9),
        ("Anguilla",10,10),
        ("Antarctica",9,15),
        ("Antigua and Barbuda", 10,10),
        ("Argentina",10 ,10),
        ("Armenia",8 ,8),
        ("Aruba", 7,7),
        ("Australia",5 ,15),
        ("Austria",4 ,13),
        ("Azerbaijan", 8,9),
        ("Bahamas", 10,10),
        ("Bahrain",8 ,8),
        ("Bangladesh", 6,10),
        ("Barbados", 10,10),
        ("Belarus", 9,10),
        ("Belgium",8 ,9),
        ("Belize",7 ,7),
        ("Benin",8 ,8),
        ("Bhutan", 7,8),
        ("Bolivia",8 ,8),
        ("Bosnia and Herzegovina", 8,8),
        ("Botswana", 7,8),
        ("Brazil",10 ,10),
        ("British Virgin Islands",10, 10),
        ("Brunei", 7,7),
        ("Bulgaria", 7,9),
        ("Burkina Faso",8 ,8),
        ("Burundi", 8,8),
        ("Cambodia",8 ,8),
        ("Cameroon",8 ,8),
        ("Canada",10 ,10),
        ("Cape Verde", 7,7),
        ("Central African Republic", 8,8),
        ("Chad",8 ,8),
        ("Chagos Archipelago", 7,12),
        ("Chile", 8,9),
        ("China", 5,12),
        ("Christmis Island",9, 11),
        ("Cocos (keeling) Island", 9,11),
        ("Colombia", 8,10),
        ("Comoros", 7,7),
        ("Congo - Brazzaville", 9,12),
        ("Congo - kinshasa", 9,12),
        ("Cook Island", 5,5),
        ("Costa Rica",8 ,8),
        ("Croatia", 8,12),
        ("Cuba", 6,8),
        ("Cyprus", 8,11),
        ("Czechia", 9,9),
        ("Côte d'Ivoire", 8,8),
        ("Denmark", 8,8),
        ("Djibouti", 6,6),
        ("Dominica",10 ,10),
        ("Dominican Republic",10 ,10),
        ("Ecuador", 8,8),
        ("Egypt", 7,9),
        ("El Salvador",7 ,11),
        ("Equatorial Guinea",9 ,9),
        ("Eritrea",7 ,7),
        ("Estonia",7 ,10),
        ("Eswatini", 7,8),
        ("Ethiopia",9 ,9),
        ("Falkland Islands", 5,5),
        ("Faroe Islands",6 ,6),
        ("Fiji", 7,7),
        ("Finland", 5,12),
        ("France", 9,9),
        ("French Guiana",9 ,9),
        ("French Polynesia", 6,6),
        ("Gabon",6 ,7),
        ("Gambia",7 ,7),
        ("Georgia",9 ,9),
        ("Germany",6 ,13),
        ("Ghana", 5,9),
        ("Gibraltar",8 ,8),
        ("Greece", 10,10),
        ("Grenada",10 ,10),
        ("Guatemala", 8,8),
        ("Guinea", 8,8),
        ("Guinea-Bissau", 8,8),
        ("Guyana", 7,7),
        ("Haiti",8 ,8),
        ("Honduras", 8,8),
        ("Hong Kong",4 ,9),
        ("Hungary", 8,9),
        ("Iceland", 7,9),
        ("India",7 ,10),
        ("Indonesia",5 ,10),
        ("Iran", 6,10),
        ("Iraq", 8,10),
        ("Ireland", 7,11),
        ("Isle of Man",10 ,10),
        ("Israel", 8,9),
        ("Italy", 11,11),
        ("Jamaica", 10,10),
        ("Japan",5 ,13),
        ("Jersey", 10,10),
        ("Jordan", 5,9),
        ("Kazakhstan", 10,10),
        ("Kenya",6 ,10),
        ("Kiribati",5,5),
        ("Kuwait", 7,8),
        ("Kosovo", 8,8),
        ("Kyrgyzstan",9 ,9),
        ("Laos",8 ,10),
        ("Latvia", 7,8),
        ("Lebanon",7 ,8),
        ("Lesotho",8 ,8),
        ("Liberia", 7,8),
        ("Libya", 8,9),
        ("Liechtenstein", 7,9),
        ("Lithuania", 8,8),
        ("Luxembourg", 4,11),
        ("Macao", 8,11),
        ("Madagascar", 9,10),
        ("Malawi", 7,8),
        ("Malaysia", 7,9),
        ("Maldives", 7,7),
        ("Mali", 8,8),
        ("Malta", 8,8),
        ("Marshall Islands", 7,7),
        ("Martinique", 9,9),
        ("Mauritania",7 ,7),
        ("Mauritius", 7,7),
        ("Mayotte", 9,9),
        ("Mexico", 10,10),
        ("Micronesia", 7,7),
        ("Moldova", 8,8),
        ("Monaco",5 ,9),
        ("Mongolia", 7,8),
        ("Montenegro",4 ,12),
        ("Montserrat", 10,10),
        ("Morocco", 9,9),
        ("Mozambique", 8,9),
        ("Myanmar (Burma)", 7,9),
        ("Aland Islands",5,7),
        ("Norway",5,8),
        ("Northern Mariana Islands",10,10),
        ("Macedonia",8,9),
        ("North Korea",6,17),
        ("Norfolk Island",6,6),
        ("Niue",4,4),
        ("Nigeria",7,10),
        ("Niger",8,8),
        ("Nicaragua",8,8),
        ("New Zealand",3,10),
        ("New Caledonia",6,6),
        ("Netherlands",9,9),
        ("Nepal",8,9),
        ("Nauru",4,7),
        ("Namibia",6,10),
        ("Oman",7,8),
        ("Puerto Rico",10,10),
        ("Portugal",9,11),
        ("Poland",6,9),
        ("Pitcairn",9,10),
        ("Philippines",8,10),
        ("Peru",8,11),
        ("Paraguay",5,9),
        ("Papua New Guinea",4,11),
        ("Panama",7,8),
        ("Palestinian Territory, Occupied",9,9),
        ("Palau",7,7),
        ("Pakistan",8,11),
        ("Qatar",3,8),
        ("Reunion",9,9),
        ("Rwanda",9,9),
        ("Russia",10,10),
        ("Romania",9,9),
        ("Sao Tome and Principe",7,7),
        ("Syrian Arab Republic",8,10),
        ("Switzerland",4,12),
        ("Sweden",7,13),
        ("Svalbard and Jan Mayen",8,8),
        ("Suriname",6,7),
        ("Sudan",9,9),
        ("Saint Vincent and the Grenadines",10,10),
        ("Saint Pierre and Miquelon",6,6),
        ("Saint Martin",9,10),
        ("Saint Lucia",10,10),
        ("Saint Kitts and Nevis",10,10),
        ("Saint Helena, Ascension and Tristan Da Cunha",5,5),
        ("Saint Barthelemy",9,9),
        ("Sri Lanka",9,9),
        ("Spain",9,9),
        ("South Sudan",7,9),
        ("South Korea",8,11),
        ("South Africa",9,9),
        ("Somalia",5,8),
        ("Solomon Islands",5,5),
        ("South Georgia and the South Sandwich Islands",10,11),
        ("Slovenia",8,8),
        ("Slovakia",4,9),
        ("Sint Maarten",10,10),
        ("Singapore",8,12),
        ("Sierra Leone",8,8),
        ("Seychelles",7,7),
        ("Serbia",4,12),
        ("Senegal",9,9),
        ("Saudi Arabia",8,9),
        ("San Marino",6,10),
        ("Samoa",3,7),
        ("Turkey",10,10),
        ("Tuvalu",5,6),
        ("Turks and Caicos Islands",10,10),
        ("Turkmenistan",8,8),
        ("Tunisia",8,8),
        ("Trinidad and Tobago",10,10),
        ("Tonga",5,7),
        ("Tokelau",4,4),
        ("Togo",8,8),
        ("Timor-Leste",7,8),
        ("Thailand",8,9),
        ("Tanzania, United Republic of Tanzania",9,9),
        ("Tajikistan",9,9),
        ("Taiwan",8,9),
        ("Uzbekistan",9,9),
        ("Uruguay",4,11),
        ("United States",10,10),
        ("United Kingdom",7,10),
        ("United Arab Emirates",8,9),
        ("Vietnam",7,10),
        ("Venezuela",10,10),
        ("Vatican City State",6,10),
        ("Vanuatu",5,7),
        ("Virgin Islands, U.S",10,10),
        ("Wallis and Futuna",6,6),
        ("Yemen",9,9),
        ("Zambia",9,9),
        ("Zimbabwe",5,10)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        uiSet()
    }
    @objc func handleSwipe() {
        navigationController?.popViewController(animated: true)
    }
    private func uiSet(){
        txtFldMobileNumber.delegate = self
        countryPickerVw.delegate = self
        
        countryPickerVw.showCountryCodeInView = false
        if let digits = digitsMax(for: countryPickerVw.selectedCountry.name) {
            txtFldMobileNumber.maxLength = digits
        }
        if isComing == true{
            lblTitle.text = "Change phone number"
            lblTitleWhtsUrNumber.text = "What is your new phone number? "
            lblSubtitle.text = "Enter your new phone number and we will send you a verification code"
            txtFldMobileNumber.placeholder = "Enter new phone number"
            lblPhoneNumber.text = "New Phone Number"
        }else{
            lblPhoneNumber.text = "Phone Number"
            txtFldMobileNumber.placeholder = "Enter your phone number"
            lblTitle.text = "Verification"
            lblTitleWhtsUrNumber.text = "What is your phone number?"
            lblSubtitle.text = "Enter your phone number and we will send you a verification code"
            
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboardWhileClick() {
        view.endEditing(true)
    }
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func actionCountryPicker(_ sender: UIButton) {
        txtFldMobileNumber.resignFirstResponder()
        countryPickerVw.showCountriesList(from: self)
        
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionContinue(_ sender: UIButton) {
       
        guard let phoneNumber = txtFldMobileNumber.text, !phoneNumber.isEmpty else {
            showSwiftyAlert("", "Enter your phone number.", false)
            return
        }
        let phoneNumberLength = txtFldMobileNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard phoneNumberLength.count > txtFldMobileNumber.minLength else {
            showSwiftyAlert("", "Invalid phone number. Please enter a valid phone number.", false)
            return
        }
        if phoneNumber.allSatisfy({ $0 == phoneNumber.first }) {
            showSwiftyAlert("", "Invalid phone number. Please enter a valid phone number.", false)
            return
        }
        if isInvalidNumber(phoneNumber) {
            showSwiftyAlert("", "Invalid phone number. Please enter a valid phone number.", false)
            return
        }
        
        guard let countryDigits = digitsMin(for: countryPickerVw.selectedCountry.name) else {
            //            showSwiftyAlert("", "Unable to validate phone number", false)
            return
        }
        
        if phoneNumber.count < countryDigits {
            showSwiftyAlert("", "Invalid phone number. Please enter a valid phone number.", false)
            return
        }
        if isComing == true{
            isOtpInvalid = true
            viewModel.ChangeMobileNumberApi(mobile: txtFldMobileNumber.text ?? "", countrycode: countryPickerVw.selectedCountry.phoneCode){ data in
                showSwiftyAlert("", "Enter otp : \(data?.otp ?? "")", true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPhoneNumberVC") as! VerifyPhoneNumberVC
                vc.isComing = self.isComing
                if Store.role == "b_user"{
                    vc.phoneNumber = String(Store.BusinessUserDetail?["mobile"] as? Int ?? 0)
                    vc.countryCode = Store.BusinessUserDetail?["countryCode"] as? String ?? ""

                }else{
                    vc.phoneNumber = String(Store.UserDetail?["mobile"] as? Int ?? 0)
                    vc.countryCode = Store.UserDetail?["countryCode"] as? String ?? ""

                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            viewModel.SendMobileVerificationOtp(mobile: txtFldMobileNumber.text ?? "",
                                                countrycode: countryPickerVw.selectedCountry.phoneCode,
                                                deviceType: "IOS",
                                                deviceId: Store.deviceToken ?? "") { data in
                
                showSwiftyAlert("", "Enter otp : \(data?.otp ?? "")", true)
                Store.role = data?.newUser?.usertype ?? ""
                
                if Store.role == "b_user"{
                    Store.BusinessUserDetail = ["userName":data?.newUser?.name ?? "",
                                                "profileImage":data?.newUser?.profilePhoto ?? "","userId":data?.newUser?.id ?? "",
                                                "mobile":data?.newUser?.mobile ?? 0,
                                                "countryCode":data?.newUser?.countrycode ?? ""]
                    
                    if let profilePhoto = data?.newUser?.profilePhoto  as? UIImage {
                        Store.LogoImage = profilePhoto
                    }
                    Store.businessLatLong = ["lat":data?.newUser?.latitude ?? 0,"long":data?.newUser?.longitude ?? 0]
                }else{
                    
                    Store.UserDetail = ["userName":data?.newUser?.name ?? "",
                                        "profileImage":data?.newUser?.profilePhoto ?? "",
                                        "userId":data?.newUser?.id ?? "",
                                        "mobile":data?.newUser?.mobile ?? 0,
                                        "countryCode":data?.newUser?.countrycode ?? ""]
                    
                    if let profilePhoto = data?.newUser?.profilePhoto  as? UIImage {
                        Store.LogoImage = profilePhoto
                    }
                    
                    print("imGE----",data?.newUser?.profilePhoto ?? "")
                    
                }
                
                Store.userId = data?.newUser?.id ?? ""
                
                Store.userLatLong = ["lat":data?.newUser?.latitude ?? 0,"long":data?.newUser?.longitude ?? 0]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPhoneNumberVC") as! VerifyPhoneNumberVC
                vc.isComing = self.isComing
                vc.phoneNumber = "\(self.txtFldMobileNumber.text ?? "")"
                vc.countryCode = "\(self.countryPickerVw.selectedCountry.phoneCode)"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    func isInvalidNumber(_ number: String) -> Bool {
        let invalidNumbers = ["0123456789", "1234567890", "9876543210","0987654321"]
        if invalidNumbers.contains(number) {
            return true
        }
        // Check if number is sequential (ascending or descending)
        let ascending = "0123456789"
        let descending = "9876543210"
        if ascending.contains(number) || descending.contains(number) {
            return true
        }
        return false
    }
    
}

//MARK: - CountryPickerViewDelegate
extension EnterPhoneNumberVC: CountryPickerViewDelegate {
    
    func digitsMax(for countryName: String) -> Int? {
        for (country, minDigits, maxDigits) in countriesPhoneNumbers {
            if country == countryName {
                return maxDigits  // Return maxDigits for the given country
            }
        }
        return nil  // Return nil if country name is not found
    }

    func digitsMin(for countryName: String) -> Int? {
        for (country, minDigits, maxDigits) in countriesPhoneNumbers {
            if country == countryName {
                return minDigits  // Return minDigits for the given country
            }
        }
        return nil  // Return nil if country name is not found
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: CPVCountry) {
        print(country)
        
        let selectedCountryName = countryPickerVw.selectedCountry.name
        
        if let maxDigits = digitsMax(for: selectedCountryName),
           let minDigits = digitsMin(for: selectedCountryName) {
            
            print("Country: \(selectedCountryName), Min Digits: \(minDigits), Max Digits: \(maxDigits)")
            txtFldMobileNumber.minLength = minDigits
            txtFldMobileNumber.maxLength = maxDigits
            txtFldMobileNumber.text = ""
            txtFldMobileNumber.resignFirstResponder()
            view.endEditing(true)
        }
    }
}
// MARK: - UITextFieldDelegate
extension EnterPhoneNumberVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only numbers (0-9)
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        // Ensure only numeric characters are allowed
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
