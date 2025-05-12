//
//  ProfileVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//

import UIKit

//MARK: - PROFILEDATA

struct ProfileData{
    let title:String?
    let img:String?
    init(title: String?, img: String?) {
        self.title = title
        self.img = img
    }
}
class ProfileVC: UIViewController {
    //MARK: - OUTLEST
    @IBOutlet var viewWallet: UIView!
    @IBOutlet var viewFiance: UIView!
    @IBOutlet var viewPromoCode: UIView!
    @IBOutlet var stackVwPromocodAndFinance: UIStackView!
    @IBOutlet var viewNotificationDot: UIView!
    @IBOutlet weak var topTitle: NSLayoutConstraint!
    @IBOutlet weak var lblPromo: UILabel!
    @IBOutlet weak var imgVwPromo: UIImageView!
    @IBOutlet weak var btmScrollVw: NSLayoutConstraint!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblMobilenumber: UILabel!
    @IBOutlet var heightTblvw: NSLayoutConstraint!
    @IBOutlet var imgVwProfile: UIImageView!
    @IBOutlet var tblVwProfile: UITableView!
    @IBOutlet weak var btnChangePhone: UIButton!
    
    //MARK: - VARIABLES
    var arrProfile = [ProfileData]()
    var viewModel = UserProfileVM()
    var viewModelBusiness = BusinessProfileVM()
    var arrInterst = [Interest]()
    var arrDietry = [DietaryPreference]()
    var arrSpecialize = [Specialization]()
    var businessUserProfile:[UserProfiles]?
    var openingHour:[OpeningHourr]?
    var isUserParticipantsList = false
    var viewModelBank = PaymentVM()
    var arrBank = [BankAccountDetailData]()
    let deviceHasNotch = UIApplication.shared.hasNotch
    var viewModelReview = SelfReviewVM()
    var isTotalReview = false
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reviewApiCall()
        NotificationCenter.default.post(name: Notification.Name("CallMenuApi"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("callHomeSocket"), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            if Store.userNotificationCount ?? 0 > 0{
                self.viewNotificationDot.isHidden = false
            }else{
                self.viewNotificationDot.isHidden = true
            }
        }
        

        NotificationCenter.default.addObserver(self, selector: #selector(self.callBackGetDot(notification:)), name: Notification.Name("callBackGetDot"), object: nil)

        getBankApi()
    }
    
   func reviewApiCall() {
        viewModelReview.getUserMomentReviews(userId: Store.UserDetail?["userId"] as? String ?? "") { data in
            if data?.averageRatings?.totalReviews ?? 0 > 0{
                self.isTotalReview = true
            }else{
                self.isTotalReview = false
            }
            self.isLoading = true
        }
    }
    
    @objc func callBackGetDot(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8){
            if Store.userNotificationCount ?? 0 > 0{
                self.viewNotificationDot.isHidden = false
            }else{
                self.viewNotificationDot.isHidden = true
            }
        }
    }

    @objc func GetBankCount(notification: Notification) {
        
       getBankApi()
    }
    func getBankApi(){
        WebService.hideLoader()
        viewModelBank.getBankDetailsApi { data in
            self.arrBank = data?.data ?? []
        }

    }

    @objc func UpdateProfileImgAndName(notification: Notification) {
        uiSet()
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        uiSet()
    }
    
    func uiSet(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("role"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateProfileImgAndName(notification:)), name: Notification.Name("UpdateUserName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetBankCount(notification:)), name: Notification.Name("ForBank"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationMenu(notification:)), name: Notification.Name("CallMenuApi"), object: nil)

            self.arrProfile.removeAll()
            self.btnChangePhone.underline()
            if Store.role == "b_user"{
                viewWallet.isHidden = true
                viewPromoCode.isHidden = true
                viewFiance.isHidden = true
                self.lblName.text =  Store.BusinessUserDetail?["userName"] as? String ?? "".capitalized
                self.lblMobilenumber.text =  "\(Store.BusinessUserDetail?["countryCode"] as? String ?? "") \(Store.BusinessUserDetail?["mobile"] as? Int ?? 0)"
                self.imgVwProfile.imageLoad(imageUrl: Store.BusinessUserDetail?["profileImage"] as? String ?? "")
                self.arrProfile.append(ProfileData(title: "Offers", img: "promoo"))
                self.arrProfile.append(ProfileData(title: "Your Task", img: "Posted Gig"))
                self.arrProfile.append(ProfileData(title: "Your Services", img: "YourService"))
                self.arrProfile.append(ProfileData(title: "Analytics", img: "analysis"))
                self.arrProfile.append(ProfileData(title: "Info and Support", img: "info"))
                self.imgVwPromo.image = UIImage(named: "promoo")
                self.lblPromo.text = "Offers"
                self.heightTblvw.constant = CGFloat(self.arrProfile.count*70)
            }else{
                viewWallet.isHidden = true
                viewPromoCode.isHidden = true
                viewFiance.isHidden = true

                self.lblName.text =  Store.UserDetail?["userName"] as? String ?? ""
                self.lblMobilenumber.text =  "\(Store.UserDetail?["countryCode"] as? String ?? "") \(Store.UserDetail?["mobile"] as? Int ?? 0)"
                self.imgVwProfile.imageLoad(imageUrl: Store.UserDetail?["profileImage"] as? String ?? "")
                self.arrProfile.append(ProfileData(title: "Promo codes", img: "promocode"))
                self.arrProfile.append(ProfileData(title: "Self Review file", img: "selfReview"))
//                self.arrProfile.append(ProfileData(title: "Your Task", img: "yourTask"))
//                self.arrProfile.append(ProfileData(title: "Applied Task", img: "Posted Gig"))
                self.arrProfile.append(ProfileData(title: "Moments", img: "MomentLst"))
                self.arrProfile.append(ProfileData(title: "Applied Moments", img: "applied"))
                self.arrProfile.append(ProfileData(title: "Popups", img: "popup"))
                self.arrProfile.append(ProfileData(title: "Info and Support", img: "info"))
                self.heightTblvw.constant = CGFloat(self.arrProfile.count*70)
                self.imgVwPromo.image = UIImage(named: "promocode")
                self.lblPromo.text = "Promo codes"
            }
            self.tblVwProfile.reloadData()
        
    }
    @objc func didTapWallet() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        self.navigationController?.pushViewController(vc, animated: true)

    }

