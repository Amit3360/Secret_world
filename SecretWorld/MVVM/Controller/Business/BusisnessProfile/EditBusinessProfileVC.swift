//
//  EditBusinessProfileVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/01/24.
//

import UIKit
import IQKeyboardManagerSwift
import AlignedCollectionViewFlowLayout
class EditBusinessProfileVC: UIViewController{
    //MARK: - IBOutlet
    @IBOutlet weak var collVwFeature: UICollectionView!
    @IBOutlet weak var btnChooseCategory: UIButton!
    @IBOutlet var lblAboutTxtCount: UILabel!
    @IBOutlet var heightTblvw: NSLayoutConstraint!
    @IBOutlet var tblVwTiming: UITableView!
    @IBOutlet var heightCollVwSearchcat: NSLayoutConstraint!
    @IBOutlet var heightCollVwCategoy: NSLayoutConstraint!
    @IBOutlet var txtFldSearch: UITextField!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var imgVwCoverPhoto: UIImageView!
    @IBOutlet weak var vwSpecialFeature: UIView!
    @IBOutlet var lblTxtCount: UILabel!
    @IBOutlet var imgVwUpload: UIImageView!
    @IBOutlet var collvwSearchCate: UICollectionView!
    @IBOutlet var collvwCategory: UICollectionView!
    @IBOutlet var txtFldGender: UITextField!
    @IBOutlet var txtFldDOB: UITextField!
    @IBOutlet var txtFldName: UITextField!
    @IBOutlet var txtVwAbout: IQTextView!
    //MARK: - variables
    var offset = 1
    var limit = 10
    var viewModel = AuthVM()
    var getBusinessUserDetail:GetBusinessUserDetail?
    var arrSearchService = [Servicelist]()
    var arrService = [Servicelist]()
    var arrServiceNames = [Service]()
    var isSelect = -1
    var businessTimingData: [[String: Any]] = [
        ["day":"Monday","starttime": "", "endtime": "","status": "0","isSelected":false],
        ["day": "Tuesday","starttime": "", "endtime": "","status": "0","isSelected":false],
        ["day": "Wednesday","starttime": "", "endtime": "","status": "0","isSelected":false],
        ["day": "Thursday","starttime": "", "endtime": "","status": "0","isSelected":false],
        ["day": "Friday","starttime": "", "endtime": "","status": "0","isSelected":false],
        ["day": "Saturday","starttime": "", "endtime": "","status": "0","isSelected":false],
        ["day": "Sunday","starttime": "", "endtime": "","status": "0","isSelected":false]
    ]
    var arrSpecialFeature = ["Kid-friendly","Pet-friendly","Vegan","Vegetarian","Non-Vegetarian"]
    var obj = [BusinessTimingModel]()
    var arrGetServices = [Service]()
    var arrSelectedSrviceId = [String]()
    var arrSelectedService = [String]()
    var viewModelProfile = BusinessProfileVM()
    var callBack:(()->())?
    var category = 0
    var categoryName:String?
    var latitude:Double?
    var longitude:Double?
    var arrSelectFeature = [String]()
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    private func updateCollectionViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let heightInterest = self.collvwCategory.collectionViewLayout.collectionViewContentSize.height
            self.heightCollVwCategoy.constant = heightInterest
            self.view.layoutIfNeeded()
        }
    }
    private func uiSet(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        let nibNearBy = UINib(nibName: "TimiingTVC", bundle: nil)
        tblVwTiming.register(nibNearBy, forCellReuseIdentifier: "TimiingTVC")
        let customLayout = CustomCollectionViewFlowLayout()
        collvwSearchCate.collectionViewLayout = customLayout
        getServiceApi(text: "")
        getUserDetail()
    }
    @objc func handleSwipe() {
        navigationController?.popViewController(animated: true)
    }
    @objc func dismissKeyboardWhileClick() {
        view.endEditing(true)
    }
    private func setTblviewHeight(){
        let maxRows = 7
        let maxTableHeight = CGFloat(maxRows * 75)
        heightTblvw.constant = min(maxTableHeight, CGFloat(businessTimingData.count * 75))
        tblVwTiming.reloadData()
    }
    private func getServiceApi(text:String){
        viewModel.GetServiceApi(offset: offset, limit: limit, search: text) { data in
            self.arrSearchService = data?.servicelist ?? []
            self.arrService = data?.servicelist ?? []
            self.collvwSearchCate.reloadData()
            //            self.updateheightCollVwSearchCategories()
        }
    }
    private func searchList(text: String) {
        self.arrService = self.arrSearchService.filter { value in
            if let name = value.name {
                return name.lowercased().contains(text.lowercased())
            } else {
                return false
            }
        }
        if text == "" {
            self.arrService = self.arrSearchService
        }
        self.collvwSearchCate.reloadData()
    }
    private func getUserDetail(){
        txtFldName.text = getBusinessUserDetail?.userProfile?.name ?? ""
        txtFldDOB.text = getBusinessUserDetail?.userProfile?.dob ?? ""
        txtFldGender.text = getBusinessUserDetail?.userProfile?.gender ?? ""
        txtVwAbout.text = getBusinessUserDetail?.userProfile?.about ?? ""
        arrSelectFeature = getBusinessUserDetail?.userProfile?.typesOfCategoryDetails ?? []
        category = getBusinessUserDetail?.userProfile?.category ?? 0
        latitude = getBusinessUserDetail?.userProfile?.latitude ?? 0
        longitude = getBusinessUserDetail?.userProfile?.longitude ?? 0
        btnLocation.setTitle(getBusinessUserDetail?.userProfile?.place ?? "", for: .normal)
        btnLocation.setTitleColor(.black, for: .normal)
        // Set category display
        switch getBusinessUserDetail?.userProfile?.category {
        case 1:
            
            self.btnChooseCategory.setTitle("Restaurants", for: .normal)
            self.vwSpecialFeature.isHidden = false
            categoryName = "Restaurants"
        case 2:
            
            self.btnChooseCategory.setTitle("Clothing/fashion", for: .normal)
            self.vwSpecialFeature.isHidden = true
            categoryName = "Clothing/fashion"
        case 3:
            self.btnChooseCategory.setTitle("Tech/electronics", for: .normal)
            self.vwSpecialFeature.isHidden = true
            categoryName = "Tech/electronics"
        case 4:
            
            self.btnChooseCategory.setTitle("Grocery", for: .normal)
            self.vwSpecialFeature.isHidden = true
            categoryName = "Grocery"
        case 5:
            
            self.btnChooseCategory.setTitle("Fitness", for: .normal)
            self.vwSpecialFeature.isHidden = true
            categoryName = "Fitness"
        case 6:
            
            self.btnChooseCategory.setTitle("Entertainment", for: .normal)
            self.vwSpecialFeature.isHidden = true
            categoryName = "Entertainment"
        default:
            self.btnChooseCategory.setTitle("Other", for: .normal)
            self.vwSpecialFeature.isHidden = true
            categoryName = "Other"
        }
        self.btnChooseCategory.setTitleColor(.black, for: .normal)
        textViewDidChange(txtVwAbout)
        imgVwUpload.imageLoad(imageUrl: getBusinessUserDetail?.userProfile?.profilePhoto ?? "")
        imgVwCoverPhoto.imageLoad(imageUrl: getBusinessUserDetail?.userProfile?.coverPhoto ?? "")
        self.businessTimingData.removeAll()
        // Define all 7 days
        let allDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var existingBusinessHours = [String: [String: Any]]()
        if let openingHours = getBusinessUserDetail?.userProfile?.openingHours {
            for openingHour in openingHours {
                let day = openingHour.day ?? ""
                let startTime = convertTo12HourFormat(timeString: openingHour.starttime ?? "") ?? ""
                let endTime = convertTo12HourFormat(timeString: openingHour.endtime ?? "") ?? ""
                print("Converted Start Time: \(startTime), Converted End Time: \(endTime)")

                existingBusinessHours[day] = [
                    "starttime": startTime,
                    "endtime": endTime,
                    "status": "1",
                    "isSelected":true
                ]
            }
        }
        for day in allDays {
            if let existingData = existingBusinessHours[day] {
                self.businessTimingData.append([
                    "day": day,
                    "starttime": existingData["starttime"] ?? "",
                    "endtime": existingData["endtime"] ?? "",
                    "status": "1",
                    "isSelected":true
                ])
            } else {
                self.businessTimingData.append([
                    "day": day,
                    "starttime": "",
                    "endtime": "",
                    "status": "0",
                    "isSelected":false
                ])
            }
        }
        print("businessTimingData: \(self.businessTimingData)")
        setTblviewHeight()
        for servicess in getBusinessUserDetail?.userProfile?.services ?? []{
            arrSelectedService.append(servicess.name ?? "")
            arrSelectedSrviceId.append(servicess.id ?? "")
            collvwCategory.reloadData()
            updateCollectionViewHeight()
        }
    }
    private func convertTo12HourFormat(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"  // 24-hour format (HH)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure proper locale
        
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "h:mm a" // 12-hour format with AM/PM
            return dateFormatter.string(from: date)
        }
        return nil
    }
    private func convertTo24HourFormat(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    @IBAction func actionChooseCategory(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "CreateBusiness"
        vc.matchTitle = categoryName
        vc.modalPresentationStyle = .popover
        vc.callBackBusiness = { (name,index) in
            self.categoryName = name
            self.btnChooseCategory.setTitle(name, for: .normal)
            self.btnChooseCategory.setTitleColor(.black, for: .normal)
            self.category = index
            if index == 1{
                self.vwSpecialFeature.isHidden = false
            }else{
                self.vwSpecialFeature.isHidden = true
            }
            self.arrSelectFeature.removeAll()
            self.collVwFeature.reloadData()
        }
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .any
        vc.preferredContentSize = CGSize(width: btnChooseCategory.frame.size.width, height: 350)
        self.present(vc, animated: false)
    }
    @IBAction func actionCoverPhoto(_ sender: UIButton) {
        ImagePicker().pickImage(self) { image in
            self.imgVwCoverPhoto.image = image
        }
    }
    @IBAction func actionUpload(_ sender: UIButton) {
        ImagePicker().pickImage(self) { image in
            self.imgVwUpload.image = image
        }
    }
    @IBAction func actionEdit(_ sender: UIButton) {
                if imgVwUpload.image == UIImage(named: ""){
        
                    showSwiftyAlert("", "Upload profile image", false)
        
                }else if txtFldName.text == ""{
        
                    showSwiftyAlert("", "Enter your business name", false)
        
                }else if !(txtFldName.text ?? "").isValidInput{
                    
                    showSwiftyAlert("", "Invalid Input: your business name should contain meaningful text", false)
                    
                }else if txtFldDOB.text == ""{
        
                    showSwiftyAlert("", "Select your business establish date", false)
        
                }else if txtVwAbout.text == ""{
        
                    showSwiftyAlert("", "Enter about your business", false)
        
                }else if !(txtVwAbout.text ?? "").isValidInput{
                    
                    showSwiftyAlert("", "Invalid Input: about your business should contain meaningful text", false)
                    
                }else{
                    var servicesArray: [[String: String]] = []
                    for serviceId in arrSelectedSrviceId {
                        let serviceDict: [String: String] = ["id": serviceId]
                        servicesArray.append(serviceDict)
                    }
                    print("servicesArray: \(servicesArray)")
                    var openinghours = [[String: String]]()
                    for (index, businessTiming) in businessTimingData.enumerated() {
                        var updatedTiming = businessTiming
                        if let isSelected = businessTiming["isSelected"] as? Bool, isSelected {
                            if let cell = tblVwTiming.cellForRow(at: IndexPath(row: index, section: 0)) as? TimiingTVC {
                                let startTime = cell.txtFldStartTime.text ?? ""
                                let endTime = cell.txtFldEndTime.text ?? ""
                                // Validation for empty start and end times
                                if startTime.isEmpty {
                                    showSwiftyAlert("", "Please select opening time", false)
                                    return
                                }
                                if endTime.isEmpty {
                                    showSwiftyAlert("", "Please select closing time", false)
                                    return
                                }
                                updatedTiming["starttime"] = startTime
                                updatedTiming["endtime"] = endTime
                            }
                            let day = updatedTiming["day"] as? String ?? ""
                            let startTime = updatedTiming["starttime"] as? String ?? ""
                            let endTime = updatedTiming["endtime"] as? String ?? ""
                            let status = updatedTiming["status"] as? String ?? "0"
                            let startTime24Hour = convertTo24HourFormat(timeString: startTime) ?? ""
                            let endTime24Hour = convertTo24HourFormat(timeString: endTime) ?? ""
                            let businessTimingDict: [String: String] = [
                                "day": day,
                                "starttime": startTime24Hour,
                                "endtime": endTime24Hour,
                                "status": status
                            ]
                            openinghours.append(businessTimingDict)
                        }
                    }
                    if openinghours.isEmpty {
                        showSwiftyAlert("", "Please select a day for opening hours", false)
                        return
                    }
                    print("Filtered Business Timing Data: \(openinghours)")
                    print("API calling...")
                    viewModelProfile.updateBusinessProfile(
                        name: txtFldName.text ?? "",
                        category: category,
                        dob: txtFldDOB.text ?? "",
                        about: txtVwAbout.text ?? "",
                        gender: "",
                        profilePhoto: imgVwUpload,
                        coverPhoto: imgVwCoverPhoto,
                        openingHour: openinghours,
                        lat: latitude ?? 0.0,
                        long: longitude ?? 0.0,
                        place: btnLocation.titleLabel?.text ?? "",
                        feature: arrSelectFeature
                    ) { message in
                        showSwiftyAlert("", message ?? "", true)
                        self.navigationController?.popViewController(animated: true)
                        self.callBack?()
                    }
                }
    }
    func dismissKeyboard(){
        txtFldName.resignFirstResponder()
        txtFldSearch.resignFirstResponder()
        txtVwAbout.resignFirstResponder()
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actiondateofbirth(_ sender: UIButton) {
        dismissKeyboard()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerVC
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = { [weak self] date in
            guard let self = self else { return }
            self.txtFldDOB.text = date
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionLocation(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentLocationVC") as! CurrentLocationVC
        vc.latitude = latitude
        vc.longitude = longitude
        vc.isSignUp = true
        vc.callBack = { [weak self] location in
            guard let self = self else { return }
            self.btnLocation.setTitle(location.placeName ?? "", for: .normal)
            self.btnLocation.setTitleColor(.black, for: .normal)
            self.latitude = location.lat
            self.longitude = location.long
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionGender(_ sender: UIButton) {
        dismissKeyboard()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenderVC") as! GenderVC
        vc.modalPresentationStyle = .overFullScreen
        vc.genderTxt = txtFldGender.text ?? ""
        vc.callBack = { [weak self] gender in
            guard let self = self else { return }
            self.txtFldGender.text = gender
        }
        self.navigationController?.present(vc, animated: true)
    }
}
//MARK: - UICollectionViewDelegate
extension EditBusinessProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSpecialFeature.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCVC", for: indexPath) as! FeatureCVC
        cell.lblName.text = arrSpecialFeature[indexPath.row]
        cell.btnTick.addTarget(self, action: #selector(tickUntick), for: .touchUpInside)
        cell.btnTick.tag = indexPath.row
        if arrSelectFeature.contains(arrSpecialFeature[indexPath.row]){
            cell.btnTick.isSelected = true
        }else{
            cell.btnTick.isSelected = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collVwFeature.frame.width/2-0, height: 32)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    @objc func tickUntick(sender: UIButton) {
        sender.isSelected.toggle()
        print(sender.tag, sender.isSelected)
        // Ensure sender.tag is within the valid range
        if sender.tag < arrSpecialFeature.count {
            let feature = arrSpecialFeature[sender.tag]
            if sender.isSelected {
                arrSelectFeature.append(feature)
            } else {
                if let index = arrSelectFeature.firstIndex(of: feature) {
                    arrSelectFeature.remove(at: index)
                }
            }
        } else {
            print("Error: sender.tag (\(sender.tag)) is out of range.")
        }
        print(arrSelectFeature)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FeatureCVC {
            cell.btnTick.isSelected.toggle()
            let feature = arrSpecialFeature[indexPath.row]
            if cell.btnTick.isSelected {
                arrSelectFeature.append(feature)
            } else {
                if let index = arrSelectFeature.firstIndex(of: feature) {
                    arrSelectFeature.remove(at: index)
                }
            }
        }
    }

}
//MARK: - UITextFieldDelegate
extension EditBusinessProfileVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = txtFldSearch.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if newText.isEmpty {
            getServiceApi(text: "")
        } else {
            let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            searchList(text: newString)
            getServiceApi(text: newString)
        }
        collvwSearchCate.reloadData()
        return true
    }
}
//MARK: - UITextViewDelegate
extension EditBusinessProfileVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        lblAboutTxtCount.text = "\(characterCount)/250"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 250
    }
}
// MARK: - Popup
extension EditBusinessProfileVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
//MARK: - UITableViewDelegate
extension EditBusinessProfileVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessTimingData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimiingTVC", for: indexPath) as! TimiingTVC
        cell.uiSet()
        let sectionData = businessTimingData[indexPath.row]
        let startTime = sectionData["starttime"] as? String ?? ""
        let endTime = sectionData["endtime"] as? String ?? ""
        let day = sectionData["day"] as? String ?? ""
        //let status = sectionData["status"] as? String ?? ""
        let isSelected = sectionData["isSelected"] as? Bool ?? false
        let imageName = isSelected ? "select1" : "unSelect1"
        cell.btnSelect.setImage(UIImage(named: imageName), for: .normal)
        var toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.app
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker(sender:)))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        cell.txtFldStartTime.text = startTime
        cell.txtFldEndTime.text = endTime
        cell.lblDay.text = day
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(actionSelect), for: .touchUpInside)
        cell.lblDay.tag = indexPath.row
        configureDatePicker(for: cell.txtFldStartTime, tag: indexPath.row)
        configureDatePicker(for: cell.txtFldEndTime, tag: indexPath.row)
        cell.indexxPathh = indexPath.row
        cell.callBack = { [weak self] indexPath in
            guard let self = self else { return }
            self.isSelect = indexPath
        }
        return cell
    }
    @objc func actionSelect(sender: UIButton) {
        let index = sender.tag
        var sectionData = businessTimingData[index]
        let currentState = sectionData["isSelected"] as? Bool ?? false
        let newState = !currentState
        sectionData["isSelected"] = newState
        sectionData["status"] = newState ? "1" : "0"
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tblVwTiming.cellForRow(at: indexPath) as? TimiingTVC {
            let startTime = cell.txtFldStartTime.text ?? ""
            let endTime = cell.txtFldEndTime.text ?? ""
            let day = cell.lblDay.text ?? ""
            sectionData["starttime"] = startTime
            sectionData["endtime"] = endTime
            sectionData["day"] = day
            print("Selected Day: \(day), Start Time: \(startTime), End Time: \(endTime)")
        }
        businessTimingData[index] = sectionData
        tblVwTiming.reloadRows(at: [indexPath], with: .none)
        print("Select tapped at row: \(index), status: \(sectionData["status"] ?? ""), isSelected: \(sectionData["isSelected"] ?? false)")
        print(businessTimingData)
    }
    @objc func donePicker(sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    @objc func actionStartTimee(sender: UITextField) {
        let index = isSelect
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tblVwTiming.cellForRow(at: indexPath) as? TimiingTVC,
              let datePicker = cell.txtFldStartTime.inputView as? UIDatePicker else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let newStartTime = dateFormatter.string(from: datePicker.date)
        businessTimingData[index]["starttime"] = newStartTime
        businessTimingData[index]["status"] = "1"
        if let endTime = businessTimingData[index]["endtime"] as? String,
           let start = dateFormatter.date(from: newStartTime),
           let end = dateFormatter.date(from: endTime) {

            if start == end {
                showSwiftyAlert("", "Opening and closing times cannot be the same. Please update your hours.", false)
                return
            } else if start > end {
                showSwiftyAlert("", "Opening time must be earlier than the closing time.", false)
                return
            }
        }

        cell.txtFldStartTime.text = newStartTime
        cell.txtFldStartTime.resignFirstResponder()
        cell.txtFldEndTime.becomeFirstResponder()
        let updatedModel = BusinessTimingModel(
            day: businessTimingData[index]["day"] as? String ?? "",
            starttime: newStartTime,
            endtime: businessTimingData[index]["endtime"] as? String ?? "",
            status: "1"
        )
        if index < obj.count {
            obj[index] = updatedModel
        }
        tblVwTiming.reloadData()
    }
    @objc func actionEndTimee(sender: UITextField) {
        let index = isSelect
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tblVwTiming.cellForRow(at: indexPath) as? TimiingTVC,
              let datePicker = cell.txtFldEndTime.inputView as? UIDatePicker else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let newEndTime = dateFormatter.string(from: datePicker.date)
        businessTimingData[index]["endtime"] = newEndTime
        businessTimingData[index]["status"] = "1"
        if let startTime = businessTimingData[index]["starttime"] as? String,
           let start = dateFormatter.date(from: startTime),
           let end = dateFormatter.date(from: newEndTime) {

            if start == end {
                showSwiftyAlert("", "Opening and closing times cannot be the same. Please update your hours.", false)
                return
            } else if start > end {
                showSwiftyAlert("", "Closing time must be later than the opening time.", false)
                return
            }
        }
        cell.txtFldEndTime.text = newEndTime
        cell.txtFldEndTime.resignFirstResponder()
        let updatedModel = BusinessTimingModel(
            day: businessTimingData[index]["day"] as? String ?? "",
            starttime: businessTimingData[index]["starttime"] as? String ?? "",
            endtime: newEndTime,
            status: "1"
        )
        if index < obj.count {
            obj[index] = updatedModel
        }
        tblVwTiming.reloadData()
    }
    func configureDatePicker(for textField: UITextField, tag: Int) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.tag = tag
        datePicker.locale = Locale(identifier: "en_US_POSIX")

        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        // Toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.app
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputView = datePicker
        textField.inputAccessoryView = toolBar
        textField.tag = tag
    }
    @objc func dateChanged(_ sender: UIDatePicker) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = tblVwTiming.cellForRow(at: indexPath) as? TimiingTVC else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let timeString = formatter.string(from: sender.date)

        if cell.txtFldStartTime.isFirstResponder {
            // Updating start time
            if let endTime = businessTimingData[sender.tag]["endtime"] as? String,
               let start = formatter.date(from: timeString),
               let end = formatter.date(from: endTime) {

                if start == end {
                    showSwiftyAlert("", "Opening and closing times cannot be the same. Please update your hours.", false)
                    return
                } else if start > end {
                    showSwiftyAlert("", "Opening time must be earlier than the closing time.", false)
                    return
                }
            }

            businessTimingData[sender.tag]["starttime"] = timeString
            cell.txtFldStartTime.text = timeString

        } else if cell.txtFldEndTime.isFirstResponder {
            // Updating end time
            if let startTime = businessTimingData[sender.tag]["starttime"] as? String,
               let start = formatter.date(from: startTime),
               let end = formatter.date(from: timeString) {

                if start == end {
                    showSwiftyAlert("", "Opening and closing times cannot be the same. Please update your hours.", false)
                    return
                } else if start > end {
                    showSwiftyAlert("", "Closing time must be later than the opening time.", false)
                    return
                }
            }

            businessTimingData[sender.tag]["endtime"] = timeString
            cell.txtFldEndTime.text = timeString
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  70
    }
}
