//
//  CompleteSignupVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//

import UIKit
import CountryPickerView
import AlignedCollectionViewFlowLayout
import GooglePlaces

class CompleteSignupVC: UIViewController,CLLocationManagerDelegate {
    //MARK: - Outlets
    @IBOutlet weak var txtFldAddress: UITextField!
    @IBOutlet weak var vwLocation: UIView!
    @IBOutlet weak var txtFldCity: UITextField!
    @IBOutlet weak var vwCity: UIView!
    @IBOutlet weak var txtFldZipcode: UITextField!
    @IBOutlet weak var vwZipCode: UIView!
    @IBOutlet var heightCollVwSpecialize: NSLayoutConstraint!
    @IBOutlet var collVwSpecializ: UICollectionView!
    @IBOutlet var heightCollVwDietry: NSLayoutConstraint!
    @IBOutlet var collVwDietry: UICollectionView!
    @IBOutlet var heightCollVwInterst: NSLayoutConstraint!
    @IBOutlet var collVwInterst: UICollectionView!
    @IBOutlet var txtVwDescription: UITextView!
    @IBOutlet var lblTextCount: UILabel!
    @IBOutlet var txtFldPlace: UITextField!
    @IBOutlet var txtFldDietary: UITextField!
    @IBOutlet var txtFldIInterest: UITextField!
    @IBOutlet var txtFldSpecilization: UITextField!
    
