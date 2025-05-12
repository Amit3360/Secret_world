//
//  ServiceDetailVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/01/24.
//

import UIKit
import FXExpandableLabel
import AlignedCollectionViewFlowLayout

class ServiceDetailVC: UIViewController,UIGestureRecognizerDelegate{
  
    @IBOutlet var lblReviewTitleOnly: UILabel!
    @IBOutlet weak var btnThreeDot: UIButton!
    @IBOutlet weak var vwImages: UIView!
    @IBOutlet weak var vwAddReview: UIView!
    @IBOutlet weak var lblDataFound: UILabel!
    @IBOutlet weak var widthImagesVw: NSLayoutConstraint!
    @IBOutlet weak var heightTblVwReview: NSLayoutConstraint!
    @IBOutlet weak var tblVwReview: CustomTableView!
    @IBOutlet weak var btnAddReview: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVwOwner: UIImageView!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var heightCollVwCategory: NSLayoutConstraint!
    @IBOutlet weak var collVwCategory: UICollectionView!
    @IBOutlet weak var vwAbout: UIView!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var collVwServiceImages: UICollectionView!
    @IBOutlet weak var lblServiceRating: UILabel!
    @IBOutlet weak var vwOwner: UIView!
    @IBOutlet weak var imgVwService: UIImageView!
    
