//
//  PopUpOwnerVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 20/01/25.
//

import UIKit

class PopUpOwnerVC: UIViewController {
    
    @IBOutlet var btnOpenCloseStore: UIButton!
    @IBOutlet var heightTblVwProducts: NSLayoutConstraint!
    @IBOutlet var tblVwProducts: UITableView!
    @IBOutlet weak var vwOpenClose: UIView!
    @IBOutlet weak var topReviewVw: NSLayoutConstraint!
    @IBOutlet weak var topStackVw: NSLayoutConstraint!
    @IBOutlet weak var heightStackVw: NSLayoutConstraint!
    @IBOutlet weak var lblPopupTime: UILabel!
    @IBOutlet weak var vwUserCount: UIView!
    @IBOutlet weak var lblDataFound: UILabel!
    @IBOutlet weak var heightTblVw: NSLayoutConstraint!
    @IBOutlet weak var heightDescriptionVw: NSLayoutConstraint!
    @IBOutlet weak var lblParticipants: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblDateFound: UILabel!
    @IBOutlet weak var btnAddReview: UIButton!
    @IBOutlet weak var lblPeopleView: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var heightCollVw: NSLayoutConstraint!
    @IBOutlet weak var vwDetail: UIView!
    @IBOutlet weak var vwOffer: UIView!
    @IBOutlet weak var tblVwReview: CustomTableView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var collVwImages: UICollectionView!
    @IBOutlet weak var vwDescription: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblUserCount: UILabel!
    @IBOutlet weak var vwReview: UIView!
    @IBOutlet weak var imgVwCategory4: UIImageView!
    @IBOutlet weak var imgVwCategory3: UIImageView!
    @IBOutlet weak var imgVwCategory2: UIImageView!
    @IBOutlet weak var imgVwCategory1: UIImageView!
    @IBOutlet weak var imgVwTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVwPopup: UIImageView!
    
