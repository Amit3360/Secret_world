//
//  CountryOriginVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//

import UIKit
import GooglePlaces

class CountryOriginVC: UIViewController {
    @IBOutlet var vwShadow: UIView!
    @IBOutlet var tblVwList: UITableView!
    @IBOutlet var txtFldSearch: UITextField!
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var lblNoData: UILabel!
    var offset = 1
    var limit = 10
    var latitude = Double()
    var longitude = Double()
    var filteredArrTitle = [String:String]()
    var callBack:((_ cityName:String?,_ shortName:String?,_ arrSubCategory:[Subcategorylist]?)->())?
    var isComing = 0
    var selectedSubCategories = [String:Any]()
    //    var arrCallBack:((_ categories:[String]?)->())?
    
    var countriesDict = [
        "Afghanistan": "AF",
        "Albania": "AL",
        "Algeria": "DZ",
        "Andorra": "AD",
        "Angola": "AO",
        "Antigua and Barbuda": "AG",
        "Argentina": "AR",
        "Armenia": "AM",
        "Australia": "AU",
        "Austria": "AT",
        "Azerbaijan": "AZ",
        "Bahamas": "BS",
        "Bahrain": "BH",
        "Bangladesh": "BD",
        "Barbados": "BB",
        "Belarus": "BY",
        "Belgium": "BE",
        "Belize": "BZ",
        "Benin": "BJ",
        "Bhutan": "BT",
        "Bolivia": "BO",
        "Bosnia and Herzegovina": "BA",
        "Botswana": "BW",
        "Brazil": "BR",
        "Brunei": "BN",
        "Bulgaria": "BG",
        "Burkina Faso": "BF",
        "Burundi": "BI",
        "Cabo Verde": "CV",
        "Cambodia": "KH",
        "Cameroon": "CM",
        "Canada": "CA",
        "Central African Republic": "CF",
        "Chad": "TD",
        "Chile": "CL",
        "China": "CN",
        "Colombia": "CO",
        "Comoros": "KM",
        "Congo": "CG",
        "Costa Rica": "CR",
        "Croatia": "HR",
        "Cuba": "CU",
        "Cyprus": "CY",
        "Czechia": "CZ",
        "Denmark": "DK",
        "Djibouti": "DJ",
        "Dominica": "DM",
        "Dominican Republic": "DO",
        "East Timor": "TL",
        "Ecuador": "EC",
        "Egypt": "EG",
        "El Salvador": "SV",
        "Equatorial Guinea": "GQ",
        "Eritrea": "ER",
        "Estonia": "EE",
        "Eswatini": "SZ",
        "Ethiopia": "ET",
        "Fiji": "FJ",
        "Finland": "FI",
        "France": "FR",
        "Gabon": "GA",
        "Gambia": "GM",
        "Georgia": "GE",
        "Germany": "DE",
        "Ghana": "GH",
        "Greece": "GR",
        "Grenada": "GD",
        "Guatemala": "GT",
        "Guinea": "GN",
        "Guinea-Bissau": "GW",
        "Guyana": "GY",
        "Haiti": "HT",
        "Honduras": "HN",
        "Hungary": "HU",
        "Iceland": "IS",
        "India": "IN",
        "Indonesia": "ID",
        "Iran": "IR",
        "Iraq": "IQ",
        "Ireland": "IE",
        "Israel": "IL",
        "Italy": "IT",
        "Ivory Coast": "CI",
        "Jamaica": "JM",
        "Japan": "JP",
        "Jordan": "JO",
        "Kazakhstan": "KZ",
        "Kenya": "KE",
        "Kiribati": "KI",
        "Korea, North": "KP",
        "Korea, South": "KR",
        "Kosovo": "XK",
        "Kuwait": "KW",
        "Kyrgyzstan": "KG",
        "Laos": "LA",
        "Latvia": "LV",
        "Lebanon": "LB",
        "Lesotho": "LS",
        "Liberia": "LR",
        "Libya": "LY",
        "Liechtenstein": "LI",
        "Lithuania": "LT",
        "Luxembourg": "LU",
        "Madagascar": "MG",
        "Malawi": "MW",
        "Malaysia": "MY",
        "Maldives": "MV",
        "Mali": "ML",
        "Malta": "MT",
        "Marshall Islands": "MH",
        "Mauritania": "MR",
        "Mauritius": "MU",
        "Mexico": "MX",
        "Micronesia": "FM",
        "Moldova": "MD",
        "Monaco": "MC",
        "Mongolia": "MN",
        "Montenegro": "ME",
        "Morocco": "MA",
        "Mozambique": "MZ",
        "Myanmar": "MM",
        "Namibia": "NA",
        "Nauru": "NR",
        "Nepal": "NP",
        "Netherlands": "NL",
        "New Zealand": "NZ",
        "Nicaragua": "NI",
        "Niger": "NE",
        "Nigeria": "NG",
        "North Macedonia": "MK",
        "Norway": "NO",
        "Oman": "OM",
        "Pakistan": "PK",
        "Palau": "PW",
        "Panama": "PA",
        "Papua New Guinea": "PG",
        "Paraguay": "PY",
        "Peru": "PE",
        "Philippines": "PH",
        "Poland": "PL",
        "Portugal": "PT",
        "Qatar": "QA",
        "Romania": "RO",
        "Russia": "RU",
        "Rwanda": "RW",
        "Saint Kitts and Nevis": "KN",
        "Saint Lucia": "LC",
        "Saint Vincent and the Grenadines": "VC",
        "Samoa": "WS",
        "San Marino": "SM",
        "Sao Tome and Principe": "ST",
        "Saudi Arabia": "SA",
        "Senegal": "SN",
        "Serbia": "RS",
        "Seychelles": "SC",
        "Sierra Leone": "SL",
        "Singapore": "SG",
        "Slovakia": "SK",
        "Slovenia": "SI",
        "Solomon Islands": "SB",
        "Somalia": "SO",
        "South Africa": "ZA",
        "South Sudan": "SS",
        "Spain": "ES",
        "Sri Lanka": "LK",
        "Sudan": "SD",
        "Suriname": "SR",
        "Sweden": "SE",
        "Switzerland": "CH",
        "Syria": "SY",
        "Taiwan": "TW",
        "Tajikistan": "TJ",
        "Tanzania": "TZ",
        "Thailand": "TH",
        "Togo": "TG",
        "Tonga": "TO",
        "Trinidad and Tobago": "TT",
        "Tunisia": "TN",
        "Turkey": "TR",
        "Turkmenistan": "TM",
        "Tuvalu": "TV",
        "Uganda": "UG",
        "Ukraine": "UA",
        "United Arab Emirates": "AE",
        "United Kingdom": "GB",
        "United States": "US",
        "Uruguay": "UY",
        "Uzbekistan": "UZ",
        "Vanuatu": "VU",
        "Vatican City": "VA",
        "Venezuela": "VE",
        "Vietnam": "VN",
        "Yemen": "YE",
        "Zambia": "ZM",
        "Zimbabwe": "ZW"
    ]
    
