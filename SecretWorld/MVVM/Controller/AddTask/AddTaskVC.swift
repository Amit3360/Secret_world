//
//  AddTaskVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 22/01/25.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import AlignedCollectionViewFlowLayout

class AddTaskVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var txtFldPaymentMeethod: UITextField!
    
    @IBOutlet weak var topHeaderImg: NSLayoutConstraint!
    @IBOutlet weak var bottomHeaderImg: NSLayoutConstraint!
    @IBOutlet weak var vwAddImage: UIView!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var btnNoImage: UIButton!
    @IBOutlet weak var txtVwAvoidDescription: IQTextView!
    @IBOutlet weak var heightTimeDuration: NSLayoutConstraint!
    @IBOutlet weak var vwTimeDuration: UIView!
    @IBOutlet weak var vwTime: UIView!
    @IBOutlet weak var stackVwTime: UIStackView!
    @IBOutlet weak var vwDate: UIView!
    @IBOutlet weak var btnLater: UIButton!
    @IBOutlet weak var btnNow: UIButton!
    @IBOutlet weak var heightToolsVw: NSLayoutConstraint!
    @IBOutlet weak var heightSkillVw: NSLayoutConstraint!
    @IBOutlet weak var btnChooseCategory: UIButton!
    @IBOutlet weak var vwAddCategory: UIView!
    @IBOutlet weak var txtFldAddCategory: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwCollVwTools: UIView!
    @IBOutlet weak var vwAddTools: UIView!
    @IBOutlet weak var vwCollVwSkill: UIView!
    @IBOutlet weak var vwAddSkill: UIView!
    @IBOutlet weak var txtFldAddTools: UITextField!
    @IBOutlet weak var collVwTools: UICollectionView!
    @IBOutlet weak var collVwSkills: UICollectionView!
    @IBOutlet weak var txtFldOwnSkill: UITextField!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var txtFldTimeDuration: UITextField!
    @IBOutlet weak var txtFldTime: UITextField!
    @IBOutlet weak var txtFldDate: UITextField!
    @IBOutlet weak var txtFldUrgency: UITextField!
    @IBOutlet weak var txtFldAmount: UITextField!
    @IBOutlet weak var txtVwSafetyTips: IQTextView!
    @IBOutlet weak var txtVwInstruction: IQTextView!
    @IBOutlet weak var txtFldNoOfPerson: UITextField!
    @IBOutlet weak var lblTools: UILabel!
    @IBOutlet weak var dropDownTools: UIImageView!
    @IBOutlet weak var lblSkills: UILabel!
    @IBOutlet weak var dropDownSkills: UIImageView!
   // @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var dropDownPaymentMethod: UIImageView!
    @IBOutlet weak var dropDownPaymentTerm: UIImageView!
    @IBOutlet weak var lblPaymentTerms: UILabel!
    @IBOutlet weak var txtFldMap: UITextField!
    @IBOutlet weak var txtVwAddress: IQTextView!
    @IBOutlet weak var btnRemote: UIButton!
    @IBOutlet weak var btnOnSite: UIButton!
    @IBOutlet weak var imgVwTask: UIImageView!
    @IBOutlet weak var lblChooseExperience: UILabel!
    @IBOutlet weak var dropDownChooseExperience: UIImageView!
    @IBOutlet weak var dropDownCategory: UIImageView!
    @IBOutlet weak var lblChooseCategory: UILabel!
    @IBOutlet weak var txtVwDescription: IQTextView!
    @IBOutlet weak var txtFldTitle: UITextField!
    
    //MARK: - VARIABLES
    private let locationManager = CLLocationManager()
    var selectedTitle:String?
    var selectGigType = "inMyLocation"
    var userGigDetail:GetUserGigData?
    var isComing  = true
    var isUploading = false
    var viewModel  = AddGigVM()
    var lat = Double()
    var long = Double()
    var bsuinessGigDetail:GetGigDetailData?
    var walletViewModel = PaymentVM()
    var walletAmount = 0
    var gigFees:Int?
    var selectedStartDate = ""
    var IsUserGig = false
    var serviceName = ""
    var serviceDuration = ""
    var experience = ""
    var paymentTerm = ""
    var paymentMethod = ""
    var callBack:(()->())?
    var arrGetCategories = [Skills]()
    var arrGetSkill = [Skills]()
    var offset = 1
    var limit = 200
    var isWorldwide = false
    var viewModelAuth = AuthVM()
    var paymentTerms = 0
    var paymentMethods = 1
    var isCancellation = 0
    var startDate:String?
    var startTime:String?
    var arrSelectedSkills = [Skills]()
    var arrTools = [String]()
    var categoryId:String = ""
    var arrSkillId = [String]()
    var gigId = ""
    var isDetailData = false
    var newPrice = ""
    var availability = 0
    var viewModelBank = PaymentVM()
    var arrBank = [BankAccountDetailData]()
    var currentDate:String?
    var currentTime:String?
    var addImage = 1
    var isUplaodImg = false
    var isComingHome = false
    var taskDetail:FilteredItem?
    var taskImage = ""
    var paymentMethodChanged = false
    let deviceHasNotch = UIApplication.shared.hasNotch
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    
    private func uiSet(){
        if deviceHasNotch{
            self.topHeaderImg.constant = 0
            self.bottomHeaderImg.constant = 10
        }else{
            self.topHeaderImg.constant = -10
            self.bottomHeaderImg.constant = 0
        }
        txtFldDate.tag = 1
        txtFldTime.tag = 2
        txtFldTimeDuration.tag = 3

        txtFldAmount.maxLength = 10
        txtFldNoOfPerson.maxLength = 5
        txtFldNoOfPerson.delegate = self
        txtFldAmount.delegate = self
        txtFldOwnSkill.delegate = self
        txtFldAddCategory.delegate = self
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        currentDate = dateFormatter.string(from: date)
//        let time = Date()
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "hh:mm a"
//        currentTime = timeFormatter.string(from: time)
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"

        // Add 9 minutes to current time
        if let nineMinutesLater = Calendar.current.date(byAdding: .minute, value: 9, to: time) {
            let nowTime = timeFormatter.string(from: nineMinutesLater)
            print(currentTime) // This will show the time after adding 9 minutes
            currentTime = nowTime
        }
        
        updateButtonStates(selectedButton: btnOnSite, deselectedButton: btnRemote)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
            self.getSkillsApi(type: "Specialization")
            self.getCategoryApi(type: "Category")
        }
        let nib = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
        collVwTools.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        collVwSkills.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        let alignedFlowLayoutCollVwDietry = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwTools.collectionViewLayout = alignedFlowLayoutCollVwDietry
        
        let alignedFlowLayoutCollVwSpecializ = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwSkills.collectionViewLayout = alignedFlowLayoutCollVwSpecializ
        
        
        if let flowLayout = collVwTools.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 40)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            
        }
        
        if let flowLayout1 = collVwSkills.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout1.estimatedItemSize = CGSize(width: 0, height: 40)
            flowLayout1.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        txtFldTitle.delegate = self
        setupDatePicker(for:txtFldDate, mode: .date, selector: #selector(startDateDonePressed))
        setupDatePicker(for: txtFldTime, mode: .time, selector: #selector(startTimeDonePressed))
        setupDatePicker(for: txtFldTimeDuration, mode: .countDownTimer, selector: #selector(timePickerDonePressed))
        if isComing == true{
            //        getCommisionApi()
            lblTitle.text = "Add Task"
            
            btnCreate.setTitle("Create Task", for: .normal)
            txtFldAmount.isUserInteractionEnabled = true
            handleLocationManager()
        }else{
            Store.AddGigImage = nil
            Store.AddGigDetail = nil
            
            lblTitle.text = "Edit Task"
            btnCreate.setTitle("Update Task", for: .normal)
            txtFldAmount.isUserInteractionEnabled = false
            if self.isDetailData == false{
                let value: Double = userGigDetail?.gig?.price ?? 0
                let formattedValue = String(format: "%.2f", value)
                newPrice = "\(formattedValue)"
                serviceName = userGigDetail?.gig?.title ?? ""
                serviceDuration = userGigDetail?.gig?.serviceDuration ?? ""
                experience = userGigDetail?.gig?.experience ?? ""
                paymentTerm = "\(userGigDetail?.gig?.paymentTerms ?? 0)"
                paymentMethod = "\(userGigDetail?.gig?.paymentMethod ?? 0)"
                categoryId = userGigDetail?.gig?.category?.id ?? ""
                lat = userGigDetail?.gig?.lat ?? 0
                long = userGigDetail?.gig?.long ?? 0
                isCancellation = userGigDetail?.gig?.isCancellation ?? 0
                self.txtFldTitle.text = userGigDetail?.gig?.title ?? ""
                self.txtVwDescription.text = userGigDetail?.gig?.about ?? ""
                
                self.lblChooseCategory.text = userGigDetail?.gig?.category?.name ?? ""
                self.lblChooseCategory.textColor = .black
                
                self.lblChooseExperience.text = userGigDetail?.gig?.experience ?? ""
                self.lblChooseExperience.textColor = .black
                
                self.txtVwAddress.text = userGigDetail?.gig?.address ?? ""
                self.txtFldMap.text = userGigDetail?.gig?.place ?? ""
                
                self.txtFldAmount.text = "\(formattedValue)"
                //            self.txtFldDressCode.text = userGigDetail?.gig?.dressCode ?? ""
                self.txtVwSafetyTips.text = userGigDetail?.gig?.safetyTips ?? ""
                self.txtVwInstruction.text = userGigDetail?.gig?.description ?? ""
                self.txtFldTimeDuration.text = userGigDetail?.gig?.serviceDuration ?? ""
                self.imgVwTask.imageLoad(imageUrl: userGigDetail?.gig?.image ?? "")
                self.taskImage = userGigDetail?.gig?.image ?? ""
                
                let isoDateFormatter = ISO8601DateFormatter()
                isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                if let date = isoDateFormatter.date(from: userGigDetail?.gig?.startDate ?? "") {
                    let displayDateFormatter = DateFormatter()
                    displayDateFormatter.dateFormat = "dd-MM-yyyy"
                    let formattedDate = displayDateFormatter.string(from: date)
                    self.txtFldDate.text = formattedDate
                    self.currentDate = formattedDate
                }
                if let time = isoDateFormatter.date(from: userGigDetail?.gig?.startTime ?? "") {
                    let displayDateFormatter = DateFormatter()
                    displayDateFormatter.dateFormat = "hh:mm a"
                    let formattedDate = displayDateFormatter.string(from: time)
                    self.txtFldTime.text = formattedDate
                    self.currentTime = formattedDate
                }
                if userGigDetail?.gig?.paymentMethod == 0{
                    txtFldPaymentMeethod.text = "Online"
                    txtFldPaymentMeethod.textColor = .black
                    paymentMethods = 0
                }else{
                    txtFldPaymentMeethod.text = "Cash"
                    txtFldPaymentMeethod.textColor = .black
                    paymentMethods = 1
                }
                if userGigDetail?.gig?.paymentTerms == 0{
                    
                    lblPaymentTerms.text = "Fixed"
                    lblPaymentTerms.textColor = .black
                }else{
                    
                    lblPaymentTerms.text = "Hourly"
                    lblPaymentTerms.textColor = .black
                }
                if userGigDetail?.gig?.isCancellation == 1{
                    btnTick.isSelected = true
                }else{
                    btnTick.isSelected = false
                }
                
                if userGigDetail?.gig?.availability == 0{
                    updateButtonStates(selectedButton: btnNow, deselectedButton: btnLater)
                    heightTimeDuration.constant = 138
                    vwDate.isHidden = true
                    stackVwTime.isHidden = false
                    vwTime.isHidden = true
                    vwTimeDuration.isHidden = false
                    availability = 0
                }else{
                    updateButtonStates(selectedButton: btnLater, deselectedButton: btnNow)
                    heightTimeDuration.constant = 192
                    vwDate.isHidden = false
                    stackVwTime.isHidden = false
                    vwTime.isHidden = false
                    vwTimeDuration.isHidden = false
                    availability = 1
                }
                
                txtFldNoOfPerson.text = "\(userGigDetail?.gig?.totalParticipants ?? 0)"
                for i in userGigDetail?.gig?.skills ?? []{
                    self.arrSkillId.append(i.id ?? "")
                    self.arrSelectedSkills.append(Skills(id: i.id ?? "", name: i.name ?? ""))
                    arrGetSkill.append(Skills(id: i.id ?? "", name: i.name ?? ""))
                }
                
                if arrSelectedSkills.count>0{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        self?.heightSkillVw.constant = (self?.collVwSkills.contentSize.height ?? 0) + 10
                        self?.vwCollVwSkill.isHidden = false
                        self?.vwAddSkill.isHidden = true
                    }
                }else{
                    self.vwAddSkill.isHidden = true
                    self.heightSkillVw.constant = 0
                    self.vwCollVwSkill.isHidden = false
                }
                
                self.collVwSkills.reloadData()
                arrTools = userGigDetail?.gig?.tools ?? []
                if arrTools.count>0{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        self?.heightToolsVw.constant = (self?.collVwTools.contentSize.height ?? 0) + 10
                        self?.vwCollVwTools.isHidden = false
                        
                    }
                }else{
                    
                    self.heightSkillVw.constant = 0
                    self.vwCollVwTools.isHidden = true
                }
                self.collVwTools.reloadData()
                if userGigDetail?.gig?.type == "worldwide"{
                    selectGigType = "worldwide"
                    btnRemote.backgroundColor = .app
                    btnRemote.setTitleColor(.white, for: .normal)
                    btnOnSite.backgroundColor = .white
                    btnOnSite.setTitleColor(UIColor(hex: "#545454"), for: .normal)
                }else{
                    selectGigType = "inMyLocation"
                    btnOnSite.backgroundColor = .app
                    btnOnSite.setTitleColor(.white, for: .normal)
                    btnRemote.backgroundColor = .white
                    btnRemote.setTitleColor(UIColor(hex: "#545454"), for: .normal)
                }
                self.txtVwAvoidDescription.text = userGigDetail?.gig?.avoidDescription ?? ""
                if userGigDetail?.gig?.image == "" || userGigDetail?.gig?.image == nil || ((userGigDetail?.gig?.image?.contains("dummyimage.jpg")) == true){
                    self.vwAddImage.isHidden = true
                    self.isUplaodImg = false
                    self.addImage = 0
                    self.updateButtonStates(selectedButton: btnNoImage, deselectedButton: btnAddImage)
                }else{
                    self.addImage = 1
                    self.isUplaodImg = true
                    self.vwAddImage.isHidden = false
                    self.updateButtonStates(selectedButton: btnAddImage, deselectedButton: btnNoImage)
                }
                
                setupCollectionViewLayout(for: collVwTools)
                setupCollectionViewLayout(for: collVwSkills)
            }else{
                if let skills = bsuinessGigDetail?.skills {
                    arrSelectedSkills = skills.map { Skills(id: $0.id ?? "", name: $0.name ?? "") }
                }
                
                let value: Double = bsuinessGigDetail?.price ?? 0
                let formattedValue = String(format: "%.2f", value)
                lat = bsuinessGigDetail?.lat ?? 0
                long = bsuinessGigDetail?.long ?? 0
                newPrice = "\(formattedValue)"
                isCancellation = bsuinessGigDetail?.isCancellation ?? 0
                serviceName = bsuinessGigDetail?.title ?? ""
                serviceDuration = bsuinessGigDetail?.serviceDuration ?? ""
                experience = bsuinessGigDetail?.experience ?? ""
                paymentTerm = "\(bsuinessGigDetail?.paymentTerms ?? 0)"
                paymentMethod = "\(bsuinessGigDetail?.paymentMethod ?? 0)"
                categoryId = bsuinessGigDetail?.category?.id ?? ""
                self.txtFldTitle.text = bsuinessGigDetail?.title ?? ""
                self.txtVwDescription.text = bsuinessGigDetail?.about ?? ""
                self.lblChooseCategory.text = bsuinessGigDetail?.category?.name ?? ""
                self.lblChooseCategory.textColor = .black
                
                self.lblChooseExperience.text = bsuinessGigDetail?.experience ?? ""
                self.lblChooseExperience.textColor = .black
                
                self.txtVwAddress.text = bsuinessGigDetail?.place ?? ""
                self.txtFldMap.text = bsuinessGigDetail?.address ?? ""
                
                self.txtFldAmount.text = "\(formattedValue)"
                //            self.txtFldDressCode.text = bsuinessGigDetail?.dressCode ?? ""
                self.txtVwSafetyTips.text = bsuinessGigDetail?.safetyTips ?? ""
                self.txtVwInstruction.text = bsuinessGigDetail?.description ?? ""
                self.txtFldTimeDuration.text = bsuinessGigDetail?.serviceDuration ?? ""
                self.imgVwTask.imageLoad(imageUrl: bsuinessGigDetail?.image ?? "")
                self.taskImage = bsuinessGigDetail?.image ?? ""
                let isoDateFormatter = ISO8601DateFormatter()
                isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                if let date = isoDateFormatter.date(from: bsuinessGigDetail?.startDate ?? "") {
                    let displayDateFormatter = DateFormatter()
                    displayDateFormatter.dateFormat = "dd-MM-yyyy"
                    let formattedDate = displayDateFormatter.string(from: date)
                    self.txtFldDate.text = formattedDate
                    self.currentDate = formattedDate
                }
                if let time = isoDateFormatter.date(from: bsuinessGigDetail?.startTime ?? "") {
                    let displayDateFormatter = DateFormatter()
                    displayDateFormatter.dateFormat = "hh:mm a"
                    let formattedDate = displayDateFormatter.string(from: time)
                    self.txtFldTime.text = formattedDate
                    self.currentTime = formattedDate
                }
                if bsuinessGigDetail?.isCancellation == 1{
                    btnTick.isSelected = true
                }else{
                    btnTick.isSelected = false
                }
                
                if bsuinessGigDetail?.paymentMethod == 0{
                    txtFldPaymentMeethod.text = "Online"
                    txtFldPaymentMeethod.textColor = .black
                    paymentMethods = 0
                }else{
                    txtFldPaymentMeethod.text = "Cash"
                    txtFldPaymentMeethod.textColor = .black
                    paymentMethods = 1
                }
                if bsuinessGigDetail?.paymentTerms == 0{
                    
                    lblPaymentTerms.text = "Fixed"
                    lblPaymentTerms.textColor = .black
                }else{
                    
                    lblPaymentTerms.text = "Hourly"
                    lblPaymentTerms.textColor = .black
                }
                txtFldNoOfPerson.text = "\(bsuinessGigDetail?.totalParticipants ?? 0)"
                
                for i in arrSelectedSkills{
                    self.arrSkillId.append(i.id)
                }
                for i in userGigDetail?.gig?.skills ?? []{
                    arrGetSkill.append(Skills(id: i.id ?? "", name: i.name ?? ""))
                }
                if arrSelectedSkills.count>0{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        
                        self?.heightSkillVw.constant = (self?.collVwSkills.contentSize.height ?? 0) + 10
                        self?.vwCollVwSkill.isHidden = false
                        self?.vwAddSkill.isHidden = true
                    }
                }else{
                    self.vwAddSkill.isHidden = true
                    self.heightSkillVw.constant = 0
                    self.vwCollVwSkill.isHidden = false
                }
                
                self.collVwSkills.reloadData()
                if arrTools.count>0{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        self?.heightToolsVw.constant = (self?.collVwTools.contentSize.height ?? 0) + 10
                        self?.vwCollVwTools.isHidden = false
                        
                    }
                }else{
                    
                    self.heightSkillVw.constant = 0
                    self.vwCollVwTools.isHidden = true
                }
                self.collVwTools.reloadData()
                if bsuinessGigDetail?.type == "worldwide"{
                    selectGigType = "worldwide"
                    btnRemote.backgroundColor = .app
                    btnRemote.setTitleColor(.white, for: .normal)
                    btnOnSite.backgroundColor = .white
                    btnOnSite.setTitleColor(UIColor(hex: "#545454"), for: .normal)
                }else{
                    selectGigType = "inMyLocation"
                    btnOnSite.backgroundColor = .app
                    btnOnSite.setTitleColor(.white, for: .normal)
                    btnRemote.backgroundColor = .white
                    btnRemote.setTitleColor(UIColor(hex: "#545454"), for: .normal)
                }
                
                if bsuinessGigDetail?.availability == 0{
                    updateButtonStates(selectedButton: btnNow, deselectedButton: btnLater)
                    heightTimeDuration.constant = 138
                    vwDate.isHidden = true
                    stackVwTime.isHidden = false
                    vwTime.isHidden = true
                    vwTimeDuration.isHidden = false
                    availability = 0
                }else{
                    updateButtonStates(selectedButton: btnLater, deselectedButton: btnNow)
                    heightTimeDuration.constant = 192
                    vwDate.isHidden = false
                    stackVwTime.isHidden = false
                    vwTime.isHidden = false
                    vwTimeDuration.isHidden = false
                    availability = 1
                }
                self.txtVwAvoidDescription.text = bsuinessGigDetail?.avoidDescription ?? ""
                if bsuinessGigDetail?.image == "" || bsuinessGigDetail?.image == nil || ((bsuinessGigDetail?.image?.contains("dummyimage.jpg")) == true){
                    self.vwAddImage.isHidden = true
                    self.isUplaodImg = false
                    self.addImage = 0
                    self.updateButtonStates(selectedButton: btnNoImage, deselectedButton: btnAddImage)
                }else{
                    self.addImage = 1
                    self.isUplaodImg = true
                    self.vwAddImage.isHidden = false
                    self.updateButtonStates(selectedButton: btnAddImage, deselectedButton: btnNoImage)
                }
            }
        }
    }
    func handleLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // Request permission
        locationManager.startUpdatingLocation()

    }
    func setupCollectionViewLayout(for collectionView: UICollectionView) {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collectionView.collectionViewLayout = layout
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 40)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @objc func handleSwipe() {
        Store.AddGigImage = nil
        Store.AddGigDetail = nil
        if isComing{
            SceneDelegate().userRoot()
            callBack?()
        }else{
            self.navigationController?.popViewController(animated: true)
            callBack?()
        }
        
    }
    
    //func getCommisionApi(){
    //    walletViewModel.GetComissionApi{ data in
    //        Store.commisionAmount = data?.result?.commission
    //    }
    //}
    
    private func updateButtonStates(selectedButton: UIButton, deselectedButton: UIButton) {
        selectedButton.backgroundColor = .app
        selectedButton.setTitleColor(.white, for: .normal)
        deselectedButton.backgroundColor = UIColor.white
        deselectedButton.borderCol = UIColor.app
        deselectedButton.borderWid = 1
        deselectedButton.setTitleColor(UIColor(hex: "#545454"), for: .normal)
    }
    func combineDateAndTime(dateString: String, timeString: String) -> String? {
        // Define the input formats for date and time
        let dateInputFormat = "dd-MM-yyyy"
        let timeInputFormat = "hh:mm a"
        let outputDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        // Create a date formatter for the date part
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Use UTC
        
        // Parse the date
        dateFormatter.dateFormat = dateInputFormat
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        
        // Parse the time
        dateFormatter.dateFormat = timeInputFormat
        guard let time = dateFormatter.date(from: timeString) else { return nil }
        
        // Combine date and time using a UTC calendar
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        // Create the combined date
        guard let combinedDate = calendar.date(from: dateComponents) else { return nil }
        
        // Format the combined date into the output format
        dateFormatter.dateFormat = outputDateFormat
        let iso8601String = dateFormatter.string(from: combinedDate)
        return iso8601String
    }

    func onFormatChanger(startDateTime: String) -> String? {
        // Define the input date format
        let inputFormat = DateFormatter()
        inputFormat.dateFormat = "dd-MM-yyyy hh:mm a"
        //inputFormat.timeZone = TimeZone.current
        inputFormat.locale = Locale(identifier: "en_US_POSIX")

        // Parse the input date string
        guard let date = inputFormat.date(from: startDateTime) else {
            return nil // Return nil if the input string cannot be parsed
        }

        // Define the output date format
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        outputFormat.timeZone = TimeZone(abbreviation: "UTC")
        outputFormat.locale = Locale(identifier: "en_US_POSIX")

        // Format and return the converted date string
        return outputFormat.string(from: date)
    }

    func addUpdateGigApi(){
        guard let selectedDate = currentDate,
              let selectedTime = currentTime else {
            print("Date or time is missing.")
            return
        }
        
        if let combinedDate = combineDateAndTime(dateString: selectedDate, timeString: selectedTime) {
            print("Combined ISO 8601 Date: \(combinedDate)")
            startDate = combinedDate
        }
        if let combinedTime = combineDateAndTime(dateString: selectedDate, timeString: selectedTime) {
            print("Combined ISO 8601 Date: \(combinedTime)")
            startTime = combinedTime
        }
        let dateFormatted = onFormatChanger(startDateTime: "\(currentDate ?? "") \(currentTime ?? "")")
        if isUplaodImg == false{
            self.imgVwTask.image = UIImage(named: "dummy")
        }
        if isComing == true{
            
            viewModel.AddNewGigApi(usertype: Store.role ?? "",
                                   image: imgVwTask,
                                   name: Store.UserDetail?["userName"] as? String ?? "",
                                   type: selectGigType,
                                   title: txtFldTitle.text ?? "",
                                   serviceName: "Haircut",
                                   serviceDuration: txtFldTimeDuration.text ?? "",
                                   startDate: dateFormatted ?? "",
                                   place:txtVwAddress.text ?? "" ,
                                   lat: lat,
                                   long: long,
                                   participants: txtFldNoOfPerson.text ?? "",
                                   about: txtVwDescription.text ?? "",
                                   price: Double(txtFldAmount.text ?? "") ?? 0,
                                   gigId: gigId,
                                   experience: lblChooseExperience.text ?? "",
                                   address: txtFldMap.text ?? "",
                                   paymentTerms: paymentTerms,
                                   paymentMethod: paymentMethods,
                                   category:categoryId,
                                   skills: arrSkillId,
                                   tools: arrTools,
                                   dressCode: "",
                                   personNeeded: Int(txtFldNoOfPerson.text ?? "") ?? 0,
                                   description: txtVwInstruction.text ?? "",
                                   safetyTips: txtVwSafetyTips.text ?? "",
                                   startTime: dateFormatted ?? "",
                                   isCancellation: isCancellation,
                                   isImageNil: isUplaodImg,availability: availability,avoidDescription: txtVwAvoidDescription.text ?? "") { data in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigCreatedVC") as! GigCreatedVC
                vc.modalPresentationStyle = .overFullScreen
                vc.callBack = {[weak self] in
                    guard let self = self else { return }
                    //                    SceneDelegate().GigListVCRoot()
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "GigListVC") as! GigListVC
                    nextVC.isComing = 2
                    nextVC.isCreate = true
                    Store.isUserParticipantsList = true
                    nextVC.callBack = {[weak self] in
                        
                        DispatchQueue.main.async {
                            self?.uiSet()
                        }
                    }
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                self.navigationController?.present(vc, animated: false)
                
            }
        }else{
            
            viewModel.UpdateNewGigApi(id:gigId, usertype: Store.role ?? "",
                                      image: imgVwTask,
                                      name: Store.UserDetail?["userName"] as? String ?? "",
                                      type: selectGigType,
                                      title: txtFldTitle.text ?? "",
                                      serviceName: "Haircut",
                                      serviceDuration: txtFldTimeDuration.text ?? "",
                                      startDate: dateFormatted ?? "",
                                      place:txtVwAddress.text ?? "",
                                      lat: lat,
                                      long: long,
                                      participants: txtFldNoOfPerson.text ?? "",
                                      about: txtVwDescription.text ?? "",
                                      price: Double(txtFldAmount.text ?? "") ?? 0,
                                      gigId: gigId,
                                      experience: lblChooseExperience.text ?? "",
                                      address:txtFldMap.text ?? "" ,
                                      paymentTerms: paymentTerms,
                                      paymentMethod: paymentMethods,
                                      category:categoryId,
                                      skills: arrSkillId,
                                      tools: arrTools,
                                      dressCode: "",
                                      personNeeded: Int(txtFldNoOfPerson.text ?? "") ?? 0,
                                      description: txtVwInstruction.text ?? "",
                                      safetyTips: txtVwSafetyTips.text ?? "",
                                      startTime: dateFormatted ?? "",
                                      isCancellation: isCancellation,
                                      isImageNil: isUplaodImg,availability: availability,avoidDescription: txtVwAvoidDescription.text ?? "") { data in
                //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigCreatedVC") as! GigCreatedVC
                //                vc.modalPresentationStyle = .overFullScreen
                //                vc.callBack = {[weak self] in
                //                    guard let self = self else { return }
                showSwiftyAlert("", data?.message ?? "", true)
                //                    SceneDelegate().GigListVCRoot()
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "GigListVC") as! GigListVC
                nextVC.isComing = 2
                Store.isUserParticipantsList = true
                self.navigationController?.pushViewController(nextVC, animated: true)
                //                }
                //                self.navigationController?.present(vc, animated: false)
                
            }
        }
    }
    func getCategoryApi(type:String){
        viewModelAuth.UserFunstionsListApi(type: type,offset:offset,limit: limit, search: "") { data in
            self.arrGetCategories.removeAll()
            self.arrGetCategories.insert(Skills(id: "0", name: "Add your own category"), at: 0)
            for i in data?.data ?? []{
                self.arrGetCategories.append(Skills(id: i._id ?? "", name: i.name ?? ""))
            }
            
            
        }
    }
    func getSkillsApi(type:String){
        viewModelAuth.UserFunstionsListApi(type: type,offset:offset,limit: limit, search: "") { data in
            self.arrGetSkill.removeAll()
            self.arrGetSkill.insert(Skills(id: "0", name: "Add your own skills"), at: 0)
            for i in data?.data ?? []{
                if i.name != ""{
                    self.arrGetSkill.append(Skills(id: i._id ?? "", name: i.name ?? ""))
                }
            }
            
            
        }
    }
    func showPopOver(type: String, sender: UIButton,height:CGFloat) {
        view.endEditing(true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = type
        vc.locationType = self.selectGigType
        if type == "category"{
            vc.matchTitle = selectedTitle
            vc.arrGetCategories = arrGetCategories
        }else if type == "skills"{
            vc.arrGetSkills = arrGetSkill
            vc.arrSelectedSkills = arrSelectedSkills
        }else if type == "experience"{
            vc.matchTitle = lblChooseExperience.text ?? ""
        }else if type == "payment"{
            vc.matchTitle = lblPaymentTerms.text ?? ""
        }else if type == "paymentMethod"{
            vc.matchTitle = paymentMethod
        }
        vc.modalPresentationStyle = .popover
        vc.callBack = { [weak self] type, title, id in
            guard let self = self else { return }
            switch type {
            case "category":
                if title == "Add your own category"{
                    self.vwAddCategory.isHidden = false
                    self.lblChooseCategory.text = "Add your own category"
                    self.lblChooseCategory.textColor = .black
                    self.selectedTitle = ""
                }else{
                    self.selectedTitle = title
                    //                    btnChooseCategory.setTitle("\(title)", for: .normal)
                    //                    btnChooseCategory.setTitleColor(.black, for: .normal)
                    self.vwAddCategory.isHidden = true
                    self.lblChooseCategory.text = "\(title)"
                    self.lblChooseCategory.textColor = .black
                    categoryId = id
                }
            case "experience":
                //                btnChooseExperience.setTitle("\(title)", for: .normal)
                //                btnChooseExperience.setTitleColor(.black, for: .normal)
                lblChooseExperience.text = "\(title)"
                lblChooseExperience.textColor = .black
                experience = title
            case "payment":
                lblPaymentTerms.text = "\(title)"
                lblPaymentTerms.textColor = .black
                paymentTerm = title
                
            case "skills":
                if title == "Add your own skills"{
                    self.vwAddSkill.isHidden = false
                }else{
                    self.vwAddSkill.isHidden = true
                    if arrSelectedSkills.contains(where: { $0.name == title }) {
                        //showSwiftyAlert("", "Already added Skills.", false)
                    } else {
                        arrSkillId.insert(id, at: 0)
                        arrSelectedSkills.insert(Skills(id: id, name: title), at: 0)
                        collVwSkills.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.heightSkillVw.constant = self.collVwSkills.contentSize.height + 10
                            self.vwCollVwSkill.isHidden = false
                        }
                    }
                    
                }
                
            case "paymentMethod":
                
                if title == "Cash"{
                    paymentMethods = 1
                }else{
                    paymentMethods = 1
                    paymentMethodChanged = true
                }
                
                txtFldPaymentMeethod.text = "\(title)"
                txtFldPaymentMeethod.textColor = .black
                paymentMethod = title
            default:
                break
            }
            
        }
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(width: btnChooseCategory.frame.size.width, height: height)
        self.present(vc, animated: false)
        
    }
    @IBAction func actionAddCategory(_ sender: UIButton) {
        if txtFldAddCategory.text?.trimWhiteSpace.isEmpty == true {
            showSwiftyAlert("", "Enter your task category", false)
        }else if !(txtFldAddCategory.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your task category should contain meaningful text", false)
            
        }else{
            viewModelAuth.CreateUserFunction(type: "Category", name: txtFldAddCategory.text ?? "") { data in
                self.getCategoryApi(type: "Category")
                self.txtFldAddCategory.text = ""
                self.categoryId = data?.data?._id ?? ""
                self.vwAddCategory.isHidden = true
                //            self.btnChooseCategory.setTitle(data?.data?.name ?? "", for: .normal)
                //            self.btnChooseCategory.setTitleColor(.black, for: .normal)
                self.lblChooseCategory.text = data?.data?.name ?? ""
                self.lblChooseCategory.textColor = .black
            }
        }
        
    }
    @IBAction func actionReadMoreCancelation(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.isComing = 2
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionAddSkills(_ sender: UIButton) {
        if txtFldOwnSkill.text?.trimWhiteSpace.isEmpty == true {
            showSwiftyAlert("", "Enter your skills.", false)
        }else if !(txtFldOwnSkill.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your task skills should contain meaningful text", false)
            
        }else{
            
            viewModelAuth.CreateUserFunction(type: "Specialization", name: txtFldOwnSkill.text ?? "") { data in
                self.getSkillsApi(type: "Specialization")
                self.txtFldOwnSkill.text = ""
                self.vwAddSkill.isHidden = true
                self.arrSkillId.insert(data?.data?._id ?? "", at: 0)
                self.arrSelectedSkills.insert(Skills(id: data?.data?._id ?? "", name: data?.data?.name ?? ""), at: 0)
                self.collVwSkills.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.heightSkillVw.constant = self.collVwSkills.contentSize.height + 10
                    self.vwCollVwSkill.isHidden = false
                }
                
            }
        }
    }
    @IBAction func actionTick(_ sender: UIButton) {
        view.endEditing(true)
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            isCancellation = 1
        }else{
            isCancellation = 0
        }
    }

    @IBAction func actionCreate(_ sender: UIButton) {
        view.endEditing(true)
        
        if categoryId == ""{
            showSwiftyAlert("", "Select a category.", false)
        }else if txtVwDescription.text == ""{
            showSwiftyAlert("", "Enter description for your task.", false)
        }else if !(txtVwDescription.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your description should contain meaningful text", false)
            
        }else if experience == ""{
            showSwiftyAlert("", "Select your experience level.", false)
        }else if addImage == 1 && isUplaodImg == false{
            showSwiftyAlert("", "Select a task image.", false)
        } else if !(txtVwAddress.text ?? "").isEmpty, !(txtVwAddress.text ?? "").isValidInput {
            showSwiftyAlert("", "Invalid Input: your address should contain meaningful text", false)
        }else if txtFldMap.text == ""{
            showSwiftyAlert("", "Select your location.", false)
        }else if paymentTerm == ""{
            showSwiftyAlert("", "Select your payment terms.", false)
        }else if experience == ""{
            showSwiftyAlert("", "Select your experience", false)
//        }else if txtFldPaymentMeethod.text == ""{
//            showSwiftyAlert("", "Select a payment method.", false)
            
        }else if txtFldAmount.text == "" {
            showSwiftyAlert("", "Enter the fee amount.", false)
        }else if txtFldAmount.text != "" {

            let formatter = NumberFormatter()
               formatter.numberStyle = .decimal
               formatter.locale = Locale.current
               
               if let amountText = txtFldAmount.text, let amount = formatter.number(from: amountText)?.doubleValue, amount > 0 {
                   if txtFldNoOfPerson.text == ""{
                      showSwiftyAlert("", "Enter the number of participants", false)
                  }else if Int(txtFldNoOfPerson.text ?? "0") ?? 0 <= 0 {
                      showSwiftyAlert("", "Enter valid participants", false)
                      
                  } else if !(txtVwInstruction.text ?? "").isEmpty, !(txtVwInstruction.text ?? "").isValidInput {
                      if !(txtVwInstruction.text ?? "").isValidInput{
                         showSwiftyAlert("", "Invalid Input: your instructions should contain meaningful text", false)
                     }
                  } else if !(txtVwSafetyTips.text ?? "").isEmpty, !(txtVwSafetyTips.text ?? "").isValidInput {
                      if !(txtVwSafetyTips.text ?? "").isValidInput{
                         showSwiftyAlert("", "Invalid Input: your safety tips should contain meaningful text", false)
                     }
                  } else if !(txtVwAvoidDescription.text ?? "").isEmpty, !(txtVwAvoidDescription.text ?? "").isValidInput {
                      if !(txtVwAvoidDescription.text ?? "").isValidInput{
                         showSwiftyAlert("", "Invalid Input: your avoid should contain meaningful text", false)
                     }
                  } else if availability == 0, txtFldTimeDuration.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                      showSwiftyAlert("", "Specify the task duration.", false)
                  } else if availability == 1 {
                      if txtFldDate.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                          showSwiftyAlert("", "Select date", false)
                      } else if txtFldTime.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                          showSwiftyAlert("", "Select time", false)
                      } else if txtFldTimeDuration.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                          showSwiftyAlert("", "Select time duration", false)
                      } else {
                          // If all conditions pass, proceed with API call
                          self.apiCalled()
                      }
                  } else {
                      self.apiCalled()
                  }
               } else {
                   showSwiftyAlert("", "Fee must be a valid number greater than 0.", false)
               }
            
        }
    }
    func apiCalled(){
        if paymentMethods == 1{
            if isComing == true{
                self.viewModel.checAddGig(price: Double(self.txtFldAmount.text ?? "") ?? 0) { message in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlatformfeePopUpVC") as! PlatformfeePopUpVC
                    
                    vc.titleText = message
                    vc.callBack = { [weak self] isPay in
                        guard let self = self else { return }
                        self.addUpdateGigApi()
                    }
                    
                    vc.modalPresentationStyle = .overFullScreen
                    self.navigationController?.present(vc, animated: false)
                }
            }else{
                if newPrice == txtFldAmount.text {
                    if paymentMethodChanged{
                        self.viewModel.checAddGig(price: Double(self.txtFldAmount.text ?? "") ?? 0) { message in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlatformfeePopUpVC") as! PlatformfeePopUpVC
                            
                            vc.titleText = message
                            vc.callBack = { [weak self] isPay in
                                guard let self = self else { return }
                                self.addUpdateGigApi()
                            }
                            
                            vc.modalPresentationStyle = .overFullScreen
                            self.navigationController?.present(vc, animated: false)
                        }
                        
                    }else{
                        self.addUpdateGigApi()
                    }
                    
                }else{
                    if paymentMethodChanged{
                        self.viewModel.checAddGig(price: Double(self.txtFldAmount.text ?? "") ?? 0) { message in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlatformfeePopUpVC") as! PlatformfeePopUpVC
                            
                            vc.titleText = message
                            vc.callBack = { [weak self] isPay in
                                guard let self = self else { return }
                                self.addUpdateGigApi()
                            }
                            
                            vc.modalPresentationStyle = .overFullScreen
                            self.navigationController?.present(vc, animated: false)
                        }
                        
                    }else{
                        self.viewModel.checUpdateGig(gigId: gigId, price: Double(self.txtFldAmount.text ?? "") ?? 0) { message in
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlatformfeePopUpVC") as! PlatformfeePopUpVC
                            
                            vc.titleText = message
                            vc.callBack = { [weak self] isPay in
                                guard let self = self else { return }
                                self.addUpdateGigApi()
                            }
                            
                            vc.modalPresentationStyle = .overFullScreen
                            self.navigationController?.present(vc, animated: false)
                        }
                    }
                    
                }
            }
            
        }else{
            self.addUpdateGigApi()
        }
    }
    @IBAction func actionPaymentMethod(_ sender: UIButton) {
//        if selectGigType == "worldwide"{
//            showPopOver(type: "paymentMethod", sender: sender, height: 50)
//        }else{
//            showPopOver(type: "paymentMethod", sender: sender, height: 100)
//        }
    }
    
    @IBAction func actionTools(_ sender: UIButton) {
    }
    
    @IBAction func actionChooseSkill(_ sender: UIButton) {
        self.showPopOver(type: "skills", sender: sender, height: CGFloat(self.arrGetSkill.count*50))
    }
    @IBAction func actionPaymentTerm(_ sender: UIButton) {
        showPopOver(type: "payment", sender: sender, height: 100)
    }
    
    @IBAction func actionMap(_ sender: UIButton) {
        
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentLocationVC") as! CurrentLocationVC
        vc.isSignUp = true
        vc.latitude = self.lat
        vc.longitude = self.long
        if isComing{
            vc.isUpdate = true
        }else{
            vc.isUpdate = true
        }
        
        vc.callBack = { [weak self] aboutLocation in
            guard let self = self else { return }
            self.txtFldMap.text = aboutLocation.placeName ?? ""
            self.lat = aboutLocation.lat ?? 0.0
            self.long = aboutLocation.long ?? 0.0

        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func actionRemote(_ sender: UIButton) {
        view.endEditing(true)
        txtVwAddress.text = ""
//        txtFldPaymentMeethod.text = ""
       // lblPaymentMethod.textColor = UIColor(hex: "#B9B9B9")
        selectGigType = "worldwide"
        updateButtonStates(selectedButton: btnRemote, deselectedButton: btnOnSite)
    }
    
    @IBAction func actionOnSite(_ sender: UIButton) {
        view.endEditing(true)
        txtVwAddress.text = ""
//        txtFldPaymentMeethod.text = ""
       // lblPaymentMethod.textColor = UIColor(hex: "#B9B9B9")
        updateButtonStates(selectedButton: btnOnSite, deselectedButton: btnRemote)
        selectGigType = "inMyLocation"
    }
    func clearAvailability(){
        txtFldTimeDuration.text = ""
        txtFldTime.text = ""
        txtFldDate.text = ""
    }

    @IBAction func actionNow(_ sender: UIButton) {
        clearAvailability()
        updateButtonStates(selectedButton: btnNow, deselectedButton: btnLater)
        heightTimeDuration.constant = 138
        vwDate.isHidden = true
        stackVwTime.isHidden = false
        vwTime.isHidden = true
        vwTimeDuration.isHidden = false
        availability = 0
        txtFldTimeDuration.text = ""
        //        let date = Date()
        //        let dateFormatter = DateFormatter()
        //         dateFormatter.dateFormat = "dd-MM-yyyy"
        //        currentDate = dateFormatter.string(from: date)
        //        let time = Date()
        //        let timeFormatter = DateFormatter()
        //        timeFormatter.dateFormat = "hh:mm a"
        //        currentTime = timeFormatter.string(from: time)
    }
    
    @IBAction func actionLater(_ sender: UIButton) {
        clearAvailability()
        txtFldTimeDuration.text = ""
        updateButtonStates(selectedButton: btnLater, deselectedButton: btnNow)
        heightTimeDuration.constant = 192
        vwDate.isHidden = false
        stackVwTime.isHidden = false
        vwTime.isHidden = false
        vwTimeDuration.isHidden = false
        availability = 1
    }
    
    @IBAction func actionAddImage(_ sender: UIButton) {
        updateButtonStates(selectedButton: btnAddImage, deselectedButton: btnNoImage)
        addImage = 1
        vwAddImage.isHidden = false
    }
    @IBAction func actionNoImage(_ sender: UIButton) {
        updateButtonStates(selectedButton: btnNoImage, deselectedButton: btnAddImage)
        addImage = 0
        //        imgVwTask.image = UIImage(named:"")
        isUplaodImg = false
        vwAddImage.isHidden = true
    }
    
    @IBAction func actionChooseCategory(_ sender: UIButton) {
        self.showPopOver(type: "category", sender: sender, height: CGFloat(self.arrGetCategories.count*50))
    }
    @IBAction func actionChooseExperience(_ sender: UIButton) {
        showPopOver(type: "experience", sender: sender, height: 200)
    }
    
    @IBAction func actionUplaodTaskImg(_ sender: UIButton) {
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectGigImageOptionVC") as! SelectGigImageOptionVC
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = { index in
            if index == 1{
                self.dismiss(animated: true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AIImageCreateVC") as! AIImageCreateVC
                vc.callBack = { image in
                    self.imgVwTask.image = image
                    self.isUplaodImg = true
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if index == 2{
                self.dismiss(animated: true)
                ImagePicker().pickImage(self) { image in
                    self.imgVwTask.image = image
                    self.isUplaodImg = true
                }
            }else{
                self.dismiss(animated: true)
            }
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionAddOwnTools(_ sender: UIButton) {
        if let toolName = txtFldAddTools.text?.trimmingCharacters(in: .whitespacesAndNewlines), !toolName.isEmpty {
            if !arrTools.contains(toolName) {
                arrTools.append(txtFldAddTools.text ?? "")
                txtFldAddTools.text = ""
                collVwTools.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.heightToolsVw.constant = self.collVwTools.contentSize.height + 10
                    self.vwCollVwTools.isHidden = false
                }
            }else{
                showSwiftyAlert("", "Already added Tools.", false)
            }
        }else{
            showSwiftyAlert("", "Enter tools name.", false)
        }
    }
}



//MARK: - UITextViewDelegate
extension AddTaskVC: UITextViewDelegate{
    
    //    func textViewDidBeginEditing(_ textView: UITextView) {
    //        let acController = GMSAutocompleteViewController()
    //        acController.delegate = self
    //        present(acController, animated: true, completion: nil)
    //    }
}
//MARK: - UITextFieldDelegate
extension AddTaskVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the text field is `txtFldTitle`
        if textField == txtFldTitle {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 40
        }else if textField == txtFldAmount || textField == txtFldNoOfPerson{
            let currentText = textField.text ?? ""
            
            // Prevent entering '0' at the beginning (unless it's followed by a decimal)
            if string == "0" && currentText.isEmpty {
                return false
            }
        
        }

        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldTitle{
            //                txtFldTitle.resignFirstResponder()
            //                txtFldPaticipants.becomeFirstResponder()
        }
        return true
    }
}
// MARK: - Popup
extension AddTaskVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate
extension AddTaskVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if place.coordinate.latitude.description.count != 0 {
            self.lat = place.coordinate.latitude
        }
        if place.coordinate.longitude.description.count != 0 {
            self.long = place.coordinate.longitude
        }
        //    txtFldSearch.text = place.formattedAddress
        txtVwAddress.text = place.formattedAddress
        txtVwAddress.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - CLLocationManagerDelegate
extension AddTaskVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
                lat = location.coordinate.latitude
                long = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

}

//MARK: - UICollectionViewDelegate
extension AddTaskVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwSkills{
            return arrSelectedSkills.count
        }else{
            return arrTools.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwSkills{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            cell.lblName.text = arrSelectedSkills[indexPath.row].name
            cell.vwBg.layer.cornerRadius = 18
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(actionDeleteSkill), for: .touchUpInside)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            cell.lblName.text = arrTools[indexPath.row]
            cell.vwBg.layer.cornerRadius = 18
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(actionDeleteTool), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc func actionDeleteSkill(sender:UIButton){
        print("deleteskill")
        arrSelectedSkills.remove(at: sender.tag)
        arrSkillId.remove(at: sender.tag)
        collVwSkills.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.heightSkillVw.constant = self.collVwSkills.contentSize.height + 10
        }
        
        if arrSelectedSkills.isEmpty {
            vwCollVwSkill.isHidden = true
            self.heightSkillVw.constant = 0
        }
        
    }
    @objc func actionDeleteTool(sender:UIButton){
        print("deletetool")
        arrTools.remove(at: sender.tag)
        collVwTools.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.heightToolsVw.constant = self.collVwTools.contentSize.height + 10
        }
        
        if arrTools.isEmpty {
            vwCollVwTools.isHidden = true
            self.heightToolsVw.constant = 0
        }
    }
}
//MARK: - Handle textfiled datepicker
extension AddTaskVC{
    func combineDateAndTime() -> String? {
        guard let dateText = txtFldDate.text,
              let timeText = txtFldTime.text else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current

        let combinedText = "\(dateText) \(timeText)"
        if let combinedDate = dateFormatter.date(from: combinedText) {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            isoFormatter.timeZone = TimeZone.current
            return isoFormatter.string(from: combinedDate)
        }
        return nil
    }

