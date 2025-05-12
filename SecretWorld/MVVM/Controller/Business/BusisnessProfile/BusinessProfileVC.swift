//
//  BusinessProfileVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/24.
//

import UIKit
import AlignedCollectionViewFlowLayout
import FXExpandableLabel

class BusinessProfileVC: UIViewController, UIGestureRecognizerDelegate {
    //MARK: - @IBOutlet
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var heightTblVwReview: NSLayoutConstraint!
    @IBOutlet weak var heightTblVwHour: NSLayoutConstraint!
    @IBOutlet weak var heightCategoryCollVw: NSLayoutConstraint!
    @IBOutlet weak var heightOfferCollVw: NSLayoutConstraint!
    @IBOutlet weak var tblVwReviews: UITableView!
    @IBOutlet weak var tblVwHours: CustomTableView!
    @IBOutlet weak var collVwCategory: UICollectionView!
    @IBOutlet weak var collVwOffer: UICollectionView!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblTaskCount: UILabel!
    @IBOutlet weak var lblServiceCount: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var imgVwBusiness: UIImageView!
    @IBOutlet weak var lblSince: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgVwBronze: UIImageView!
    @IBOutlet weak var imgVwVerifyTick: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var vwCategory: UIView!
    @IBOutlet weak var vwOffer: UIView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var vwOpeningHour: UIView!
    @IBOutlet weak var vwReviews: UIView!
    
