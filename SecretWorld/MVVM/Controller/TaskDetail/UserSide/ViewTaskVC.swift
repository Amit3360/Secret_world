//
//  ViewTaskVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/01/25.
//

import UIKit
import AlignedCollectionViewFlowLayout
import MapboxMaps
import Solar
import SideMenu

class ViewTaskVC: UIViewController, SideMenuNavigationControllerDelegate {
    @IBOutlet weak var vwAppliedPeople: UIView!
    @IBOutlet weak var vwTools: UIView!
    @IBOutlet weak var vwSkills: UIView!
    @IBOutlet weak var vwAbout: UIView!
    @IBOutlet weak var vwInstruction: UIView!
    @IBOutlet weak var vwSafetyTips: UIView!
    @IBOutlet weak var vwAvoidDescription: UIView!
    @IBOutlet weak var lblAvoidDescription: UILabel!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var lblPayoutType: UILabel!
    @IBOutlet weak var lblTaskType: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imgVwImmediate: UIImageView!
    @IBOutlet weak var lblImmediate: UILabel!
    @IBOutlet weak var imgVwTask: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var lblNoReview: UILabel!
    @IBOutlet var viewReview: UIView!
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var widthBtnChat: NSLayoutConstraint!
    @IBOutlet var lblAppliedPeoples: UILabel!
    @IBOutlet var lblExperience: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet var lblPayout: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblSafty: UILabel!
    @IBOutlet var lblInstructions: UILabel!
    @IBOutlet var lblHelp: UILabel!
    @IBOutlet var lblProviderRating: UILabel!
    @IBOutlet var lblProviderName: UILabel!
    @IBOutlet var imgVwUserType: UIImageView!
    @IBOutlet var imgVwProvider: UIImageView!
    @IBOutlet var slider: CustomSlide!
    @IBOutlet var lblUserCount: UILabel!
    @IBOutlet weak var mapVw: MapView!
    @IBOutlet var heightTblVwReview: NSLayoutConstraint!
    @IBOutlet var viewCompleteGig: UIView!
    @IBOutlet var tblVwReviews: UITableView!
    @IBOutlet var heightCollVwSkills: NSLayoutConstraint!
    @IBOutlet var heightCollVwTools: NSLayoutConstraint!
    @IBOutlet var collVwTools: UICollectionView!
    @IBOutlet var collVwSkills: UICollectionView!
    @IBOutlet var collVwUserList: UICollectionView!
    @IBOutlet weak var lblAppliedText: UILabel!
    
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
    var price = Double()
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
    var isReviewed = false
    var descriptionText = ""
    var gigName = ""
    private var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiData()
      
    }
    func uiData(){
        slider.setThumbImage(UIImage(), for: .normal)
        slider.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        let nibReiew = UINib(nibName: "ReviewTVC", bundle: nil)
        tblVwReviews.register(nibReiew, forCellReuseIdentifier: "ReviewTVC")

        let nib = UINib(nibName: "SkillToolsCVC", bundle: nil)
        collVwTools.register(nib, forCellWithReuseIdentifier: "SkillToolsCVC")
        let nib2 = UINib(nibName: "SkillToolsCVC", bundle: nil)
        collVwSkills.register(nib2, forCellWithReuseIdentifier: "SkillToolsCVC")
        let nib3 = UINib(nibName: "UserListCVC", bundle: nil)
        collVwUserList.register(nib3, forCellWithReuseIdentifier: "UserListCVC")
        sideMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuNavigationController") as? SideMenuNavigationController
         sideMenu?.sideMenuDelegate = self
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)

        setCollectionViewHeight()
   
    }
    
    func setCollectionViewHeight(){
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
        let heightInterest = self.collVwTools.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwTools.constant = heightInterest
        let heightDietry = self.collVwSkills.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwSkills.constant = heightDietry
        self.view.layoutIfNeeded()
    }
    private func updateCollectionViewHeights() {
        collVwTools.layoutIfNeeded()
        collVwSkills.layoutIfNeeded()
        
        let toolsHeight = collVwTools.collectionViewLayout.collectionViewContentSize.height
        heightCollVwTools.constant = toolsHeight
        
        let skillsHeight = collVwSkills.collectionViewLayout.collectionViewContentSize.height
        heightCollVwSkills.constant = skillsHeight
        
        view.layoutIfNeeded()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightInterest = self.collVwTools.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwTools.constant = heightInterest
        let heightDietry = self.collVwSkills.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwSkills.constant = heightDietry
        self.view.layoutIfNeeded()
      }
    @objc func handleSwipe() {
        self.navigationController?.popViewController(animated: true)
        callBack?()
           }

    override func viewWillAppear(_ animated: Bool) {
        uiSet()
        getGigChat()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDescription))
        lblHelp.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.heightTblVwReview.constant = self.tblVwReviews.contentSize.height+10
    
        NotificationCenter.default.post(name: Notification.Name("AddReview"), object: nil)
        self.view.layoutIfNeeded()
    }
    func updateTableViewHeight() {
        self.heightTblVwReview.constant = self.tblVwReviews.contentSize.height + 10
        self.view.layoutIfNeeded()
    }
    @objc private func toggleDescription() {
        isExpanded.toggle()
        if lblHelp.text?.contains("Read More") ?? false || lblHelp.text?.contains("Read Less") ?? false{
            if isExpanded {
                lblHelp.appendReadLess(after: descriptionText, trailingContent: .readless)
            } else {
                lblHelp.appendReadmore(after: descriptionText, trailingContent: .readmore)
            }
           
           
          }
       
    }
    func uiSet(){
        if let solar = Solar(coordinate: CLLocationCoordinate2D(latitude: myCurrentLat, longitude: myCurrentLong)) {
            self.solar = solar
            let isDaytime = solar.isDaytime
            print(isDaytime ? "It's day time!" : "It's night time!")
            if isDaytime{
                if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                    mapVw.mapboxMap.loadStyleURI(StyleURI(url: styleURL) ?? .light)
                }

            }else{
        if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                           mapVw.mapboxMap.loadStyleURI(StyleURI(url: styleURL) ?? .light)
                       }
            }
            }
        mapVw.ornaments.scaleBarView.isHidden = true
        mapVw.ornaments.logoView.isHidden = true
        mapVw.ornaments.attributionButton.isHidden = true
        
        tblVwReviews.estimatedRowHeight = 100
        tblVwReviews.rowHeight = UITableView.automaticDimension
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
            let clusterManager = ClusterManager(mapView: self.mapVw)
            clusterManager.removeClusters()
            self.customAnnotations.removeAll()
            self.arrSkill.removeAll()
            self.arrTools.removeAll()
            self.arrCategory.removeAll()
            self.arrParticiptant.removeAll()
            self.arrParticiptant = data?.participantsList ?? []
         
            self.collVwUserList.reloadData()
            self.arrCategory.append(Skills(id: data?.gig?.category?.id ?? "", name: data?.gig?.category?.name ?? ""))
            for i in data?.gig?.skills ?? []{
                self.arrSkill.append(Skills(id: i.id ?? "", name: i.name ?? ""))
            }
            self.arrTools = data?.gig?.tools ?? []
            self.collVwTools.reloadData()
            self.collVwSkills.reloadData()
            DispatchQueue.main.async {
                self.updateCollectionViewHeights()
            }
            self.lblTitle.text = "\(data?.gig?.title ?? "") \((data?.gig?.category?.name ?? ""))"
            self.gigName = "\(data?.gig?.title ?? "") \((data?.gig?.category?.name ?? ""))"
            self.lblAddress.text = data?.gig?.address ?? ""
     
            self.lblExperience.text = data?.gig?.experience ?? ""
         
            self.lblSafty.text = data?.gig?.safetyTips ?? ""
          
            self.lblInstructions.text = data?.gig?.description ?? ""
            self.changeTimeStatus(data?.gig?.timeStatus ?? "")
            self.lblDuration.text = data?.gig?.serviceDuration ?? ""
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
            if data?.gig?.avoidDescription == "" || data?.gig?.avoidDescription == nil{
                self.vwAvoidDescription.isHidden = true
            }else{
                self.vwAvoidDescription.isHidden = false
            }
            
            if data?.gig?.about == "" || data?.gig?.about == nil{
                self.vwAbout.isHidden = true
            }else{
                self.vwAbout.isHidden = false
            }
            
            if data?.gig?.description == "" || data?.gig?.description == nil{
                self.vwInstruction.isHidden = true
            }else{
                self.vwInstruction.isHidden = false
            }
            
            if data?.gig?.safetyTips == "" || data?.gig?.safetyTips == nil{
                self.vwSafetyTips.isHidden = true
            }else{
                self.vwSafetyTips.isHidden = false
            }
            
            self.lblAvoidDescription.text = data?.gig?.avoidDescription  ?? ""
            self.descriptionText = data?.gig?.about ?? ""
            self.lblHelp.appendReadmore(after: self.descriptionText, trailingContent: .readmore)
            if data?.gig?.paymentMethod == 0{
                self.lblPayoutType.text = "Payout (Online)"
            }else{
                self.lblPayoutType.text = "Payout (Cash)"
            }
            let value: Double = data?.gig?.price ?? 0
            let formattedValue = String(format: "%.2f", value)
            
            if data?.gig?.paymentTerms == 0{
              
                self.lblPayout.text = "$\(formattedValue) (Fixed)"
            }else{
                self.lblPayout.text = "$\(formattedValue) (Hourly)"
            }
            if data?.gig?.type == "worldwide"{
                self.lblTaskType.text = "(Worldwide)"
             
            }else{
                self.lblTaskType.text = "(Local)"
              
            }
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
                        self.lblDateTime.text = "Now"
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
                            self.lblDateTime.text = formattedDateTime
                        }
                    }
                } else {
                    print("Failed to parse time string: \(timeString)")
                }
            }
            
            self.mapVw.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: data?.gig?.lat ?? 0, longitude: data?.gig?.long ?? 0),zoom: 11,bearing: 0,pitch: 0))
            self.customAnnotations.append(ClusterPoint(coordinate: CLLocationCoordinate2D(latitude: data?.gig?.lat ?? 0, longitude: data?.gig?.long ?? 0 ), price: data?.gig?.price ?? 0, seen: 1))
            clusterManager.addClusters(with: self.customAnnotations)

            self.userGigDetail = data
            self.promoCodeDetail = data?.promoCodes
            self.arrUserReview.removeAll()
            self.arrUserReview.append(contentsOf: data?.reviews ?? [])
            self.participantCount = data?.appliedParticipants ?? 0
            if data?.reviews?.count ?? 0 > 0{
                self.viewReview.isHidden = false
            }else{
              self.viewReview.isHidden = true
             
            }

            self.userId = data?.gig?.user?.id ?? ""
            self.gigUserType = data?.gig?.usertype ?? ""
            self.userDetail = data?.gig?.user
            
            self.userGigStatus = data?.status
            self.imgVwProvider.imageLoad(imageUrl: data?.gig?.user?.profilePhoto ?? "")
            self.lblProviderName.text = data?.gig?.user?.name ?? ""
            if let rating = data?.gig?.user?.averageRating {
                switch rating {
                case .double(let value):
                    print("Average Rating as Double:", value)
                    self.lblProviderRating.text = "\(value)"
                case .string(let value):
                    print("Average Rating as String:", value)
                    self.lblProviderRating.text = "\(value)"
                }
            }
          
