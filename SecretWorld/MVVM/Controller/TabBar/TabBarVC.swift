//
//  TabBarVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//
import UIKit

class TabBarVC: UIViewController{
    //MARK: - OUTLETS
    
    @IBOutlet weak var btnItinerary: UIButton!
    @IBOutlet weak var lblItinerary: UILabel!
    @IBOutlet weak var vwItinerary: UIView!
    @IBOutlet var bottomImmgVwImgAppIcon: NSLayoutConstraint!
    @IBOutlet var imgVwAppIcon: UIImageView!
    @IBOutlet var lblBusiness: UILabel!
    @IBOutlet var lblGig: UILabel!
    @IBOutlet var lblStore: UILabel!
    @IBOutlet var imgVwBusiness: UIImageView!
    @IBOutlet var imgVwGig: UIImageView!
    @IBOutlet var imgVwStore: UIImageView!
    @IBOutlet var btnBusiness: UIButton!
    @IBOutlet var btnGig: UIButton!
    @IBOutlet var btnStore: UIButton!
    @IBOutlet var viewBusiness: UIView!
    @IBOutlet var viewStore: UIView!
    @IBOutlet var viewGig: UIView!
    @IBOutlet var stackVwBtns: UIStackView!
    @IBOutlet var viewExplore: UIView!
    @IBOutlet var viewMenu: UIView!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var lblMenu: UILabel!
    @IBOutlet var btnAddService: UIButton!
    @IBOutlet var lblHome: UILabel!
    @IBOutlet var lblExplore: UILabel!
    @IBOutlet var lblChat: UILabel!
    @IBOutlet var lblProfile: UILabel!
    @IBOutlet var viewShadow: UIView!
    @IBOutlet var viewBackProfile: UIView!
    @IBOutlet var viewBackHome: UIView!
    @IBOutlet var stackVw: UIStackView!
    @IBOutlet var btnHome: UIButton!
    @IBOutlet var btnExplore: UIButton!
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var scrollVw: UIScrollView!
    @IBOutlet weak var heightBottomVw: NSLayoutConstraint!
    @IBOutlet var topShadowView: NSLayoutConstraint!
    
