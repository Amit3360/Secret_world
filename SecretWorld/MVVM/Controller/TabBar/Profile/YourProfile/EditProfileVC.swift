//
//  EditProfileVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 26/12/23.
//
import UIKit
import IQKeyboardManagerSwift
import AlignedCollectionViewFlowLayout
import GooglePlaces
class EditProfileVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet weak var txtFldAddress: UITextField!
    @IBOutlet weak var txtFldZipCode: UITextField!
    @IBOutlet weak var vwZipcode: UIView!
    @IBOutlet var heightCollVwDietry: NSLayoutConstraint!
    @IBOutlet var heightCollVwSpecil: NSLayoutConstraint!
    @IBOutlet var collVwSpecialization: UICollectionView!
    @IBOutlet var collVwDietry: UICollectionView!
    @IBOutlet var txtFldName: UITextField!
    @IBOutlet var txtfldCountry: UITextField!
    @IBOutlet var heightCollVwInterst: NSLayoutConstraint!
    @IBOutlet var txtFldDietry: UITextField!
    @IBOutlet var txtFldInterst: UITextField!
    @IBOutlet var lblTxtCount: UILabel!
    @IBOutlet var txtVwAbout: IQTextView!
    @IBOutlet var txtFldGender: UITextField!
    @IBOutlet var txtFldDateOfBirth: UITextField!
    @IBOutlet var imgVwProfile: UIImageView!
    @IBOutlet var collVwInterst: UICollectionView!
    //MARK: - VARIABLES
    var shortName = ""
    var offset = 1
    var limit = 100
    var arrInterst = [Interest]()
    var arrDietry = [DietaryPreference]()
    var arrSpecialize = [Specialization]()
    var arrDietryId = [String]()
    var arrInterstId = [String]()
    var arrSpecilizeId = [String]()
    var viewModel = UserProfileVM()
    var countryShortName:String?
    var arrGetInterst = [Functions]()
    var arrGetDietry = [Functions]()
    var arrGetSpecialize = [Functions]()
    var viewModelAuth = AuthVM()
    var getUserDetail:UserProfile?
    var arrInterstName = [String]()
    var arrDietryName = [String]()
    var arrSpecializeName = [String]()
    var isSelectInterst = 0
    var isSelectDietary = 0
    var isSelectSpecilize = 0
    var callBack:(()->())?
    var lat = Double()
    var long = Double()
    var heightInterst = false
    var birthDate = String()
    var shortCountry = ""
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
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()

    }
    @objc func handleSwipe() {
               navigationController?.popViewController(animated: true)
           }
    @objc func dismissKeyboardWhileClick() {
           view.endEditing(true)
       }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCollectionViewHeight()
    }
    func updateCollectionViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let heightInterest = self.collVwInterst.collectionViewLayout.collectionViewContentSize.height
            if self.isSelectInterst == 0{
                if self.arrInterst.count == 0{
                    self.heightCollVwInterst.constant = 0
                }else if self.arrInterst.count == 1{
                    self.heightCollVwInterst.constant = 49
                }else{
                    self.heightCollVwInterst.constant = heightInterest+12
                }
            }else{
                if self.arrGetInterst.count == 0{
                    self.heightCollVwInterst.constant = 0
                }else if self.arrGetInterst.count == 1{
                    self.heightCollVwInterst.constant = 49
                }else{
                    self.heightCollVwInterst.constant = heightInterest+12
                }
            }
            let heightDietry = self.collVwDietry.collectionViewLayout.collectionViewContentSize.height
            if self.isSelectDietary == 0{
                if self.arrDietry.count == 0{
                    self.heightCollVwDietry.constant = 0
                }else if self.arrDietry.count == 1{
                    self.heightCollVwDietry.constant = 49
                }else{
                    self.heightCollVwDietry.constant = heightDietry+12
                }
            }else{
                if self.arrGetDietry.count == 0{
                    self.heightCollVwDietry.constant = 0
                }else if self.arrGetDietry.count == 1{
                    self.heightCollVwDietry.constant = 49
                }else{
                    self.heightCollVwDietry.constant = heightDietry+12
                }
            }
