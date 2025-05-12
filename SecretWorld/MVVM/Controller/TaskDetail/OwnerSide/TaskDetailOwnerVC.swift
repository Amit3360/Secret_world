//
//  TaskDetailOwnerVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 23/01/25.
//

import UIKit
import AlignedCollectionViewFlowLayout
import SideMenu
import Solar

class TaskDetailOwnerVC: UIViewController, SideMenuNavigationControllerDelegate {
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet weak var participantCollCenter: NSLayoutConstraint!
    @IBOutlet weak var vwAppliedParticipant: UIView!
    @IBOutlet weak var vwSafetyTips: UIView!
    @IBOutlet weak var vwAvoidDEscription: UIView!
    @IBOutlet weak var lblAvoidDescription: UILabel!
    @IBOutlet weak var vwPolicy: UIView!
    @IBOutlet weak var lblAppliedUser: UILabel!
    @IBOutlet weak var vwDescription: UIView!
    @IBOutlet weak var vwTools: UIView!
    @IBOutlet weak var vwSkills: UIView!
    @IBOutlet weak var lblPayoutType: UILabel!
    @IBOutlet weak var heightAppliedVw: NSLayoutConstraint!
    @IBOutlet weak var lblTaskType: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var vwCountParticipant: UIView!
    @IBOutlet weak var lblViewedGig: UILabel!
    @IBOutlet weak var imgVwFire: UIImageView!
    @IBOutlet weak var lblImediate: UILabel!
    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet weak var imgVwTask: UIImageView!
    @IBOutlet weak var heightCollVwTools: NSLayoutConstraint!
    @IBOutlet weak var heightCollVwSkill: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var heightParticipantCountVw: NSLayoutConstraint!
    @IBOutlet weak var widthParticipantVw: NSLayoutConstraint!
    @IBOutlet weak var lblParticipantCount: UILabel!
    @IBOutlet weak var collVwParticipant: UICollectionView!
    @IBOutlet weak var heightParticipantVw: NSLayoutConstraint!
    @IBOutlet weak var vwParticipant: UIView!
    @IBOutlet weak var lblSpotsCount: UILabel!
    @IBOutlet weak var vwCompleteTask: UIView!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var lblTaskPayout: UILabel!
    @IBOutlet weak var lblTaskDuration: UILabel!
    @IBOutlet weak var lblTaskTime: UILabel!
    @IBOutlet weak var lblQuickHelp: UILabel!
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var lblSafetyTips: UILabel!
    @IBOutlet weak var collVwSkills: UICollectionView!
    @IBOutlet weak var collVwTools: UICollectionView!
    @IBOutlet weak var heightTblVwReview: NSLayoutConstraint!
    @IBOutlet weak var btnAddReview: UIButton!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var vwDelete: UIView!
    @IBOutlet weak var lblDataFound: UILabel!
    @IBOutlet weak var tblVwReview: UITableView!
    @IBOutlet weak var vwReview: UIView!
    