    var popupId:String?
    var viewModel = PopUpVM()
    private var fullText = ""
    private var isExpanded = false
    var popupDetails:PopupDetailData?
    var callBack:(()->())?
    var arrReview = [PopUpReview]()
    private var heightDescription = 0
    private var reviewHeight = 0
    var arrProducts = [AddProducts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSet()
    }
    func uiSet() {
        // Existing UI setup code
        getPopUpDetailApi()
        vwDescription.layer.shadowColor = UIColor.black.cgColor
        vwDescription.layer.shadowOpacity = 0.2
        vwDescription.layer.shadowOffset = CGSize(width: 4, height: 4)
        vwDescription.layer.shadowRadius = 4
        vwDescription.layer.masksToBounds = false

        vwOffer.layer.shadowColor = UIColor.black.cgColor
        vwOffer.layer.shadowOpacity = 0.2
        vwOffer.layer.shadowOffset = CGSize(width: 4, height: 4)
        vwOffer.layer.shadowRadius = 4
        vwOffer.layer.masksToBounds = false

        vwDetail.layer.shadowColor = UIColor.black.cgColor
        vwDetail.layer.shadowOpacity = 0.2
        vwDetail.layer.shadowOffset = CGSize(width: 4, height: 4)
        vwDetail.layer.shadowRadius = 4
        vwDetail.layer.masksToBounds = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDescription))
        lblDescription.addGestureRecognizer(tapGesture)
       
      
    }
    
    override func viewWillLayoutSubviews() {
        self.heightTblVw.constant = self.tblVwReview.contentSize.height+10
      
    }
    
    @objc private func toggleDescription() {
        isExpanded.toggle()
        if lblDescription.text?.contains("Read More") ?? false || lblDescription.text?.contains("Read Less") ?? false{
            if isExpanded {
                lblDescription.appendReadLess(after: fullText, trailingContent: .readless)
            } else {
                lblDescription.appendReadmore(after: fullText, trailingContent: .readmore)
            }
            
            // Update the label's frame and constraint
            lblDescription.sizeToFit()
            
            // Calculate the new height based on the label's content size
            let updatedHeight = lblDescription.intrinsicContentSize.height
            heightDescriptionVw.constant = updatedHeight + 30 // Adjust the extra padding as needed
            
            // Force layout updates
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
          }
       
    }
    
    func getPopUpDetailApi(){
        let nib = UINib(nibName: "AddedProductListTVC", bundle: nil)
        tblVwProducts.register(nib, forCellReuseIdentifier: "AddedProductListTVC")

        let nibNearBy = UINib(nibName: "ReviewTVC", bundle: nil)
        tblVwReview.register(nibNearBy, forCellReuseIdentifier: "ReviewTVC")
        viewModel.getPopupDetailApi(loader: true, popupId: popupId ?? "") { data in
            self.popupDetails = data
            self.btnOpenCloseStore.isHidden = false
            if data?.isClosed == true{
                self.vwOpenClose.isHidden = false
                self.btnOpenCloseStore.isSelected = false
            }else{
                self.vwOpenClose.isHidden = true
                self.btnOpenCloseStore.isSelected = true
            }
            if data?.popupStatus == "upcoming"{
               
                self.heightStackVw.constant = 50
                self.topStackVw.constant = 30
                self.topReviewVw.constant = 20

            }else{
                self.heightStackVw.constant = 0
                self.topStackVw.constant = 0
                self.topReviewVw.constant = 0
            }
            if (data?.endSoon ?? false){
                self.imgVwTitle.image = UIImage(named: "redApprove")
            }else{
                self.imgVwTitle.image = UIImage(named: "greenApprove")
            }
            self.lblTitle.text = data?.name ?? ""
            self.imgVwPopup.imageLoad(imageUrl: data?.businessLogo ?? "")
            self.lblParticipants.text = "\(data?.Requests ?? 0)/\(data?.availability ?? 0) participants"
            self.lblUserCount.text = "\(data?.Requests ?? 0)"
            if data?.Requests == 0{
                self.vwUserCount.isHidden = true
            }else{
                self.vwUserCount.isHidden = false
            }
            
            self.lblPeopleView.text = "\(data?.hitCount ?? 0) people viewed this pop-up"
          
            if data?.deals == ""{
                self.vwOffer.isHidden = true
            }else{
                self.vwOffer.isHidden = false
                self.lblOffer.text = data?.deals ?? ""
            }
            self.lblAddress.text = data?.place ?? ""
            let startTime = self.convertUpdateDateString(data?.startDate ?? "")
            let endTime = self.convertUpdateDateString(data?.endDate ?? "")
            self.lblTime.text = "\(startTime ?? "") - \(endTime ?? "")"
            let startDate = data?.startDate ?? ""
            let endDate = data?.endDate ?? ""
            self.lblPopupTime.text = "\(self.convertUpdateDateString(startDate, outputFormat: "MMM,dd.yyyy") ?? "Invalid Date") - \(self.convertUpdateDateString(endDate, outputFormat: "MMM,dd.yyyy") ?? "Invalid Date")"
            self.fullText = data?.description ?? ""
            
            self.lblDescription.appendReadmore(after: self.fullText, trailingContent: .readmore)
            self.lblDescription.sizeToFit()
            self.lblDescription.layoutIfNeeded()
            self.heightDescriptionVw.constant = self.lblDescription.frame.height+35
            print("Height----",self.heightDescriptionVw.constant)
            self.heightCollVw.constant = 0
//            if self.popupDetails?.productImages?.count == 0{
//                self.heightCollVw.constant = 0
//            }else if (self.popupDetails?.productImages?.count == 1) || (self.popupDetails?.productImages?.count == 2){
//                self.heightCollVw.constant = 100
//            }else if (self.popupDetails?.productImages?.count == 3) || (self.popupDetails?.productImages?.count == 4){
//                self.heightCollVw.constant = 200
//            }else{
//                self.heightCollVw.constant = 300
//            }
            if data?.categoryType == 1{
                self.lblCategory.text = "Food & Drinks"
                self.imgVwCategory1.image = UIImage(named: "category1")
                self.imgVwCategory2.image = UIImage(named: "category2")
                self.imgVwCategory3.image = UIImage(named: "category3")
                self.imgVwCategory4.image = UIImage(named: "category4")
            }else if data?.categoryType == 2{
                self.lblCategory.text = "Services"
                self.imgVwCategory1.image = UIImage(named: "category5")
                self.imgVwCategory2.image = UIImage(named: "category6")
                self.imgVwCategory3.image = UIImage(named: "category7")
                self.imgVwCategory4.image = UIImage(named: "category8")
            }else if data?.categoryType == 3{
                self.lblCategory.text = "Clothes / Fashion"
                self.imgVwCategory1.image = UIImage(named: "category9")
                self.imgVwCategory2.image = UIImage(named: "category10")
                self.imgVwCategory3.image = UIImage(named: "category11")
                self.imgVwCategory4.image = UIImage(named: "category12")
            }else if data?.categoryType == 4{
                self.lblCategory.text = "Beauty / Self-Care"
                self.imgVwCategory1.image = UIImage(named: "category13")
                self.imgVwCategory2.image = UIImage(named: "category14")
                self.imgVwCategory3.image = UIImage(named: "category15")
                self.imgVwCategory4.image = UIImage(named: "category16")
            }else{
                self.lblCategory.text = "Low Key"
                self.imgVwCategory1.image = UIImage(named: "category17")
                self.imgVwCategory2.image = UIImage(named: "category18")
                self.imgVwCategory3.image = UIImage(named: "category19")
                self.imgVwCategory4.image = UIImage(named: "category20")
            }
            self.arrReview = data?.reviews ?? []
            if data?.reviews?.count ?? 0 > 0{
                self.lblDataFound.isHidden = true
                self.vwReview.isHidden = false
            }else{
                self.lblDataFound.isHidden = true
                self.vwReview.isHidden = true
            }
            self.arrProducts = data?.addProducts ?? []
            self.heightTblVwProducts.constant = CGFloat(self.arrProducts.count*95)
            self.tblVwProducts.reloadData()
            self.tblVwReview.reloadData()
            self.collVwImages.reloadData()
        }
    }
   
    func convertUpdateDateString(_ dateString: String, outputFormat: String = "h:mm a") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Define the possible date formats dynamically
        let possibleFormats: [String] = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",  // With milliseconds
            "yyyy-MM-dd'T'HH:mm:ssZ"       // Without milliseconds
        ]

        for format in possibleFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                // Format the parsed date into the desired output format
                dateFormatter.dateFormat = outputFormat
                return dateFormatter.string(from: date)
            }
        }
        
        return nil
    }
    @IBAction func actionDelete(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelGigVC") as! CancelGigVC
        vc.isSelect = 2
        vc.popupId = self.popupDetails?.id ?? ""
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack  = { message in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 10
                vc.message = message
                vc.callBack = {[weak self] in
                    guard let self = self else { return }
                    self.navigationController?.popViewController(animated: true)
                    self.callBack?()
                }
                self.navigationController?.present(vc, animated: false)
        }
        self.navigationController?.present(vc, animated: false)
    }
    
    @IBAction func actionEdit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPopUpVC") as! AddPopUpVC
        vc.isComing = true
        vc.popupDetails = self.popupDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAddReview(_ sender: UIButton) {
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionUserList(_ sender: UIButton) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserParticipantsListVC") as! UserParticipantsListVC
                vc.isComing = 1
                vc.popupId = popupDetails?.id ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionOpenClose(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            vwOpenClose.isHidden = false
            openCloseStoreApi(isOpen: false)
        }else{
            vwOpenClose.isHidden = true
            openCloseStoreApi(isOpen: true)
        }
    }
    private func openCloseStoreApi(isOpen:Bool){
        viewModel.openCloseStoreApi(popUpId: popupDetails?.id ?? "", status: isOpen) { message in
            self.uiSet()
        }
    }
}

