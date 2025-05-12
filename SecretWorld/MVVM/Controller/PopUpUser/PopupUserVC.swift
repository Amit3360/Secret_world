//
//  PopupUserVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 20/01/25.
//

import UIKit

class PopupUserVC: UIViewController {
    
    @IBOutlet weak var lblOpenDays: UILabel!
    @IBOutlet weak var vwOpenPopup: UIView!
    @IBOutlet weak var vwPopupDate: UIView!
    @IBOutlet weak var heightItemsList: NSLayoutConstraint!
    @IBOutlet weak var tblVwItemsList: UITableView!
    @IBOutlet weak var vwItemsList: UIView!
    @IBOutlet weak var vwItemsHeader: UIView!
    @IBOutlet weak var lblItemTotal: UILabel!
    @IBOutlet weak var heightSelectedItem: NSLayoutConstraint!
    @IBOutlet weak var tblVwSelectedItem: UITableView!
    @IBOutlet weak var vwSelectedItem: UIView!
    @IBOutlet var btnProductOnOff: UIButton!
    @IBOutlet var heightTblVwProducts: NSLayoutConstraint!
    @IBOutlet var tblVwProducts: UITableView!
    @IBOutlet weak var vwOffer: UIView!
    @IBOutlet weak var lblPopupTime: UILabel!
    @IBOutlet weak var heightReviewTitle: NSLayoutConstraint!
    @IBOutlet weak var vwReview: UIView!
    @IBOutlet weak var btnSendRequest: UIButton!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var imgVwCategory4: UIImageView!
    @IBOutlet weak var imgVwCategory3: UIImageView!
    @IBOutlet weak var imgVwCategory2: UIImageView!
    @IBOutlet weak var imgVwCategory1: UIImageView!
    @IBOutlet weak var heightCollVwImg: NSLayoutConstraint!
    @IBOutlet weak var topImgCollVw: NSLayoutConstraint!
    @IBOutlet weak var widthReviewBtn: NSLayoutConstraint!
    @IBOutlet weak var heightTblVw: NSLayoutConstraint!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var imgVwPopUp: UIImageView!
    @IBOutlet weak var imgVwFill: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDataFound: UILabel!
    @IBOutlet weak var tblVwReview: CustomTableView!
    @IBOutlet weak var btnAddReview: UIButton!
    @IBOutlet weak var lblViewPopUp: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var collVwImages: UICollectionView!
    @IBOutlet weak var lblDescription: UILabel!
    
