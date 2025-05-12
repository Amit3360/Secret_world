//
//  PopupSummaryVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 10/04/25.
//

import UIKit
import MapboxMaps
import Solar

class PopupSummaryVC: UIViewController {
    
    @IBOutlet weak var vwProductList: UIView!
    @IBOutlet weak var vwProductHeader: UIView!
    @IBOutlet weak var heightTblVwItem: NSLayoutConstraint!
    @IBOutlet weak var tblVwItems: UITableView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var heightTblVw: NSLayoutConstraint!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tblVwProducts: UITableView!
   
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblPopupName: UILabel!
    
    @IBOutlet weak var vwMap: MapView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgVwStatus: UIImageView!
    @IBOutlet weak var imgVwPopup: UIImageView!
    
    var viewModel = PopUpVM()
    var popupId = ""
    var arrProducts = [AddProducts]()
    var status:Int?
    private var fullText = ""
    private var arrImages = [String]()
    private var isExpanded = false
    private var solar: Solar?
    var arrPointAnnotaion: [PointAnnotation] = []
    var pointAnnotationManagerPop: PointAnnotationManager!
    var arrItem = [AddItems]()
    var groupedItems = [String: [AddItems]]()
    var sortedCategories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
        
    }
    
    override func viewWillLayoutSubviews() {
        self.tblVwItems.reloadData()
          self.tblVwItems.layoutIfNeeded()
        self.heightTblVwItem.constant = self.tblVwItems.contentSize.height + 10
        
    }
    
    func uiSet(){
        let nib = UINib(nibName: "AddedProductListTVC", bundle: nil)
        tblVwProducts.register(nib, forCellReuseIdentifier: "AddedProductListTVC")
        let nibHeader = UINib(nibName: "ItemHeaderTVC", bundle: nil)
        tblVwItems.register(nibHeader, forCellReuseIdentifier: "ItemHeaderTVC")
        let nibItems = UINib(nibName: "ItemCategoryTVC", bundle: nil)
        tblVwItems.register(nibItems, forCellReuseIdentifier: "ItemCategoryTVC")
        getPopUpDetailApi()
        if let solar = Solar(coordinate: CLLocationCoordinate2D(latitude: myCurrentLat, longitude: myCurrentLong)) {
            self.solar = solar
            let isDaytime = solar.isDaytime
            print(isDaytime ? "It's day time!" : "It's night time!")
            if isDaytime{
                if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                    vwMap.mapboxMap.loadStyleURI(StyleURI(url: styleURL) ?? .light)
                }
                
            }else{
                if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                    vwMap.mapboxMap.loadStyleURI(StyleURI(url: styleURL) ?? .light)
                }
            }
        }
        vwMap.ornaments.scaleBarView.isHidden = true
        vwMap.ornaments.logoView.isHidden = true
        vwMap.ornaments.attributionButton.isHidden = true
    }
    
    func getPopUpDetailApi(){
        print("Token",Store.authKey ?? "")
        
        viewModel.getPopupDetailApi(loader: true, popupId: popupId) { data in
            self.arrProducts = data?.addProducts ?? []
            if data?.addProducts?.count ?? 0 > 0{
                self.heightTblVw.constant = CGFloat(self.arrProducts.count*94)
            }else{
                self.heightTblVw.constant = 0
            }
            
            self.tblVwProducts.reloadData()
            
            self.lblPopupName.text = data?.name ?? ""
            
            self.imgVwPopup.imageLoad(imageUrl: data?.businessLogo ?? "")
            
            self.lblAddress.text = data?.place ?? ""
            let startTime = self.convertUpdateDateString(data?.startDate ?? "")
            let endTime = self.convertUpdateDateString(data?.endDate ?? "")
        
            
            self.lblRating.text = "\(data?.rating ?? 0)"
            self.fullText = data?.description ?? ""
            self.arrImages = data?.productImages ?? []
            
            self.lblDescription.appendReadmore(after: self.fullText, trailingContent: .readmore)
            
            if data?.categoryType == 1{
                self.lblCategory.text = "Food & Drinks"
                
            }else if data?.categoryType == 2{
                self.lblCategory.text = "Services"
                
            }else if data?.categoryType == 3{
                self.lblCategory.text = "Clothes / Fashion"
            }else if data?.categoryType == 4{
                self.lblCategory.text = "Beauty / Self-Care"
            }else{
                self.lblCategory.text = "Low Key"
                
            }
            if (data?.endSoon ?? false){
                self.imgVwStatus.image = UIImage(named: "redApprove")
            }else{
                self.imgVwStatus.image = UIImage(named: "greenApprove")
            }
            
            if data?.categoryType == 5{
                self.arrItem.removeAll()
                self.sortedCategories.removeAll()
               
                self.arrItem = data?.addItems ?? []
                self.groupItemsByCategory()
          
                DispatchQueue.main.asyncAfter(deadline: .now()+2.0){
                    self.tblVwItems.reloadData()
                      self.tblVwItems.layoutIfNeeded()
                      self.heightTblVwItem.constant = self.tblVwItems.contentSize.height + 10
                }
                self.vwProductHeader.isHidden = true
                self.vwProductList.isHidden = true
                self.tblVwItems.isHidden = false
                if let rawArray = data?.closedDays,
                   let jsonString = rawArray.first, // Get the first (and only) string
                   let jsonData = jsonString.data(using: .utf8) {
                    
                    do {
                        let daysArray = try JSONDecoder().decode([String].self, from: jsonData)
                        let daysText = daysArray.joined(separator: ", ")
                        self.lblDate.text = "Closed on: \(daysText)"
                    } catch {
                        print("Failed to decode days: \(error)")
                        self.lblDate.text = "Open all week"
                    }
                } else {
                    self.lblDate.text = "Open all week"
                }
            }else{
                self.vwProductHeader.isHidden = false
                self.vwProductList.isHidden = false
                self.tblVwItems.isHidden = true
                self.heightTblVwItem.constant = 0
                self.lblDate.text = "\(startTime ?? "") - \(endTime ?? "")"
            }
            self.downloadAnnotationImage(for: CLLocationCoordinate2D(latitude: data?.lat ?? 0, longitude: data?.long ?? 0))
            self.vwMap.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: data?.lat ?? 0, longitude: data?.long ?? 0),zoom: 11,bearing: 0,pitch: 0))
            
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDescription))
        lblDescription.addGestureRecognizer(tapGesture)
        
    }
    func groupItemsByCategory() {
        groupedItems.removeAll()
       
        for item in arrItem {
            let category = item .itemCategory
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
    func convertUpdateDateString(_ dateString: String, outputFormat: String = "MMM dd,h:mm a") -> String? {
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
    
    func downloadAnnotationImage(for coordinate: CLLocationCoordinate2D) {
        
     
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
       
      
            let image = self.combineImagesPopUp(overlayImage: UIImage(named: "redMarker") ?? UIImage(), overlaySize: CGSize(width: 14, height: 20))
            let pointAnnotation = self.createPointAnnotation(for: centerCoordinate, withImage: image ?? UIImage())
            self.updatePopUpAnnotations(with: pointAnnotation)
        
    }
    
    private func updatePopUpAnnotations(with pointAnnotation: PointAnnotation) {
 
        arrPointAnnotaion.append(pointAnnotation)
        
        
        DispatchQueue.main.async {
            self.pointAnnotationManagerPop = self.vwMap.annotations.makePointAnnotationManager()
            self.pointAnnotationManagerPop?.annotations = self.arrPointAnnotaion
        }
    }
    func createPointAnnotation(for coordinate: CLLocationCoordinate2D, withImage image: UIImage) -> PointAnnotation {
        var annotation = PointAnnotation(coordinate: coordinate)
        annotation.image = .init(image: image, name: "redMarker") // Ensure unique name
        return annotation
    }
    func combineImagesPopUp(
        overlayImage: UIImage,
        overlaySize: CGSize
    ) -> UIImage? {
        // Set up adjusted base size
        let adjustedBaseSize = CGSize(width: overlaySize.width, height: overlaySize.height)
        
        // Start graphics context
        UIGraphicsBeginImageContextWithOptions(adjustedBaseSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to create graphics context.")
            return nil
        }
        
        // Define overlay position
        let overlayOrigin = CGPoint(x: 0, y: 0)
        let overlayRect = CGRect(origin: overlayOrigin, size: overlaySize)
  
        overlayImage.draw(in: overlayRect)
        context.restoreGState()
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension PopupSummaryVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblVwItems {
            return sortedCategories.count
        } else if tableView == tblVwProducts{
            return 1
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemHeaderTVC") as! ItemHeaderTVC
        if tableView == tblVwItems{
            cell.lblName.text = sortedCategories[section]
            cell.btnSeeAll.isHidden = true
            cell.contentView.backgroundColor = UIColor(hex: "#C7E2C4")
            let category = sortedCategories[section]
            if let items = groupedItems[category] {
                if items.count > 2{
                    cell.btnSeeAll.isHidden = false
                    cell.btnSeeAll.underline()
                    cell.btnSeeAll.addTarget(self, action: #selector(seeAllItem), for: .touchUpInside)
                    cell.btnSeeAll.tag = section
                }else{
                    cell.btnSeeAll.isHidden = true
                }
            }
        }
        return cell.contentView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblVwItems {
            50
        }else{
            0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwProducts{
            return arrProducts.count
   
        }else if tableView == tblVwItems{
            return 1
        }else{
            return 0
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
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCategoryTVC", for: indexPath) as! ItemCategoryTVC
            
            let category = sortedCategories[indexPath.section]
            if let items = groupedItems[category] {
                cell.configure(with: items, isType: false, isMyPopup: false, viewSummary: true)
     
                }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVwProducts{
            return 94
        }else{
            return 220
        }
        
    }
    @objc func seeAllItem(sender:UIButton){
        var arrSectionItem = [AddItems]()
        let category = sortedCategories[sender.tag]
        if let items = groupedItems[category] {
            print(items)
            arrSectionItem.insert(contentsOf: items, at: 0)
            }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemsListVC") as! ItemsListVC
            vc.isComingUpdate = true
            vc.arrAddItem = arrSectionItem
            vc.isComingFrom = "seeAll"
            vc.isComingSummary = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