//            if data?.gig?.image == "" || data?.gig?.image == nil{
                self.imgVwTask.image = UIImage(named: "taskIcon")
//                self.mapVw.isHidden = false
//            }else{
//                self.imgVwTask.imageLoad(imageUrl: data?.gig?.image ?? "")
////                self.mapVw.isHidden = true
//            }

          
            self.textAbout = data?.gig?.about ?? ""
            self.lblAddress.text = data?.gig?.address ?? ""
          
            self.lblAppliedPeoples.text = "\(data?.appliedParticipants ?? 0)"
            self.lblUserCount.text = "Spots \(data?.participantsList?.count ?? 0)/\(data?.gig?.totalParticipants ?? 0)"
            self.slider.minimumValue = 0
            self.slider.maximumValue =  Float(data?.gig?.totalParticipants ?? 0)
            self.slider.value = Float(data?.participantsList?.count ?? 0)
            
           

            
            if data?.gig?.usertype == "user"{
                if data?.status == 0{
                    self.vwAppliedPeople.isHidden = true
                    self.btnMessage.isHidden = true
                    self.viewCompleteGig.isHidden = true
                    self.btnApply.setTitle("Requested", for: .normal)
                    self.btnApply.backgroundColor =  UIColor(red: 255/255, green: 230/255, blue: 182/255, alpha: 1.0)
                    self.btnApply.setTitleColor(UIColor(red: 255/255, green: 178/255, blue: 30/255, alpha: 1.0), for: .normal)
                    self.btnApply.isUserInteractionEnabled = false
                    self.lblAppliedText.text = "people applied in last hour"
                }else  if data?.status == 1{
                    self.vwAppliedPeople.isHidden = true
                    self.btnMessage.isHidden = false
                    self.viewCompleteGig.isHidden = true
                    self.btnApply.isHidden = false
                    self.btnApply.setTitle("Added to itinerary", for: .normal)
                    self.btnApply.backgroundColor =  UIColor.app.withAlphaComponent(0.5)
                    self.btnApply.setTitleColor(UIColor.white, for: .normal)
                    self.btnApply.isUserInteractionEnabled = false
//                    self.btnChat.isHidden = false
                    self.lblAppliedText.text = "people applied in last hour"
                }else if data?.status == 2 || data?.status == 3{
                    self.lblAppliedText.text = "people worked with you"
                    //complete
//                    self.btnChat.isHidden = true
                    self.vwAppliedPeople.isHidden = true
                    self.btnMessage.isHidden = true
                    self.viewCompleteGig.isHidden = false
                    if data?.promoCodes?.isViewed == false{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PromoCodePopUpVC") as! PromoCodePopUpVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.promoCodeDetail = self.promoCodeDetail
                        vc.callBack = {[weak self] in
                            guard let self = self else { return }
                            self.getUserGigDetailApi()
                        }
                        self.navigationController?.present(vc, animated: false)
                        
                    }else{
                        if data?.isReview == true{
                            
                            self.btnApply.isHidden = false
                         
//                            self.heightviewCompleteMsg.constant = 0
                       
                            self.btnApply.setTitle("Update review", for: .normal)
                        }else{
                            
                            self.btnApply.isHidden = false
                       
                            self.btnApply.backgroundColor =  UIColor.app
                            self.btnApply.setTitleColor(UIColor.white, for: .normal)
//                            self.btnMore.isHidden = true
//                            self.heightviewCompleteMsg.constant = 100
                          
                            self.btnApply.setTitle("Add review", for: .normal)


                        }
                    }
                }else{
                    self.vwAppliedPeople.isHidden = false
                    self.lblAppliedText.text = "people applied in last hour"
                    self.btnMessage.isHidden = true
                    self.viewCompleteGig.isHidden = true
                    if Store.userId == data?.gig?.user?.id ?? ""{
                        self.btnApply.isHidden = true
                        self.btnApply.setTitle("", for: .normal)
                        self.btnApply.backgroundColor =  UIColor.clear
                        self.btnApply.setTitleColor(UIColor.clear, for: .normal)
                    }else{
                        self.btnApply.isHidden = false
                        self.btnApply.setTitle("Apply", for: .normal)
                        self.btnApply.backgroundColor =  UIColor.app
                        self.btnApply.setTitleColor(UIColor.white, for: .normal)
                    }
                   
                  
//                    self.btnMore.isHidden = true
                }
            }else{
                
                if data?.status == 0{
                    self.btnMessage.isHidden = true
                    self.viewCompleteGig.isHidden = true
                    self.btnApply.setTitle("Requested", for: .normal)
                    self.btnApply.backgroundColor =  UIColor(red: 255/255, green: 230/255, blue: 182/255, alpha: 1.0)
                    self.btnApply.setTitleColor(UIColor(red: 255/255, green: 178/255, blue: 30/255, alpha: 1.0), for: .normal)
                    self.btnApply.isUserInteractionEnabled = false
//                    self.btnMore.isHidden = true
                    self.lblAppliedText.text = "people applied in last hour"
                }else  if data?.status == 1{
                    self.btnMessage.isHidden = false
                    self.viewCompleteGig.isHidden = true
                    self.btnApply.isHidden = false
                    self.btnApply.setTitle("Added to itinerary", for: .normal)
                    self.btnApply.backgroundColor =  UIColor.app.withAlphaComponent(0.5)
                    self.btnApply.setTitleColor(UIColor.white, for: .normal)
//                    self.btnMore.isHidden = true
                    self.btnApply.isUserInteractionEnabled = false
//                    self.btnChat.isHidden = false
                    self.lblAppliedText.text = "people applied in last hour"
                }else if data?.status == 2{
                    
                    //complete
//                    self.btnChat.isHidden = true
//                    self.btnMore.isHidden = true
                    self.btnMessage.isHidden = true
                    self.viewCompleteGig.isHidden = false
                    if data?.promoCodes?.isViewed == false{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PromoCodePopUpVC") as! PromoCodePopUpVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.promoCodeDetail = self.promoCodeDetail
                        vc.callBack = {[weak self] in
                            guard let self = self else { return }
                            self.getUserGigDetailApi()
                        }
                        self.navigationController?.present(vc, animated: false)
                        
                    }else{
                        if data?.isReview == true{
                        
                            self.btnApply.isHidden = true
//                            self.btnMore.isHidden = true
//                            self.heightviewCompleteMsg.constant = 0
                        
                            self.btnApply.setTitle("Update review", for: .normal)
                          
                        }else{
                            
                            self.btnApply.isHidden = false
                        
                            self.btnApply.backgroundColor =  UIColor.app
                            self.btnApply.setTitleColor(UIColor.white, for: .normal)
//                            self.btnMore.isHidden = true
//                            self.heightviewCompleteMsg.constant = 100
                          
                            self.btnApply.setTitle("Add review", for: .normal)

                        }
                    }
                    self.lblAppliedText.text = "people worked with you"
                }else{
                    self.lblAppliedText.text = "people applied in last hour"
                    self.btnMessage.isHidden = true
                    self.viewCompleteGig.isHidden = true
                    if Store.userId == data?.gig?.user?.id ?? ""{
                        self.btnApply.isHidden = true
                        self.btnApply.setTitle("", for: .normal)
                        self.btnApply.backgroundColor =  UIColor.clear
                        self.btnApply.setTitleColor(UIColor.clear, for: .normal)
                    }else{
                        self.btnApply.isHidden = false
                        self.btnApply.setTitle("Apply", for: .normal)
                        self.btnApply.backgroundColor =  UIColor.app
                        self.btnApply.setTitleColor(UIColor.white, for: .normal)
                    }
//                    self.btnMore.isHidden = true
                }
            }
            self.tblVwReviews.reloadData()
            self.tblVwReviews.invalidateIntrinsicContentSize()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self.updateTableViewHeight()
            }
            
        }
    }
    func getBusinessGigDetailApi(){
        
        viewModel.GetBuisnessGigDetailApi(gigId: gigId) { data in
            let clusterManager = ClusterManager(mapView: self.mapVw)
            clusterManager.removeClusters()
            self.customAnnotations.removeAll()
            self.arrSkill.removeAll()
            self.arrTools.removeAll()
            self.arrCategory.removeAll()
            self.arrCategory.append(Skills(id: data?.category?.id ?? "", name: data?.category?.name ?? ""))
            for i in data?.skills ?? []{
                self.arrSkill.append(Skills(id: i.id ?? "", name: i.name ?? ""))
            }
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
            self.price = data?.price ?? 0
            self.lblDuration.text = data?.serviceDuration ?? ""
            self.lblTitle.text = "\(data?.title ?? "") \((data?.category?.name ?? ""))"
            self.gigName = "\(data?.title ?? "") \((data?.category?.name ?? ""))"
            if data?.avoidDescription == "" || data?.avoidDescription == nil{
                self.vwAvoidDescription.isHidden = true
            }else{
                self.vwAvoidDescription.isHidden = false
            }
            
            if data?.about == "" || data?.about == nil{
                self.vwAbout.isHidden = true
            }else{
                self.vwAbout.isHidden = false
            }
            
            if data?.description == "" || data?.description == nil{
                self.vwInstruction.isHidden = true
            }else{
                self.vwInstruction.isHidden = false
            }
            
            if data?.safetyTips == "" || data?.safetyTips == nil{
                self.vwSafetyTips.isHidden = true
            }else{
                self.vwSafetyTips.isHidden = false
            }
            self.lblAvoidDescription.text = data?.avoidDescription ?? ""
            self.changeTimeStatus(data?.timeStatus ?? "")
            self.lblAddress.text = data?.address ?? ""
//            self.imgVwTask.imageLoad(imageUrl: data?.image ?? "")
            
//            self.lblGigCategory.text = data?.category?.name ?? ""
            self.lblExperience.text = data?.experience ?? ""
            self.lblSafty.text = data?.safetyTips ?? ""
          
            self.lblInstructions.text = data?.description ?? ""
            self.descriptionText = data?.about ?? ""
            self.lblHelp.appendReadmore(after: self.descriptionText, trailingContent: .readmore)
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
            if data?.type == "worldwide"{
                self.lblTaskType.text = "(worldwide)"
             
            }else{
                self.lblTaskType.text = "(local)"
              
            }
            if data?.paymentMethod == 0{
                self.lblPayoutType.text = "Payout (Online)"
            }else{
                self.lblPayoutType.text = "Payout (Cash)"
            }
            let value: Double = data?.price ?? 0
            let formattedValue = String(format: "%.2f", value)
            
            if data?.paymentTerms == 0{
                self.lblPayout.text = "$\(formattedValue) (Fixed)"
            }else{
                self.lblPayout.text = "$\(formattedValue) (Hourly)"
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
                        self.lblDateTime.text = "Now"
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
                            self.lblDateTime.text = formattedDateTime
                        }
                    }
                } else {
                    print("Failed to parse time string: \(timeString)")
                }
            }
            
            self.mapVw.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: data?.lat ?? 0, longitude: data?.long ?? 0),zoom: 11,bearing: 0,pitch: 0))
            self.customAnnotations.append(ClusterPoint(coordinate: CLLocationCoordinate2D(latitude: data?.lat ?? 0, longitude: data?.long ?? 0 ), price: data?.price ?? 0, seen: 1))
            clusterManager.addClusters(with: self.customAnnotations)
            
            if data?.reviews?.count ?? 0 > 0{
                self.viewReview.isHidden = false
              
            }else{
              self.viewReview.isHidden = true
              
            }

            if data?.status == 0{
//                self.btnMore.isHidden = false
//
                self.btnMessage.isHidden = true
                self.viewCompleteGig.isHidden = true
                if data?.paymentStatus == 0{
                    self.btnApply.isHidden = false
                  
                    self.btnApply.setTitle("Pay Now", for: .normal)
                    self.btnApply.backgroundColor =  UIColor.app
                    self.btnApply.setTitleColor(UIColor.white, for: .normal)
                    self.paymentStatus = 0
                }else{
                    self.btnApply.isHidden = true
                    
                    self.paymentStatus = 1
                }
                self.lblAppliedText.text = "people applied in last hour"
            }else if data?.status == 1{
                self.btnMessage.isHidden = false
                self.viewCompleteGig.isHidden = true
                self.btnApply.isHidden = false
//                self.btnMore.isHidden = true
                self.btnApply.setTitle("Complete", for: .normal)
                self.btnApply.backgroundColor =  UIColor.app
                self.btnApply.setTitleColor(UIColor.white, for: .normal)
//                self.btnChat.isHidden = false
                self.lblAppliedText.text = "people applied in last hour"
            }else if data?.status == 2{
                self.btnMessage.isHidden = true
                self.viewCompleteGig.isHidden = false
//                self.btnMore.isHidden = true
                self.btnApply.isHidden = false
                self.btnApply.backgroundColor = .app
                self.btnApply.setTitleColor(.white, for: .normal)
                
                    if self.isReviewNil == true{
                     
                        self.btnApply.setTitle("Update review", for: .normal)
                   
                    }else{
                     
                        self.btnApply.setTitle("Add review", for: .normal)
                       
                    }
                self.lblAppliedText.text = "people worked with you"
            }else{
                self.btnMessage.isHidden = true
                self.viewCompleteGig.isHidden = true
                self.btnApply.isHidden = true
                self.lblAppliedText.text = "people applied in last hour"
//                self.btnMore.isHidden = true
                
                
            }
            
            self.imgVwProvider.imageLoad(imageUrl: data?.user?.profilePhoto ?? "")
            self.lblProviderName.text = data?.user?.name ?? ""
            self.lblProviderRating.text = data?.user?.averageRating ?? ""