    @objc func startTimeDonePressed() {
        if let datePicker = txtFldTime.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone.current

            let currentDate = dateFormatter.string(from: Date())
            let selectedStartDateText = txtFldDate.text ?? ""
            if selectedStartDateText == currentDate {
                datePicker.minimumDate = Date()
            } else {
                datePicker.minimumDate = nil
            }
            updateTextField(txtFldTime, datePicker: datePicker)
        }
        txtFldTime.resignFirstResponder()
    }

    @objc func startDateDonePressed() {
        if let datePicker = txtFldDate.inputView as? UIDatePicker {
            updateTextField(txtFldDate, datePicker: datePicker)
        }
        txtFldDate.resignFirstResponder()
    }
    @objc func timePickerDonePressed() {
        if let datePicker = txtFldTimeDuration.inputView as? UIDatePicker {
            // Format and validate the service duration
            if let formattedDuration = formatServiceDuration(for: datePicker.date) {
                txtFldTimeDuration.text = formattedDuration
            }
        }
        txtFldTimeDuration.resignFirstResponder()
    }
    func setupDatePicker(for textField: UITextField, mode: UIDatePicker.Mode, selector: Selector) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        if textField == txtFldTimeDuration {
            let calendar = Calendar.current
            let baseDate = calendar.startOfDay(for: Date())
            let minDuration = calendar.date(byAdding: .minute, value: 30, to: baseDate)
            datePicker.minimumDate = minDuration
            datePicker.date = minDuration ?? Date()
           } else if datePicker.datePickerMode == .date{
            datePicker.minimumDate = Date()
        }else if datePicker.datePickerMode == .time{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let currentDate = dateFormatter.string(from: Date())
            if currentDate == txtFldDate.text {
                datePicker.minimumDate = Date()
            }
        }
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        textField.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: selector)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.tag = textField.tag
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        switch sender.tag {
        case 1:
            updateTextField(txtFldDate, datePicker: sender)
            print("Date changed: \(txtFldDate.text ?? "N/A")")
        case 2:
            updateTextField(txtFldTime, datePicker: sender)
            print("Time changed: \(txtFldTime.text ?? "N/A")")
        case 3:
            updateTextField(txtFldTimeDuration, datePicker: sender)
            print("Duration changed: \(txtFldTimeDuration.text ?? "N/A")")
        default:
            break
        }
    }

    func updateTextField(_ textField: UITextField, datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if textField == txtFldDate {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            textField.text = dateFormatter.string(from: datePicker.date)
            currentDate = dateFormatter.string(from: datePicker.date)
        } else if textField == txtFldTime {
            dateFormatter.dateFormat = "hh:mm a"
            textField.text = dateFormatter.string(from: datePicker.date)
            currentTime = dateFormatter.string(from: datePicker.date)
        } else if textField == txtFldTimeDuration {
            // Use 24-hour format to capture the duration in hours and minutes
            dateFormatter.dateFormat = "HH:mm"
            let durationString = dateFormatter.string(from: datePicker.date)
            // Ensure the format is "<HH:MM> hours"
            textField.text = "\(durationString) hours"
            
        }
    }
    
}

//MARK: - combineDateAndTime, date and time format
extension AddTaskVC{
    func formatServiceDuration(for duration: Date) -> String? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: duration)
        guard let hours = components.hour, let minutes = components.minute else { return nil }
        // Ensure duration is within the valid range
        if hours == 0 && minutes < 1 {
            return nil // Minimum "00:01 hours"
        } else if hours > 24 || (hours == 24 && minutes > 0) {
            return nil // Maximum "24:00 hours"
        }
        
        // Format the duration
        return String(format: "%02d:%02d hours", hours, minutes)
    }
}