    //MARK: - variables
    var arrReviews = [Reviewwe]()
    var isLabelExpanded = false
    var businessUserProfile:[UserProfiles]?
    var openingHour:[OpeningHourr]?
    var viewModelBusiness = BusinessProfileVM()
    var getBusinessUserDetail:GetBusinessUserDetail?
    var obj = [BusinessTimingModel]()
    var totalHeight = 0
    var arrGetServices = [Service]()
    let refreshControl = UIRefreshControl()
    var isComing = false
    var businessId:String?
    var textAbout = ""
    var arrFeature = [String]()
    var arrDeals = [businessDeals]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    override func viewWillLayoutSubviews() {
        self.heightTblVwReview.constant = self.tblVwReviews.contentSize.height+20
    }
    private func uiSet(){
        print(Store.authKey ?? "")
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        obj.insert(BusinessTimingModel(day: "Monday",starttime: "",endtime: "",status: "0"), at: 0)
        obj.insert(BusinessTimingModel(day: "Tuesday",starttime: "",endtime: "",status: "0"), at: 1)
        obj.insert(BusinessTimingModel(day: "Wednesday",starttime: "",endtime: "",status: "0"), at: 2)
        obj.insert(BusinessTimingModel(day: "Thursday",starttime: "",endtime: "",status: "0"), at: 3)
        obj.insert(BusinessTimingModel(day: "Friday",starttime: "",endtime: "",status: "0"), at: 4)
        obj.insert(BusinessTimingModel(day: "Saturday",starttime: "",endtime: "",status: "0"), at: 5)
        obj.insert(BusinessTimingModel(day: "Sunday",starttime: "",endtime: "",status: "0"), at: 6)
        lblAbout.numberOfLines = 5
        
        let nib = UINib(nibName: "ReviewTVC", bundle: nil)
        tblVwReviews.register(nib, forCellReuseIdentifier: "ReviewTVC")
        let nib2 = UINib(nibName: "BusinessHourTVC", bundle: nil)
        tblVwHours.register(nib2, forCellReuseIdentifier: "BusinessHourTVC")
        let nibCollvw = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
        collVwCategory.register(nibCollvw, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        collVwOffer.register(nibCollvw, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        
        tblVwReviews.estimatedRowHeight = 120
        let alignedFlowLayoutCollVwInterst = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwCategory.collectionViewLayout = alignedFlowLayoutCollVwInterst
        
        if let flowLayout = collVwCategory.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 36)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            
        }
        if isComing == true{
            btnEdit.isHidden = false
            
            getBusinessUserProfileApiFromBusinessSide(loader: true)
            
        }else{
            btnEdit.isHidden = true
            getBusinessUserProfileFromUserSide(loader: true, businessId: businessId ?? "")
            
        }
        addTapGestureToLabel()
    }
    private func getBusinessUserProfileApiFromBusinessSide(loader:Bool){
        
        viewModelBusiness.GetBusinessUserProfile(id: "",loader: loader){ data in
            WebService.hideLoader()
            self.getBusinessUserDetail = data
            self.arrReviews = data?.reviews ?? []
            
            if data?.reviews?.count ?? 0 > 0{
                self.vwReviews.isHidden = false
            }else{
                self.vwReviews.isHidden = true
            }
            if data?.userProfile?.category == 1{
                if data?.userProfile?.typesOfCategoryDetails?.count ?? 0 > 0{
                    self.vwCategory.isHidden = false
                }else{
                    self.vwCategory.isHidden = true
                }
            }else{
                self.vwCategory.isHidden = true
            }
            
            if data?.userProfile?.businessDeals?.count ?? 0 > 0{
                self.vwOffer.isHidden = false
                self.arrDeals = data?.userProfile?.businessDeals ?? []
                self.heightOfferCollVw.constant = CGFloat(((data?.userProfile?.businessDeals?.count ?? 0)*53))
                self.collVwOffer.reloadData()
            }else{
                self.vwOffer.isHidden = true
            }
            if data?.userProfile?.isVerified == true{
                self.imgVwVerifyTick.isHidden = false
            }else{
                self.imgVwVerifyTick.isHidden = true
            }
            
            if data?.UserRating ?? 0 > 3{
                self.imgVwBronze.isHidden = false
            }else{
                self.imgVwBronze.isHidden = true
            }
            self.lblTaskCount.text = "\(data?.gigCount ?? 0)"
            self.lblServiceCount.text = "\(data?.serviceCount ?? 0)"
            self.arrGetServices = data?.userProfile?.services ?? []
            self.arrFeature = data?.userProfile?.typesOfCategoryDetails ?? []
            self.lblName.text = data?.userProfile?.name ?? ""
            self.lblBusinessName.text = data?.userProfile?.businessname ?? ""
            if data?.userProfile?.category == 1{
                self.lblCategory.text = "Restaurants"
            }else if data?.userProfile?.category == 2{
                self.lblCategory.text = "Clothing/fashion"
            }else if data?.userProfile?.category == 3{
                self.lblCategory.text = "Tech/electronics"
            }else if data?.userProfile?.category == 4{
                self.lblCategory.text = "Grocery"
            }else if data?.userProfile?.category == 5{
                self.lblCategory.text = "Fitness"
            }else if data?.userProfile?.category == 6{
                self.lblCategory.text = "Entertainment"
            }else{
                self.lblCategory.text = "Other"
            }
            //            self.lblAbout.text = data?.userProfile?.about ?? ""
            let formattedDate = self.convertDateFormat(inputDate: data?.userProfile?.dob ?? "")
            self.lblSince.text = "Since \(formattedDate)"
            self.textAbout = data?.userProfile?.about ?? ""
            self.lblAbout.numberOfLines = 2
            self.lblAbout.appendReadmore(after: self.textAbout, trailingContent: .readmore)
            self.lblAbout.sizeToFit()
            self.lblAddress.text = data?.userProfile?.place ?? ""
            Store.BusinessUserDetail = ["userName":data?.userProfile?.name ?? "",
                                        "profileImage":data?.userProfile?.profilePhoto ?? "","userId":data?.userProfile?.id ?? "","mobile":data?.userProfile?.mobile ?? 0]
            NotificationCenter.default.post(name: Notification.Name("UpdateUserName"), object: nil)
            let rating = data?.UserRating ?? 0.0
            let formattedRating = String(format: "%.1f", rating)
            if data?.reviews?.count ?? 0 > 1{
                self.lblReviewCount.text = "\(formattedRating) (\(data?.reviews?.count ?? 0) Reviews)"
            }else{
                self.lblReviewCount.text = "\(formattedRating) (\(data?.reviews?.count ?? 0) Review)"
            }
            let dateString = data?.userProfile?.dob ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = "MMM-dd-yyyy"
                let newDateString = dateFormatter.string(from: date)
            }
            self.imgVwProfile.imageLoad(imageUrl: data?.userProfile?.profilePhoto ?? "")
            
            
            let dayIndices: [String: Int] = [
                "Monday": 0, "Tuesday": 1, "Wednesday": 2,
                "Thursday": 3, "Friday": 4, "Saturday": 5, "Sunday": 6
            ]
            
            for i in data?.userProfile?.openingHours ?? [] {
                if let index = dayIndices[i.day ?? ""] {
                    self.obj[index] = BusinessTimingModel(day: i.day ?? "", starttime: i.starttime ?? "", endtime: i.endtime ?? "", status: "1")
                }
            }
            self.tblVwHours.reloadData()
            self.collVwCategory.reloadData()
            self.tblVwReviews.reloadData()
            self.tblVwReviews.invalidateIntrinsicContentSize()
            self.updateheightCollVw()
        }
    }
    private func getBusinessUserProfileFromUserSide(loader:Bool,businessId:String){
        viewModelBusiness.GetBusinessUserProfile(id: businessId,loader: loader){ data in
            WebService.hideLoader()
            self.getBusinessUserDetail = data
            self.arrReviews = data?.reviews ?? []
            
            if data?.reviews?.count ?? 0 > 0{
                self.vwReviews.isHidden = false
            }else{
                self.vwReviews.isHidden = true
            }
            if data?.userProfile?.category == 1{
                if data?.userProfile?.typesOfCategoryDetails?.count ?? 0 > 0{
                    self.vwCategory.isHidden = false
                }else{
                    self.vwCategory.isHidden = true
                }
            }else{
                self.vwCategory.isHidden = true
            }
            if data?.userProfile?.deals?.count ?? 0 > 0{
                self.vwOffer.isHidden = false
            }else{
                self.vwOffer.isHidden = true
            }
            if data?.userProfile?.category == 1{
                self.lblCategory.text = "Restaurants"
            }else if data?.userProfile?.category == 2{
                self.lblCategory.text = "Clothing/fashion"
            }else if data?.userProfile?.category == 3{
                self.lblCategory.text = "Tech/electronics"
            }else if data?.userProfile?.category == 4{
                self.lblCategory.text = "Grocery"
            }else if data?.userProfile?.category == 5{
                self.lblCategory.text = "Fitness"
            }else if data?.userProfile?.category == 6{
                self.lblCategory.text = "Entertainment"
            }else{
                self.lblCategory.text = "Other"
            }
            self.lblTaskCount.text = "\(data?.gigCount ?? 0)"
            self.lblServiceCount.text = "\(data?.serviceCount ?? 0)"
            self.arrGetServices = data?.userProfile?.services ?? []
            self.arrFeature = data?.userProfile?.typesOfCategoryDetails ?? []
            self.lblName.text = data?.userProfile?.name ?? ""
            self.lblBusinessName.text = data?.userProfile?.businessname ?? ""
            self.lblAbout.text = data?.userProfile?.about ?? ""
            self.lblAddress.text = data?.userProfile?.place ?? ""
            Store.BusinessUserDetail = ["userName":data?.userProfile?.name ?? "",
                                        "profileImage":data?.userProfile?.profilePhoto ?? "","mobile":data?.userProfile?.mobile ?? 0]
            NotificationCenter.default.post(name: Notification.Name("UpdateUserName"), object: nil)
            let rating = data?.UserRating ?? 0.0
            let formattedRating = String(format: "%.1f", rating)
            if data?.reviews?.count ?? 0 > 1{
                self.lblReviewCount.text = "\(formattedRating) (\(data?.reviews?.count ?? 0) Reviews)"
            }else{
                self.lblReviewCount.text = "\(formattedRating) (\(data?.reviews?.count ?? 0) Review)"
            }
            
            let date = data?.userProfile?.dob ?? ""
            let formattedDate = self.convertDateFormat(inputDate: data?.userProfile?.dob ?? "")
            self.lblSince.text = "Since \(formattedDate)"
            //            self.lblDateOfBirth.text = dob
            self.imgVwProfile.imageLoad(imageUrl: data?.userProfile?.profilePhoto ?? "")
            
            
            for i in data?.userProfile?.openingHours ?? []{
                if i.day == "Monday"{
                    self.obj.remove(at: 0)
                    self.obj.insert(BusinessTimingModel(day: i.day ?? "",starttime: i.starttime ?? "",endtime: i.endtime ?? "",status: "1"), at: 0)
                }else if i.day == "Tuesday"{
                    self.obj.remove(at: 1)
                    self.obj.insert(BusinessTimingModel(day: i.day ?? "",starttime: i.starttime ?? "",endtime: i.endtime ?? "",status: "1"), at: 1)
                }else if i.day == "Wednesday"{
                    self.obj.remove(at: 2)
                    self.obj.insert(BusinessTimingModel(day: i.day ?? "",starttime: i.starttime ?? "",endtime: i.endtime ?? "",status: "1"), at: 2)
                }else if i.day == "Thursday"{
                    self.obj.remove(at: 3)
                    self.obj.insert(BusinessTimingModel(day: i.day ?? "",starttime: i.starttime ?? "",endtime: i.endtime ?? "",status: "1"), at: 3)
                }else if i.day == "Friday"{
                    self.obj.remove(at: 4)
                    self.obj.insert(BusinessTimingModel(day: i.day ?? "",starttime: i.starttime ?? "",endtime: i.endtime ?? "",status: "1"), at: 4)
                }else if i.day == "Saturday"{
                    self.obj.remove(at: 5)
                    self.obj.insert(BusinessTimingModel(day: i.day ?? "",starttime: i.starttime ?? "",endtime: i.endtime ?? "",status: "1"), at: 5)
                }else{
                    self.obj.remove(at: 6)
                    self.obj.insert(BusinessTimingModel(day: i.day ?? "",starttime: i.starttime ?? "",endtime: i.endtime ?? "",status: "1"), at: 6)
                }
                
                self.tblVwHours.reloadData()
            }
            
            self.collVwCategory.reloadData()
            self.tblVwReviews.reloadData()
            self.tblVwReviews.invalidateIntrinsicContentSize()
            self.updateheightCollVw()
        }
    }
    
    
    @objc func handleSwipe() {
        navigationController?.popViewController(animated: true)
    }
    
    private func convertDateFormat(inputDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM yyyy"
            return outputFormatter.string(from: date)
        }
        
        return "Invalid Date"
    }
    
    private func addTapGestureToLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblAbout.isUserInteractionEnabled = true
        lblAbout.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let text = lblAbout.text else { return }
        
        let readmore = (text as NSString).range(of: TrailingContent.readmore.text)
        let readless = (text as NSString).range(of: TrailingContent.readless.text)
        if gesture.didTap(label: lblAbout, inRange: readmore) {
            lblAbout.appendReadLess(after: textAbout, trailingContent: .readless)
        } else if  gesture.didTap(label: lblAbout, inRange: readless) {
            lblAbout.appendReadmore(after: textAbout, trailingContent: .readmore)
        } else { return }
    }
    
    @IBAction func actionEdit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditBusinessProfileVC") as! EditBusinessProfileVC
        vc.getBusinessUserDetail = getBusinessUserDetail
        vc.obj = obj
        vc.arrGetServices = arrGetServices
        vc.callBack = {[weak self] in
            guard let self = self else { return }
            self.getBusinessUserProfileApiFromBusinessSide(loader: false)
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        //        if isComing == true{
        //            SceneDelegate().tabBarProfileRoot()
        //        }else{
        self.navigationController?.popViewController(animated: true)
        //        }
    }
    
    @IBAction func actionServices(_ sender: UIButton) {
        if isComing == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyServicesVC") as! MyServicesVC
            vc.isSelect = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionGigs(_ sender: UIButton) {
        if isComing == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigListVC") as! GigListVC
            vc.isComing = 2
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionPopups(_ sender: UIButton) {
        if isComing == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpListVC") as! PopUpListVC
            vc.isComing = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: -UITableViewDelegate
extension BusinessProfileVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwHours{
            return  obj.count
        }else{
            return arrReviews.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwHours {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessHourTVC", for: indexPath) as! BusinessHourTVC
            
            let day = obj[indexPath.row].day
            cell.lblday.text = day.capitalized
            
            
            if obj[indexPath.row].status == "1"{
                let startTime24 = obj[indexPath.row].starttime
                let endTime24 = obj[indexPath.row].endtime
                
                let startTime12 = convertTo12HourFormat(timeString: startTime24)
                let endTime12 = convertTo12HourFormat(timeString: endTime24)
                cell.lblTime.text = "\(startTime12 ?? "") - \(endTime12 ?? "")"
                cell.lblTime.textColor = UIColor( red: 91 / 255.0,green: 91 / 255.0,blue: 91 / 255.0,alpha: 1.0)
            }else{
                cell.lblTime.text = "Closed"
                cell.lblTime.textColor = UIColor( red: CGFloat(0xFF) / 255.0,green: CGFloat(0x3B) / 255.0,blue: CGFloat(0x3B) / 255.0,alpha: 1.0)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTVC", for: indexPath) as! ReviewTVC
            
            cell.lblName.text = arrReviews[indexPath.row].userID?.name ?? ""
            cell.lblDescription.text = arrReviews[indexPath.row].comment ?? ""
            
            cell.ratingView.rating = Double(arrReviews[indexPath.row].starCount ?? 0)
            cell.imgVwUser.imageLoad(imageUrl: arrReviews[indexPath.row].userID?.profilePhoto ?? "")
            cell.lblDescription.sizeToFit()
            if arrReviews[indexPath.row].media == "" || arrReviews[indexPath.row].media == nil{
                cell.heightImgVw.constant = 0
                totalHeight += 115 + Int(cell.lblDescription.frame.height)
            }else{
                cell.heightImgVw.constant = 150
                totalHeight += 250 + Int(cell.lblDescription.frame.height)
                cell.imgVwReview.imageLoad(imageUrl: arrReviews[indexPath.row].media ?? "")
            }
            heightTblVwReview.constant = CGFloat(totalHeight)
            let createdAt = arrReviews[indexPath.row].createdAt ?? ""
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
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVwHours{
            return  35
        }else{
            return  UITableView.automaticDimension
        }
        
        
    }
    
    
}
//MARK: - UICollectionViewDelegate
extension BusinessProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwCategory{
            if arrFeature.count > 0{
                return arrFeature.count
            }else{
                return 0
            }
        }else{
            if arrDeals.count > 0{
                return arrDeals.count
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwCategory{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            
            cell.lblName.text = arrFeature[indexPath.row]
            cell.vwBg.backgroundColor = UIColor(hex: "#E6F2E5")
            cell.vwBg.layer.cornerRadius = 20
            cell.widthBtnCross.constant = 0
            cell.lblName.textColor = .black
            cell.vwBg.layer.cornerRadius = 4
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            cell.lblName.text = arrDeals[indexPath.row].title ?? ""
            cell.btnCross.isHidden = true
            cell.vwBg.backgroundColor = UIColor(hex: "#e7f3e6")
            cell.lblName.textColor = .black
            cell.vwBg.layer.cornerRadius = 5
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwOffer{
            return CGSizeMake(collVwOffer.frame.width, 48)
        }
        return CGSize(width: 0, height: 0)
    }
    func updateheightCollVw() {
        
        let rowsSpeciliz = ceil(CGFloat(arrFeature.count) / 3.0)
        let newHeightSpeciliz = rowsSpeciliz * 36 + max(0, rowsSpeciliz - 1) * 8
        heightCategoryCollVw.constant = newHeightSpeciliz
        
    }
    
}
extension BusinessProfileVC {
     func convertTo12HourFormat(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"  // 24-hour format (HH)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure proper locale
        
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "h:mm a" // 12-hour format with AM/PM
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
