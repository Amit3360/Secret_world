//
//  CreateBusinessAcVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 25/12/23.
//
import UIKit
import IQKeyboardManagerSwift
import AlignedCollectionViewFlowLayout
class CreateBusinessAcVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet weak var btnChooseCategory: UIButton!
    @IBOutlet weak var collVwFeature: UICollectionView!
    @IBOutlet weak var vwSpecialFeature: UIView!
    @IBOutlet var txtFldBusinesName: UITextField!
    @IBOutlet var heightTblVwTiming: NSLayoutConstraint!
    @IBOutlet var tblVwTiming: UITableView!
    @IBOutlet var txtVwAbout: IQTextView!
    @IBOutlet var viewDottedBorderCover: RectangularDashedView!
    @IBOutlet var imgVwCover: UIImageView!
    @IBOutlet var lblTxtCount: UILabel!
    @IBOutlet var imgVwUpload: UIImageView!
    @IBOutlet var lblUploadImg: UILabel!
    @IBOutlet var txtFldLocation: UITextField!
    @IBOutlet var viewDottedBusinessid: RectangularDashedView!
    
    //MARK: - VARIABLES
    var offset = 1
    var limit = 10
    var isUploadCoverImage = false
    var isUploadBusinessIdImage = false
    var arrCategory = [String]()
    var arrCategoryId = [String]()
    var viewModel = AuthVM()
    var arrService = [Servicelist]()
    var arrSearchService = [Servicelist]()
    var selectedDay: String?
    var latitude:Double?
    var longitude:Double?
    var selectedLocation:LocationData?
    var selectedDayIndex: Int?
    var arrSelectedSrviceId = [String]()
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
    var arrSelectFeature = [String]()
    var obj = [BusinessTimingModel]()
    var category = 0
    var arrSpecialFeature = ["Kid-friendly","Pet-friendly","Vegan","Vegetarian","Non-Vegetarian"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    @objc func handleSwipe() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BackPopPupVC") as! BackPopPupVC
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        uiSet()
    }
    //MARK: - FUNCTIONS
    func uiSet(){
        Store.role = "b_user"
        let nibNearBy = UINib(nibName: "TimiingTVC", bundle: nil)
        tblVwTiming.register(nibNearBy, forCellReuseIdentifier: "TimiingTVC")
        setTblviewHeight()
        
        
        getServiceApi(text: "")
        //        updateheightCollVwSelectedCategories()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboardWhileClick() {
        view.endEditing(true)
    }
    func setTblviewHeight(){
        let maxRows = 7
        let maxTableHeight = CGFloat(maxRows * 75)
        heightTblVwTiming.constant = min(maxTableHeight, CGFloat(businessTimingData.count * 70))
        tblVwTiming.reloadData()
    }
    func getServiceApi(text:String){
        viewModel.GetServiceApi(offset: offset, limit: limit, search: text) { data in
            self.arrSearchService = data?.servicelist ?? []
            self.arrService = data?.servicelist ?? []
            
            //            self.updateheightCollVwSearchCategories()
        }
    }
    func searchList(text: String) {
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
        
    }
    //MARK: - BUTTON ACTIONS
    @IBAction func actionUploadCoverPic(_ sender: UIButton) {
        if isUploadCoverImage == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePhotoVC") as! ChangePhotoVC
            vc.isComing = 2
            vc.callBack = { [weak self] image in
                guard let self = self else { return }
                self.imgVwCover.image = image
                if Store.CoverImage == UIImage(named: "") || Store.CoverImage == nil{
                    self.isUploadCoverImage = false
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            ImagePicker().pickImage(self) { image in
                self.imgVwCover.image = image
                self.isUploadCoverImage = true
                Store.CoverImage = image
            }
        }
    }
    @IBAction func actionUploadPhoto(_ sender: UIButton) {
        if isUploadBusinessIdImage == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePhotoVC") as! ChangePhotoVC
            vc.isComing = 1
            vc.callBack = { [weak self] image in
                guard let self = self else { return }
                self.imgVwUpload.image = image
                if Store.BusinessIdImage == UIImage(named: "") || Store.BusinessIdImage == nil{
                    self.isUploadBusinessIdImage = false
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            ImagePicker().pickImage(self) { image in
                self.imgVwUpload.image = image
                self.isUploadBusinessIdImage = true
                Store.BusinessIdImage = image
            }
        }
    }
    @IBAction func actionChooseCategory(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "CreateBusiness"
        
        vc.modalPresentationStyle = .popover
        vc.callBackBusiness = { (name,index) in
            self.btnChooseCategory.setTitle(name, for: .normal)
            self.btnChooseCategory.setTitleColor(.black, for: .normal)
            self.category = index
            if index == 1{
                self.vwSpecialFeature.isHidden = false
            }else{
                self.vwSpecialFeature.isHidden = true
            }
            self.arrSelectFeature.removeAll()
        }
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .any
        vc.preferredContentSize = CGSize(width: btnChooseCategory.frame.size.width, height: 200)
        self.present(vc, animated: false)
    }
    @IBAction func actionLocation(_ sender: UIButton) {
        txtFldBusinesName.resignFirstResponder()
        txtVwAbout.resignFirstResponder()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentLocationVC") as! CurrentLocationVC
        vc.latitude = latitude
        vc.longitude = longitude
        vc.isSignUp = true
        vc.callBack = { [weak self] location in
            guard let self = self else { return }
            self.txtFldLocation.text = location.placeName ?? ""
            self.latitude = location.lat
            self.longitude = location.long
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BackPopPupVC") as! BackPopPupVC
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)
    }
    @IBAction func actionSignup(_ sender: UIButton) {
        if txtFldBusinesName.text == ""{
            showSwiftyAlert("", "Enter business name", false)
        }else if !(txtFldBusinesName.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your business name should contain meaningful text", false)
        }else if txtFldLocation.text == ""{
            showSwiftyAlert("", "Select your location", false)
        }else if imgVwUpload.image == UIImage(named: ""){
            showSwiftyAlert("", "Upload business id image", false)
        }else if txtVwAbout.text == ""{
            showSwiftyAlert("", "Enter about your business", false)
        }else if !(txtVwAbout.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: about your business should contain meaningful text", false)
        }else if category == 0{
            showSwiftyAlert("", "Choose business category", false)
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
                        
                        updatedTiming["starttime"] = startTime
                        updatedTiming["endtime"] = endTime
                    }
                    
                    let day = updatedTiming["day"] as? String ?? ""
                    let startTime = updatedTiming["starttime"] as? String ?? ""
                    let endTime = updatedTiming["endtime"] as? String ?? ""
                    let status = updatedTiming["status"] as? String ?? "0"
                    let startTime24Hour = convertTo24HourFormat(timeString: startTime) ?? ""
                    let endTime24Hour = convertTo24HourFormat(timeString: endTime) ?? ""
                    
                    if startTime.isEmpty {
                        showSwiftyAlert("", "Please select start time", false)
                        return
                    }
                    if endTime.isEmpty {
                        showSwiftyAlert("", "Please select end time", false)
                        return
                    }
                    
                    let businessTimingDict: [String: String] = [
                        "day": day,
                        "starttime": startTime24Hour,
                        "endtime": endTime24Hour,
                        "status": status
                    ]
                    openinghours.append(businessTimingDict)
                }
            }
            
            if openinghours.isEmpty{
                
                showSwiftyAlert("", "Please select a day for opening hours", false)
                return
            }
            
            print("Filtered Business Timing Data: \(openinghours)")
            print("api calling:--")
            viewModel.CreateBusinessAccountApi(about: txtVwAbout.text ?? "", deviceId: Store.deviceToken ?? "",
                                               businessname: txtFldBusinesName.text ?? "",
                                               place: txtFldLocation.text ?? "",
                                               lat: latitude ?? 0.0,
                                               long: longitude ?? 0.0,
                                               category: category,
                                               business_id: imgVwUpload,
                                               cover_photo: imgVwCover,
                                               services: servicesArray,
                                               openinghours: openinghours, feature: arrSelectFeature) { data in
                Store.autoLogin = data?.user?.profileStatus
                Store.userId = data?.user?.id ?? ""
                Store.businessLatLong = ["lat":self.latitude ?? 0,"long":self.longitude ?? 0]
                DispatchQueue.main.async {
                    WebService.hideLoader()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatAcSuccessVC") as! CreatAcSuccessVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func convertTo24HourFormat(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

//MARK: - UITextViewDelegate
extension CreateBusinessAcVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        lblTxtCount.text = "\(characterCount)/250"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 250
    }
}
// MARK: - Popup
extension CreateBusinessAcVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}

extension CreateBusinessAcVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
}

//MARK: - UITableViewDelegate
extension CreateBusinessAcVC: UITableViewDelegate,UITableViewDataSource{
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
            }
            if start > end {
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
            }
            if start > end {
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
        formatter.dateFormat = "hh:mm a" // Customize as needed
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
                }
                if start > end {
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
                }
                if start > end {
                    showSwiftyAlert("", "Closing time must be later than the opening time.", false)
                    return
                }
            }
            businessTimingData[sender.tag]["endtime"] = timeString
            cell.txtFldEndTime.text = timeString
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var newAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in attributes {
            let newAttribute = attribute.copy() as! UICollectionViewLayoutAttributes
            if newAttribute.indexPath.item >= 2 {
                let previousAttribute = newAttributes.last
                let previousFrame = previousAttribute?.frame ?? .zero
                let currentFrame = newAttribute.frame
                if previousFrame.maxY == currentFrame.minY {
                    newAttribute.frame.origin.x = previousFrame.origin.x
                }
            }
            newAttributes.append(newAttribute)
        }
        return newAttributes
    }
}