    //MARK: - VARIABLES
    var arrCompleteParticipants = [GetRequestData]()
    var isComing = 0
    var isLabelExpanded = false
    var gigId = ""
    var viewModel = AddGigVM()
    var BusinessUserDetail:UserDetailes?
    var userDetail:UserDetailses?
    var userGigDetail:GetUserGigData?
    var businessGigDetail:GetGigDetailData?
    var userGigStatus:Int?
    var businessGigStatus:Int?
    var userId = ""
    var arrUserReview = [Reviews]()
    var arrBusinessReview = [ReviewGigBuser]()
    var gigUserType = ""
    var heightDescription = 0
    var reviewHeight = 0
    var callBack:(()->())?
    var promoCodeDetail:PromoCodes?
    var providerUserId = ""
    var paymentStatus = 0
    var price = 0
    var matchId = false
    var participantsId = ""
    var walletAmount = 0
    var textAbout = ""
    var arrDetail = [GroupChatModel]()
    var participantCount = 0
    var gigUserId = ""
    var sideMenu: SideMenuNavigationController?
    var groupId = ""
    var isReviewNil:Bool?
    private var solar: Solar?
    var arrSkill = [Skills]()
    var arrCategory = [Skills]()
    var arrTools = [String]()
    var customAnnotations: [ClusterPoint] = []
    var isComingDeepLink = false
    var arrParticiptant = [Participantzz]()
    var descriptionText = ""
    private var isExpanded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        uiData()
        uiSet()
        getGigChat()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDescription))
        lblQuickHelp.addGestureRecognizer(tapGesture)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.heightTblVwReview.constant = self.tblVwReview.contentSize.height+10
        
        NotificationCenter.default.post(name: Notification.Name("AddReview"), object: nil)
        self.view.layoutIfNeeded()
    }
    
    func uiData(){
        handleProgressView()
        let nibReiew = UINib(nibName: "ReviewTVC", bundle: nil)
        tblVwReview.register(nibReiew, forCellReuseIdentifier: "ReviewTVC")
        
        let nib = UINib(nibName: "SkillToolsCVC", bundle: nil)
        collVwTools.register(nib, forCellWithReuseIdentifier: "SkillToolsCVC")
        let nib2 = UINib(nibName: "SkillToolsCVC", bundle: nil)
        collVwSkills.register(nib2, forCellWithReuseIdentifier: "SkillToolsCVC")
        let nib3 = UINib(nibName: "UserListCVC", bundle: nil)
        collVwParticipant.register(nib3, forCellWithReuseIdentifier: "UserListCVC")
        sideMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuNavigationController") as? SideMenuNavigationController
        sideMenu?.sideMenuDelegate = self
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        
        let alignedFlowLayoutCollVwDietry = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwTools.collectionViewLayout = alignedFlowLayoutCollVwDietry
        
        let alignedFlowLayoutCollVwSpecializ = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwSkills.collectionViewLayout = alignedFlowLayoutCollVwSpecializ
        
        
        if let flowLayout = collVwTools.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 37)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            
        }
        
        if let flowLayout1 = collVwSkills.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout1.estimatedItemSize = CGSize(width: 0, height: 37)
            flowLayout1.itemSize = UICollectionViewFlowLayout.automaticSize
            //collVwSkills.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
    }
    func handleProgressView(){
        // Increase the height of progressView
        progressView.transform = CGAffineTransform(scaleX: 1, y: 1.5)
        progressView.progress = 0.0

        // Set the track (empty area) background color
        progressView.trackTintColor = UIColor(hex: "#D9D9D9")  // your desired background
        progressView.progressTintColor = UIColor.app     // your progress color

        // Rounded corners
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true

        if let progressLayer = progressView.layer.sublayers?.last {
            progressLayer.cornerRadius = 3
            progressLayer.masksToBounds = true
        }

        // Add custom shadow layer on track
        if let trackLayer = progressView.layer.sublayers?.first {
            let shadowLayer = CALayer()
            shadowLayer.frame = trackLayer.bounds
            shadowLayer.backgroundColor = UIColor(hex: "#D9D9D9").cgColor
            
            // Mimic box-shadow: 0px 2px 4px 0px #00000026 inset
            shadowLayer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
            shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
            shadowLayer.shadowRadius = 4
            shadowLayer.shadowOpacity = 1
            shadowLayer.cornerRadius = 3
            shadowLayer.masksToBounds = true

            trackLayer.insertSublayer(shadowLayer, at: 0)
        }

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightInterest = self.collVwTools.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwTools.constant = heightInterest
        let heightDietry = self.collVwSkills.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwSkill.constant = heightDietry
        self.view.layoutIfNeeded()
    }
    private func updateCollectionViewHeights() {
        collVwTools.layoutIfNeeded()
        collVwSkills.layoutIfNeeded()
        
        let toolsHeight = collVwTools.collectionViewLayout.collectionViewContentSize.height
        heightCollVwTools.constant = toolsHeight
        
        let skillsHeight = collVwSkills.collectionViewLayout.collectionViewContentSize.height
        heightCollVwSkill.constant = skillsHeight
        
        view.layoutIfNeeded()
    }
    @objc func handleSwipe() {
        self.navigationController?.popViewController(animated: true)
        callBack?()
    }
    
    func updateTableViewHeight() {
        self.heightTblVwReview.constant = self.tblVwReview.contentSize.height + 10
        self.view.layoutIfNeeded()
    }
    @objc private func toggleDescription() {
        isExpanded.toggle()
        if lblQuickHelp.text?.contains("Read More") ?? false || lblQuickHelp.text?.contains("Read Less") ?? false{
            if isExpanded {
                lblQuickHelp.appendReadLess(after: descriptionText, trailingContent: .readless)
            } else {
                lblQuickHelp.appendReadmore(after: descriptionText, trailingContent: .readmore)
            }
            
            
        }
        
    }
    func uiSet(){
        tblVwReview.estimatedRowHeight = 100
        tblVwReview.rowHeight = UITableView.automaticDimension
        
        if isComing == 1{
            //Business
            
            heightTblVwReview.constant = 0
            
            getBusinessGigDetailApi()
            getCompleteParticipants(loader: false)
        }else{
            //User
            
            heightTblVwReview.constant = 0
            
            getUserGigDetailApi()
        }
    }
    func getCompleteParticipants(loader: Bool) {
        viewModel.GetCompleteGigParticipantsListApi(loader: loader, gigId: gigId) { data in
            self.arrCompleteParticipants = data ?? []
            for i in data ?? [] {
                self.participantsId = i.applyuserID ?? ""
            }
            if let participants = data, participants.count > 0 {
                if participants.count > 1 {
                    self.isReviewNil = false
                } else {
                    if participants[0].review == nil {
                        self.isReviewNil = false
                    } else {
                        self.isReviewNil = true
                    }
                }
            } else {
                self.isReviewNil = false
            }
        }
    }
    func getUserGigDetailApi(){
        
        viewModel.GetUserGigDetailApi(gigId: gigId, showLoader: true) { data in
            
            self.arrSkill.removeAll()
            self.arrTools.removeAll()
            self.arrCategory.removeAll()
            self.arrParticiptant.removeAll()
            self.arrParticiptant = data?.participantsList ?? []
            
            self.collVwParticipant.reloadData()
            self.arrCategory.append(Skills(id: data?.gig?.category?.id ?? "", name: data?.gig?.category?.name ?? ""))
            for i in data?.gig?.skills ?? []{
                self.arrSkill.append(Skills(id: i.id ?? "", name: i.name ?? ""))
            }
            self.arrTools = data?.gig?.tools ?? []
            self.collVwTools.reloadData()
            self.collVwSkills.reloadData()
            if data?.gig?.skills?.count ?? 0 > 0{
                self.vwSkills.isHidden = false
            }else{
                self.vwSkills.isHidden = true
            }
            if data?.gig?.tools?.count ?? 0 > 0{
                self.vwTools.isHidden = false
            }else{
                self.vwTools.isHidden = true
            }
            DispatchQueue.main.async {
                self.updateCollectionViewHeights()
            }
            self.lblTaskTitle.text = "\(data?.gig?.title ?? "") \(data?.gig?.category?.name ?? "")"
            self.lblAvoidDescription.text = data?.gig?.avoidDescription ?? ""
            self.changeTimeStatus(data?.gig?.timeStatus ?? "")
            
            if data?.gig?.avoidDescription == "" || data?.gig?.avoidDescription == nil{
                self.vwAvoidDEscription.isHidden = true
            }else{
                self.vwAvoidDEscription.isHidden = false
            }
            
            
            if data?.gig?.description == "" || data?.gig?.description == nil{
                self.vwDescription.isHidden = true
            }else{
                self.vwDescription.isHidden = false
            }
            
            if data?.gig?.safetyTips == "" || data?.gig?.safetyTips == nil{
                self.vwSafetyTips.isHidden = true
            }else{
                self.vwSafetyTips.isHidden = false
            }
            
            self.imgVwTask.imageLoad(imageUrl: data?.gig?.image ?? "")
            self.lblTaskDuration.text = data?.gig?.serviceDuration ?? ""
            self.lblCategory.text = data?.gig?.category?.name ?? ""
            self.lblExperience.text = data?.gig?.experience ?? ""
            self.lblQuickHelp.text = data?.gig?.about ?? ""
            self.lblSafetyTips.text = data?.gig?.safetyTips ?? ""
            if data?.gig?.paymentMethod == 0{
                self.lblPayoutType.text = "Payout (Online)"
            }else{
                self.lblPayoutType.text = "Payout (Cash)"
            }
            let value: Double = data?.gig?.price ?? 0
            let formattedValue = String(format: "%.2f", value)
            if data?.gig?.paymentTerms == 0{
                self.lblTaskPayout.text = "$\(formattedValue) (Fixed)"
            }else{
                self.lblTaskPayout.text = "$\(formattedValue) (Hourly)"
            }
            self.lblInstruction.text = data?.gig?.description ?? ""
            
            for i in data?.reviews ?? []{
                if Store.userId == i.user?.id{
                    self.matchId = true
                }
            }
            self.gigId = data?.id ?? ""
            
            self.providerUserId = data?.gig?.user?.id ?? ""
            self.gigUserId = data?.gig?.user?.id ?? ""
            
            let isoDateFormatter = ISO8601DateFormatter()
            isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            // Create an array of possible time formats
            let timeFormats = ["hh:mm a", "yyyy-MM-dd'T'HH:mm:ss.SSSZ"]
            
            if let dateString = data?.gig?.startDate,
               let timeString = data?.gig?.startTime,
               let date = isoDateFormatter.date(from: dateString) {
                
                var time: Date? = nil
                
                // Try parsing the time string with each format until one succeeds
                for format in timeFormats {
                    let timeFormatter = DateFormatter()
                    timeFormatter.locale = Locale(identifier: "en_US_POSIX")
                    timeFormatter.dateFormat = format
                    
                    if let parsedTime = timeFormatter.date(from: timeString) {
                        time = parsedTime
                        break
                    }
                }
                
                // Proceed only if time parsing was successful
                if let time = time {
                    let calendar = Calendar.current
                    
                    // Combine the date and time into a single Date object
                    let combinedDateTime = calendar.date(
                        bySettingHour: calendar.component(.hour, from: time),
                        minute: calendar.component(.minute, from: time),
                        second: calendar.component(.second, from: time),
                        of: date
                    )
                    if data?.gig?.availability == 0{
                        self.lblTaskTime.text = "Now"
                    }else{
                        if let finalDate = combinedDateTime {
                            let displayDateFormatter = DateFormatter()
                            displayDateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures locale consistency
                            
                            // Check if the date is today, yesterday, or any other day
                            if calendar.isDateInToday(finalDate) {
                                // Today
                                displayDateFormatter.dateFormat = "'Today,' h:mm a" // Use 'h' for 12-hour format
                            } else if calendar.isDateInYesterday(finalDate) {
                                // Yesterday
                                displayDateFormatter.dateFormat = "'Yesterday,' h:mm a" // Use 'h' for 12-hour format
                            } else {
                                // Any other day
                                displayDateFormatter.dateFormat = "dd/MM/yyyy, h:mm a" // Use 'h' for 12-hour format
                            }
                            
                            // Format the final date into the string
                            let formattedDateTime = displayDateFormatter.string(from: finalDate)
                            
                            // Set the formatted date string to the label
                            self.lblTaskTime.text = formattedDateTime
                        }
                    }
                } else {
                    print("Failed to parse time string: \(timeString)")
                }
            }
            
            
            self.userGigDetail = data
            self.promoCodeDetail = data?.promoCodes
            self.arrUserReview.removeAll()
            self.arrUserReview.append(contentsOf: data?.reviews ?? [])
            self.participantCount = data?.appliedParticipants ?? 0
            self.descriptionText = data?.gig?.about ?? ""
            self.lblQuickHelp.appendReadmore(after: self.descriptionText, trailingContent: .readmore)
            
            if data?.reviews?.count ?? 0 > 0{
                self.vwReview.isHidden = false
            }else{
                self.vwReview.isHidden = true
                
            }
            if data?.gig?.type == "worldwide"{
                self.lblTaskType.text = "(Remote)"
                
            }else{
                self.lblTaskType.text = "(On-Site)"
                
            }
            if data?.gig?.isCancellation == 1{
                self.vwPolicy.isHidden = false
            }else{
                self.vwPolicy.isHidden = true
            }
            self.userId = data?.gig?.user?.id ?? ""
            self.gigUserType = data?.gig?.usertype ?? ""
            self.userDetail = data?.gig?.user
            
            self.userGigStatus = data?.status
            
            self.textAbout = data?.gig?.about ?? ""
            
            self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
            self.lblSpotsCount.text = "Spots (\(data?.participantsList?.count ?? 0)/\(data?.gig?.totalParticipants ?? 0))"
            self.lblParticipantCount.text = "\(data?.appliedParticipants ?? 0)"
            let total = Float(data?.gig?.totalParticipants ?? 0)
            let current = Float(data?.participantsList?.count ?? 0)

            if total > 0 {
                self.progressView.progress = current / total
            } else {
                self.progressView.progress = 0.0
            }

            if data?.gig?.usertype == "user"{
                if data?.status == 0{
                    self.btnAddReview.isHidden = true
                    self.vwDelete.isHidden = false
                    self.vwMessage.isHidden = false
                    self.btnEdit.isHidden = false
                    self.vwCompleteTask.isHidden = true
                    self.lblAppliedUser.text = "people applied in last hour"
                    self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
                    self.heightAppliedVw.constant = 110
                }else  if data?.status == 1{
                    self.btnAddReview.isHidden = false
                    self.vwDelete.isHidden = true
                    self.vwMessage.isHidden = false
                    self.btnEdit.isHidden = true
                    self.vwCompleteTask.isHidden = true
                    self.lblAppliedUser.text = "people applied in last hour"
                    self.btnAddReview.setTitle("Comlete Task", for: .normal)
                    self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
                    self.heightAppliedVw.constant = 110
                }else if data?.status == 2{
                    self.lblAppliedUser.text = "people worked with you"
                    self.lblViewedGig.text = "\(data?.participantsList?.count ?? 0)"
                    //complete
                    self.btnAddReview.isHidden = false
                    self.vwDelete.isHidden = true
                    self.vwMessage.isHidden = false
                    self.btnEdit.isHidden = true
                    self.vwCompleteTask.isHidden = false
                    self.btnAddReview.setTitle("Add Review", for: .normal)
                    if data?.promoCodes?.isViewed == false{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PromoCodePopUpVC") as! PromoCodePopUpVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.promoCodeDetail = self.promoCodeDetail
                        vc.callBack = {[weak self] in
                            guard let self = self else { return }
                            self.getUserGigDetailApi()
                        }
                        self.navigationController?.present(vc, animated: false)
                        
                    }
                    self.heightAppliedVw.constant = 110
                }else{
                    self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
                    self.lblAppliedUser.text = "people applied in last hour"
                    self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
                    self.vwCompleteTask.isHidden = true
                    self.btnAddReview.isHidden = true
                    self.vwDelete.isHidden = false
                    self.vwMessage.isHidden = false
                    self.btnEdit.isHidden = false
                    self.heightAppliedVw.constant = 110
                    
                    
                }
            }else{
                
                if data?.status == 0{
                    self.lblAppliedUser.text = "people applied in last hour"
                    self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
                    self.vwCompleteTask.isHidden = true
                    self.btnAddReview.isHidden = true
                    self.vwDelete.isHidden = false
                    self.vwMessage.isHidden = true
                    self.btnEdit.isHidden = false
                    self.heightAppliedVw.constant = 110
                }else  if data?.status == 1{
                    self.btnAddReview.isHidden = true
                    self.vwDelete.isHidden = false
                    self.vwMessage.isHidden = false
                    self.btnEdit.isHidden = false
                    self.vwCompleteTask.isHidden = true
                    self.lblAppliedUser.text = "people applied in last hour"
                    self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
                    self.heightAppliedVw.constant = 110
                }else if data?.status == 2{
                    self.btnAddReview.isHidden = false
                    self.vwDelete.isHidden = true
                    self.vwMessage.isHidden = false
                    self.btnEdit.isHidden = true
                    self.vwCompleteTask.isHidden = false
                    //complete
                    self.heightAppliedVw.constant = 110
                    self.lblAppliedUser.text = "people worked with you"
                    self.lblViewedGig.text = "\(data?.participantsList?.count ?? 0)"
                    if data?.promoCodes?.isViewed == false{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PromoCodePopUpVC") as! PromoCodePopUpVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.promoCodeDetail = self.promoCodeDetail
                        vc.callBack = {[weak self] in
                            guard let self = self else { return }
                            self.getUserGigDetailApi()
                        }
                        self.navigationController?.present(vc, animated: false)
                        
                    }
                    
                }else{
                    self.heightAppliedVw.constant = 110
                    self.lblAppliedUser.text = "people applied in last hour"
                    self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
                    self.vwCompleteTask.isHidden = true
                    self.btnAddReview.isHidden = true
                    self.vwDelete.isHidden = false
                    self.vwMessage.isHidden = true
                    self.btnEdit.isHidden = false
                    
                }
            }
            self.tblVwReview.reloadData()
            self.tblVwReview.invalidateIntrinsicContentSize()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self.updateTableViewHeight()
                
            }
        }
    }
    func getBusinessGigDetailApi(){
        print("Token--",Store.authKey)
        print("GigId--",gigId)
        viewModel.GetBuisnessGigDetailApi(gigId: gigId) { data in
            
            self.arrSkill.removeAll()
            self.arrTools.removeAll()
            self.arrCategory.removeAll()
            self.arrCategory.append(Skills(id: data?.category?.id ?? "", name: data?.category?.name ?? ""))
            for i in data?.skills ?? []{
                self.arrSkill.append(Skills(id: i.id ?? "", name: i.name ?? ""))
            }
            if data?.skills?.count ?? 0 > 0{
                self.vwSkills.isHidden = false
            }else{
                self.vwSkills.isHidden = true
            }
            if data?.tools?.count ?? 0 > 0{
                self.vwTools.isHidden = false
            }else{
                self.vwTools.isHidden = true
            }
            if data?.isCancellation == 1{
                self.vwPolicy.isHidden = false
            }else{
                self.vwPolicy.isHidden = true
            }
            
            self.arrParticiptant.removeAll()
            self.arrParticiptant = data?.participantsList ?? []
            self.descriptionText = data?.about ?? ""
            self.collVwParticipant.reloadData()
            self.arrTools = data?.tools ?? []
            self.collVwTools.reloadData()
            self.collVwSkills.reloadData()
            DispatchQueue.main.async {
                self.updateCollectionViewHeights()
            }
            self.businessGigDetail = data
            self.BusinessUserDetail = data?.user
            self.gigUserId = data?.user?.id ?? ""
            self.businessGigStatus = data?.status
            self.participantCount = data?.appliedParticipants ?? 0
            self.arrBusinessReview = data?.reviews ?? []
            self.providerUserId = data?.user?.id ?? ""
            self.price = Int(data?.price ?? 0)
            
            //            self.lblTaskTitle.text = data?.title ?? ""
            self.lblTaskTitle.text = "\(data?.title ?? "") \(data?.category?.name ?? "")"
            self.lblAvoidDescription.text = data?.avoidDescription ?? ""
            if data?.avoidDescription == "" || data?.avoidDescription == nil{
                self.vwAvoidDEscription.isHidden = true
            }else{
                self.vwAvoidDEscription.isHidden = false
            }
            
            
            if data?.description == "" || data?.description == nil{
                self.vwDescription.isHidden = true
            }else{
                self.vwDescription.isHidden = false
            }
            
            if data?.safetyTips == "" || data?.safetyTips == nil{
                self.vwSafetyTips.isHidden = true
            }else{
                self.vwSafetyTips.isHidden = false
            }
            self.changeTimeStatus(data?.timeStatus ?? "")
            self.imgVwTask.imageLoad(imageUrl: data?.image ?? "")
            self.lblTaskDuration.text = data?.serviceDuration ?? ""
            self.lblExperience.text = data?.experience ?? ""
            //            self.lblQuickHelp.text = data?.about ?? ""
            self.descriptionText = data?.about ?? ""
            self.lblQuickHelp.appendReadmore(after: self.descriptionText, trailingContent: .readmore)
            
            self.lblSafetyTips.text = data?.safetyTips ?? ""
            if data?.paymentMethod == 0{
                self.lblPayoutType.text = "Payout (Online)"
            }else{
                self.lblPayoutType.text = "Payout (Cash)"
            }
            let value: Double = data?.price ?? 0
            let formattedValue = String(format: "%.2f", value)
            if data?.paymentTerms == 0{
                self.lblTaskPayout.text = "$\(formattedValue) (Fixed)"
            }else{
                self.lblTaskPayout.text = "$\(formattedValue) (Hourly)"
            }
            
            self.lblInstruction.text = data?.description ?? ""
            //            self.lblCategory.text = data?.category?.name
            if data?.type == "worldwide"{
                self.lblTaskType.text = "(Remote)"
                
            }else{
                self.lblTaskType.text = "(On-Site)"
                
            }
            
            let isoDateFormatter = ISO8601DateFormatter()
            isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            // Create an array of possible time formats
            let timeFormats = ["hh:mm a", "yyyy-MM-dd'T'HH:mm:ss.SSSZ"]
            
            if let dateString = data?.startDate,
               let timeString = data?.startTime,
               let date = isoDateFormatter.date(from: dateString) {
                
                var time: Date? = nil
                
                // Try parsing the time string with each format until one succeeds
                for format in timeFormats {
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = format
                    
                    if let parsedTime = timeFormatter.date(from: timeString) {
                        time = parsedTime
                        break
                    }
                }
                
                // Proceed only if time parsing was successful
                if let time = time {
                    let calendar = Calendar.current
                    
                    // Combine the date and time into a single Date object
                    let combinedDateTime = calendar.date(
                        bySettingHour: calendar.component(.hour, from: time),
                        minute: calendar.component(.minute, from: time),
                        second: calendar.component(.second, from: time),
                        of: date
                    )
                    if data?.availability == 0{
                        self.lblTaskTime.text = "Now"
                    }else{
                        if let finalDate = combinedDateTime {
                            let displayDateFormatter = DateFormatter()
                            
                            if calendar.isDateInToday(finalDate) {
                                // Today
                                displayDateFormatter.dateFormat = "'Today,' hh:mm a"
                            } else if calendar.isDateInYesterday(finalDate) {
                                // Yesterday
                                displayDateFormatter.dateFormat = "'Yesterday,' hh:mm a"
                            } else {
                                // Any other day
                                displayDateFormatter.dateFormat = "dd/MM/yyyy, hh:mm a"
                            }
                            
                            let formattedDateTime = displayDateFormatter.string(from: finalDate)
                            self.lblTaskTime.text = formattedDateTime
                        }
                    }
                    
                } else {
                    print("Failed to parse time string: \(timeString)")
                }
            }
            
            
            if data?.reviews?.count ?? 0 > 0{
                self.vwReview.isHidden = false
                
            }else{
                self.vwReview.isHidden = true
                
            }
            
            if data?.status == 0{
                self.btnAddReview.isHidden = true
                self.vwDelete.isHidden = false
                self.vwMessage.isHidden = true
                self.btnEdit.isHidden = false
                self.vwCompleteTask.isHidden = true
                self.heightAppliedVw.constant = 110
                self.lblAppliedUser.text = "people applied in last hour"
                self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
                if data?.paymentStatus == 0{
                    
                    self.paymentStatus = 0
                }else{
                    
                    self.paymentStatus = 1
                }
                self.participantCollCenter.constant = 0
            }else if data?.status == 1{
                self.btnAddReview.isHidden = false
                self.vwDelete.isHidden = true
                self.vwMessage.isHidden = false
                self.btnEdit.isHidden = true
                self.vwCompleteTask.isHidden = true
                self.heightAppliedVw.constant = 110
                self.btnAddReview.setTitle("Comlete Task", for: .normal)
                self.lblAppliedUser.text = "people applied in last hour"
                self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
                self.participantCollCenter.constant = 0
            }else if data?.status == 2{
                self.lblAppliedUser.text = "people worked with you"
                self.lblViewedGig.text = "\(data?.participantsList?.count ?? 0)"
                self.vwCountParticipant.isHidden = true
                self.heightAppliedVw.constant = 70
                self.participantCollCenter.constant = -20
                self.heightParticipantVw.constant = 0
                self.progressView.isHidden = true
                self.lblSpotsCount.isHidden = true
                
                self.btnAddReview.isHidden = false
                self.vwDelete.isHidden = true
                self.vwMessage.isHidden = true
                self.btnEdit.isHidden = true
                self.vwCompleteTask.isHidden = false
                self.btnAddReview.setTitle("Add Review", for: .normal)
                self.btnAddReview.isUserInteractionEnabled = true
                self.btnAddReview.backgroundColor = UIColor.app
            }else{
                self.heightAppliedVw.constant = 110
                self.lblAppliedUser.text = "people applied in last hour"
                self.lblViewedGig.text = "\(data?.appliedParticipants ?? 0)"
                self.btnAddReview.isHidden = true
                self.vwDelete.isHidden = false
                self.vwMessage.isHidden = true
                self.btnEdit.isHidden = false
                self.vwCompleteTask.isHidden = true
                self.participantCollCenter.constant = 0
            }
            
            self.textAbout = data?.about ?? ""
            
            
            self.lblSpotsCount.text = "Spots (\(data?.participantsList?.count ?? 0)/\(data?.totalParticipants ?? 0))"
            self.lblParticipantCount.text = "\(data?.appliedParticipants ?? 0)"
            let total = Float(data?.totalParticipants ?? 0)
            let current = Float(data?.participantsList?.count ?? 0)

            if total > 0 {
                self.progressView.progress = current / total
            } else {
                self.progressView.progress = 0.0
            }

            self.tblVwReview.reloadData()
            self.tblVwReview.invalidateIntrinsicContentSize()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self.updateTableViewHeight()
                
            }
            
        }
    }
    private func changeTimeStatus(_ timeStatus: String) {
        lblImediate.text = timeStatus
        switch timeStatus {
        case "Immediate!":
            
            lblImediate.textColor = UIColor(hex: "#D8553A")
            imgVwFire.image = UIImage(named: "fire") // Replace with your asset name
        case "Same Day!":
            
            lblImediate.textColor = UIColor(hex: "#FF9100")
            imgVwFire.image = UIImage(named: "sameDay") // Replace with your asset name
        case "Scheduled task!":
            
            lblImediate.textColor =  UIColor(hex: "#17A3CE")
            imgVwFire.image = UIImage(named: "sheduleTask") // Replace with your asset name
        default:
            lblImediate.textColor = UIColor(hex: "#D8553A")
            imgVwFire.image = UIImage(named: "fire") // Default icon
        }
    }
    func getGigChat(){
        let param:parameters = ["gigId":self.gigId,"senderId":Store.userId ?? "","isOpen":true,"deviceId":Store.deviceToken ?? "","groupId":groupId]
        print("Param-----",param)
        SocketIOManager.sharedInstance.getGroupChat(dict: param)
        SocketIOManager.sharedInstance.groupData = { data in
            if data?[0].groupChatDetails?.count ?? 0 > 0{
                self.groupId = data?[0].groupChatDetails?[0].group?.id ?? ""
                print("dataaa-----",data ?? [])
                let id = data?[0].groupChatDetails?[0].gig?._id ?? ""
                
                if self.gigId == id {
                    Store.GigChatDetail = data ?? []
                }
            }
        }
    }
    @IBAction func actionParticipant(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantsVC") as! ParticipantsVC
        vc.isComing = 0
        vc.gigId = gigId
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        callBack?()
    }
    @IBAction func actionDelete(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelGigVC") as! CancelGigVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isSelect = 0
        vc.gigId = self.businessGigDetail?.id ?? ""
        vc.callBack = { [weak self] message in
            guard let self = self else { return }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
            vc.modalPresentationStyle = .overFullScreen
            vc.isSelect = 10
            vc.message = message
            vc.callBack = {[weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.present(vc, animated: false)
            
        }
        self.navigationController?.present(vc, animated: false)
    }
    
    @IBAction func actionEdit(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        vc.isComing = false
        if self.isComing == 1{
            vc.isDetailData = true
        }else{
            vc.isDetailData = false
        }
        
        vc.arrTools = self.arrTools
        vc.arrGetSkill = self.arrSkill
        vc.gigId = gigId
        vc.userGigDetail = self.userGigDetail
        vc.bsuinessGigDetail = self.businessGigDetail
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionMessage(_ sender: UIButton) {
        
        if Store.GigChatDetail?[0].isReady == 1{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigChatVC") as! GigChatVC
            vc.gigId = self.gigId
            vc.gigUserId = self.gigUserId
            vc.modalPresentationStyle = .overFullScreen
            vc.callBack = { [weak self] isBack in
                guard let self = self else { return }
                if !isBack{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigCompleteVC") as! GigCompleteVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.callBack = {[weak self] in
                        guard let self = self else { return }
                        self.getGigChat()
                        self.uiSet()
                    }
                    self.navigationController?.present(vc, animated: true)
                }
                
            }
            vc.callBackViewImg = { (images, index) in
                print("Self in callBackViewImg:", self)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
                vc.arrImage = images
                vc.index = index
                //                vc.modalPresentationStyle = .overFullScreen
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false)
            }
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigReadyVC") as! GigReadyVC
            vc.modalPresentationStyle = .overFullScreen
            vc.isComing = 1
            vc.userOwnerGigDetail = businessGigDetail
            vc.groupId = groupId
            
            vc.callBack = {[weak self] in
                guard let self = self else { return }
                
                let param:parameters = ["userId":Store.userId ?? "","deviceId":Store.deviceToken ?? "","gigId":self.gigId,"groupId":self.groupId]
                print("param--",param)
                
                SocketIOManager.sharedInstance.readyUser(dict: param)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    if Store.role == "user"{
                        let param2 = ["senderId":Store.userId ?? "","groupId":self.groupId,
                                      "message":"\(Store.UserDetail?["userName"] as? String ?? "") is ready",
                                      "deviceId":Store.deviceToken ?? "",
                                      "gigId":self.gigId]
                        SocketIOManager.sharedInstance.sendMessage(dict: param2)
                    }else{
                        let param2 = ["senderId":Store.userId ?? "",
                                      "groupId":self.groupId,
                                      "message":"\(Store.BusinessUserDetail?["userName"] as? String ?? "") is ready",
                                      "deviceId":Store.deviceToken ?? "",
                                      "gigId":self.gigId]
                        SocketIOManager.sharedInstance.sendMessage(dict: param2)
                    }
                    
                }
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigChatVC") as! GigChatVC
                vc.gigId = self.gigId
                vc.gigUserId = self.gigUserId
                vc.modalPresentationStyle = .overFullScreen
                vc.callBack = { [weak self] isBack in
                    guard let self = self else { return }
                    if !isBack{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigCompleteVC") as! GigCompleteVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.callBack = {[weak self] in
                            guard let self = self else { return }
                            self.getGigChat()
                            self.uiSet()
                        }
                        self.navigationController?.present(vc, animated: true)
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    @IBAction func actionAddReview(_ sender: UIButton) {
        if businessGigStatus == 2{
            //            if arrCompleteParticipants.count > 1{
            
            //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantsVC") as! ParticipantsVC
            //                vc.isComing = 2
            //                vc.businessGigDetail = businessGigDetail
            //                vc.gigId = gigId
            //                self.navigationController?.pushViewController(vc, animated: true)
            //            }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupReviewVC") as! PopupReviewVC
            vc.isComingPopUp = true
            vc.isMyTask = true
            vc.gigId = gigId
            vc.businessGigDetail = businessGigDetail
            vc.arrCompleteParticipants = self.arrCompleteParticipants
            
            vc.callBack = { message  in
                
                self.getBusinessGigDetailApi()
                self.getCompleteParticipants(loader: false)
                
            }
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true)
            //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewVC") as! AddReviewVC
            //
            //                vc.modalPresentationStyle = .overFullScreen
            //                vc.isComing = 1
            //                if arrCompleteParticipants[sender.tag].review == nil{
            //                    vc.isUpdateReview = false
            //                }else{
            //                    vc.isUpdateReview = true
            //                    vc.reviewsToParticipants = arrCompleteParticipants[sender.tag].review
            //                }
            //                vc.gigId = gigId
            //                vc.userId = participantsId
            //                vc.businessGigDetail = businessGigDetail
            //                vc.callBack = {[weak self] in
            //                    guard let self = self else { return }
            //                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterFeedbackPopUpVC") as! AfterFeedbackPopUpVC
            //                    vc.modalPresentationStyle = .overFullScreen
            //                    vc.callBack = {[weak self] in
            //                        guard let self = self else { return }
            //
            //                        self.getBusinessGigDetailApi()
            //                        self.getCompleteParticipants(loader: false)
            //
            //                    }
            //                    self.navigationController?.present(vc, animated: false)
            //
            //                }
            //                self.navigationController?.present(vc, animated: true)
            //            }
            
        }else if businessGigStatus == 1{
            viewModel.CompleteGigApi(gigid: gigId) { message in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.isSelect = 10
                vc.message = message
                vc.callBack = {[weak self] in
                    guard let self = self else { return }
                    self.getBusinessGigDetailApi()
                    self.getGigChat()
                }
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: true)
                
            }
        }
    }
}

//MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
extension TaskDetailOwnerVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwTools{
            if arrTools.count > 0{
                return arrTools.count
            }else{
                return 0
            }
        }else if collectionView == collVwSkills{
            if arrSkill.count > 0{
                return  arrSkill.count
            }else{
                return 0
            }
        }else{
            if arrParticiptant.count > 0{
                return  arrParticiptant.count
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collVwTools{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillToolsCVC", for: indexPath) as! SkillToolsCVC
            guard indexPath.row < arrTools.count else {
                fatalError("Index out of range for arrTools at \(indexPath.row)")
            }
            cell.lblTitle.text = arrTools[indexPath.row]
            return cell
        }else if collectionView == collVwSkills{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillToolsCVC", for: indexPath) as! SkillToolsCVC
            guard indexPath.row < arrSkill.count else {
                fatalError("Index out of range for arrSkills at \(indexPath.row)")
            }
            cell.lblTitle.text = arrSkill[indexPath.row].name
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserListCVC", for: indexPath) as! UserListCVC
            cell.imgVwUser.layer.cornerRadius = 15
            cell.imgVwUser.imageLoad(imageUrl: arrParticiptant[indexPath.row].profilePhoto ?? "")
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 30, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collVwTools || collectionView == collVwTools{
            return 5
        }else{
            return -10
        }
    }
    
}
//MARK: -UITableViewDelegate
extension TaskDetailOwnerVC: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComing == 0{
            return arrUserReview.count
        }else{
            return arrBusinessReview.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTVC", for: indexPath) as! ReviewTVC
        
        if isComing == 0{
            cell.imgVwUser.imageLoad(imageUrl: arrUserReview[indexPath.row].user?.profilePhoto ?? "")
            cell.lblName.text = arrUserReview[indexPath.row].user?.name ?? ""
            cell.lblDescription.text = arrUserReview[indexPath.row].comment ?? ""
            cell.lblDescription.sizeToFit()
            
            cell.ratingView.rating = Double(rating)
            heightDescription += Int(cell.lblDescription.frame.size.height)
            
            if arrUserReview[indexPath.row].media == "" || arrUserReview[indexPath.row].media == nil{
                cell.heightImgVw.constant = 0
                reviewHeight += Int(70 + CGFloat(self.heightDescription))
            }else{
                cell.heightImgVw.constant = 150
                reviewHeight += Int(220 + CGFloat(self.heightDescription))
                cell.imgVwReview.imageLoad(imageUrl: arrUserReview[indexPath.row].media ?? "")
            }
            
            let createdAt = arrUserReview[indexPath.row].updatedAt ?? ""
            let timeAgoString = createdAt.timeAgoSinceDate()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let createdDate = dateFormatter.date(from: createdAt) {
                let timeDifference = Date().timeIntervalSince(createdDate)
                if timeDifference < 60 {
                    cell.lblTime.text = "Just now"
                } else {
                    cell.lblTime.text = "\(timeAgoString) Ago"
                }
            } else {
                cell.lblTime.text = "\(timeAgoString) Ago"
            }
            
        }else{
            cell.imgVwUser.imageLoad(imageUrl: arrBusinessReview[indexPath.row].userID?.profilePhoto ?? "")
            cell.lblName.text = arrBusinessReview[indexPath.row].userID?.name ?? ""
            cell.lblDescription.text = arrBusinessReview[indexPath.row].comment ?? ""
            cell.lblDescription.sizeToFit()
            let rating = arrBusinessReview[indexPath.row].starCount ?? 0.0
            
            cell.ratingView.rating = rating
            heightDescription += Int(cell.lblDescription.frame.size.height)
            
            let createdAt = arrBusinessReview[indexPath.row].updatedAt ?? ""
            let timeAgoString = createdAt.timeAgoSinceDate()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let createdDate = dateFormatter.date(from: createdAt) {
                let timeDifference = Date().timeIntervalSince(createdDate)
                if timeDifference < 60 {
                    cell.lblTime.text = "Just now"
                } else {
                    cell.lblTime.text = "\(timeAgoString) Ago"
                }
            } else {
                cell.lblTime.text = "\(timeAgoString) Ago"
            }
            
            if arrBusinessReview[indexPath.row].media == "" || arrBusinessReview[indexPath.row].media == nil{
                cell.heightImgVw.constant = 0
                reviewHeight += Int(70 + CGFloat(self.heightDescription))
            }else{
                cell.heightImgVw.constant = 150
                reviewHeight += Int(220 + CGFloat(self.heightDescription))
                cell.imgVwReview.imageLoad(imageUrl: arrBusinessReview[indexPath.row].media ?? "")
            }
            
        }
        
        return cell
    }
    
    
}