    var popupId:String?
    var arrReview = [PopUpReview]()
    private var popupDetailData:PopupDetailData?
    var viewModel = PopUpVM()
    private var fullText = ""
    private var isExpanded = false
    private var arrImages = [String]()
    private var heightDescription = 0
    private var reviewHeight = 0
    private var isReviewed = false
    var callBack:(()->())?
    var status:Int?
    var providerId = ""
    var popUpLat:Double = 0
    var popUpLong:Double = 0
    var currentSelectedIndex = 0
    var noOfCards = 3
    var popupName = ""
    var arrProducts = [AddProducts]()
    var arrItems = [AddItems]()
    var groupedItems = [String: [AddItems]]()
    var sortedCategories = [String]()
    var viewModelItem = ItemsVM()
    var selectedItems = [AddItems]()
    var soldCount: Int = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "AddedProductListTVC", bundle: nil)
        tblVwProducts.register(nib, forCellReuseIdentifier: "AddedProductListTVC")
        let nibHeader = UINib(nibName: "ItemHeaderTVC", bundle: nil)
        tblVwItemsList.register(nibHeader, forCellReuseIdentifier: "ItemHeaderTVC")
        tblVwProducts.register(nibHeader, forCellReuseIdentifier: "ItemHeaderTVC")
        tblVwSelectedItem.register(nibHeader, forCellReuseIdentifier: "ItemHeaderTVC")
        let nibItems = UINib(nibName: "ItemCategoryTVC", bundle: nil)
        tblVwItemsList.register(nibItems, forCellReuseIdentifier: "ItemCategoryTVC")
        let nibSelectedItem = UINib(nibName: "SelectedItemTVC", bundle: nil)
        tblVwSelectedItem.register(nibSelectedItem, forCellReuseIdentifier: "SelectedItemTVC")
        getPopUpDetailApi()
    }
  
    override func viewWillLayoutSubviews() {
        self.heightTblVw.constant = self.tblVwReview.contentSize.height+10
       
            self.tblVwItemsList.reloadData()
            self.tblVwItemsList.layoutIfNeeded()
            self.heightItemsList.constant = self.tblVwItemsList.contentSize.height + 10
       
        
    }
    
    func getPopUpDetailApi(){
        print("Token",Store.authKey ?? "")
        vwOffer.backgroundColor = UIColor(hex: "#C7E2C4")
        let nibNearBy = UINib(nibName: "ReviewTVC", bundle: nil)
        tblVwReview.register(nibNearBy, forCellReuseIdentifier: "ReviewTVC")
        collVwImages.collectionViewLayout = CardsCollectionFlowLayout()
        viewModel.getPopupDetailApi(loader: true, popupId: popupId ?? "") { data in
            if data?.categoryType == 5{
                self.vwOffer.isHidden = true
                self.vwOpenPopup.isHidden = false
                self.vwPopupDate.isHidden = true
             
                self.vwItemsHeader.isHidden = false
                self.vwItemsList.isHidden = false
                self.arrItems = data?.addItems ?? []
                if data?.addItems?.count ?? 0 > 0{
                    self.heightItemsList.constant = CGFloat(self.arrItems.count*125)
                }else{
                    self.heightItemsList.constant = 0
                }
                self.groupItemsByCategory()
                DispatchQueue.main.asyncAfter(deadline: .now()+2.0){
                    self.tblVwItemsList.reloadData()
                    self.tblVwItemsList.layoutIfNeeded()
                    self.heightItemsList.constant = self.tblVwItemsList.contentSize.height + 10
                }
                if let rawArray = data?.closedDays,
                   let jsonString = rawArray.first, // Get the first (and only) string
                   let jsonData = jsonString.data(using: .utf8) {
                    
                    do {
                        let daysArray = try JSONDecoder().decode([String].self, from: jsonData)
                        let daysText = daysArray.joined(separator: ", ")
                        self.lblOpenDays.text = "Popup closed on: \(daysText)"
                    } catch {
                        print("Failed to decode days: \(error)")
                        self.lblOpenDays.text = "Popup Open all week"
                    }
                } else {
                    self.lblOpenDays.text = "Open all week"
                }
                for i in data?.addItems ?? [] {
                    if i.isSelected == true, !self.selectedItems.contains(where: { $0.id == i.id }) {
                        self.selectedItems.append(i)
                    }
                }
                DispatchQueue.main.asyncAfter(wallDeadline: .now()){
                    if self.selectedItems.count > 0{
                        self.vwSelectedItem.isHidden = false
                    }else{
                        self.vwSelectedItem.isHidden = true
                    }
                  
                    self.tblVwSelectedItem.reloadData()
                    self.heightSelectedItem.constant = CGFloat(self.selectedItems.count*128) + 25
                    let totalPrice = self.calculateTotalPrice()
                    self.lblItemTotal.text = "Total \(String(format: "$%.2f", totalPrice))"
                }
               
            }else{
                self.vwOpenPopup.isHidden = true
                self.vwPopupDate.isHidden = false
                self.vwSelectedItem.isHidden = true
                self.vwItemsHeader.isHidden = true
                self.vwItemsList.isHidden = true
                self.vwOffer.isHidden = false
                self.arrProducts = data?.addProducts ?? []
                self.tblVwProducts.reloadData()
                if data?.addProducts?.count ?? 0 > 0{
                    self.heightTblVwProducts.constant = CGFloat(self.arrProducts.count*94)
                }else{
                    self.heightTblVwProducts.constant = 0
                }
            }
          
         
            self.popupDetailData = data
            self.status = data?.status?.status
            self.providerId = data?.user?.id ?? ""
            self.lblTitle.text = data?.name ?? ""
            self.popupName = data?.name ?? ""
            self.imgVwPopUp.imageLoad(imageUrl: data?.businessLogo ?? "")
//            self.lblDescription.text = data?.description ?? ""
//            if data?.deals == ""{
//                self.vwOffer.isHidden = true
//            }else{
//                self.vwOffer.isHidden = false
//                self.lblOffer.text = data?.deals ?? ""
//            }
            
            self.lblLocation.text = data?.place ?? ""
            let startTime = self.convertUpdateDateString(data?.startDate ?? "")
            let endTime = self.convertUpdateDateString(data?.endDate ?? "")
            self.lblTime.text = "\(startTime ?? "") - \(endTime ?? "")"
            let startDate = data?.startDate ?? ""
            let endDate = data?.endDate ?? ""
            self.lblPopupTime.text = "\(self.convertUpdateDateString(startDate, outputFormat: "MMM,dd.yyyy") ?? "Invalid Date") - \(self.convertUpdateDateString(endDate, outputFormat: "MMM,dd.yyyy") ?? "Invalid Date")"
            self.lblRating.text = "\(data?.rating ?? 0)"
            self.fullText = data?.description ?? ""
            self.arrImages = data?.productImages ?? []
            self.lblViewPopUp.text = "\(data?.hitCount ?? 0) people viewed this pop-up"
            self.lblDescription.appendReadmore(after: self.fullText, trailingContent: .readmore)
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
            if (data?.endSoon ?? false){
                self.imgVwFill.image = UIImage(named: "redApprove")
            }else{
                self.imgVwFill.image = UIImage(named: "greenApprove")
            }
            self.arrReview = data?.reviews ?? []
            if data?.reviews?.count ?? 0 > 0{
                self.vwReview.isHidden = false
                
            }else{
                self.vwReview.isHidden = true
                self.heightTblVw.constant = 0
            }
            for i in data?.reviews ?? []{
                if i.userId?.id ?? "" == Store.userId{
                  
                    self.btnAddReview.setTitle("Update Reviews", for: .normal)
                    self.widthReviewBtn.constant = 115
                    self.isReviewed = true
                }else{
                    self.isReviewed = false
                    self.btnAddReview.setTitle("Add Reviews", for: .normal)
                    self.widthReviewBtn.constant = 100
                }
            }
            if data?.productImages?.count ?? 0 > 0{
                self.heightCollVwImg.constant = 150
                self.topImgCollVw.constant = 20
                self.collVwImages.isHidden = false
            }else{
                self.heightCollVwImg.constant = 0
                self.topImgCollVw.constant = 0
                self.collVwImages.isHidden = true
            }
            self.tblVwReview.reloadData()
            self.collVwImages.reloadData()
            if data?.status?.status == 0{
              
                self.btnSendRequest.isHidden = false
                self.btnSendRequest.setTitle("Request Sent", for: .normal)
                self.btnSendRequest.isUserInteractionEnabled = false
                self.btnSendRequest.backgroundColor = .app.withAlphaComponent(0.75)
                self.vwMessage.isHidden = true
            }else if data?.status?.status == 1{
                self.btnSendRequest.backgroundColor = .app.withAlphaComponent(1.0)
                for i in data?.reviews ?? [] {
                    if i.userId?.id ?? "" == Store.userId ?? "" {
                        self.btnSendRequest.setTitle("Update Review", for: .normal)
                    }else{
                        self.btnSendRequest.setTitle("Add Review", for: .normal)
                    }
                }
                
                self.btnSendRequest.backgroundColor = UIColor(hex: "#FFB21E")
                self.btnSendRequest.isUserInteractionEnabled = true
                self.vwMessage.isHidden = false
            }else if data?.status?.status == 2{
                self.btnSendRequest.backgroundColor = .app.withAlphaComponent(1.0)
                self.btnSendRequest.setTitle("Rejected", for: .normal)
                self.btnSendRequest.isUserInteractionEnabled = false
                self.vwMessage.isHidden = true
            }else{
                self.btnSendRequest.backgroundColor = .app.withAlphaComponent(1.0)
                self.btnSendRequest.isHidden = false
                self.btnSendRequest.setTitle("Send Request", for: .normal)
               
                self.vwMessage.isHidden = true
                self.btnSendRequest.isUserInteractionEnabled = true
            }
           
        }
  
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDescription))
        lblDescription.addGestureRecognizer(tapGesture)
        
    }
    func groupItemsByCategory() {
        groupedItems.removeAll()
       
        for item in arrItems {
            let category = item.itemCategory
            if groupedItems[category ?? ""] != nil {
                groupedItems[category ?? ""]?.append(item)
            } else {
                groupedItems[category ?? ""] = [item]
            }
        }
        
        sortedCategories = groupedItems.keys.sorted()
      
    }
    @objc private func toggleDescription() {
        isExpanded.toggle()
        if lblDescription.text?.contains("Read More") ?? false || lblDescription.text?.contains("Read Less") ?? false{
            if isExpanded {
                lblDescription.appendReadLess(after: fullText, trailingContent: .readless)
            } else {
                lblDescription.appendReadmore(after: fullText, trailingContent: .readmore)
            }
           
           
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
    @IBAction func actionProductsOnOff(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            heightTblVwProducts.constant = 0
        }else{
            heightTblVwProducts.constant = CGFloat(self.arrProducts.count*94)
            tblVwProducts.reloadData()
        }
    }
    
    @IBAction func actionAddReviews(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupReviewVC") as! PopupReviewVC
        vc.popupId = popupId ?? ""
        vc.popUpDetail = self.popupDetailData
        vc.isComing = self.isReviewed
        
        vc.callBack = { message in
            self.getPopUpDetailApi()
        }
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        callBack?()
    }
    @IBAction func actionLocation(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RouteVC") as! RouteVC
        vc.lat = self.popupDetailData?.lat ?? 0
        vc.long = self.popupDetailData?.long ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionMessage(_ sender: UIButton) {
        if status == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
            vc.receiverId = providerId
            vc.chatType = "popup"
            vc.typeName = popupDetailData?.name ?? ""
            vc.typeId = popupDetailData?.id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessagePopupVC") as! MessagePopupVC
            vc.modalPresentationStyle = .overFullScreen
            vc.popupId = popupId ?? ""
            vc.popupName = self.popupName
            vc.callBack = { [weak self] message in
                guard let self = self else { return }
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 10
                vc.message = message
                vc.callBack = {[weak self] in
                    guard let self = self else { return }
                    self.getPopUpDetailApi()
                }
                self.navigationController?.present(vc, animated: false)
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    @IBAction func actionAddToItinerary(_ sender: UIButton) {

        
        if status == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupReviewVC") as! PopupReviewVC
            vc.popupId = popupId ?? ""
            vc.popUpDetail = self.popupDetailData
            vc.isComing = self.isReviewed
            
            vc.callBack = { message in
                self.getPopUpDetailApi()
            }
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessagePopupVC") as! MessagePopupVC
            vc.modalPresentationStyle = .overFullScreen
            vc.popupId = popupId ?? ""
            vc.popupName = self.popupName
            vc.callBack = { [weak self] message in
                guard let self = self else { return }
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 10
                vc.message = message
                vc.callBack = {[weak self] in
                    guard let self = self else { return }
                    self.getPopUpDetailApi()
                }
                self.navigationController?.present(vc, animated: false)
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
}

extension PopupUserVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopuppImagesCVC", for: indexPath) as! PopuppImagesCVC
        cell.imgVwPopup.imageLoad(imageUrl: arrImages[indexPath.row])
      
        return cell
    }
    
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView != collVwImages{
                return CGSize(width: collVwImages.frame.width/1, height: 160)
            }else{
                
                return CGSize(width: collVwImages.frame.width-40, height: 160)
                
            }
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            if collectionView != collVwImages{
                return 10
            }else{
                return 0
            }
          
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            if collectionView != collVwImages{
                return 10
            }else{
                return 0
            }
        
        }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if arrImages.count > 1{
            guard scrollView == collVwImages, let flowLayout = collVwImages.collectionViewLayout as? CardsCollectionFlowLayout else { return }
            
            let cellWidthIncludingSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
            let estimatedIndex = (scrollView.contentOffset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            let targetIndex: Int
            
            if velocity.x > 0 {
                targetIndex = Int(ceil(estimatedIndex))
            } else if velocity.x < 0 {
                targetIndex = Int(floor(estimatedIndex))
            } else {
                targetIndex = Int(round(estimatedIndex))
            }
            
            let safeIndex = max(0, min(targetIndex, arrImages.count - 1))
            let newOffset = CGFloat(safeIndex) * cellWidthIncludingSpacing - scrollView.contentInset.left+10
            
            targetContentOffset.pointee = CGPoint(x: newOffset, y: scrollView.contentOffset.y)
        }
    }
}

extension PopupUserVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblVwItemsList {
            return sortedCategories.count
        } else if tableView == tblVwProducts || tableView == tblVwSelectedItem || tableView == tblVwReview {
            return 1
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemHeaderTVC") as! ItemHeaderTVC
        if tableView == tblVwItemsList{
            cell.lblName.text = sortedCategories[section]
            cell.btnSeeAll.isHidden = true
            cell.contentView.backgroundColor = .white
        }
        return cell.contentView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblVwItemsList {
            30
        }else{
            0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwProducts{
            return arrProducts.count
            
        }else if tableView == tblVwSelectedItem{
            return selectedItems.count
        }else if tableView == tblVwItemsList{
            return 1
        }else{
            return arrReview.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwProducts{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddedProductListTVC", for: indexPath) as! AddedProductListTVC
            cell.contentView.backgroundColor = UIColor(hex: "#C7E2C4")
            if arrProducts[indexPath.row].isHide ?? false{
                cell.viewForHIdeOrNot.isHidden = false
            }else{
                cell.viewForHIdeOrNot.isHidden = true
            }
            cell.imgVwProduct.imageLoad(imageUrl: arrProducts[indexPath.row].image?.first ?? "")
            cell.lblPrice.text = "$\(arrProducts[indexPath.row].price ?? 0)"
            cell.lblProductName.text = arrProducts[indexPath.row].productName ?? ""

            return cell
        }else if tableView == tblVwSelectedItem{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedItemTVC", for: indexPath) as! SelectedItemTVC
            let item = selectedItems[indexPath.item]
            print("Item---",item)
            cell.vwBackground.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 3, offset:CGSize(width: 2, height: 2))
            cell.lblItemName.text = item.itemName ?? ""
            cell.lblItemCategory.text = item.itemCategory ?? ""
            cell.imgVwItem.imageLoad(imageUrl: item.image?[0] ?? "")
            cell.selectedItems = self.selectedItems
            cell.txtFldWeight.tag = indexPath.row
            let sellingPrice = item.sellingPrice ?? 0
            let discount = item.discount ?? 0
            let discountType = item.discountType ?? 0
            if item.discount == 0{
                cell.lblOff.isHidden = true
                cell.lblTotalPrice.isHidden = true
                cell.lblActualPrice.isHidden = false
                cell.lblLine.isHidden = true
            }else{
                cell.lblOff.isHidden = false
                cell.lblTotalPrice.isHidden = false
                cell.lblActualPrice.isHidden = false
                cell.lblLine.isHidden = false
            }
            cell.lblTotalPrice.text = "$\(sellingPrice)"
            
            var finalPrice: Double = Double(sellingPrice)
            
            if discountType == 0 {
                // Fixed amount off
                cell.lblOff.text = "$\(discount) off"
                finalPrice = Double(sellingPrice) - Double(discount)
              
            } else {
                // Percentage off
                cell.lblOff.text = "\(discount)% off"
                finalPrice = Double(sellingPrice) - (Double(sellingPrice) * Double(discount) / 100.0)
              
            }
            
            // Show the final price after discount with two decimal places
            cell.lblActualPrice.text = String(format: "$%.2f", finalPrice)
            if item.sellingType == 0{
              
                    cell.vwWeight.isHidden = false
                    cell.vwQuantity.isHidden = true
                let perGramPrice: Double

                if item.stockType == 0 {
                    // Price is for 10 grams
                    perGramPrice = finalPrice
                    let quantityInGrams = item.selectedQuantity ?? 0.0
                    let totalValue = perGramPrice * quantityInGrams
                   
                    cell.lblQuantityPrice.text = String(format: "$%.2f", totalValue)
                    cell.txtFldWeight.text = "\(Int(item.selectedQuantity ?? 0))"
                  
                } else {
               
                    let quantityInGrams = (item.selectedQuantity ?? 0.0) * 1000.0  // Convert kg to grams
                    let perGramPrice = finalPrice / 1000.0                         // $ per gram
                    let totalValue = quantityInGrams * perGramPrice
                    cell.lblQuantityPrice.text = String(format: "$%.2f", totalValue) // show 3 decimals
                 
                    cell.txtFldWeight.text = String(format: "%.2f", item.selectedQuantity ?? 0.0)
                }
             
            }else{
              
                cell.vwWeight.isHidden = true
                cell.vwQuantity.isHidden = false
                cell.lblQuantity.text = "\(item.selectedQuantity ?? 0.0)"
                let quantity = item.selectedQuantity ?? 0.0
             
                let totalPrice = finalPrice * quantity
           
                print("Price-----",totalPrice)
                cell.lblQuantityPrice.text = String(format: "$%.2f", totalPrice)
                
               
            }
            
            cell.callBack = { [weak self] value in
                guard let self = self else { return }
            
            }
            cell.btnPlus.addTarget(self, action: #selector(PlusQuantity), for: .touchUpInside)
            cell.btnPlus.tag = indexPath.row
            cell.btnMinus.addTarget(self, action: #selector(MinusQuantity), for: .touchUpInside)
            cell.btnMinus.tag = indexPath.row
            cell.btnTick.addTarget(self, action: #selector(AddWeight), for: .touchUpInside)
            cell.btnTick.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deleteSelectedItem), for: .touchUpInside)
            cell.btnDelete.tag = indexPath.row
            return cell
        }else if tableView == tblVwItemsList{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCategoryTVC", for: indexPath) as! ItemCategoryTVC
            let category = sortedCategories[indexPath.section]
            if let items = groupedItems[category] {
                cell.configure(with: items, isType: false, isMyPopup: false, viewSummary: false)
                cell.selectedItemMark = selectedItems

                // Capture items inside closure
                cell.callBackMarkSelectItem = { [weak self] type, item in
                    guard let self = self else { return }
                    
                    if type == "Add" {
                       
                   
                            if let index = self.selectedItems.firstIndex(where: { $0.id == item.id }) {
                                self.selectedItems.remove(at: index)
                                if self.selectedItems.count > 0{
                                    self.vwSelectedItem.isHidden = false
                                    self.heightSelectedItem.constant = CGFloat(self.selectedItems.count*128) + 25
                                    self.tblVwSelectedItem.reloadData()
                                }else{
                                    self.heightSelectedItem.constant = CGFloat(self.selectedItems.count*128) + 25
                                    self.vwSelectedItem.isHidden = true
                                    self.heightSelectedItem.constant = 0
                                    self.tblVwSelectedItem.reloadData()
                                }
                            }
                   
                        viewModelItem.markSelectedItemApi(itemId: item.id ?? "", popupId: self.popupId ?? "", status: false, selectedQuantity: 0, showhud: true) {
                        }
                    } else {
                       
                      
                        var newItem = item
                          if item.sellingType == 0 {
                              if item.stockType == 0 {
                                  newItem.selectedQuantity = 10
                              } else {
                                  newItem.selectedQuantity = 0.01
                              }
                          } else {
                              newItem.selectedQuantity = 1
                          }

                          self.selectedItems.append(newItem)
                          self.vwSelectedItem.isHidden = false
                          self.heightSelectedItem.constant = CGFloat(self.selectedItems.count * 118) + 25
                          self.tblVwSelectedItem.reloadData()

                          // ✅ Call API with proper quantity
                          viewModelItem.markSelectedItemApi(
                              itemId: item.id ?? "",
                              popupId: self.popupId ?? "",
                              status: true,
                              selectedQuantity: newItem.selectedQuantity ?? 0, showhud: true
                          ) {}

                          cell.selectedItemMark = self.selectedItems

                          // ✅ Reload only the updated item in collectionView
//                          if let itemIndex = items.firstIndex(where: { $0.id == item.id }) {
//                              let indexPath = IndexPath(item: itemIndex, section: 0)
//                              cell.collVwItems.reloadItems(at: [indexPath])
//                          }
                      }
                    cell.selectedItemMark = self.selectedItems
                    let total = calculateTotalPrice()
                    self.lblItemTotal.text = "Total \(String(format: "$%.2f", total))"
                  
                   
                }
            }
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTVC", for: indexPath) as! ReviewTVC
            cell.imgVwUser.imageLoad(imageUrl: arrReview[indexPath.row].userId?.profilePhoto ?? "")
            cell.lblName.text = arrReview[indexPath.row].userId?.name ?? ""
            cell.lblDescription.text = arrReview[indexPath.row].comment ?? ""
            cell.lblDescription.sizeToFit()
            
            cell.ratingView.rating = Double(arrReview[indexPath.row].starCount ?? 0)
            heightDescription += Int(cell.lblDescription.frame.size.height)
            
            
            if arrReview[indexPath.row].userId?.id == Store.userId{
                cell.btnDelete.isHidden = false
                
                cell.btnDelete.removeTarget(nil, action: nil, for: .allEvents)
                cell.btnDelete.addTarget(self, action: #selector(deleteReview), for: .touchUpInside)
                cell.btnDelete.tag = indexPath.row
            }else{
                cell.btnDelete.isHidden = true
            }
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
            
        }else if  tableView == tblVwSelectedItem{
            return 118
       
        }else{
            return UITableView.automaticDimension
        }

    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    func calculateTotalPrice() -> Double {
        var total: Double = 0.0
        for item in selectedItems {
            let sellingPrice = item.sellingPrice ?? 0
            let discount = item.discount ?? 0
            let discountType = item.discountType ?? 0
            var finalPrice = Double(sellingPrice)
            
            if discountType == 0 {
                finalPrice -= Double(discount)
            } else {
                finalPrice -= Double(sellingPrice) * Double(discount) / 100.0
            }
            
            let quantity = item.selectedQuantity ?? 0.0
            
            if item.sellingType == 0 {
                if item.stockType == 0 {
                    total += (finalPrice / 10.0) * quantity * 10
                } else {
                    total += (finalPrice / 1000.0) * quantity * 1000
                }
            } else {
                total += finalPrice * quantity
            }
        }
        return total
    }
    
    @objc func deleteReview(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelGigVC") as! CancelGigVC
        vc.isSelect = 4
        vc.reviewId = arrReview[sender.tag].id ?? ""
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack  = { message in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 10
                vc.message = message
                vc.callBack = {[weak self] in
                    guard let self = self else { return }
                    self.getPopUpDetailApi()
                }
                self.navigationController?.present(vc, animated: false)
        }
        self.navigationController?.present(vc, animated: false)
    }
    
    @objc func PlusQuantity(sender: UIButton) {
        let row = sender.tag
        guard
            row < selectedItems.count,
            let cell = tblVwSelectedItem.cellForRow(at: IndexPath(row: row, section: 0)) as? SelectedItemTVC
        else { return }

        let item = selectedItems[row]
        let sellingPrice = item.sellingPrice ?? 0
        let discount = item.discount ?? 0
        let discountType = item.discountType ?? 0
        let currentQuantity = item.selectedQuantity ?? 0
        let totalStock = item.totalStock ?? 0.0

        // ✅ Prevent increment if quantity would exceed stock
        if currentQuantity >= totalStock {
            showSwiftyAlert("", "Quantity cannot exceed available stock", false)
            return
        }

        var finalPrice = Double(sellingPrice)
        if discountType == 0 {
            finalPrice -= Double(discount)
        } else {
            finalPrice -= (Double(sellingPrice) * Double(discount) / 100.0)
        }

        let updatedQuantity = currentQuantity + 1
        selectedItems[row].selectedQuantity = updatedQuantity
        cell.lblQuantity.text = "\(Int(updatedQuantity))"
        let totalPrice = finalPrice * updatedQuantity
        cell.lblQuantityPrice.text = String(format: "$%.2f", totalPrice)

        let total = calculateTotalPrice()
        self.lblItemTotal.text = "Total \(String(format: "$%.2f", total))"

        viewModelItem.markSelectedItemApi(
            itemId: item.id ?? "",
            popupId: popupId ?? "",
            status: true,
            selectedQuantity: updatedQuantity, showhud: false
        ) {
            // Completion logic if needed
        }
    }

    
    @objc func MinusQuantity(sender: UIButton) {
        let row = sender.tag
        guard
            row < selectedItems.count,
            let cell = tblVwSelectedItem.cellForRow(at: IndexPath(row: row, section: 0)) as? SelectedItemTVC
        else { return }

        let item = selectedItems[row]
        var quantity = item.selectedQuantity ?? 0.0

        guard quantity > 0 else { return } // Prevent going below 0

        quantity -= 1
        selectedItems[row].selectedQuantity = quantity // ✅ Keep model in sync regardless of quantity

        // Update UI
        cell.lblQuantity.text = "\(Int(quantity))"

        // Calculate final price
        let sellingPrice = item.sellingPrice ?? 0
        let discount = item.discount ?? 0
        let discountType = item.discountType ?? 0
        var finalPrice = Double(sellingPrice)
        if discountType == 0 {
            finalPrice -= Double(discount)
        } else {
            finalPrice -= (Double(sellingPrice) * Double(discount) / 100.0)
        }
        let totalPrice = finalPrice * quantity
        cell.lblQuantityPrice.text = String(format: "$%.2f", totalPrice)

        let total = calculateTotalPrice()
        self.lblItemTotal.text = "Total \(String(format: "$%.2f", total))"

        // Call API
        if quantity > 0 {
            viewModelItem.markSelectedItemApi(
                itemId: item.id ?? "",
                popupId: popupId ?? "",
                status: true,
                selectedQuantity: quantity, showhud: false
            ) {}
        } else {
            
            selectedItems[row].selectedQuantity = 0 // ✅ Explicitly set to 0
            viewModelItem.markSelectedItemApi(
                itemId: item.id ?? "",
                popupId: popupId ?? "",
                status: false,
                selectedQuantity: 0, showhud: true
            ) {
                self.selectedItems.remove(at: row)
                self.tblVwSelectedItem.reloadData()
                self.vwSelectedItem.isHidden = self.selectedItems.isEmpty
                self.heightSelectedItem.constant = self.selectedItems.isEmpty ? 0 : CGFloat(self.selectedItems.count * 128) + 25
            }
        }
    }
    
    @objc func AddWeight(sender:UIButton){
        let row = sender.tag
        guard
            row < selectedItems.count,
            let cell = tblVwSelectedItem.cellForRow(at: IndexPath(row: row, section: 0)) as? SelectedItemTVC
        else { return }

        let item = selectedItems[row]
        let sellingPrice = item.sellingPrice ?? 0
        let discount = item.discount ?? 0
        let discountType = item.discountType ?? 0

        var finalPrice = Double(sellingPrice)
        if discountType == 0 {
            finalPrice -= Double(discount)
        } else {
            finalPrice -= (Double(sellingPrice) * Double(discount) / 100.0)
        }

        let updatedQuantity = (cell.txtFldWeight.text ?? "")
        selectedItems[row].selectedQuantity = Double(updatedQuantity) // ✅ Keep model in sync
        cell.lblQuantity.text = "\(updatedQuantity)"
        let totalPrice = finalPrice * (Double(updatedQuantity) ?? 0)
        cell.lblQuantityPrice.text = String(format: "$%.2f", totalPrice)
        let total = calculateTotalPrice()
        self.lblItemTotal.text = "Total \(String(format: "$%.2f", total))"
        viewModelItem.markSelectedItemApi(
            itemId: item.id ?? "",
            popupId: popupId ?? "",
            status: true,
            selectedQuantity: Double(updatedQuantity) ?? 0, showhud: false
        ) {
            // Completion logic if needed
        }
    }
    @objc func deleteSelectedItem(sender:UIButton){
        let row = sender.tag
        guard
            row < selectedItems.count,
            let cell = tblVwSelectedItem.cellForRow(at: IndexPath(row: row, section: 0)) as? SelectedItemTVC
        else { return }

        let item = selectedItems[row]
        selectedItems[row].selectedQuantity = 0 // ✅ Explicitly set to 0
        viewModelItem.markSelectedItemApi(
            itemId: item.id ?? "",
            popupId: popupId ?? "",
            status: false,
            selectedQuantity: 0, showhud: true
        ) {
            self.selectedItems.remove(at: row)
            self.tblVwSelectedItem.reloadData()
            self.vwSelectedItem.isHidden = self.selectedItems.isEmpty
            self.heightSelectedItem.constant = self.selectedItems.isEmpty ? 0 : CGFloat(self.selectedItems.count * 128) + 25
            self.tblVwItemsList.reloadData()
        }
    }
}

extension UICollectionViewCell {
    func transformToLarge() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    func transformToStandard() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
    
}