//            self.heightCollVwDietry.constant = heightDietry
            let heightSpelize = self.collVwSpecialization.collectionViewLayout.collectionViewContentSize.height
            if self.isSelectSpecilize == 0{
                if self.arrSpecialize.count == 0{
                    self.heightCollVwSpecil.constant = 0
                }else if self.arrSpecialize.count == 1{
                    self.heightCollVwSpecil.constant = 49
                }else{
                    self.heightCollVwSpecil.constant = heightSpelize+12
                }
            }else{
                if self.arrGetSpecialize.count == 0{
                    self.heightCollVwSpecil.constant = 0
                }else if self.arrGetSpecialize.count == 1{
                    self.heightCollVwSpecil.constant = 49
                }else{
                    self.heightCollVwSpecil.constant = heightSpelize+12
                }
            }
//            self.heightCollVwSpecil.constant = heightSpelize
            self.view.layoutIfNeeded()
        }
    }
    func uiSet(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
               tapGesture.cancelsTouchesInView = false
               view.addGestureRecognizer(tapGesture)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)

        let nib = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
        collVwInterst.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        collVwDietry.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        collVwSpecialization.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        let alignedFlowLayoutCollVwInterst = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwInterst.collectionViewLayout = alignedFlowLayoutCollVwInterst
        let alignedFlowLayoutCollVwDietry = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwDietry.collectionViewLayout = alignedFlowLayoutCollVwDietry
        let alignedFlowLayoutCollVwSpecializ = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwSpecialization.collectionViewLayout = alignedFlowLayoutCollVwSpecializ
        setupAlignedFlowLayout(for: collVwInterst)
        setupAlignedFlowLayout(for: collVwDietry)
        setupAlignedFlowLayout(for: collVwSpecialization)
        setupFlowLayout(for: collVwInterst)
        setupFlowLayout(for: collVwDietry)
        setupFlowLayout(for: collVwSpecialization)
        getFunctionApis()
        getUserDetails()
    }
    func getUserDetails(){
        self.txtVwAbout.text = getUserDetail?.about ?? ""
        self.textViewDidChange(self.txtVwAbout)
        self.txtFldName.text = getUserDetail?.name ?? ""
        self.txtFldGender.text = getUserDetail?.gender ?? ""
        self.txtFldDateOfBirth.text = getUserDetail?.dob ?? ""
        self.txtfldCountry.text = getUserDetail?.country?.capitalized ?? ""
        if let userCountry = getUserDetail?.country,
           let countryShortName = countriesDict[userCountry] {
            print("Short name for \(userCountry): \(countryShortName)")
            shortName = countryShortName
        } else {
            print("Country not found in dictionary")
        }

        self.txtFldZipCode.text = getUserDetail?.zipCode ?? ""
        self.txtFldAddress.text = getUserDetail?.place ?? ""
        self.imgVwProfile.imageLoad(imageUrl: getUserDetail?.profilePhoto ?? "")
        Store.UserProfileViewImage = UIImage(named: getUserDetail?.profilePhoto ?? "")
        self.convertDateBirth(date: getUserDetail?.dob ?? "")
        self.arrDietry.append(contentsOf: getUserDetail?.Dietary ?? [])
        for i in getUserDetail?.Dietary ?? [] {
            if let functionId = i._id {
                self.arrDietryId.append(functionId)
            }
        }
        self.arrInterst.append(contentsOf: getUserDetail?.Interests ?? [])
        for i in getUserDetail?.Interests ?? [] {
            if let functionId = i._id {
                self.arrInterstId.append(functionId)
            }
        }
        self.arrSpecialize.append(contentsOf: getUserDetail?.Specialization ?? [])
        for i in getUserDetail?.Specialization ?? [] {
            if let functionId = i._id {
                self.arrSpecilizeId.append(functionId)
            }
        }
        self.collVwDietry.reloadData()
        self.collVwInterst.reloadData()
        self.collVwSpecialization.reloadData()
        self.updateCollectionViewHeight()
    }
    func convertDateBirth(date:String){
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatterInput.date(from: date) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatterOutput.string(from: date)
            self.birthDate = formattedDate
        } else {
            print("Invalid date format")
        }
    }
    func getFunctionApis(){
//        getinterstApi()
//        getDietaryApi()
        getSpecializationApi()
    }
    func getinterstApi(){
        viewModelAuth.UserFunstionsListApi(type: "Interests",offset:offset,limit: limit, search: "") { data in
            self.arrGetInterst.removeAll()
            self.arrGetInterst.append(contentsOf: data?.data ?? [])
        }
    }
    func getDietaryApi(){
        viewModelAuth.UserFunstionsListApi(type: "Dietary Preferences",offset:offset,limit: limit, search: "") { data in
            self.arrGetDietry.removeAll()
            self.arrGetDietry.append(contentsOf: data?.data ?? [])
        }
    }
    func getSpecializationApi(){
        viewModelAuth.UserFunstionsListApi(type: "Specialization",offset:offset,limit: limit, search: "") { data in
            self.arrGetSpecialize.removeAll()
            for i in data?.data ?? []{
                if i.name != ""{
                    self.arrGetSpecialize.append(i)
                }
            }
        }
    }
    func setupFlowLayout(for collectionView: UICollectionView) {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 37)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            collectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
    }
    func setupAlignedFlowLayout(for collectionView: UICollectionView) {
        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collectionView.collectionViewLayout = alignedFlowLayout
    }
    //MARK: - BUTTON ACTIONS
    @IBAction func actionProfilePic(_ sender: UIButton) {
    }
    @IBAction func actionPlace(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.countries = [shortName]
        acController.autocompleteFilter = filter
        
        present(acController, animated: true, completion: nil)

    }
    @IBAction func actionCountryOrigin(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryOriginVC") as! CountryOriginVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = 1
        vc.callBack = { countryName,shortname,arrSubCategory in
            self.txtfldCountry.text = countryName?.capitalized
            self.vwZipcode.isHidden = true
            self.shortName = shortname ?? ""
            self.txtFldAddress.text = ""
            
        }
        self.navigationController?.present(vc, animated: true)
     
    }
    @IBAction func actionDateOfBirth(_ sender: UIButton) {
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerVC
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = { date in
            self.txtFldDateOfBirth.text = date
            self.birthDate = date ?? ""
        }
        self.navigationController?.present(vc, animated: true)
    }

    @IBAction func actionUpdate(_ sender: UIButton) {
        if imgVwProfile.image == UIImage(named: ""){
            showSwiftyAlert("", "Upload profile image", false)
        }else if txtFldName.text == ""{
            showSwiftyAlert("", "Enter your name", false)
        }else if !(txtFldName.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your full name should contain meaningful text", false)
        }else if txtFldDateOfBirth.text == ""{
            showSwiftyAlert("", "Enter your date of birth", false)
        } else if !(txtVwAbout.text ?? "").isEmpty, !(txtVwAbout.text ?? "").isValidInput {
            showSwiftyAlert("", "Invalid Input: your about should contain meaningful text", false)
        }else if arrSpecilizeId.isEmpty{
            showSwiftyAlert("", "Select specialization", false)
        }else if txtFldAddress.text == ""{
            showSwiftyAlert("", "Select place", false)
        }else{
            viewModel.UpdateUserProfileApi(name: txtFldName.text ?? "", about: txtVwAbout.text ?? "", dob: self.birthDate, gender: txtFldGender.text ?? "", place: txtFldAddress.text ?? "",city:"",country: txtfldCountry.text ?? "",zipCode: txtFldZipCode.text ?? "",lat:lat , long: long , profile_photo: imgVwProfile, interests: arrInterstId, specialization: arrSpecilizeId,dietary: arrDietryId) {
                showSwiftyAlert("", "Profile updated successfully", true)
                self.navigationController?.popViewController(animated: true)
                self.callBack?()
            }
        }
    }
    @IBAction func actionInterst(_ sender: UIButton) {
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DietarypreferencesVC") as! DietarypreferencesVC
        vc.modalPresentationStyle = .overFullScreen
        vc.arrInterst = arrGetInterst
        vc.isComing = 0
        vc.selectedInterstItemsId = arrInterstId
        if isSelectInterst == 0{
            vc.selectedItemsInterst =  arrInterst.map { $0.name ?? "" }
        }else{
            vc.selectedItemsInterst = arrInterstName
        }
        vc.callBack = { selectedRowsName,ids in
            self.arrInterstId.removeAll()
            self.arrInterstName.removeAll()
            self.isSelectInterst = 1
            self.arrInterstId.append(contentsOf: ids)
            self.arrInterstName.append(contentsOf: selectedRowsName)
            self.collVwInterst.reloadData()
            self.updateCollectionViewHeight()
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionDietry(_ sender: UIButton) {
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DietarypreferencesVC") as! DietarypreferencesVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = 1
        vc.arrDietary = arrGetDietry
        vc.selectedDietryItemsId = arrDietryId
        if isSelectDietary == 0{
            vc.selectedItemsDietry =  arrDietry.map { $0.name ?? "" }
        }else{
            vc.selectedItemsDietry =  arrDietryName
        }
        vc.callBack = { selectedRow,ids in
            self.arrDietryId.removeAll()
            self.arrDietryName.removeAll()
            self.isSelectDietary = 1
            self.arrDietryId.append(contentsOf: ids)
            self.arrDietryName.append(contentsOf: selectedRow)
            self.collVwDietry.reloadData()
            self.updateCollectionViewHeight()
//            self.updateheightCollVwDietry()
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionSpecilization(_ sender: UIButton) {
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DietarypreferencesVC") as! DietarypreferencesVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = 3
        vc.selectedSpecilizeItemsId = arrSpecilizeId
        vc.arrSpeciasliz = arrGetSpecialize
        if isSelectSpecilize == 0 {
            vc.selectedItemsSpecialize =  arrSpecialize.map { $0.name ?? "" }
        }else{
            vc.selectedItemsSpecialize =  arrSpecializeName
        }
        vc.callBack = { selectedRowss,ids in
            self.arrSpecilizeId.removeAll()
            self.arrSpecializeName.removeAll()
            self.isSelectSpecilize = 1
            self.arrSpecilizeId.append(contentsOf: ids)
            self.arrSpecializeName.append(contentsOf: selectedRowss)
            self.collVwSpecialization.reloadData()
//            self.updateheightCollVwSpecialize()
            self.updateCollectionViewHeight()
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionGender(_ sender: UIButton) {
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenderVC") as! GenderVC
        vc.modalPresentationStyle = .overFullScreen
        vc.genderTxt = txtFldGender.text
        vc.callBack = { gender in
            self.txtFldGender.text = gender
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionUpload(_ sender: UIButton) {
        ImagePicker().pickImage(self) { image in
            self.imgVwProfile.image = image
        }
    }
}
//MARK: - UITextViewDelegate
extension EditProfileVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        lblTxtCount.text = "\(characterCount)/250"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 250
    }
}
//MARK: - UICollectionViewDelegate
extension EditProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwInterst{
            if isSelectInterst == 0{
                return arrInterst.count
            }else{
                return arrInterstName.count
            }
        }else if collectionView == collVwDietry{
            if isSelectDietary == 0{
                return arrDietry.count
            }else{
                return arrDietryName.count
            }
        }else{
            if isSelectSpecilize == 0{
                return arrSpecialize.count
            }else{
                return arrSpecializeName.count
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwInterst{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            if isSelectInterst == 0{
                cell.lblName.text = arrInterst[indexPath.row].name ?? ""
            }else{
                cell.lblName.text = arrInterstName[indexPath.row]
            }
            cell.vwBg.layer.cornerRadius = 18
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(actionDeleteInterst), for: .touchUpInside)
            return cell
        }else if collectionView == collVwDietry{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            if isSelectDietary == 0{
                cell.lblName.text = arrDietry[indexPath.row].name ?? ""
            }else{
                cell.lblName.text = arrDietryName[indexPath.row]
            }
            cell.vwBg.layer.cornerRadius = 18
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(actionDeleteDietary), for: .touchUpInside)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            if isSelectSpecilize == 0{
                cell.lblName.text = arrSpecialize[indexPath.row].name ?? ""
            }else{
                cell.lblName.text = arrSpecializeName[indexPath.row]
            }
            cell.lblName.textColor = .black
            cell.btnCross.setImage(UIImage(named: "crossinterst"), for: .normal)
            cell.vwBg.backgroundColor = UIColor(hex: "#4EB644").withAlphaComponent(0.2)
            cell.vwBg.layer.cornerRadius = 18
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(actionDeleteSpecialize), for: .touchUpInside)
            return cell
        }
    }
    @objc func actionDeleteInterst(sender:UIButton){
        if isSelectInterst == 0{
            if sender.tag < arrInterst.count {
                arrInterst.remove(at: sender.tag)
            }
            if sender.tag < arrInterstId.count {
                arrInterstId.remove(at: sender.tag)
            }
        }else{
            if sender.tag < arrInterstName.count {
                arrInterstName.remove(at: sender.tag)
            }
            if sender.tag < arrInterstId.count {
                arrInterstId.remove(at: sender.tag)
            }
        }
        collVwInterst.reloadData()
        updateCollectionViewHeight()
    }
    @objc func actionDeleteDietary(sender:UIButton){
        if isSelectDietary == 0{
            if sender.tag < arrDietry.count {
                arrDietry.remove(at: sender.tag)
            }
            if sender.tag < arrDietryId.count {
                arrDietryId.remove(at: sender.tag)
            }
        }else{
            if sender.tag < arrDietryName.count {
                arrDietryName.remove(at: sender.tag)
            }
            if sender.tag < arrDietryId.count {
                arrDietryId.remove(at: sender.tag)
            }
        }
        collVwDietry.reloadData()
        updateCollectionViewHeight()
    }
    @objc func actionDeleteSpecialize(sender:UIButton){
        if isSelectSpecilize == 0{
            if sender.tag < arrSpecialize.count {
                arrSpecialize.remove(at: sender.tag)
            }
            if sender.tag < arrSpecilizeId.count {
                arrSpecilizeId.remove(at: sender.tag)
            }
        }else{
            if sender.tag < arrSpecializeName.count {
                arrSpecializeName.remove(at: sender.tag)
            }
            if sender.tag < arrSpecilizeId.count {
                arrSpecilizeId.remove(at: sender.tag)
            }
        }
        collVwSpecialization.reloadData()
        updateCollectionViewHeight()
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate
extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if place.coordinate.latitude.description.count != 0 {
            self.lat = place.coordinate.latitude
        }
        if place.coordinate.longitude.description.count != 0 {
            self.long = place.coordinate.longitude
        }
        getZipCodeFromCoordinates(latitude: lat, longitude: long) { zipCode in
            if let zip = zipCode {
                print("Fetched ZIP Code: \(zip)")
                DispatchQueue.main.async {
                    // Assuming you have a text field for ZIP code
                    self.txtFldZipCode.text = zip
                    self.txtFldZipCode.isUserInteractionEnabled = zip.isEmpty
                }
            } else {
                self.txtFldZipCode.text = ""
                self.txtFldZipCode.isUserInteractionEnabled = true

                print("Failed to fetch ZIP Code")
            }
        }

        if let addressComponents = place.addressComponents {
            var orderedAddress = [String?]()
            
            var neighborhood: String?
            var sublocality2: String?
            var sublocality1: String?
            var city: String?
            var state: String?
            var zipCode: String?
            
            
            for component in addressComponents {
                if component.types.contains("neighborhood") {
                    neighborhood = component.name
                } else if component.types.contains("sublocality_level_2") {
                    sublocality2 = component.name
                } else if component.types.contains("sublocality_level_1") {
                    sublocality1 = component.name
                } else if component.types.contains("locality") {
                    city = component.name
                } else if component.types.contains("administrative_area_level_1") {
                    state = component.name
                } else if component.types.contains("postal_code") {
                    zipCode = component.name
                }
            }
            
            // Append values in required order
            orderedAddress.append(place.name)
            orderedAddress.append(neighborhood)
            orderedAddress.append(sublocality2)
            orderedAddress.append(sublocality1)
            orderedAddress.append(city)
            orderedAddress.append(state)
            
            // Filter nil values and join with commas
            txtFldAddress.text = orderedAddress.compactMap { $0 }.joined(separator: ", ")
           // txtFldZipcode.text = zipCode ?? ""
            
            print("Formatted Address: \(orderedAddress.compactMap { $0 }.joined(separator: ", "))")
        }
        vwZipcode.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
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

}