    //MARK: - VARIABLES
    var offset = 1
    var limit = 100
    var arrInterst = [String]()
    var arrDietry = [String]()
    var arrSpecialize = [String]()
    var selectedCountry: String?
    var viewModel = AuthVM()
    var selectedInterstItemsId = [String]()
    var selectedDietryItemsId = [String]()
    var selectedSpecilizeItemsId = [String]()
    var signupDetail = [SignupModel]()
    var latitude = Double()
    var longitude = Double()
    var arrGetInterst = [Functions]()
    var arrGetDietry = [Functions]()
    var arrGetSpecialize = [Functions]()
    var shortName = ""
    var getExpertise = false
    var signupApiCall = false
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("Get"), object: nil)
        getFunctionApis()
    }
    
    @objc func methodOfReceivedNotification(notification:Notification){
        getFunctionApis()
    }
    
    private func uiSet(){

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        lblTextCount.text = "0/250"
        let nib = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
        collVwInterst.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        collVwDietry.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        collVwSpecializ.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        
        let alignedFlowLayoutCollVwInterst = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwInterst.collectionViewLayout = alignedFlowLayoutCollVwInterst
        
        let alignedFlowLayoutCollVwDietry = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwDietry.collectionViewLayout = alignedFlowLayoutCollVwDietry
        
        let alignedFlowLayoutCollVwSpecializ = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwSpecializ.collectionViewLayout = alignedFlowLayoutCollVwSpecializ
        
        
        if let flowLayout = collVwInterst.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 37)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            
        }
        
        if let flowLayout1 = collVwDietry.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout1.estimatedItemSize = CGSize(width: 0, height: 37)
            flowLayout1.itemSize = UICollectionViewFlowLayout.automaticSize
            collVwDietry.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
        
        if let flowLayout2 = collVwSpecializ.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout2.estimatedItemSize = CGSize(width: 0, height: 37)
            flowLayout2.itemSize = UICollectionViewFlowLayout.automaticSize
            collVwSpecializ.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }




    @objc func handleSwipe() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BackPopPupVC") as! BackPopPupVC
        vc.modalPresentationStyle = .overFullScreen
        
        self.navigationController?.present(vc, animated: false)
    }
    
    @objc func dismissKeyboardWhileClick() {
        view.endEditing(true)
    }
    private func getFunctionApis(){
        
        //
        //        viewModel.UserFunstionsListApi(type: "Interests",offset:offset,limit: limit, search: "") { data in
        //            self.arrGetInterst.removeAll()
        //            self.arrGetInterst.append(contentsOf: data?.data ?? [])
        //
        //        }
        //
        //        viewModel.UserFunstionsListApi(type: "Dietary Preferences",offset:offset,limit: limit, search: "") { data in
        //            self.arrGetDietry.removeAll()
        //            self.arrGetDietry.append(contentsOf: data?.data ?? [])
        //
        //        }
        
        viewModel.UserFunstionsListApi(type: "Specialization",offset:offset,limit: limit, search: "") { data in
            self.arrGetSpecialize.removeAll()
            for i in data?.data ?? []{
                if i.name != ""{
                    self.arrGetSpecialize.append(i)
                }
            }
            self.getExpertise = true
            
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightInterest = self.collVwInterst.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwInterst.constant = heightInterest
        let heightDietry = self.collVwDietry.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwDietry.constant = heightDietry
        let heightSpelize = self.collVwSpecializ.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwSpecialize.constant = heightSpelize
        self.view.layoutIfNeeded()
    }
    private func updateCollectionViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let heightInterest = self.collVwInterst.collectionViewLayout.collectionViewContentSize.height
            self.heightCollVwInterst.constant = heightInterest
            let heightDietry = self.collVwDietry.collectionViewLayout.collectionViewContentSize.height
            self.heightCollVwDietry.constant = heightDietry
            let heightSpelize = self.collVwSpecializ.collectionViewLayout.collectionViewContentSize.height
            self.heightCollVwSpecialize.constant = heightSpelize
            self.view.layoutIfNeeded()
        }
    }
    //MARK: - Button Actions
    @IBAction func actionSpecilize(_ sender: UIButton) {
        txtVwDescription.resignFirstResponder()
        if getExpertise{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DietarypreferencesVC") as! DietarypreferencesVC
            vc.modalPresentationStyle = .overFullScreen
            vc.selectedItemsSpecialize = arrSpecialize
            vc.selectedSpecilizeItemsId = selectedSpecilizeItemsId
            vc.isComing = 3
            vc.arrSpeciasliz = arrGetSpecialize
            vc.callBack = { selectedRowss,ids in
                self.arrSpecialize.removeAll()
                self.arrSpecialize.append(contentsOf: selectedRowss )
                
                self.selectedSpecilizeItemsId.removeAll()
                self.selectedSpecilizeItemsId.append(contentsOf: ids )
                
                self.collVwSpecializ.reloadData()
                self.updateCollectionViewHeight()
                
            }
            self.navigationController?.present(vc, animated: true)
            
        }
    }
    @IBAction func actionInterst(_ sender: UIButton) {
        txtVwDescription.resignFirstResponder()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DietarypreferencesVC") as! DietarypreferencesVC
        vc.modalPresentationStyle = .overFullScreen
        vc.selectedItemsInterst = arrInterst
        vc.selectedInterstItemsId = selectedInterstItemsId
        vc.isComing = 0
        vc.arrInterst = arrGetInterst
        vc.offset = offset
        vc.limit = limit
        vc.callBack = { selectedRows,ids in
            self.arrInterst.removeAll()
            self.arrInterst.append(contentsOf: selectedRows )
            
            self.selectedInterstItemsId.removeAll()
            self.selectedInterstItemsId.append(contentsOf: ids )
            
            self.collVwInterst.reloadData()
            self.updateCollectionViewHeight()
            
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionPlace(_ sender: UIButton) {
        txtVwDescription.resignFirstResponder()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryOriginVC") as! CountryOriginVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = 1
        vc.callBack = { countryName,shortname,arrSubCategory in
            self.txtFldPlace.text = countryName
            self.vwLocation.isHidden = false
            self.vwZipCode.isHidden = true
            self.shortName = shortname ?? ""
            self.txtFldAddress.text = ""
            
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func actionSelectCity(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.countries = [shortName]
        acController.autocompleteFilter = filter
        
        present(acController, animated: true, completion: nil)
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectCityVC") as! SelectCityVC
        //        vc.modalPresentationStyle = .overFullScreen
        //        vc.shortCityName = shortName
        //
        //        vc.callBack = { selectCity,lat,long,zipCode,country,placeName in
        //            self.latitude = lat ?? 0.0
        //            self.longitude = long ?? 0.0
        //            self.txtFldZipcode.text = zipCode
        //            self.txtFldCity.text = selectCity
        //            self.txtFldAddress.text = placeName
        //            self.vwZipCode.isHidden = false
        //            self.vwLocation.isHidden = false
        //        }
        //        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionDietary(_ sender: UIButton) {
        txtVwDescription.resignFirstResponder()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DietarypreferencesVC") as! DietarypreferencesVC
        vc.modalPresentationStyle = .overFullScreen
        vc.selectedItemsDietry = arrDietry
        vc.selectedDietryItemsId = selectedDietryItemsId
        vc.isComing = 1
        vc.arrDietary = arrGetDietry
        vc.callBack = { selectedRow,ids in
            
            self.arrDietry.removeAll()
            self.arrDietry.append(contentsOf: selectedRow )
            
            self.selectedDietryItemsId.removeAll()
            self.selectedDietryItemsId.append(contentsOf: ids )
            
            self.collVwDietry.reloadData()
            self.updateCollectionViewHeight()
            
        }
        self.navigationController?.present(vc, animated: true)
        
    }
    @IBAction func actionBack(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BackPopPupVC") as! BackPopPupVC
        vc.modalPresentationStyle = .overFullScreen
        
        self.navigationController?.present(vc, animated: false)
    }
    
    @IBAction func actionSignup(_ sender: UIButton) {
        
//        if arrSpecialize.isEmpty{
//            
//            showSwiftyAlert("", "Select at least one expertise.", false)
//            
//        }else
        if txtFldPlace.text == ""{
            
            showSwiftyAlert("", "Specify your place of origin to continue.", false)
        }else if txtFldZipcode.text == ""{
            
            showSwiftyAlert("", "Enter your zip code.", false)
            
        }else{
            guard !signupApiCall else { return }
            self.signupApiCall = true
            viewModel.signUpApi(about: txtVwDescription.text ?? "",
                                interests: selectedInterstItemsId,
                                specialization: selectedSpecilizeItemsId,
                                dietary: selectedDietryItemsId,
                                place: txtFldAddress.text ?? "",
                                lat: latitude,
                                long: longitude, deviceId: Store.deviceToken ?? "",country: txtFldPlace.text ?? "",zipcode: txtFldZipcode.text ?? "",city: txtFldCity.text ?? "") { data in
                Store.autoLogin = data?.user?.profileStatus
                Store.userId = data?.user?.id ?? ""
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatAcSuccessVC") as! CreatAcSuccessVC
                vc.modalPresentationStyle = .overFullScreen
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        
        
    }
    
    
    
}

extension CompleteSignupVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldZipcode {
            let maxLength = 10
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= maxLength
        }
        return true
    }
    
}


//MARK: - UITextViewDelegate
extension CompleteSignupVC: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        
        let characterCount = textView.text.count
        lblTextCount.text = "\(characterCount)/250"
        
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 250
        
    }
}


//MARK: - UICollectionViewDelegate
extension CompleteSignupVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwInterst{
            return arrInterst.count
        }else if collectionView == collVwDietry{
            return arrDietry.count
        }else{
            return arrSpecialize.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwInterst{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            cell.lblName.text = arrInterst[indexPath.row]
            cell.vwBg.layer.cornerRadius = 18
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(actionDeleteInterst), for: .touchUpInside)
            
            return cell
        }else if collectionView == collVwDietry{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            cell.lblName.text = arrDietry[indexPath.row]
            cell.vwBg.layer.cornerRadius = 18
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(actionDeleteDietary), for: .touchUpInside)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            cell.lblName.text = arrSpecialize[indexPath.row]
            cell.vwBg.layer.cornerRadius = 18
            cell.lblName.textColor = .black
            cell.btnCross.setImage(UIImage(named: "crossinterst"), for: .normal)
            cell.vwBg.backgroundColor = UIColor(hex: "#4EB644").withAlphaComponent(0.2)
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(actionDeleteSpecialize), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc func actionDeleteInterst(sender:UIButton){
        
        if sender.tag < arrInterst.count {
            arrInterst.remove(at: sender.tag)
            collVwInterst.reloadData()
            updateCollectionViewHeight()
        }
        
        if sender.tag < selectedInterstItemsId.count {
            selectedInterstItemsId.remove(at: sender.tag)
            collVwInterst.reloadData()
            updateCollectionViewHeight()
        }
        
    }
    @objc func actionDeleteDietary(sender:UIButton){
        if sender.tag < arrDietry.count {
            arrDietry.remove(at: sender.tag)
            
            collVwDietry.reloadData()
            updateCollectionViewHeight()
        }
        if sender.tag < selectedDietryItemsId.count {
            selectedDietryItemsId.remove(at: sender.tag)
            
            collVwDietry.reloadData()
            updateCollectionViewHeight()
        }
    }
    @objc func actionDeleteSpecialize(sender:UIButton){
        if sender.tag < arrSpecialize.count{
            arrSpecialize.remove(at: sender.tag)
            
            collVwSpecializ.reloadData()
            updateCollectionViewHeight()
        }
        if sender.tag < selectedSpecilizeItemsId.count{
            selectedSpecilizeItemsId.remove(at: sender.tag)
            
            collVwSpecializ.reloadData()
            updateCollectionViewHeight()
        }
    }
}
//MARK: - GMSAutocompleteViewControllerDelegate
extension CompleteSignupVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if place.coordinate.latitude.description.count != 0 {
            self.latitude = place.coordinate.latitude
        }
        if place.coordinate.longitude.description.count != 0 {
            self.longitude = place.coordinate.longitude
        }
        print("latitude",latitude)
        print("longitude",longitude)
        print("place.coordinate.latitude",place.coordinate.latitude)
        print("place.coordinate.longitude",place.coordinate.longitude)
        // Call function to get ZIP Code
        
        getZipCodeFromCoordinates(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude) { zipCode in
            if let zip = zipCode {
                print("Fetched ZIP Code: \(zip)")
                DispatchQueue.main.async {
                    // Assuming you have a text field for ZIP code
                    self.txtFldZipcode.text = zip
                    self.txtFldZipcode.isUserInteractionEnabled = zip.isEmpty
                }
            } else {
                self.txtFldZipcode.text = ""
                self.txtFldZipcode.isUserInteractionEnabled = true
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
        vwZipCode.isHidden = false
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