    @objc func methodOfReceivedNotificationMenu(notification: Notification) {
        if Store.userNotificationCount ?? 0 > 0{
            self.viewNotificationDot.isHidden = false
        }else{
            self.viewNotificationDot.isHidden = true
        }
    }

    //MARK: - IBAction
    @IBAction func actionNOtification(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        vc.callBack = {
            NotificationCenter.default.post(name: Notification.Name("CallMenuApi"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("callHomeSocket"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                if Store.userNotificationCount ?? 0 > 0{
                    self.viewNotificationDot.isHidden = false
                }else{
                    self.viewNotificationDot.isHidden = true
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionProfile(_ sender: UIButton) {
        if Store.role == "b_user"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileVC") as! BusinessProfileVC
            vc.isComing = true
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewVC") as! ProfileViewVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionLogout(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogOutVC") as! LogOutVC
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)

    }
    @IBAction func actionFinance(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfoAndSupportVC") as! InfoAndSupportVC
        vc.isComing = false
        vc.arrBank = self.arrBank
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionPromocode(_ sender: UIButton) {
        if Store.role == "b_user"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpecialOfferVC") as! SpecialOfferVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PromoCodeVC") as! PromoCodeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    @IBAction func actionChnagephoneNumber(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterPhoneNumberVC") as! EnterPhoneNumberVC
        vc.isComing = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE

extension ProfileVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProfile.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVC", for: indexPath) as! ProfileTVC
        cell.imgVwTitle.image = UIImage(named: arrProfile[indexPath.row].img ?? "")
        cell.lbltitle.text = arrProfile[indexPath.row].title ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //business
        if Store.role == "b_user"{
            switch indexPath.row {
            case 0:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpecialOfferVC") as! SpecialOfferVC
                self.navigationController?.pushViewController(vc, animated: true)

            case 1:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigListVC") as! GigListVC
                vc.isComing = 2
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyServicesVC") as! MyServicesVC
                vc.isSelect = 1
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnalysisVC") as! AnalysisVC
                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfoAndSupportVC") as! InfoAndSupportVC
                vc.isComing = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
            
        }else{

            //User
            switch indexPath.row {
            case 0:
                pushViewController(identifier: "PromoCodeVC")
            case 1:
                if isLoading{
                    if isTotalReview{
                        pushViewController(identifier: "SelfReviewFileVC")
                    }else{
                        pushViewController(identifier: "AddSelfReviewVC")
                    }
                }
               // pushViewController(identifier: "SelfReviewFileVC")
                //pushViewController(identifier: "NewReviewVC")
                
//            case 2:
//                pushViewController(identifier: "GigListVC") { (vc: GigListVC) in
//                    vc.isComing = 2
//                    Store.isUserParticipantsList = true
//                }
//            case 3:
//                pushViewController(identifier: "GigListVC") { (vc: GigListVC) in
//                    vc.isComing = 1
//                    Store.isUserParticipantsList = false
//                }
            case 2:
                pushViewController(identifier: "OwnerMomentsListVC")
            case 3:
                pushViewController(identifier: "OwnerMomentsListVC") { (vc: OwnerMomentsListVC) in
                    vc.isApplied = true
                }
            case 4:
                pushViewController(identifier: "PopUpListVC")
            case 5:
                pushViewController(identifier: "InfoAndSupportVC") { (vc: InfoAndSupportVC) in
                    vc.isComing = true
                }
            default:
                break
            }
        }
    }
    func pushViewController<T: UIViewController>(identifier: String, configure: ((T) -> Void)? = nil) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: identifier) as? T {
            configure?(vc)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