    var isLabelExpanded = false
    var viewModel = AddServiceVM()
    var serviceId = String()
    var arrServiceDetail:Servicess?
    var arrImgs = [String]()
    var arrReview = [ReviewService]()
    var userServiceDetail:GetServiceDataaa?
    var businessServiceDetail:GetServiceDetailDataa?
    var heightDescription = 0
    var reviewHeight = 0
    var phoneNumber: Int?
    var providerId = ""
    var arrCategory = [Subcategoryz]()
    var callBack:((_ message:String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        let nibNearBy = UINib(nibName: "ReviewTVC", bundle: nil)
        tblVwReview.register(nibNearBy, forCellReuseIdentifier: "ReviewTVC")
        tblVwReview.estimatedRowHeight = 100
        uiSet()
        
    }
    @objc func handleSwipe() {
              navigationController?.popViewController(animated: true)
          }
    override func viewWillLayoutSubviews() {
        if self.arrReview.count > 0{
            self.heightTblVwReview.constant = self.tblVwReview.contentSize.height+10
        }else{
            self.heightTblVwReview.constant = 100
        }
    }
    func uiSet(){
        let nib = UINib(nibName: "ReviewTVC", bundle: nil)
        tblVwReview.register(nib, forCellReuseIdentifier: "ReviewTVC")
       
        let nibCollvw = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
        collVwCategory.register(nibCollvw, forCellWithReuseIdentifier: "BusinessCategoryCVC")
      
        let alignedFlowLayoutCollVwInterst = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwCategory.collectionViewLayout = alignedFlowLayoutCollVwInterst
        
        if let flowLayout = collVwCategory.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 36)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            
        }
        tblVwReview.estimatedRowHeight = 100
        tblVwReview.rowHeight = UITableView.automaticDimension
        if Store.role == "b_user"{
//            btnThreedot.isHidden = false
            vwOwner.isHidden = true
            vwAddReview.isHidden = true
            
        }else{
            vwAddReview.isHidden = false
//            btnThreedot.isHidden = true
            vwOwner.isHidden = false
        
            
        }
        getUserServiceDetailApi()
    }
    
    func getUserServiceDetailApi(){
        viewModel.GetServiceDetailUserSideApi(service_id: serviceId) { data in
            Store.ServiceId = self.serviceId
            self.arrCategory = data?.subcategories ?? []
            self.collVwCategory.reloadData()
            self.userServiceDetail = data
            self.arrReview = data?.reviews ?? []
                if self.arrReview.count > 0{
                    self.lblDataFound.isHidden = true
                    if Store.role == "b_user"{
                        self.lblReviewTitleOnly.isHidden = true
                    }
                }else{
                    self.lblDataFound.isHidden = false
                    if Store.role == "b_user"{
                        self.lblReviewTitleOnly.isHidden = false
                    }

                    
                }
            self.phoneNumber = data?.user?.mobile ?? 0
            if data?.serviceImages?.count ?? 0 > 0{
                self.imgVwService.imageLoad(imageUrl: data?.serviceImages?[0] ?? "")
                if self.widthImagesVw.constant < self.view.frame.width{
                    self.widthImagesVw.constant = CGFloat((data?.serviceImages?.count ?? 0)*54)+10
                }else{
                    self.widthImagesVw.constant = self.view.frame.width-40
                }
             
            }
            self.lblName.text = data?.user?.name ?? ""
            self.imgVwOwner.imageLoad(imageUrl: data?.user?.profilePhoto ?? "")
//            self.lblLocation.text = data?.user?.place ?? ""
            let rating = data?.rating ?? 0.0
            let formattedRating = String(format: "%.1f", rating)
            if data?.reviews?.count ?? 0 > 1{
                self.lblServiceRating.text = "\(formattedRating) (\(data?.reviews?.count ?? 0) Reviews)"
            }else{
                self.lblServiceRating.text = "\(formattedRating) (\(data?.reviews?.count ?? 0) Review)"
            }
            
            let price = Double(data?.actualPrice ?? 0)
            let roundedPrice = floor(price)
            self.lblDiscountPrice.text = String(format: "$%.1f", roundedPrice)

            self.lblDiscount.text = "\(Int(data?.discount ?? 0))% Off"
            self.lblPrice.text = "$\(data?.price ?? 0)"
            self.lblAbout.text = data?.description ?? ""
            if data?.serviceImages?.count ?? 0 > 0{
                self.arrImgs = data?.serviceImages ?? []
            
            }
            if Store.userId == data?.userID{
                self.btnThreeDot.isHidden = false
            }else{
                self.btnThreeDot.isHidden = true
            }
            self.collVwServiceImages.reloadData()
            self.tblVwReview.reloadData()
            self.tblVwReview.invalidateIntrinsicContentSize()
            self.updateCollectionViewHeight(for: self.collVwCategory, heightConstraint: self.heightCollVwCategory)
        }
    }
    private func updateCollectionViewHeight(for collectionView: UICollectionView, heightConstraint: NSLayoutConstraint) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height
            heightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }



    @IBAction func actionServiceProviderProfile(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileVC") as! BusinessProfileVC
        vc.businessId = Store.UserServiceDetailData?.getBusinessDetails?.id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionThreeDot(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServicesMoreOptionsVC") as! ServicesMoreOptionsVC
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = { isSelect in
            
            if isSelect == true{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditServiceVC") as! EditServiceVC
                vc.arrSelectSubCate = self.arrCategory
                vc.editServiceDetail = self.userServiceDetail
                vc.serviceId = self.userServiceDetail?.id ?? ""
                vc.callBack = {
                    self.uiSet()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelGigVC") as! CancelGigVC
                vc.isSelect = 1
                vc.modalPresentationStyle = .overFullScreen
                vc.callBack = { message in
                    self.navigationController?.popViewController(animated: true)
                    self.callBack?(message ?? "")
                }
                self.navigationController?.present(vc, animated: false)
            }
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAddReview(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewVC") as! AddReviewVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = 0
        vc.serviceDetail = userServiceDetail
        for (index, review) in arrReview.enumerated() {
            if Store.userId == review.user?.id ?? ""{
                vc.isUpdateReview = true
                vc.serviceReview = review
                break
            }
        }
        vc.callBack = {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterFeedbackPopUpVC") as! AfterFeedbackPopUpVC
            vc.modalPresentationStyle = .overFullScreen
            vc.callBack = {
                self.getUserServiceDetailApi()
            }
            self.navigationController?.present(vc, animated: false)
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionAllGallary(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GallaryImagesVC") as! GallaryImagesVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = false
        vc.arrServiceImgs = arrImgs
        vc.callBack = { index in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
            vc.index = index
            vc.arrImage = self.arrImgs
//            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionMessage(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
        vc.receiverId = Store.recevrID ?? ""
        vc.isAbout = true
        vc.chatType = "business"
        vc.typeId = Store.recevrID ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionCall(_ sender: UIButton) {
        let numberUrl = URL(string: "tel://\(phoneNumber ?? 0)")!
        if UIApplication.shared.canOpenURL(numberUrl) {
            UIApplication.shared.open(numberUrl)
        }
    }
    
}
//MARK: - UICollectionViewDelegate
extension ServiceDetailVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwServiceImages{
            return arrImgs.count
        }else{
            return arrCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwServiceImages{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GallaryImgsCVC", for: indexPath) as! GallaryImgsCVC
            cell.imgVwService.imageLoad(imageUrl: arrImgs[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            if arrCategory.count > 0{
                cell.lblName.text = arrCategory[indexPath.row].subcategoryName
            }
            cell.vwBg.layer.cornerRadius = 20
            cell.widthBtnCross.constant = 0
            cell.lblName.textColor = .black
            cell.vwBg.backgroundColor = UIColor(hex: "#e7f3e6")
            cell.vwBg.layer.cornerRadius = 4
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwServiceImages{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
            vc.arrImage = self.arrImgs
//            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
    }
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePhotoVC") as! ChangePhotoVC
    //        vc.isComing = 7
    //        vc.img = arrImgs[indexPath.row]
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwServiceImages{
            return CGSize(width: 44, height: 44)
        }else{
            return CGSize(width: 0, height: 30)
        }
    }
}
//MARK: -UITableViewDelegate
extension ServiceDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTVC", for: indexPath) as! ReviewTVC
        
        cell.imgVwUser.imageLoad(imageUrl: arrReview[indexPath.row].user?.profilePhoto ?? "")
        cell.lblName.text = arrReview[indexPath.row].user?.name ?? ""
        cell.lblDescription.text = arrReview[indexPath.row].comment ?? ""
        cell.ratingView.rating = arrReview[indexPath.row].starCount ?? 0.0
      
        cell.lblDescription.sizeToFit()
        heightDescription += Int(cell.lblDescription.frame.size.height)
        let createdAt = arrReview[indexPath.row].createdAt ?? ""
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
        if arrReview[indexPath.row].media == "" || arrReview[indexPath.row].media == nil{
            cell.heightImgVw.constant = 0
            reviewHeight += Int(70 + CGFloat(self.heightDescription))
        }else{
            cell.heightImgVw.constant = 150
            reviewHeight += Int(220 + CGFloat(self.heightDescription))
            cell.imgVwReview.imageLoad(imageUrl: arrReview[indexPath.row].media ?? "")
        }
        
        return cell
    }
    
   
}