    //MARK: - VARIABLES
    var selectedButtonTag: Int = 0
    var viewModel = AuthVM()
    var isStatus = 0
    var isGigType = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deviceHasNotch = UIApplication.shared.hasNotch
        if deviceHasNotch{
            if UIDevice.current.hasDynamicIsland {
                
                heightBottomVw.constant = 94
                topShadowView.constant = -94
                
            }else{
                heightBottomVw.constant = 104
                topShadowView.constant = -104
            }
            
        }else{
            
            heightBottomVw.constant = 80
            topShadowView.constant = -80
            
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        uiSet()
        viewModel.verificationStatus { data in
            self.isStatus = data?.verificationStatus ?? 0
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.touchMap(notification:)), name: Notification.Name("touchMap"), object: nil)
            //            NotificationCenter.default.addObserver(self, selector: #selector(self.personalItenery(notification:)), name: Notification.Name("personal"), object: nil)
            //
            //            NotificationCenter.default.addObserver(self, selector: #selector(self.professionalItenery(notification:)), name: Notification.Name("professional"), object: nil)
            //
            //            NotificationCenter.default.addObserver(self, selector: #selector(self.allIteneryBtn(notification:)), name: Notification.Name("all"), object: nil)
        }
        
    }
    func uiSet(){
        
        viewShadow.layer.cornerRadius = 15
        viewShadow.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewShadow.layer.shadowColor = UIColor.black.cgColor
        viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewShadow.layer.shadowRadius = 16
        viewShadow.layer.shadowOpacity = 0.25
        if Store.role == "b_user"{
            viewExplore.isHidden = true
            viewMenu.isHidden = false
            vwItinerary.isHidden = true
        }else{
            vwItinerary.isHidden = false
            viewExplore.isHidden = true
            viewMenu.isHidden = true
        }
        switch selectedButtonTag {
        case 1:
            homeSetup()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.homeSetup()
            }
        case 2:
            //            exploreSetup()
            itinerarySetup()
        case 3:
            bookmarkSetup()
        case 4:
            chatSetup()
        case 5:
            profileSetup()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.profileSetup()
            }
        case 6:
            menuSetup()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.menuSetup()
            }
        default:
            break
        }
    }
    //    @objc func personalItenery(notification:Notification){
    //        isPersonal = true
    //        isSelectItenery = true
    //        btnAddService.isHidden = false
    //        isSelectedAddItinerary = true
    //    }
    //    @objc func professionalItenery(notification:Notification){
    //        isPersonal = false
    //        isSelectItenery = true
    //        btnAddService.isHidden = false
    //        isSelectedAddItinerary = true
    //    }
    //    @objc func allIteneryBtn(notification:Notification){
    //        isSelectItenery = false
    //        btnAddService.isHidden = true
    //        isSelectedAddItinerary = false
    //    }
    //MARK: - BUTTON ACTIONS
    
    
    
    @IBAction func actionAddService(_ sender: UIButton) {
        sender.isEnabled = false
        viewModel.verificationStatus { data in
            self.isStatus = data?.verificationStatus ?? 0
            
            if self.isStatus == 0{
                sender.isEnabled = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 0
                vc.callBack = {[weak self] in
                    
                    guard let self = self else { return }
                    self.viewModel.verificationStatus { data in
                        self.isStatus = data?.verificationStatus ?? 0
                    }
                }
                self.navigationController?.present(vc, animated: false)
            }else if self.isStatus == 1{
                sender.isEnabled = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 5
                vc.callBack = {[weak self] in
                    
                    guard let self = self else { return }
                    self.viewModel.verificationStatus { data in
                        self.isStatus = data?.verificationStatus ?? 0
                    }
                }
                self.navigationController?.present(vc, animated: false)
            }else{
                sender.isEnabled = true
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditServiceVC") as! EditServiceVC
                vc.isComing = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }
    @IBAction func actionAdd(_ sender: UIButton) {
        
        if Store.role == "user"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectServiceTypeVC") as! SelectServiceTypeVC
            vc.modalPresentationStyle = .overFullScreen
            vc.callBack = { [weak self] type in
                
                guard let self = self else { return }
                self.viewModel.verificationStatus{ data in
                    self.isStatus = data?.verificationStatus ?? 0
                    if self.isStatus == 0{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                        vc.modalPresentationStyle = .overFullScreen
                        if type == 1{
                            vc.isSelect = 6
                        }else{
                            vc.isSelect = 3
                        }
                        vc.callBack = {[weak self] in
                            
                            guard let self = self else { return }
                            self.viewModel.verificationStatus{ data in
                                self.isStatus = data?.verificationStatus ?? 0
                            }
                        }
                        self.navigationController?.present(vc, animated: false)
                    }else if self.isStatus == 1{
                        //gig //popup
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.isSelect = 5
                        vc.callBack = {[weak self] in
                            
                            guard let self = self else { return }
                            self.viewModel.verificationStatus{ data in
                                self.isStatus = data?.verificationStatus ?? 0
                            }
                        }
                        self.navigationController?.present(vc, animated: false)
                    }else{
                        if type == 1{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPopUpVC") as! AddPopUpVC
                            vc.isComing = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
            self.navigationController?.present(vc, animated: true)
        }else{
            self.viewModel.verificationStatus{ data in
                self.isStatus = data?.verificationStatus ?? 0
                if self.isStatus == 0{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isSelect = 25
                    vc.callBack = {[weak self] in
                        
                        guard let self = self else { return }
                        self.viewModel.verificationStatus{ data in
                            self.isStatus = data?.verificationStatus ?? 0
                        }
                    }
                    self.navigationController?.present(vc, animated: false)
                }else if self.isStatus == 1{
                    //gig //popup
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isSelect = 5
                    vc.callBack = {[weak self] in
                        
                        guard let self = self else { return }
                        self.viewModel.verificationStatus{ data in
                            self.isStatus = data?.verificationStatus ?? 0
                        }
                    }
                    self.navigationController?.present(vc, animated: false)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
                    //                            vc.isComing = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    @IBAction func actionMenu(_ sender: UIButton) {
        
        print("\(selectedButtonTag)")
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            menuSetup()
            
            selectedButtonTag = sender.tag
           // NotificationCenter.default.post(name: Notification.Name("CallMenuApi"), object: nil)
        }
    }
    func menuSetup(){
        scrollVw.setContentOffset(.zero, animated: false)
        scrollVw.setContentOffset(CGPoint(x: scrollVw.frame.size.width*5, y: 0), animated: false)
        btnAddService.isHidden = false
        lblMenu.textColor = .app
        lblHome.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblExplore.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblChat.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblProfile.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        btnChat.setImage(UIImage(named: "chatt"), for: .normal)
        btnProfile.setImage(UIImage(named: "profiletab"), for: .normal)
        btnExplore.setImage(UIImage(named: "explore"), for: .normal)
        btnMenu.setImage(UIImage(named: "menuselect"), for: .normal)
        btnMenu.isSelected = true
        btnHome.isSelected = false
        btnExplore.isSelected = false
        btnChat.isSelected = false
        btnProfile.isSelected = false
        lblItinerary.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255,alpha: 1.0)
        btnItinerary.isSelected = false
        btnItinerary.setImage(UIImage(named: "itinerary 1"), for: .normal)
    }
    
    
    @IBAction func actionHome(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("TabBar"), object: nil)
            self.homeSetup()
            
        }
        
    }
    
    func homeButtonsSetup(sender: Bool) {
        if Store.role == "user"{
            if sender {
                // Show stack view with animation
                stackVwBtns.transform = CGAffineTransform(translationX: 0, y: 200)
                stackVwBtns.isHidden = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.stackVwBtns.transform = .identity
                    self.stackVwBtns.alpha = 1
                })
            } else {
                // Hide stack view with animation
                UIView.animate(withDuration: 0.3, animations: {
                    self.stackVwBtns.transform = CGAffineTransform(translationX: 0, y: 200)
                    self.stackVwBtns.alpha = 0
                }, completion: { _ in
                    self.stackVwBtns.isHidden = true
                })
            }
        }
    }
    
    
    func homeSetup(){
        if Store.role == "b_user"{
            
            let deviceHasNotch = UIApplication.shared.hasNotch
            if deviceHasNotch{
                if UIDevice.current.hasDynamicIsland {
                    
                    heightBottomVw.constant = 94
                    topShadowView.constant = -94
                    
                
                }else{
                    if isSelectAnother{
                        heightBottomVw.constant = 104
                        topShadowView.constant = -118
                    }else{
                        heightBottomVw.constant = 104
                        topShadowView.constant = -104
                    }
                }
                
            }else{
                
                if isSelectAnother{
                    heightBottomVw.constant = 80
                    topShadowView.constant = -94
                }else{
                    heightBottomVw.constant = 80
                    topShadowView.constant = -80
                }
                
            }
        }
        scrollVw.setContentOffset(.zero, animated: false)
        btnAddService.isHidden = true
        lblHome.textColor = .app
        lblMenu.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblExplore.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblChat.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblProfile.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        
        btnChat.setImage(UIImage(named: "chatt"), for: .normal)
        btnProfile.setImage(UIImage(named: "profiletab"), for: .normal)
        btnMenu.setImage(UIImage(named: "menuunselect"), for: .normal)
        btnExplore.setImage(UIImage(named: "explore"), for: .normal)
        btnHome.isSelected = true
        btnMenu.isSelected = false
        btnExplore.isSelected = false
        btnChat.isSelected = false
        btnProfile.isSelected = false
        lblItinerary.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255,alpha: 1.0)
        btnItinerary.isSelected = false
        btnItinerary.setImage(UIImage(named: "itinerary 1"), for: .normal)
    }
    @IBAction func actionExplore(_ sender: UIButton) {
        
        homeButtonsSetup(sender: false)
        
        NotificationCenter.default.post(name: Notification.Name("StopTimer"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("ExploreApi"), object: nil)
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            NotificationCenter.default.post(name: Notification.Name("SelectOther"), object: nil)
            exploreSetup()
            selectedButtonTag = sender.tag
        }
    }
    func exploreSetup(){
        btnAddService.isHidden = false
        lblExplore.textColor = .app
        lblMenu.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblHome.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblChat.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblProfile.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        scrollVw.setContentOffset(.zero, animated: false)
        scrollVw.setContentOffset(CGPoint(x: scrollVw.frame.size.width*1, y: 0), animated: false)
        
        btnExplore.setImage(UIImage(named: "selectExplor 1"), for: .normal)
        btnChat.setImage(UIImage(named: "chatt"), for: .normal)
        btnProfile.setImage(UIImage(named: "profiletab"), for: .normal)
        btnMenu.setImage(UIImage(named: "menuunselect"), for: .normal)
        btnExplore.isSelected = true
        btnHome.isSelected = false
        btnChat.isSelected = false
        btnProfile.isSelected = false
        btnMenu.isSelected = false
        lblItinerary.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255,alpha: 1.0)
        btnItinerary.isSelected = false
        btnItinerary.setImage(UIImage(named: "itinerary 1"), for: .normal)
    }
    func bookmarkSetup(){
        if Store.role == "b_user"{
            
            let deviceHasNotch = UIApplication.shared.hasNotch
            if deviceHasNotch{
                if UIDevice.current.hasDynamicIsland {
                  
                        heightBottomVw.constant = 94
                        topShadowView.constant = -94
                }else{
                  
                        heightBottomVw.constant = 104
                        topShadowView.constant = -104
                    
                }
                
            }else{
                
                if isSelectAnother{
                    heightBottomVw.constant = 80
                    topShadowView.constant = -94
                }else{
                    heightBottomVw.constant = 80
                    topShadowView.constant = -80
                }
                
            }
        }
        btnAddService.isHidden = true
        lblMenu.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblHome.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblExplore.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblChat.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblProfile.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        scrollVw.setContentOffset(.zero, animated: false)
        scrollVw.setContentOffset(CGPoint(x: scrollVw.frame.size.width*2, y: 0), animated: false)
        btnChat.setImage(UIImage(named: "chatt"), for: .normal)
        btnProfile.setImage(UIImage(named: "profiletab"), for: .normal)
        btnMenu.setImage(UIImage(named: "menuunselect"), for: .normal)
        btnExplore.setImage(UIImage(named: "explore"), for: .normal)
        btnHome.isSelected = false
        btnExplore.isSelected = false
        btnChat.isSelected = false
        btnProfile.isSelected = false
        btnMenu.isSelected = false
        lblItinerary.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255,alpha: 1.0)
        btnItinerary.isSelected = false
        btnItinerary.setImage(UIImage(named: "itinerary 1"), for: .normal)
    }
    @IBAction func actionChat(_ sender: UIButton) {
        homeButtonsSetup(sender: false)
        isSelectAnother = true
        
        NotificationCenter.default.post(name: Notification.Name("StopTimer"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("GetMessage"), object: nil)
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            NotificationCenter.default.post(name: Notification.Name("SelectOther"), object: nil)
            chatSetup()
            selectedButtonTag = sender.tag
        }
    }
    func chatSetup(){
        if Store.role == "b_user"{
            
            let deviceHasNotch = UIApplication.shared.hasNotch
            if deviceHasNotch{
                if UIDevice.current.hasDynamicIsland {
                 
                        heightBottomVw.constant = 94
                        topShadowView.constant = -94
                    
                }else{
                 
                        heightBottomVw.constant = 104
                        topShadowView.constant = -104
                    
                }
                
            }else{
                
                if isSelectAnother{
                    heightBottomVw.constant = 80
                    topShadowView.constant = -94
                }else{
                    heightBottomVw.constant = 80
                    topShadowView.constant = -80
                }
                
            }
        }
        btnAddService.isHidden = true
        lblChat.textColor = .app
        lblMenu.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblHome.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblExplore.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblProfile.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        scrollVw.setContentOffset(.zero, animated: false)
        scrollVw.setContentOffset(CGPoint(x: scrollVw.frame.size.width*3, y: 0), animated: false)
        btnChat.setImage(UIImage(named: "selectChat"), for: .normal)
        btnProfile.setImage(UIImage(named: "profiletab"), for: .normal)
        btnMenu.setImage(UIImage(named: "menuunselect"), for: .normal)
        btnExplore.setImage(UIImage(named: "explore"), for: .normal)
        btnChat.isSelected = true
        btnHome.isSelected = false
        btnExplore.isSelected = false
        btnProfile.isSelected = false
        btnMenu.isSelected = false
        lblItinerary.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255,alpha: 1.0)
        btnItinerary.isSelected = false
        btnItinerary.setImage(UIImage(named: "itinerary 1"), for: .normal)
    }
    @IBAction func actionProfile(_ sender: UIButton) {
        homeButtonsSetup(sender: false)
        isSelectAnother = true
        
        print("Token:- \(Store.authKey ?? "")")
        NotificationCenter.default.post(name: Notification.Name("ForBank"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("StopTimer"), object: nil)
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            NotificationCenter.default.post(name: Notification.Name("SelectOther"), object: nil)
            profileSetup()
            selectedButtonTag = sender.tag
        }
    }
    func profileSetup(){
        if Store.role == "b_user"{
            
            let deviceHasNotch = UIApplication.shared.hasNotch
            if deviceHasNotch{
                if UIDevice.current.hasDynamicIsland {
                  
                        heightBottomVw.constant = 94
                        topShadowView.constant = -94
                    
                }else{
                   
                        heightBottomVw.constant = 104
                        topShadowView.constant = -104
                    
                }
                
            }else{
                
                if isSelectAnother{
                    heightBottomVw.constant = 80
                    topShadowView.constant = -94
                }else{
                    heightBottomVw.constant = 80
                    topShadowView.constant = -80
                }
                
            }
        }
        
        btnAddService.isHidden = true
        lblProfile.textColor = .app
        lblMenu.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblHome.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblExplore.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblChat.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        scrollVw.setContentOffset(.zero, animated: false)
        scrollVw.setContentOffset(CGPoint(x: scrollVw.frame.size.width*4, y: 0), animated: false)
        btnProfile.setImage(UIImage(named: "selectProfile"), for: .normal)
        btnChat.setImage(UIImage(named: "chatt"), for: .normal)
        btnMenu.setImage(UIImage(named: "menuunselect"), for: .normal)
        btnExplore.setImage(UIImage(named: "explore"), for: .normal)
        btnProfile.isSelected = true
        btnMenu.isSelected = false
        btnHome.isSelected = false
        btnExplore.isSelected = false
        btnChat.isSelected = false
        lblItinerary.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255,alpha: 1.0)
        btnItinerary.isSelected = false
        btnItinerary.setImage(UIImage(named: "itinerary 1"), for: .normal)
    }
    
    @IBAction func actionItinerary(_ sender: UIButton) {
        homeButtonsSetup(sender: false)
        isSelectAnother = true
        
        NotificationCenter.default.post(name: Notification.Name("StopTimer"), object: nil)
        
        //        NotificationCenter.default.post(name: Notification.Name("ExploreApi"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("addItenery"), object: nil)
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            NotificationCenter.default.post(name: Notification.Name("SelectOther"), object: nil)
            itinerarySetup()
            selectedButtonTag = sender.tag
        }
    }
    func itinerarySetup(){
        btnAddService.isHidden = true
        lblItinerary.textColor = .app
        lblMenu.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblHome.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblChat.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        lblProfile.textColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
        scrollVw.setContentOffset(.zero, animated: false)
        scrollVw.setContentOffset(CGPoint(x: scrollVw.frame.size.width*6, y: 0), animated: false)
        
        btnItinerary.setImage(UIImage(named: "greenItinerary"), for: .normal)
        btnChat.setImage(UIImage(named: "chatt"), for: .normal)
        btnProfile.setImage(UIImage(named: "profiletab"), for: .normal)
        btnMenu.setImage(UIImage(named: "menuunselect"), for: .normal)
        btnItinerary.isSelected = true
        btnHome.isSelected = false
        btnChat.isSelected = false
        btnProfile.isSelected = false
        btnMenu.isSelected = false
    }
    @objc func touchMap(notification:Notification){
        homeButtonsSetup(sender: false)
        
    }
}