    //    let apiKey = "AIzaSyBV343YslRWhvjzOoV9DgUE9Ik1m1If75I"
    let apiKey = "AIzaSyB8Jo13V8hcS7wKGuRsDbNgM9Fp6TAnCeE"
    
    var viewModel = AddServiceVM()
    var arrCategories = [Userservices]()
    var arrSearchCategories = [Userservices]()
    var arrSubCategories = [Subcategorylist]()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        if isComing == 1{
            filteredArrTitle = countriesDict
            lblScreenTitle.text = "Country of origin"
            
            
            
        }else{
            arrSearchCategories = arrCategories
            lblScreenTitle.text = "Add Category"
            print("selectedSubCategories:--\(selectedSubCategories)")
            
        }
        
        vwShadow.layer.cornerRadius = 35
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
    
    func getSubCategoryApi(categoryId:String,index:Int){
        
        viewModel.getSubCtegoriesApi(service_id: categoryId, offset: offset, limit: limit, search: "") { data in
            self.arrSubCategories = data?.subcategorylist ?? []
            self.callBack?(self.arrSearchCategories[index].id ?? "",self.arrSearchCategories[index].name ?? "",data?.subcategorylist ?? [])
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if isComing == 1{
            filteredArrTitle = countriesDict.filter { $0.key.lowercased().contains(searchText.lowercased()) }
            print("Filtered Titles: \(filteredArrTitle)")
            DispatchQueue.main.async {
                self.tblVwList.reloadData()
            }
        }else{
            arrSearchCategories = arrCategories.filter { ($0.name?.lowercased() ?? "").contains(searchText.lowercased()) }
            DispatchQueue.main.async {
                self.tblVwList.reloadData()
            }
        }
        
    }
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
}
extension CountryOriginVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComing == 1{
            if filteredArrTitle.count > 0{
                lblNoData.isHidden = true
                return filteredArrTitle.count
            }else{
                lblNoData.isHidden = false
                return 0
            }
            
        }else{
            
            if arrSearchCategories.count > 0{
                lblNoData.isHidden = true
                return arrSearchCategories.count
            }else{
                lblNoData.isHidden = false
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryOriginTVC", for: indexPath) as! CountryOriginTVC
        if isComing == 1{
            cell.lblName.text = filteredArrTitle.keys.sorted()[indexPath.row]
        }else{
            cell.lblName.text = arrSearchCategories[indexPath.row].name ?? ""
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        if isComing == 1{
            if filteredArrTitle.count > 0{
                let selectedCountryName = filteredArrTitle.keys.sorted()[indexPath.row]
                let selectedShortName = filteredArrTitle[selectedCountryName]
                print("Selected Country Index: \(indexPath.row), Country Name: \(selectedCountryName), Short Name: \(selectedShortName ?? "")")
                callBack?(selectedCountryName, selectedShortName,[])
            }
        }else{
            let selectedCategory = arrSearchCategories[indexPath.row].id ?? ""
            print("Selected Category Index: \(indexPath.row), Category: \(selectedCategory)")
            getSubCategoryApi(categoryId: arrSearchCategories[indexPath.row].id ?? "", index: indexPath.row)
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
extension CountryOriginVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isComing == 1{
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if newText.isEmpty {
                filteredArrTitle = countriesDict
            } else {
                filteredArrTitle = countriesDict.filter { $0.key.lowercased().contains(newText.lowercased()) }
            }
            tblVwList.reloadData()
        }else {
            let currentText = txtFldSearch.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if newText.isEmpty {
                arrSearchCategories = arrCategories
            } else {
                
                filterContentForSearchText(newText)
            }
            tblVwList.reloadData()
        }
        return true
    }
}
