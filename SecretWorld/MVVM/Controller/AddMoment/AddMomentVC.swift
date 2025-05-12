//
//  AddMomentVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 08/04/25.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation

class AddMomentVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var lblBelowDateAndTime: UILabel!
    @IBOutlet var lblBelowTime: UILabel!
    @IBOutlet var lblHappending: UILabel!
    @IBOutlet var stackVwStoylineBtns: UIStackView!
    @IBOutlet var heightBtnAddRole: NSLayoutConstraint!
    @IBOutlet var txtFldLaterToday: UITextField!
    @IBOutlet var stackVwPickDateTime: UIStackView!
    @IBOutlet var viewLaterTodayTime: UIView!
    @IBOutlet var btnProof: UIButton!
    @IBOutlet var btnPickDate: UIButton!
    @IBOutlet var btnLater: UIButton!
    @IBOutlet var btnNOw: UIButton!
    @IBOutlet var viewMap: UIView!
    @IBOutlet var txtVwAddres: IQTextView!
    @IBOutlet var txtFldPaymentMethod: UITextField!
    @IBOutlet var viewPaymentMethods: UIView!
    @IBOutlet var hieghtImgvwTitleBack: NSLayoutConstraint!
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var txtVwDescription: IQTextView!
    @IBOutlet var viewDate: UIView!
    @IBOutlet var txtFldDate: UITextField!
    @IBOutlet var viewTime: UIView!
    @IBOutlet var txtFldTime: UITextField!
    //@IBOutlet var btnLocationVisible: UIButton!
    @IBOutlet var txtFldLocation: UITextField!
    @IBOutlet var txtFldTitle: UITextField!
    @IBOutlet var heightTblVwTask: NSLayoutConstraint!
    @IBOutlet var tblVwTaskList: UITableView!
    
    //MARK: - variables
    let arrRoleType: [String] = [
        "Promote (Wear or hold something to advertise)",
        "Support Online (Like, comment, or repost to boost someone)",
        "Act in Scene (Play a role in someone's skit or video)",
        "Run Errand (Help with simple tasks like pickup or waiting)",
        "Show Up (Be present at an event or help fill a crowd)",
        "Check Location (Take a photo or confirm a place is open)",
        "Help Out (Be an extra hand or fill in for someone quickly)"
    ]
    
    var momentType:String?
    var isProof = false
    var momentHappeningType:String?
    var arrTaskList = [AddMomentModel]()
    var lat:Double?
    var long:Double?
    var startDate = ""
    var startTime = ""
    var viewModel = MomentsVM()
    var MomentData:MomentData?
    var isEdit = false
    var callBack:(()->())?
    var locationManager = CLLocationManager()
    var paymentMethod = 1
    var withFiveMinuteStartTime = ""
    var totalTasksAmount:Double?
    var isOnline = false
    var momentTimer:Timer?
    var currentlat:Double?
    var currentlong:Double?
    var momentid:String?
    var isLater = false
    var isPickDateTime = false
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeight()
    }
    func updateButtonSelection(selectedButton: UIButton) {
        resetButtonStyles()
        selectedButton.backgroundColor = UIColor(hex: "#CFEACD")
        selectedButton.setTitleColor(.app, for: .normal)
    }
    func resetButtonStyles() {
        let buttons = [btnPickDate, btnLater, btnNOw]
        for button in buttons {
            button?.backgroundColor = .white
            button?.setTitleColor(.app, for: .normal)
        }
    }
    
    private func uiSet(){
        
        txtFldLocation.isUserInteractionEnabled = false
        let tapGestureMap = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        viewMap.addGestureRecognizer(tapGestureMap)
        txtFldLaterToday.delegate = self
        txtFldTime.delegate = self
        txtFldDate.delegate = self
        handleLocationManager()
        txtFldTime.tag = 1
        txtFldDate.tag = 2
        let nibProduct = UINib(nibName: "AddMomentTVC", bundle: nil)
        tblVwTaskList.register(nibProduct, forCellReuseIdentifier: "AddMomentTVC")
        setupDatePickers()
        txtFldLaterToday.setInputViewDatePickerPop(target: self, selector: #selector(handleLaterTodayPicker), isSelectType: "time")
        
        if isEdit{
            btnSave.setTitle("Update Moment", for: .normal)
            lblScreenTitle.text = "Update Moment"
            getEditMomentDetails()
        }else{
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMomentPlatformFeeVC") as! AddMomentPlatformFeeVC
                vc.callBack = {
                    self.navigationController?.popViewController(animated: true)
                }
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
            
            if momentType == "single"{
                
                momentHappeningType = "now"
                let now = Date()
                let fullFormatter = DateFormatter()
                fullFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                fullFormatter.timeZone = TimeZone.current
                let fullDateTime = fullFormatter.string(from: now)
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                timeFormatter.timeZone = TimeZone.current
                let timeOnly = timeFormatter.string(from: now)
                startDate = fullDateTime
                startTime = timeOnly
                
                stackVwStoylineBtns.isHidden = true
                lblHappending.isHidden = true
                heightBtnAddRole.constant = 0
                arrTaskList.append(AddMomentModel(role: "", RoleInstruction: "", _id: "", personRequired: "1", amount: "", personAccepted: "", paymentType: "", OfferBarter: "",duration: "", roleType: "",paymentTerm: ""))
                
            }else{
                
                btnNOw.isHidden = true
                heightBtnAddRole.constant = 50
                stackVwStoylineBtns.isHidden = false
                lblHappending.isHidden = false
                arrTaskList.append(AddMomentModel(role: "", RoleInstruction: "", _id: "", personRequired: "", amount: "", personAccepted: "", paymentType: "", OfferBarter: "",duration: "",roleType: "",paymentTerm: ""))
                
            }
            
            saveVisibleCellsData()
            tblVwTaskList.reloadData()
            updateTableHeight()
            paymentMethod = 1
            isOnline = true
            viewPaymentMethods.isUserInteractionEnabled = true
            btnSave.setTitle("Post Moment", for: .normal)
            lblScreenTitle.text = "Add Moment"
            tblVwTaskList.rowHeight = UITableView.automaticDimension
            tblVwTaskList.estimatedRowHeight = 500
            
        }
    }
    
    @objc func handleLaterTodayPicker(_ sender: UIDatePicker) {
        let formatter12Hour = DateFormatter()
        formatter12Hour.dateStyle = .none
        formatter12Hour.timeStyle = .short // 12-hour format (e.g., 2:30 PM)
        
        let formatter24Hour = DateFormatter()
        formatter24Hour.dateFormat = "HH:mm" // 24-hour format (e.g., 14:30)
        
        // Format the selected time in 12-hour format for the text field
        let formattedTime12Hour = formatter12Hour.string(from: sender.date)
        txtFldLaterToday.text = formattedTime12Hour
        
        // Store the start time in 24-hour format
        startTime = formatter24Hour.string(from: sender.date)
    }
    
    @objc func mapTapped(gesture: UITapGestureRecognizer){
        gotoMap()
    }
    func gotoMap(){
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentLocationVC") as! CurrentLocationVC
        vc.isSignUp = true
        // vc.isUpdate = true
        vc.latitude = lat
        vc.longitude = long
        vc.callBack = { [weak self] location in
            guard let self = self else { return }
            DispatchQueue.main.async {
                //  self.updateLocation = true
                self.txtFldLocation.text = location.placeName ?? ""
                self.lat = location.lat
                self.long = location.long
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    private func handleLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    private func getEditMomentDetails(){
        if MomentData?.type == "now"{
            
            momentHappeningType = "now"
            stackVwStoylineBtns.isHidden = true
            lblHappending.isHidden = true
            heightBtnAddRole.constant = 0
        }else{
            
            btnNOw.isHidden = true
            heightBtnAddRole.constant = 50
            stackVwStoylineBtns.isHidden = false
            lblHappending.isHidden = false
        }
        txtVwAddres.text = MomentData?.address ?? ""
        txtFldTitle.text = MomentData?.title?.capitalized ?? ""
        txtFldLocation.text = MomentData?.place ?? ""
        startDate = MomentData?.startDate ?? ""
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: MomentData?.startDate ?? "") {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            timeFormatter.timeZone = TimeZone.current
            let time24Hour = timeFormatter.string(from: date)
            startTime = time24Hour
        }
        txtVwDescription.text = MomentData?.description ?? ""
        lat = MomentData?.lat ?? 0
        long = MomentData?.long ?? 0
        paymentMethod = MomentData?.paymentMethod ?? 0
        //        if MomentData?.paymentMethod ?? 0 == 1{
        //            txtFldPaymentMethod.text = "Cash"
        //            isOnline = false
        //        }else{
        //            txtFldPaymentMethod.text = "Online"
        //            isOnline = true
        //        }
        
        if MomentData?.type == "dateAndTime"{
            updateButtonSelection(selectedButton: btnPickDate)
            momentHappeningType = "dateAndTime"
            lblBelowDateAndTime.isHidden = false
            lblBelowTime.isHidden = true
            txtFldDate.text = ""
            txtFldTime.text = ""
            viewLaterTodayTime.isHidden = true
            stackVwPickDateTime.isHidden = false
            txtFldDate.text = convertISODateString(MomentData?.startDate ?? "", toDateFormat: "dd-MM-yyyy")
            txtFldTime.text = convertISODateString(MomentData?.startDate ?? "", toDateFormat: "h:mm a")
            
        }else{
            updateButtonSelection(selectedButton: btnLater)
            momentHappeningType = "later"
            lblBelowDateAndTime.isHidden = true
            lblBelowTime.isHidden = false
            txtFldLaterToday.text = ""
            stackVwPickDateTime.isHidden = true
            viewLaterTodayTime.isHidden = false
            txtFldLaterToday.text = convertISODateString(MomentData?.startDate ?? "", toDateFormat: "h:mm a")
            
        }
        
        for task in MomentData?.tasks ?? [] {
            let personRequiredStr = String(task.personNeeded ?? 0)
            let amountStr = String(task.amount ?? 0)
            let paymentTermInt = task.paymentTerms ?? 0
            let paymentTypeInt = task.taskPaymentMethod ?? 0
            
            let paymentTermTitle = paymentTermInt == 0 ? "Fixed" : "Hourly"
            
            
            arrTaskList.append(AddMomentModel(
                role: task.role ?? "",
                RoleInstruction: task.roleInstruction ?? "",
                _id: task.id ?? "",
                personRequired: personRequiredStr,
                amount: amountStr,
                paymentType: "\(task.taskPaymentMethod ?? 0)",
                OfferBarter: task.barterProposal ?? "",
                duration:task.taskDuration ?? "",
                roleType:"\(task.roleType ?? 0)",
                paymentTerm: paymentTermTitle
            ))
        }
        updateTableHeight()
    }
    
    func convertISODateString(_ isoString: String, toDateFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = formatter.date(from: isoString) {
            formatter.dateFormat = format
            formatter.timeZone = .current // Show in user’s local time
            return formatter.string(from: date)
        }
        return ""
    }
    
    //MARK: - IBAction
    @IBAction func actionProof(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        //        if sender.isSelected{
        //
        //        }else{
        //
        //        }
    }
    @IBAction func actionPickDate(_ sender: UIButton) {
        view.endEditing(true)
        
        lblBelowDateAndTime.isHidden = false
        lblBelowTime.isHidden = true
        // txtFldDate.text = ""
        //  txtFldTime.text = ""
        viewLaterTodayTime.isHidden = true
        stackVwPickDateTime.isHidden = false
        updateButtonSelection(selectedButton: btnPickDate)
        momentHappeningType = "dateAndTime"
        tblVwTaskList.reloadData()
    }
    
    @IBAction func actionLater(_ sender: UIButton) {
        view.endEditing(true)
        lblBelowDateAndTime.isHidden = true
        lblBelowTime.isHidden = false
        // txtFldLaterToday.text = ""
        stackVwPickDateTime.isHidden = true
        viewLaterTodayTime.isHidden = false
        updateButtonSelection(selectedButton: btnLater)
        momentHappeningType = "later"
        let now = Date()
        let fullFormatter = DateFormatter()
        fullFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        fullFormatter.timeZone = TimeZone.current
        let fullDateTime = fullFormatter.string(from: now)
        let timeFormatter = DateFormatter()
        startDate = fullDateTime
        print("Full Date-Time: \(fullDateTime)")
        tblVwTaskList.reloadData()
    }
    @IBAction func actionNow(_ sender: UIButton) {
        view.endEditing(true)
        lblBelowDateAndTime.isHidden = true
        lblBelowTime.isHidden = true
        stackVwPickDateTime.isHidden = true
        viewLaterTodayTime.isHidden = true
        updateButtonSelection(selectedButton: btnNOw)
        momentHappeningType = "now"
        let now = Date()
        let fullFormatter = DateFormatter()
        fullFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        fullFormatter.timeZone = TimeZone.current
        let fullDateTime = fullFormatter.string(from: now)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = TimeZone.current
        let timeOnly = timeFormatter.string(from: now)
        startDate = fullDateTime
        startTime = timeOnly
        print("Time (24-hour): \(timeOnly)")
        print("Full Date-Time: \(fullDateTime)")
        
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        print("startdate:-", startDate)
        print("startTime:-", startTime)
        momentTimer?.invalidate()
        momentTimer = nil
        
        let tasksWithEmptyID = arrTaskList.filter { ($0._id ?? "").isEmpty }
        let totalAmount = tasksWithEmptyID
            .compactMap { Double($0.amount ?? "") }
            .reduce(0, +)
        
        print("Total Amount for tasks with empty _id: \(totalAmount)")
        
        guard let title = txtFldTitle.text, !title.isEmpty else {
            showSwiftyAlert("", "Title is required.", false)
            return
        }
        guard title.isValidInput else {
            showSwiftyAlert("", "Invalid Input: your title should contain meaningful text", false)
            return
        }
        
        guard let address = txtVwAddres.text, !address.isEmpty else {
            showSwiftyAlert("", "Address is required.", false)
            return
        }
        guard address.isValidInput else {
            showSwiftyAlert("", "Invalid Input: your address should contain meaningful text", false)
            return
        }
        
        guard let location = txtFldLocation.text, !location.isEmpty else {
            showSwiftyAlert("", "Location is required.", false)
            return
        }
        if momentType != "single"{
            guard let happeningType = momentHappeningType, !happeningType.isEmpty else {
                showSwiftyAlert("", "Please select moment type.", false)
                return
            }
            
            if happeningType == "later" {
                guard let laterTime = txtFldLaterToday.text, !laterTime.isEmpty else {
                    showSwiftyAlert("", "Time is required.", false)
                    return
                }
            } else if happeningType == "dateAndTime" {
                guard let date = txtFldDate.text, !date.isEmpty else {
                    showSwiftyAlert("", "Date is required.", false)
                    return
                }
                guard let time = txtFldTime.text, !time.isEmpty else {
                    showSwiftyAlert("", "Time is required.", false)
                    return
                }
            }
        }
        guard !arrTaskList.isEmpty else {
            showSwiftyAlert("", "Please add at least one task.", false)
            return
        }
        
        guard validateMomentModel(arrTaskList) else { return }
        
        if isEdit {
            DispatchQueue.main.async {
                //                    if self.paymentMethod == 1{
                //                        if !tasksWithEmptyID.isEmpty {
                //                            isAddFunds = true
                //                            self.viewModel.checAddMoment(price: totalAmount, momentId: self.momentid ?? "") { data in
                //                                self.showPlatformFeePopUp(message: data?.message ?? "")
                //                            }
                //                        } else {
                //                            self.callUpdateMomentApi()
                //                        }
                //                    }else{
                self.callUpdateMomentApi()
                // }
            }
        } else {
            DispatchQueue.main.async {
                self.handlePopupsBeforeAdding()
            }
        }
    }
    
    private func getTotalAmount() -> Double {
        return arrTaskList.reduce(0.0) { partialResult, task in
            let amountValue = Double(task.amount ?? "") ?? 0.0
            return partialResult + amountValue
        }
    }
    private func showPlatformFeePopUp(message: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlatformfeePopUpVC") as! PlatformfeePopUpVC
        vc.titleText = message
        vc.callBack = { [weak self] isPay in
            guard let self = self else { return }
            self.callUpdateMomentApi()
        }
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)
    }
    
    private func callUpdateMomentApi() {
        let latValue = (self.lat ?? 0) == 0 ? (self.currentlat ?? 0) : self.lat!
        let longValue = (self.long ?? 0) == 0 ? (self.currentlong ?? 0) : self.long!
        viewModel.updateMomentApi(momentId: self.MomentData?._id ?? "",
                                  usertype: "user",
                                  name: Store.UserDetail?["userName"] as? String ?? "",
                                  title: self.txtFldTitle.text ?? "",
                                  address: self.txtVwAddres.text ?? "",
                                  type: momentHappeningType ?? "",
                                  startDate: startDate,
                                  lat: latValue,
                                  long: longValue,
                                  startTime: self.startTime,
                                  place:  self.txtFldLocation.text ?? "",
                                  exactLocation: false,
                                  tasks: self.arrTaskList){ data in
            if data?.message == "Kindly pay amount"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.isSelect = 27
                vc.isEditMoment = true
                vc.message = data?.message ?? ""
                vc.callBack = { [weak self] in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlatformfeePopUpVC") as! PlatformfeePopUpVC
                        vc.titleText = data?.data?.message ?? ""
                        vc.callBack = { isPay in
                            DispatchQueue.main.async {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
                                vc.modalPresentationStyle = .overFullScreen
                                vc.paymentLink = data?.data?.paymentUrl ?? ""
                                vc.callback = { [weak self] payment in
                                    DispatchQueue.main.async {
                                        if payment{
                                            
                                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                                            vc.isSelect = 10
                                            vc.message = "Moment updated successfully."
                                            vc.callBack = { [weak self] in
                                                guard let self = self else { return }
                                                DispatchQueue.main.async {
                                                    self.navigationController?.popViewController(animated: true)
                                                    self.callBack?()
                                                }
                                            }
                                            vc.modalPresentationStyle = .overFullScreen
                                            self?.present(vc, animated: false)
                                            
                                        }else{
                                            self?.dismiss(animated: false)
                                            
                                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                                            vc.isSelect = 10
                                            vc.message = "Failed to update moment."
                                            vc.callBack = { [weak self] in
                                                guard let self = self else { return }
                                                DispatchQueue.main.async {
                                                    self.dismiss(animated: false)
                                                }
                                            }
                                            vc.modalPresentationStyle = .overFullScreen
                                            self?.present(vc, animated: false)
                                            
                                            
                                        }
                                    }
                                }
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: false)
                            }
                        }
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        
                    }
                }
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }else{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.isSelect = 10
                vc.message = data?.message ?? ""
                vc.callBack = { [weak self] in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                        self.callBack?()
                    }
                }
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false)
                
            }
        }
    }
    func getPaymentSummaryMessage(ourPrice: Int) -> String {
        if ourPrice >= 30 {
            let percentageFee = Double(ourPrice) * 0.15
            let totalFee = percentageFee + 1.0
            
            return """
            Your Moment Price: $\(ourPrice).00
            Platform Fee: $1.00 + 15% = $\(String(format: "%.2f", totalFee))
            Amount to Pay Now: $\(String(format: "%.2f", totalFee))
            """
        } else {
            return """
            Your Moment Price: $\(ourPrice).00
            Platform Fee: $3.00
            Amount to Pay Now: $3.00
            """
        }
    }

    private func handlePopupsBeforeAdding() {
        // Parse from 24-hour format first
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Output in 12-hour format with AM/PM
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let startDateTime = inputFormatter.date(from: startTime) {
            let newTime = Calendar.current.date(byAdding: .minute, value: 5, to: startDateTime)!
            let newTimeString = outputFormatter.string(from: newTime)
            print("Start Time + 5 minutes: \(newTimeString)") // e.g., 2:25 PM
            withFiveMinuteStartTime = newTimeString
        } else {
            print("Failed to parse start time.")
        }
        let totalAmount = self.getTotalAmount()
        print("Total Amount: \(totalAmount)")
        let calculationMessage = getPaymentSummaryMessage(ourPrice: Int(totalAmount))
        print(calculationMessage)
        
        DispatchQueue.main.async {
            //            if self.isOnline{
            //                //                self.showPopUp(message: "After task completion, you can raise a dispute within 24 hours. If no dispute is raised, the payment will be processed after the 24-hour window.", isSuccess: false) {
            //                DispatchQueue.main.async {
            //
            //                    self.showPopUp(message: "Be on time. Your tasks will start 5 minutes after the scheduled time, i.e., \(self.withFiveMinuteStartTime)", isSuccess: false) {
            //                        DispatchQueue.main.async {
            //                            let totalAmount = self.getTotalAmount()
            //                            print("Total Amount: \(totalAmount)")
            //                            isAddFunds = true
            //                            self.viewModel.checAddMoment(price: totalAmount, momentId: self.momentid ?? "") { data in
            //
            //                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlatformfeePopUpVC") as! PlatformfeePopUpVC
            //                                vc.titleText = data?.message ?? ""
            //                                vc.callBack = { [weak self] isPay in
            //                                    guard let self = self else { return }
            //                                    //call addMomentApi
            //                                    //                                        addMomentApi{
            //                                    //                                        }
            //                                }
            //                                vc.modalPresentationStyle = .overFullScreen
            //                                self.navigationController?.present(vc, animated: false)
            //
            //                            }
            //
            //                        }
            //                    }
            //                }
            //                //                }
            //            }else{
            //            self.showPopUp(message: "Be on time. Your tasks will start 5 minutes after the scheduled time, i.e., \(self.withFiveMinuteStartTime)", isSuccess: false) {
            //cash payment
            
            let latValue = (self.lat ?? 0) == 0 ? (self.currentlat ?? 0) : self.lat!
            let longValue = (self.long ?? 0) == 0 ? (self.currentlong ?? 0) : self.long!
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMomentPlatformFeeVC") as! AddMomentPlatformFeeVC
            vc.isComing = true
            vc.feesDetailMessage = calculationMessage
            vc.modalPresentationStyle = .overFullScreen
            vc.callBack = {
                DispatchQueue.main.async {
                    self.viewModel.addMomentApi(usertype: "user", name: Store.UserDetail?["userName"] as? String ?? "", title: self.txtFldTitle.text ?? "", startDate: self.startDate, lat: latValue, long: longValue, startTime: self.startTime, place: self.txtFldLocation.text ?? "", address: self.txtVwAddres.text ?? "", exactLocation: false, type: self.momentHappeningType ?? "", tasks: self.arrTaskList) { addMomentData in
                        DispatchQueue.main.async {
                            //isAddFunds = true
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
                            vc.modalPresentationStyle = .overFullScreen
                            vc.paymentLink = addMomentData?.data?.paymentUrl ?? ""
                            vc.callback = { [weak self] payment in
                                DispatchQueue.main.async {
                                    if payment{
                                        
                                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                                        vc.isSelect = 10
                                        vc.message = "Moment Created Successfully."
                                        vc.callBack = {
                                            DispatchQueue.main.async {
                                                SceneDelegate().MomentListRoot()
                                            }
                                        }
                                        vc.modalPresentationStyle = .overFullScreen
                                        self?.present(vc, animated: true)
                                        
                                    }else{
                                        
                                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                                        vc.isSelect = 10
                                        vc.message = "Unable to create moment"
                                        vc.callBack = {
                                            DispatchQueue.main.async {
                                                self?.dismiss(animated: true)
                                            }
                                        }
                                        vc.modalPresentationStyle = .overFullScreen
                                        self?.present(vc, animated: true)
                                        
                                    }
                                }
                            }
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true)
                        }
                    }
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            
        }
        
        
        
    }
    private func showPopUp(message: String,isSuccess:Bool, callback: @escaping () -> Void) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
        vc.isSuccess = isSuccess
        vc.isSelect = 10
        vc.message = message
        vc.callBack = callback
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    
    
    private func validateMomentModel(_ models: [AddMomentModel]) -> Bool {
        for (index, model) in models.enumerated() {
            
            guard let role = model.role, !role.isEmpty else {
                showSwiftyAlert("", "Please fill required fields in tasks.", false)
                return false
            }
            
            guard role.isValidInput else {
                showSwiftyAlert("", "Invalid Input: your role should contain meaningful text", false)
                return false
            }
            
            guard let roleInst = model.RoleInstruction, !roleInst.isEmpty else {
                showSwiftyAlert("", "Please fill required fields in tasks.", false)
                return false
            }
            
            guard roleInst.isValidInput else {
                showSwiftyAlert("", "Invalid Input: role instructions should contain meaningful text", false)
                return false
            }
            guard let roleTypp = model.roleType, !roleTypp.isEmpty else {
                showSwiftyAlert("", "Please fill required fields in tasks.", false)
                return false
            }
            
            guard let personRequired = model.personRequired, !personRequired.isEmpty else {
                showSwiftyAlert("", "Please fill required fields in tasks.", false)
                return false
            }
            guard let duration = model.duration, !duration.isEmpty else {
                showSwiftyAlert("", "Please fill required fields in tasks.", false)
                return false
            }
            guard let paymentType = model.paymentType, !paymentType.isEmpty else {
                showSwiftyAlert("", "Please fill required fields in tasks.", false)
                return false
            }
            
            // ✅ Payment type logic
            switch paymentType {
            case "0":
                print("pay")
                guard let payAmount = model.amount, !payAmount.isEmpty else {
                    showSwiftyAlert("", "Please fill required fields in tasks.", false)
                    return false
                }
                guard let payTerm = model.paymentTerm, !payTerm.isEmpty else {
                    showSwiftyAlert("", "Please fill required fields in tasks.", false)
                    return false
                }
                
            case "1":
                print("barter")
                guard let barter = model.OfferBarter, !barter.isEmpty else {
                    showSwiftyAlert("", "Please fill required fields in tasks.", false)
                    return false
                }
                guard barter.isValidInput else {
                    showSwiftyAlert("", #"Invalid Input: your "Barter Proposal" should contain meaningful text"#, false)
                    return false
                }
            case "2":
                guard let payAmount = model.amount, !payAmount.isEmpty else {
                    showSwiftyAlert("", "Please fill required fields in tasks.", false)
                    return false
                }
                guard let payTerm = model.paymentTerm, !payTerm.isEmpty else {
                    showSwiftyAlert("", "Please fill required fields in tasks.", false)
                    return false
                }
                guard let barter = model.OfferBarter, !barter.isEmpty else {
                    showSwiftyAlert("", "Please fill required fields in tasks.", false)
                    return false
                }
                guard barter.isValidInput else {
                    showSwiftyAlert("", #"Invalid Input: your "Barter Proposal" should contain meaningful text"#, false)
                    return false
                }
                
                print("pay")
                print("barter")
            default:
                print("Unknown payment type")
            }
        }
        return true
    }
    //                showSwiftyAlert("", #"Invalid Input: your "Barter Proposal" should contain meaningful text"#, false)
    
    @IBAction func actionVisibleLocation(_ sender: UIButton) {
        view.endEditing(true)
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            handleLocationVisiblePopup(isSelect: sender.isSelected, sender: sender)
        }else{
            handleLocationVisiblePopup(isSelect: sender.isSelected, sender: sender)
        }
        
    }
    private  func handleLocationVisiblePopup(isSelect:Bool,sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationPopupVC") as! LocationPopupVC
        vc.isSelect = isSelect
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 175, height: 25)
        
        if let popOver = vc.popoverPresentationController {
            popOver.delegate = self
            popOver.sourceView = sender
            popOver.sourceRect = sender.bounds
            popOver.permittedArrowDirections = .down
        }
        
        self.present(vc, animated: true)
        
    }
    @IBAction func actionMap(_ sender: UIButton) {
        gotoMap()
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionAddNew(_ sender: UIButton) {
        view.endEditing(true)
        saveVisibleCellsData()
        arrTaskList.append(AddMomentModel(role: "", RoleInstruction: "", _id: "", personRequired: "", amount: "", personAccepted: "", paymentType: "", OfferBarter: ""))
        updateTableHeight()
        
    }
    // MARK: - Save Visible Cell Data
    func saveVisibleCellsData() {
        for (index, cell) in tblVwTaskList.visibleCells.enumerated() {
            if let addCell = cell as? AddMomentTVC, index < arrTaskList.count {
                arrTaskList[index].role = addCell.txtfldRole.text ?? ""
                arrTaskList[index].RoleInstruction = addCell.txtVwRoleInstructions.text ?? ""
                arrTaskList[index].personRequired = addCell.txtFldPersonRequired.text ?? ""
                
                // FIXED: Save roleType as index
                if let roleText = addCell.txtFldRoleType.text,
                   let indexInArray = arrRoleType.firstIndex(of: roleText) {
                    arrTaskList[index].roleType = "\(indexInArray)"
                }
                
                arrTaskList[index].duration = addCell.txtFldRoleDuration.text ?? ""
                arrTaskList[index].amount = addCell.txtFldAmount.text ?? ""
                arrTaskList[index].paymentTerm = addCell.txtFldPaymentTerm.text ?? ""
                arrTaskList[index].OfferBarter = addCell.txtVwOfferBarter.text ?? ""
            }
        }
    }
    
    func updateTableHeight() {
        DispatchQueue.main.async {
            self.tblVwTaskList.reloadData()
            self.tblVwTaskList.layoutIfNeeded()
            self.heightTblVwTask.constant = self.tblVwTaskList.contentSize.height
        }
    }
}
//MARK: -UITableViewDelegate
extension AddMomentVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrTaskList.count > 0{
            return arrTaskList.count
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMomentTVC", for: indexPath) as! AddMomentTVC
        
        let moment = arrTaskList[indexPath.row]
        if momentType == "single" || MomentData?.type == "now"{
            cell.btnDelete.isHidden = true
            cell.heightLblTotal.constant = 0
            cell.txtFldPersonRequired.isUserInteractionEnabled = false
            cell.viewPersonRequired.isHidden = true
            cell.lblPlaceholderPerperson.text = "$"
            
        }else{
            cell.btnDelete.isHidden = false
            cell.heightLblTotal.constant = 25
            cell.lblPlaceholderPerperson.text = "per person"
            cell.txtFldPersonRequired.isUserInteractionEnabled = true
            cell.viewPersonRequired.isHidden = false
        }
        
        var paymentTypeTitle = ""
        if let typeInt = Int(moment.paymentType ?? "") {
            
            switch typeInt {
            case 1:
                paymentTypeTitle = "Barter"
                cell.viewOfferBarter.isHidden = false
                cell.stackVwPayAndPaymerntTerm.isHidden = true
            case 2:
                
                paymentTypeTitle = "Money + Barter"
                cell.viewOfferBarter.isHidden = false
                cell.stackVwPayAndPaymerntTerm.isHidden = false
                
                updateTotalPayout(for: cell, at: indexPath.row)
//                // Update total dynamically
//                let personStr = self.arrTaskList[indexPath.row].personRequired ?? "0"
//                let amountStr = self.arrTaskList[indexPath.row].amount ?? "0"
//                if let person = Int(personStr), let amount = Int(amountStr), amount > 0 {
//                    let total = person * amount
//                    let fullText = "Total Payout: (\(person) × $\(amount) = $\(total))"
//                    let totalString = "$\(total)"
//                    let attributed = NSMutableAttributedString(string: fullText)
//
//                    if let range = fullText.range(of: totalString) {
//                        attributed.addAttribute(.foregroundColor, value: UIColor.app, range: NSRange(range, in: fullText))
//                    }
//                    attributed.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: fullText.count))
//                    cell.lblTotal.attributedText = attributed
//                } else {
//                    cell.lblTotal.text = ""
//                }

            default:
                
                paymentTypeTitle = "Money"
                cell.viewOfferBarter.isHidden = true
                cell.stackVwPayAndPaymerntTerm.isHidden = false
                
                updateTotalPayout(for: cell, at: indexPath.row)
//                // Update total dynamically
//                let personStr = self.arrTaskList[indexPath.row].personRequired ?? "0"
//                let amountStr = self.arrTaskList[indexPath.row].amount ?? "0"
//                if let person = Int(personStr), let amount = Int(amountStr), amount > 0 {
//                    let total = person * amount
//                    let fullText = "Total Payout: (\(person) × $\(amount) = $\(total))"
//                    let totalString = "$\(total)"
//                    let attributed = NSMutableAttributedString(string: fullText)
//
//                    if let range = fullText.range(of: totalString) {
//                        attributed.addAttribute(.foregroundColor, value: UIColor.app, range: NSRange(range, in: fullText))
//                    }
//                    attributed.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: fullText.count))
//                    cell.lblTotal.attributedText = attributed
//                } else {
//                    cell.lblTotal.text = ""
//                }

                
            }
        }
        cell.txtFldPaymentMethod.text = paymentTypeTitle
        
        // Role type logic (FIXED)
        var roleTypeDescription = ""
        if let roleTypeIndexStr = moment.roleType,
           let roleTypeIndex = Int(roleTypeIndexStr),
           roleTypeIndex < arrRoleType.count {
            roleTypeDescription = arrRoleType[roleTypeIndex]
        }
        cell.txtFldRoleType.text = roleTypeDescription
        
        cell.txtfldRole.text = moment.role?.capitalized
        cell.txtVwRoleInstructions.text = moment.RoleInstruction?.capitalized
        cell.txtFldPersonRequired.text = moment.personRequired
        cell.txtFldRoleDuration.text = moment.duration
        
        if isEdit{
            cell.txtFldPaymentTerm.text = moment.paymentTerm ?? ""
        }else{
            if Int(moment.paymentTerm ?? "") == 0{
                cell.txtFldPaymentTerm.text = "Fixed"
            }else  if Int(moment.paymentTerm ?? "") == 1{
                cell.txtFldPaymentTerm.text = "Hourly"
            }
        }
        
        
        cell.txtVwOfferBarter.text = moment.OfferBarter?.capitalized
        if let amount = moment.amount, let amountValue = Int(amount), amountValue > 0 {
            cell.txtFldAmount.text = amount
        } else {
            cell.txtFldAmount.text = ""
        }

        cell.onTextViewUpdate = { field, value in
            if field == "roleInstructions" {
                self.arrTaskList[indexPath.row].RoleInstruction = value
            } else if field == "offerBarter" {
                self.arrTaskList[indexPath.row].OfferBarter = value
            }
        }
        let row = indexPath.row
        cell.onTextFieldUpdate = { [weak self] field, value in
            guard let self = self else { return }
            
            // Update the model
            switch field {
            case "role": self.arrTaskList[row].role = value
            case "roleInstructions": self.arrTaskList[row].RoleInstruction = value
            case "personRequired": self.arrTaskList[row].personRequired = value
            case "paymentType": self.arrTaskList[row].paymentType = value
            case "OfferBarter": self.arrTaskList[row].OfferBarter = value
            case "amount": self.arrTaskList[row].amount = value
            case "duration": self.arrTaskList[row].duration = value
            case "roleType": self.arrTaskList[row].roleType = value
            case "paymentTerm": self.arrTaskList[row].paymentTerm = value
            default: break
            }
            updateTotalPayout(for: cell, at: indexPath.row)
//            // Update total dynamically
//            let personStr = self.arrTaskList[row].personRequired ?? "0"
//            let amountStr = self.arrTaskList[row].amount ?? "0"
//            if let person = Int(personStr), let amount = Int(amountStr), amount > 0 {
//                let total = person * amount
//                let fullText = "Total Payout: (\(person) × $\(amount) = $\(total))"
//                let totalString = "$\(total)"
//                let attributed = NSMutableAttributedString(string: fullText)
//
//                if let range = fullText.range(of: totalString) {
//                    attributed.addAttribute(.foregroundColor, value: UIColor.app, range: NSRange(range, in: fullText))
//                }
//                attributed.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: fullText.count))
//                cell.lblTotal.attributedText = attributed
//            } else {
//                cell.lblTotal.text = ""
//            }
        }
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(actionDelete), for: .touchUpInside)
        
        // Tap handlers
        cell.onTapPaymentMethod = { [weak self] tappedCell in
            guard let self = self,
                  let indexPath = tableView.indexPath(for: tappedCell) else { return }
            self.view.endEditing(true)
            print("duration tapped at row \(indexPath.row)")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
            vc.modalPresentationStyle = .popover
            vc.type = "payBy"
            vc.matchTitle = tappedCell.txtFldPaymentMethod.text ?? ""
            vc.callBack = { [weak self] type, title, id in
                guard let self = self else { return }
                switch type {
                case "payBy":
                    
                    tappedCell.txtFldPaymentMethod.text = title
                    if tappedCell.txtFldPaymentMethod.text == "Barter"{
                        cell.txtFldAmount.text = ""
                        cell.txtFldPaymentTerm.text = ""
                        cell.lblTotal.text = ""
                        self.arrTaskList[indexPath.row].paymentType = "\(1)"
                        cell.viewOfferBarter.isHidden = false
                        cell.stackVwPayAndPaymerntTerm.isHidden = true
                        self.updateTableHeight()
                    }else  if tappedCell.txtFldPaymentMethod.text == "Money + Barter"{
                        cell.txtFldAmount.text = ""
                        cell.txtFldPaymentTerm.text = ""
                        cell.lblTotal.text = ""
                        self.arrTaskList[indexPath.row].paymentType = "\(2)"
                        cell.viewOfferBarter.isHidden = false
                        cell.stackVwPayAndPaymerntTerm.isHidden = false
                        self.updateTableHeight()
                    }else{
                        cell.txtFldAmount.text = ""
                        cell.txtFldPaymentTerm.text = ""
                        cell.lblTotal.text = ""
                        self.arrTaskList[indexPath.row].paymentType = "\(0)"
                        cell.viewOfferBarter.isHidden = true
                        cell.stackVwPayAndPaymerntTerm.isHidden = false
                        self.updateTableHeight()
                    }
                    
                default:
                    break
                }
            }
            
            let popOver = vc.popoverPresentationController!
            popOver.sourceView = tappedCell.viewPaymentMethod
            popOver.delegate = self
            popOver.permittedArrowDirections = .any
            vc.preferredContentSize = CGSize(width: tappedCell.viewPaymentMethod.frame.size.width, height: CGFloat(3*50+10))
            
            self.present(vc, animated: false)
        }
        
        
        cell.onTapDuration = { [weak self] tappedCell in
            guard let self = self,
                  let indexPath = tableView.indexPath(for: tappedCell) else { return }
            self.view.endEditing(true)
            print("duration tapped at row \(indexPath.row)")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
            vc.modalPresentationStyle = .popover
            vc.type = "duration"
            vc.matchTitle = tappedCell.txtFldRoleDuration.text ?? ""
            vc.callBack = { [weak self] type, title, id in
                guard let self = self else { return }
                switch type {
                case "duration":
                    tappedCell.txtFldRoleDuration.text = title
                    self.arrTaskList[indexPath.row].duration = title
                default:
                    break
                }
            }
            
            let popOver = vc.popoverPresentationController!
            popOver.sourceView = tappedCell.viewRoleDuiration
            popOver.delegate = self
            popOver.permittedArrowDirections = .up
            vc.preferredContentSize = CGSize(width: tappedCell.viewRoleDuiration.frame.size.width, height: CGFloat(8*50))
            
            self.present(vc, animated: false)
        }
        
        cell.onTapRoleType = { [weak self] tappedCell in
            guard let self = self,
                  let indexPath = tableView.indexPath(for: tappedCell) else { return }
            self.view.endEditing(true)
            print("Payment Type tapped at row \(indexPath.row)")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
            vc.modalPresentationStyle = .popover
            vc.type = "roleType"
            vc.matchTitle = tappedCell.txtFldRoleType.text ?? ""
            vc.callBackRoleType = { [weak self] type,title, index in
                guard let self = self else { return }
                switch type {
                case "roleType":
                    tappedCell.txtFldRoleType.text = title
                    self.arrTaskList[indexPath.row].roleType = "\(index + 1)"
                default:
                    break
                }
            }
            
            let popOver = vc.popoverPresentationController!
            popOver.sourceView = tappedCell.viewRoleType
            popOver.delegate = self
            popOver.permittedArrowDirections = .up
            vc.preferredContentSize = CGSize(width: tappedCell.viewRoleType.frame.size.width, height: 200)
            
            self.present(vc, animated: false)
        }
        cell.onTapPaymentTerm = { [weak self] tappedCell in
            guard let self = self,
                  let indexPath = tableView.indexPath(for: tappedCell) else { return }
            self.view.endEditing(true)
            print("Payment Type tapped at row \(indexPath.row)")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
            vc.modalPresentationStyle = .popover
            vc.type = "payment"
            vc.matchTitle = tappedCell.txtFldPaymentTerm.text ?? ""
            vc.callBackRoleType = { [weak self] type,title, index in
                guard let self = self else { return }
                switch type {
                case "payment":
                    
                    self.arrTaskList[indexPath.row].paymentTerm = "\(index)"
                    if Int(self.arrTaskList[indexPath.row].paymentTerm ?? "") == 0{
                        tappedCell.txtFldPaymentTerm.text = "Fixed"
                    }else if index == 1{
                        tappedCell.txtFldPaymentTerm.text = "Hourly"
                    }
                    
                default:
                    break
                }
            }
            
            let popOver = vc.popoverPresentationController!
            popOver.sourceView = tappedCell.viewPaymentTerm
            popOver.delegate = self
            popOver.permittedArrowDirections = .up
            vc.preferredContentSize = CGSize(width: tappedCell.viewPaymentTerm.frame.size.width, height: 100)
            
            self.present(vc, animated: false)
        }
        
        cell.lblTaskNumber.text = "Task \(indexPath.row + 1)"
        return cell
    }
    func updateTotalPayout(for cell: AddMomentTVC, at index: Int) {
        let personStr = arrTaskList[index].personRequired ?? "0"
        let amountStr = arrTaskList[index].amount ?? "0"
        if let person = Int(personStr), let amount = Int(amountStr), amount > 0 {
            let total = person * amount
            let fullText = "Total Payout: (\(person) × $\(amount) = $\(total))"
            let totalString = "$\(total)"
            let attributed = NSMutableAttributedString(string: fullText)
            if let range = fullText.range(of: totalString) {
                attributed.addAttribute(.foregroundColor, value: UIColor.app, range: NSRange(range, in: fullText))
            }
            attributed.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: fullText.count))
            cell.lblTotal.attributedText = attributed
        } else {
            cell.lblTotal.text = ""
        }
    }

    @objc func actionDelete(sender:UIButton){
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteMomentPopUpVC") as! DeleteMomentPopUpVC
        vc.isSelect = 0
        vc.callBack = {[weak self] in
            guard let self = self else { return }
            let index = sender.tag
            guard index < self.arrTaskList.count else { return }
            
            self.arrTaskList.remove(at: index)
            self.tblVwTaskList.reloadData()
            self.updateTableHeight()
        }
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Handle textfields datepicker
extension AddMomentVC {
    func setupDatePickers() {
        setupDatePicker(for: txtFldTime, mode: .time, selector: #selector(timeDonePress))
        setupDatePicker(for: txtFldDate, mode: .date, selector: #selector(dateDonePress))
    }
    func setupDatePicker(for textField: UITextField, mode: UIDatePicker.Mode, selector: Selector) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        datePicker.tag = textField.tag
        
        if textField == txtFldDate {
            // For Date Picker: today onwards
            datePicker.minimumDate = Date()
        } else if textField == txtFldTime{
            // For Time Picker: 3 hours ahead of now
            let threeHoursLater = Calendar.current.date(byAdding: .hour, value: 3, to: Date())!
            datePicker.minimumDate = threeHoursLater
        }
        
        textField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: selector)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        textField.inputAccessoryView = toolbar
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        switch sender.tag {
        case txtFldTime.tag:
            updateTextField(txtFldTime, datePicker: sender)
        case txtFldDate.tag:
            updateTextField(txtFldDate, datePicker: sender)
        default:
            break
        }
    }
    
    
    @objc func dateDonePress() {
        if let datePicker = txtFldDate.inputView as? UIDatePicker {
            updateTextField(txtFldDate, datePicker: datePicker)
            
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let selectedDateStr = dateFormatter.string(from: datePicker.date)
            let todayStr = dateFormatter.string(from: now)
            
            if selectedDateStr == todayStr {
                // If today, set minimum time to 3 hours from now
                if let timePicker = txtFldTime.inputView as? UIDatePicker {
                    let threeHoursLater = Calendar.current.date(byAdding: .hour, value: 3, to: now)!
                    timePicker.minimumDate = threeHoursLater
                }
            } else {
                // If future date, allow any time
                if let timePicker = txtFldTime.inputView as? UIDatePicker {
                    timePicker.minimumDate = nil
                }
            }
        }
        txtFldDate.resignFirstResponder()
    }
    @objc func timeDonePress() {
        if let datePicker = txtFldTime.inputView as? UIDatePicker {
            updateTextField(txtFldTime, datePicker: datePicker)
            startTimer()
        }
        txtFldTime.resignFirstResponder()
    }
    func startTimer() {
        momentTimer?.invalidate()
        momentTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let now = Date()
            let calendar = Calendar.current
            
            // Add 3 hours to current time
            let futureTime = calendar.date(byAdding: .hour, value: 3, to: now) ?? now
            
            let futureComponents = calendar.dateComponents([.hour, .minute], from: futureTime)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
            guard let selectedTimeString = txtFldTime.text,
                  let selectedTime = dateFormatter.date(from: selectedTimeString) else {
                return
            }
            
            let selectedComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
            
            // Now compare only hour and minute
            if let selectedHour = selectedComponents.hour,
               let selectedMinute = selectedComponents.minute,
               let futureHour = futureComponents.hour,
               let futureMinute = futureComponents.minute {
                
                // Update the date format to match the format in your txtFldDate (dd-MM-yyyy)
                let dateFormatterForDate = DateFormatter()
                dateFormatterForDate.dateFormat = "dd-MM-yyyy"
                
                if let selectedDateString = txtFldDate.text,
                   let selectedDate = dateFormatterForDate.date(from: selectedDateString) {
                    // Check if selectedDate is today
                    let isToday = calendar.isDateInToday(selectedDate)
                    
                    if !isToday {
                        print("Selected date is not today. Keeping the time as is.")
                        return // Don't clear the time if it's not today
                    }
                }
                
                if selectedHour < futureHour || (selectedHour == futureHour && selectedMinute < futureMinute) {
                    txtFldTime.text = ""
                    momentTimer?.invalidate()
                    momentTimer = nil
                    print("Selected time is before current (+3h) time. Clearing text field and stopping timer.")
                }
            }
        }
    }
    func updateTextField(_ textField: UITextField, datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if textField == txtFldDate {
            dateFormatter.dateFormat = "dd-MM-yyyy"
        } else {
            dateFormatter.dateFormat = "h:mm a"  // Applies to both txtFldTime and txtFldLaterToday
        }
        
        textField.text = dateFormatter.string(from: datePicker.date)
        validateDateAndTime()
        
        // Convert to full ISO and 24-hour format
        if
            let dateText = txtFldDate.text,
            let timeText = textField.text,  // works for both time fields
            !dateText.isEmpty,
            !timeText.isEmpty
        {
            let inputFormatter = DateFormatter()
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.dateFormat = "dd-MM-yyyy h:mm a"
            
            if let selectedDateTime = inputFormatter.date(from: "\(dateText) \(timeText)") {
                let isoFormatter = ISO8601DateFormatter()
                isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let isoString = isoFormatter.string(from: selectedDateTime)
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let time24 = timeFormatter.string(from: selectedDateTime)
                
                if textField == txtFldTime{
                    print("Start Time ISO: \(isoString)")
                    print("Start Time (24h): \(time24)")
                    startDate = isoString
                    startTime = time24
                }
            }
        }
    }
    func validateDateAndTime() {
        guard
            let dateText = txtFldDate.text, !dateText.isEmpty,
            let timeText = txtFldTime.text, !timeText.isEmpty
        else {
            return
        }
        
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateTimeFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        
        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateOnlyFormatter.dateFormat = "dd-MM-yyyy"
        
        let now = Date()
        let currentDateStr = dateOnlyFormatter.string(from: now)
        
        guard
            let selectedDate = dateOnlyFormatter.date(from: dateText),
            let selectedDateTime = dateTimeFormatter.date(from: "\(dateText) \(timeText)"),
            let currentDateOnly = dateOnlyFormatter.date(from: currentDateStr)
        else {
            return
        }
        
        if Calendar.current.isDate(selectedDate, inSameDayAs: currentDateOnly) {
            // Add 3 hours to current time
            let threeHoursFromNow = Calendar.current.date(byAdding: .hour, value: 3, to: now)!
            
            //            if selectedDateTime < threeHoursFromNow {
            //                txtFldTime.text = nil
            //                showSwiftyAlert("", "Start time must be at least 3 hours from now to get your suitable applicant hired.", false)
            //                return
            //            }
        }
        
        if selectedDate < currentDateOnly {
            txtFldDate.text = nil
            txtFldTime.text = nil
            showSwiftyAlert("", "Please select valid time.", false)
            return
        }
    }
    
}

extension AddMomentVC:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldTime {
            if txtFldDate.text?.isEmpty ?? true {
                showSwiftyAlert("", "Select date first", false)
                return false // Don't allow editing
            }
        }
        return true // Allow editing
    }
}
// MARK: - Popup
extension AddMomentVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
// MARK: - CLLocationManagerDelegate
extension AddMomentVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        currentlat = location.coordinate.latitude
        currentlong = location.coordinate.longitude
        
        print("Latitude: \(lat ?? 0), Longitude: \(long ?? 0)")
        
        // Optionally stop updates if you only need one
        locationManager.stopUpdatingLocation()
    }
    
}