//            if data?.image == "" || data?.image == nil{
                self.imgVwTask.image = UIImage(named: "taskIcon")
//            
//            }else{
//                self.imgVwTask.imageLoad(imageUrl: data?.image ?? "")
//            
//            }
            
            self.lblHelp.text = data?.about ?? ""
            self.textAbout = data?.about ?? ""
            self.lblAddress.text = data?.address ?? ""
         
            self.lblAppliedPeoples.text = "\(data?.appliedParticipants ?? 0)"
            self.lblUserCount.text = "Spots \(data?.participantsList?.count ?? 0)/\(data?.totalParticipants ?? 0)"
            self.slider.minimumValue = 0
            self.slider.maximumValue =  Float(data?.totalParticipants ?? 0) 
            self.slider.value = Float(data?.participantsList?.count ?? 0)
          
          

//            if data?.paymentTerms == 0{
//                self.lblPrice.text = "$\(data?.price ?? 0) Fixed"
//            }else{
//                self.lblPrice.text = "$\(data?.price ?? 0) Hourly"
//            }
            self.tblVwReviews.reloadData()
            self.tblVwReviews.invalidateIntrinsicContentSize()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self.updateTableViewHeight()
            }
            
        }
    }
    
    private func changeTimeStatus(_ timeStatus: String) {
        lblImmediate.text = timeStatus
        switch timeStatus {
        case "Immediate!":
            imgVwUserType.isHidden = false
            lblImmediate.textColor = UIColor(hex: "#D8553A")
            imgVwImmediate.image = UIImage(named: "fire") // Replace with your asset name
        case "Same Day!":
            imgVwUserType.isHidden = true
            lblImmediate.textColor = UIColor(hex: "#FF9100")
            imgVwImmediate.image = UIImage(named: "sameDay") // Replace with your asset name
        case "Scheduled task!":
            imgVwUserType.isHidden = true
            lblImmediate.textColor =  UIColor(hex: "#17A3CE")
            imgVwImmediate.image = UIImage(named: "sheduleTask") // Replace with your asset name
        default:
            imgVwUserType.isHidden = true
            lblImmediate.textColor = UIColor(hex: "#D8553A")
            imgVwImmediate.image = UIImage(named: "fire") // Default icon
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
    //MARK: - IBAction
    @IBAction func actionChat(_ sender: Any) {
        if Store.GigChatDetail?[0].isReady == 1{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigChatVC") as! GigChatVC
            vc.gigId = self.gigId
            vc.gigUserId = self.gigUserId
          
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
        }else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigReadyVC") as! GigReadyVC
            vc.modalPresentationStyle = .overFullScreen
            vc.isComing = 2
            vc.gigDetail2 = userGigDetail
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
                self.navigationController?.pushViewController(vc, animated: false)
                
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
    @IBAction func actionApply(_ sender: Any) {
        if Store.role == "b_user"{
            if businessGigStatus == 2 || businessGigStatus == 3{
//                if arrCompleteParticipants.count > 1{
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantsVC") as! ParticipantsVC
//                    vc.isComing = 2
//                    vc.businessGigDetail = businessGigDetail
//                    vc.gigId = gigId
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }else{
                    
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupReviewVC") as! PopupReviewVC
                    
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isMyTask = false
                    vc.isComingPopUp = true
//                    vc.isComing = 1
//                    if arrCompleteParticipants[sender.tag].review == nil{
//                        vc.isUpdateReview = false
//                    }else{
//                        vc.isUpdateReview = true
//                        vc.reviewsToParticipants = arrCompleteParticipants[sender.tag].review
//                    }
                    vc.gigId = gigId
//                    vc.userId = participantsId
                    vc.businessGigDetail = businessGigDetail
                    vc.arrCompleteParticipants = self.arrCompleteParticipants
                    vc.callBack = { message in
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterFeedbackPopUpVC") as! AfterFeedbackPopUpVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.callBack = {[weak self] in
                            guard let self = self else { return }
                            self.btnApply.isHidden = true
                         
                            self.getBusinessGigDetailApi()
                            self.getCompleteParticipants(loader: false)
                        
                        }
                        self.navigationController?.present(vc, animated: false)
                        
                    }
                    self.navigationController?.present(vc, animated: true)
//                }
                
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
            }else{
                print(businessGigStatus ?? 0)
                if paymentStatus == 0{
                    viewModel.createGig(gigId: gigId,price:price) { data in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.paymentLink = data?.url ?? ""
                        vc.callback = { [weak self] payment in
                            guard let self = self else { return }
                            if payment == true{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigCreatedVC") as! GigCreatedVC
                                vc.modalPresentationStyle = .overFullScreen
                                vc.callBack = {[weak self] in
                                    guard let self = self else { return }
                                    SceneDelegate().GigListVCRoot()
                                }
                                self.navigationController?.present(vc, animated: false)
                            }else{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                                vc.isSelect = 20
                                vc.callBack = {[weak self] in
                                    guard let self = self else { return }
                                    SceneDelegate().GigListVCRoot()
                                }
                                vc.modalPresentationStyle = .overFullScreen
                                self.navigationController?.present(vc, animated: true)
                            }
                            
                            
                        }
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false)
                    }
                }
            }
            
            
        }else{
            
            if userGigStatus == 0{
                print(userGigStatus ?? 0)
             
            }else if userGigStatus == 1{
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatInboxVC") as! ChatInboxVC
//                vc.receiverId = providerUserId
//                self.navigationController?.pushViewController(vc, animated: true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddItineryVC") as! AddItineryVC
                vc.isPersonal = false
                self.navigationController?.pushViewController(vc, animated: true)
            }else if userGigStatus == 2 || userGigStatus == 3{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupReviewVC") as! PopupReviewVC
                    
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isMyTask = false
                    vc.isComingPopUp = true
//                    vc.isComing = 1
//                    if arrCompleteParticipants[sender.tag].review == nil{
//                        vc.isUpdateReview = false
//                    }else{
//                        vc.isUpdateReview = true
//                        vc.reviewsToParticipants = arrCompleteParticipants[sender.tag].review
//                    }
                    vc.gigId = gigId
//                    vc.userId = participantsId
                vc.userGigDetail = userGigDetail
                    vc.arrCompleteParticipants = self.arrCompleteParticipants
                    vc.callBack = { message in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterFeedbackPopUpVC") as! AfterFeedbackPopUpVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.callBack = {[weak self] in
                            guard let self = self else { return }
                            self.btnApply.isHidden = true
                            self.getUserGigDetailApi()
                            
                            
                        }
                        self.navigationController?.present(vc, animated: false)
                        
                    }
                    self.navigationController?.present(vc, animated: true)
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewVC") as! AddReviewVC
//                vc.modalPresentationStyle = .overFullScreen
//                vc.isComing = 2
//                vc.gigId = gigId
//                vc.userId = providerUserId
//                vc.userGigDetail = userGigDetail
//                for (index, review) in arrUserReview.enumerated() {
//                    if Store.userId == review.user?.id ?? ""{
//                        vc.isUpdateReview = true
//                        vc.gigReview = review
//                        break
//                    }
//                }
//                vc.callBack = {[weak self] in
//                    guard let self = self else { return }
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterFeedbackPopUpVC") as! AfterFeedbackPopUpVC
//                    vc.modalPresentationStyle = .overFullScreen
//                    vc.callBack = {[weak self] in
//                        guard let self = self else { return }
//                        self.btnApply.isHidden = true
//                     
//                        self.getUserGigDetailApi()
//                        
//                        
//                    }
//                    self.navigationController?.present(vc, animated: false)
//                    
//                }
//                self.navigationController?.present(vc, animated: true)
                
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
                vc.modalPresentationStyle = .overFullScreen
                vc.gigId = gigId
                vc.taskName = gigName
                vc.userDetail = userDetail
                vc.isComing = 1
                vc.callBack = { [weak self] message in
                    guard let self = self else { return }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.isSelect = 10
                    vc.message = message
                    vc.callBack = {[weak self] in
                        guard let self = self else { return }
                        self.getUserGigDetailApi()
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    self.navigationController?.present(vc, animated: true)
                    
                }
                self.navigationController?.present(vc, animated: true)
            }
        }
        
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        callBack?()
    }
    @IBAction func actionProfileBtn(_ sender: UIButton) {
        
        if isComing == 1{
            if BusinessUserDetail?.role == "user"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewVC") as! ProfileViewVC
                vc.id = BusinessUserDetail?.id ?? ""
                vc.isComingChat = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileVC") as! BusinessProfileVC
                vc.businessId = BusinessUserDetail?.id ?? ""
                vc.isComing = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if userDetail?.role == "user"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewVC") as! ProfileViewVC
                vc.id = userDetail?.id ?? ""
                vc.isComingChat = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileVC") as! BusinessProfileVC
                vc.businessId = userDetail?.id ?? ""
                vc.isComing = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
      
    
    }
    
}
//MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
extension ViewTaskVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
extension ViewTaskVC: UITableViewDelegate,UITableViewDataSource{

        
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
                let rating = arrUserReview[indexPath.row].starCount ?? 0.0
              
                cell.ratingView.rating = rating
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

   