extension PopUpOwnerVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popupDetails?.productImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopuppImagesCVC", for: indexPath) as! PopuppImagesCVC
        let data = popupDetails?.productImages?[indexPath.row]
        cell.imgVwPopup.imageLoad(imageUrl: data ?? "")
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collVwImages.frame.width/2-5, height: 90)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension PopUpOwnerVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwProducts{
            return arrProducts.count
        }else{
            return arrReview.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwProducts{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddedProductListTVC", for: indexPath) as! AddedProductListTVC
            if arrProducts[indexPath.row].isHide ?? false{
                cell.viewForHIdeOrNot.isHidden = false
            }else{
                cell.viewForHIdeOrNot.isHidden = true
            }
            cell.imgVwProduct.imageLoad(imageUrl: arrProducts[indexPath.row].image?.first ?? "")
            cell.lblPrice.text = "$\(arrProducts[indexPath.row].price ?? 0)"
            cell.lblProductName.text = arrProducts[indexPath.row].productName ?? ""

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTVC", for: indexPath) as! ReviewTVC
            cell.imgVwUser.imageLoad(imageUrl: arrReview[indexPath.row].userId?.profilePhoto ?? "")
            cell.lblName.text = arrReview[indexPath.row].userId?.name ?? ""
            cell.lblDescription.text = arrReview[indexPath.row].comment ?? ""
            cell.lblDescription.sizeToFit()
            
            cell.ratingView.rating = Double(arrReview[indexPath.row].starCount ?? 0)
            heightDescription += Int(cell.lblDescription.frame.size.height)
            
            if arrReview[indexPath.row].media == "" || arrReview[indexPath.row].media == nil{
                cell.heightImgVw.constant = 0
                reviewHeight += Int(70 + CGFloat(self.heightDescription))
            }else{
                cell.heightImgVw.constant = 150
                reviewHeight += Int(220 + CGFloat(self.heightDescription))
                cell.imgVwReview.imageLoad(imageUrl: arrReview[indexPath.row].media ?? "")
            }
            
            let createdAt = arrReview[indexPath.row].updatedAt ?? ""
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
        if tableView == tblVwProducts{
            return 94
        }else{
            return UITableView.automaticDimension
        }
        
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
}
