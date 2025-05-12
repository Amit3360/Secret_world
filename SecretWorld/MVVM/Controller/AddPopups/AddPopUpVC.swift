//
//  AddPopUpVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//
import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import CryptoKit
import CommonCrypto
import CoreImage
import Vision
import CoreLocation
import AlignedCollectionViewFlowLayout

struct Products {
    let name: String?
    let price: Int?
    let images:String?
    let description:String?
    var isHide:Bool?
    init(name: String?, price: Int?, images: String?, description: String?, isHide: Bool?) {
        self.name = name
        self.price = price
        self.images = images
        self.description = description
        self.isHide = isHide
    }
}



class AddPopUpVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - OUTLETS
    @IBOutlet weak var headerImgTop: NSLayoutConstraint!
    @IBOutlet weak var headerImgBottom: NSLayoutConstraint!
  
    @IBOutlet weak var btnExistingItem: UIButton!
    @IBOutlet weak var vwExistingVw: UIView!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var vwProductHeader: UIView!
    @IBOutlet weak var topCollVwList: NSLayoutConstraint!
    @IBOutlet weak var heightProductList: NSLayoutConstraint!
    @IBOutlet weak var vwProductList: UIView!
    @IBOutlet weak var tblVwProductList: UITableView!
    @IBOutlet weak var btnAddProduct: UIButton!
    @IBOutlet weak var vwAddProduct: UIView!
    @IBOutlet weak var txtFldDays: UITextField!
    @IBOutlet weak var heightDaysCollVw: NSLayoutConstraint!
    @IBOutlet weak var collVwDays: UICollectionView!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var heightCollvwItems: NSLayoutConstraint!
    @IBOutlet weak var collVwItems: UICollectionView!
    @IBOutlet weak var vwItems: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var txtFldDealingOffer: UITextField!
    @IBOutlet var txtFldPopupType: UITextField!
    @IBOutlet var btnMarkerLogo: UIButton!
    @IBOutlet var imgVwMarkerLogo: UIImageView!
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var txtFldName: UITextField!
    @IBOutlet var txtFldLOcation: UITextField!
    @IBOutlet var btnPopupLogo: UIButton!
    @IBOutlet var imgVwPopupLogo: UIImageView!
    @IBOutlet weak var imgVwMarker: UIImageView!
    @IBOutlet var txtFldEndTime: UITextField!
    @IBOutlet var txtFldEndDate: UITextField!
    @IBOutlet var txtFldStartTime: UITextField!
    @IBOutlet var txtFldStartDate: UITextField!
    @IBOutlet var txtVwDescription: IQTextView!
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet weak var lblDescriptionCount: UILabel!

    
    //MARK: - VARIABLES
    var arrProducts = [Products]()
    var isUploadLogoImg = false
    var isUploadMarker = false
    var viewModel = PopUpVM()
    var viewModelUpload = UploadImageVM()
    var lat:Double?
    var long:Double?
    var selectedStartTime:String?
    var selectedEndTime:String?
    var selectedStartDate:String?
    var selectedEndDate:String?
    var currentTime:String?
    var currentDate:String?
    var isComing = false
    var arrEditProducts = [AddProducts]()
    var productImg = [""]
    var callBack:(()->())?
    var popupDetails:PopupDetailData?
    var popUptype = 0
    var updateLocation = false
    var uploadedImages: [UIImage] = []
    var uploadCustomMarker = false
    private let locationManager = CLLocationManager()
    let deviceHasNotch = UIApplication.shared.hasNotch
    var arrDays = [String]()
    var arrItems = [AddItems]()
    var selectedItem = [AllItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    
    
    private func uiSet(){
        btnSeeAll.underline()
        btnExistingItem.underline()
        
        collVwDays.isHidden = true
        
        let nib = UINib(nibName: "AddedProductListTVC", bundle: nil)
        tblVwProductList.register(nib, forCellReuseIdentifier: "AddedProductListTVC")
        
        let nibItems = UINib(nibName: "AddItemCVC", bundle: nil)
        collVwItems.register(nibItems, forCellWithReuseIdentifier: "AddItemCVC")
        

        let nibDays = UINib(nibName: "SubCategoriesCVC", bundle: nil)
        collVwDays.register(nibDays, forCellWithReuseIdentifier: "SubCategoriesCVC")
        let alignedFlowLayoutCollVwSpecializ = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwDays.collectionViewLayout = alignedFlowLayoutCollVwSpecializ
      
        if let flowLayout1 = collVwDays.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout1.estimatedItemSize = CGSize(width: 0, height: 40)
            flowLayout1.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        btnSeeAll.underline()
        if deviceHasNotch{
            self.headerImgTop.constant = 0
            self.headerImgBottom.constant = 10
        }else{
            self.headerImgTop.constant = -10
            self.headerImgBottom.constant = 0
        }

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        txtFldStartDate.tag = 1
        txtFldEndDate.tag = 2
        txtFldStartTime.tag = 3
        txtFldEndTime.tag = 4
    
        txtVwDescription.delegate = self
        txtFldName.delegate = self
        
        if isComing == true{
            // Update promote business
            lblScreenTitle.text = "Edit Popup"
            btnCreate.setTitle("Update Popup", for: .normal)
            btnPopupLogo.setImage(UIImage(named: ""), for: .normal)
            imgVwPopupLogo.imageLoad(imageUrl: popupDetails?.businessLogo ?? "")
            popUptype = popupDetails?.categoryType ?? 0
            txtFldDealingOffer.text = popupDetails?.deals ?? ""
        
            if popupDetails?.categoryType == 1{
                txtFldPopupType.text = "Food & Drinks"
                
            }else if popupDetails?.categoryType == 2{
                txtFldPopupType.text = "Services"
            }else if popupDetails?.categoryType == 3{
                txtFldPopupType.text = "Clothes / Fashion"
            }else if popupDetails?.categoryType == 4{
                txtFldPopupType.text = "Beauty / Self-Care"
            }else{
                txtFldPopupType.text = "Low Key"
            }

            txtFldName.text = popupDetails?.name ?? ""
            txtVwDescription.text = popupDetails?.description ?? ""
            txtFldLOcation.text = popupDetails?.place ?? ""
            updateLocation = true
            arrEditProducts = popupDetails?.addProducts ?? []
         
            txtFldStartDate.text = convertDateString(popupDetails?.startDate ?? "")
            txtFldEndDate.text = convertDateString(popupDetails?.endDate ?? "")
            txtFldStartTime.text = convertTimeString(popupDetails?.startDate ?? "")
            txtFldEndTime.text = convertTimeString(popupDetails?.endDate ?? "")
            lat = popupDetails?.lat ?? 0.0
            long = popupDetails?.long ?? 0.0
            self.productImg.removeAll()
            if popupDetails?.productImages?.count ?? 0 > 0{
                
                self.productImg = popupDetails?.productImages ?? []
                self.productImg.insert("", at: 0)
            }else{
                self.productImg.insert("", at: 0)
            }
            if popupDetails?.categoryType != 5{
                arrEditProducts = popupDetails?.addProducts  ?? []
                if popupDetails?.addProducts?.count ?? 0 > 0{
                    vwAddProduct.isHidden = true
                    tblVwProductList.isHidden = false
                }else{
                    vwAddProduct.isHidden = false
                    tblVwProductList.isHidden = true
                }
                heightProductList.constant = CGFloat(arrEditProducts.count*94)
                tblVwProductList.reloadData()
            }else{
                arrItems = popupDetails?.addItems  ?? []
                if popupDetails?.addItems?.count ?? 0 > 0{
                    vwItems.isHidden = false
                
                }else{
                    vwItems.isHidden = true
                   
                }
                self.vwExistingVw.isHidden = false
                self.btnAddItem.isHidden = false
                self.collVwItems.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    self.heightCollvwItems.constant = self.collVwItems.contentSize.height
                   
                       
                            if self.arrItems.count > 0{
                                self.heightCollvwItems.constant = 220
                            }else{
                                self.heightCollvwItems.constant = 0
                            }
                        
 
                }
            }
          
            if let jsonString = popupDetails?.closedDays?.first,
               let jsonData = jsonString.data(using: .utf8),
               let result = try? JSONDecoder().decode([String].self, from: jsonData) {
                print(result)  // ["Sunday", "Monday"]
                self.arrDays = result
            }
            self.collVwDays.isHidden = false
        
         
            self.collVwDays.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.heightDaysCollVw.constant = self.collVwDays.contentSize.height
          
            }
           
        }else{
            //add
            updateLocation = true
            lblScreenTitle.text = "Add Popup"
            btnCreate.setTitle("Create Popup", for: .normal)
            handleLocationManager()
        }
        for url in popupDetails?.productImages ?? [] {
            SDWebImageDownloader.shared.downloadImage(with: URL(string: url)) { (image, data, error, finished) in
                if let image = image, finished {
                    DispatchQueue.main.async {
                        self.uploadedImages.append(image)
                        print("Image added: \(image)")
                    }
                }
            }
        }
        setupDatePickers()
    }
    @objc func handleSwipe() {
               navigationController?.popViewController(animated: true)
           }

    private func handleLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // Request permission
        locationManager.startUpdatingLocation()

    }

    //MARK: - BUTTON ACTIONS
    
    @IBAction func actionChoosetype(_ sender: UIButton) {
        view.endEditing(true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "popupType"
        vc.matchTitle = txtFldPopupType.text ?? ""
        vc.modalPresentationStyle = .popover
        vc.callBackBusiness = {[weak self] (name,index) in
            guard let self = self else { return }
            self.popUptype = index
            self.txtFldPopupType.text = name
            if index == 5{
                self.btnAddItem.isHidden = false
                self.btnSeeAll.isHidden = true
                self.vwAddProduct.isHidden = true
                self.vwProductHeader.isHidden = true
                self.vwExistingVw.isHidden = false
                self.vwItems.isHidden = false
            }else{
                self.btnAddItem.isHidden = true
                self.vwAddProduct.isHidden = false
                self.vwProductHeader.isHidden = false
                self.vwExistingVw.isHidden = true
                self.vwItems.isHidden = true
            }
        }
        let height = CGFloat(250)
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(width: txtFldPopupType.frame.size.width, height: height)
        self.present(vc, animated: false)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupTypeVC") as! PopupTypeVC
//        vc.modalPresentationStyle = .overFullScreen
//        vc.popUptype = popUptype
//        vc.callBack = {[weak self] (type,category) in
//            guard let self = self else { return }
//            self.popUptype = type ?? 0
//            self.txtFldPopupType.text = category
//        }
//        self.navigationController?.present(vc, animated: true)

    }
    @IBAction func actionUploadMarkerLogo(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMarkerImageVC") as! AddMarkerImageVC
        vc.callBack = { image in
            if image == UIImage(named: "") || image == nil{
                self.btnMarkerLogo.setImage(UIImage(named: "Group25"), for: .normal)
            }else{
                self.btnMarkerLogo.setImage(UIImage(named: ""), for: .normal)
                self.imgVwMarkerLogo.image = image
            }
            
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func openCamera() {
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
               let imagePicker = UIImagePickerController()
               imagePicker.sourceType = .camera
               imagePicker.delegate = self
               imagePicker.allowsEditing = false
               self.present(imagePicker, animated: true, completion: nil)
           }
       }
    // MARK: - UIImagePickerControllerDelegate
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
         if let image = info[.originalImage] as? UIImage {
//             do {
//                 let processedImage = try BackgroundRemoval().removeBackground(image: image)
//
                    self.imgVwMarkerLogo.image = image
                     Store.MarkerLogo = image
                     self.btnMarkerLogo.setImage(UIImage(named: ""), for: .normal)
                     self.isUploadMarker = true
//
//             } catch {
//                 print("Error removing background: \(error.localizedDescription)")
//             }
         }
         picker.dismiss(animated: true, completion: nil)
     }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionUploadimg(_ sender: UIButton) {
        if isUploadLogoImg == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePhotoVC") as! ChangePhotoVC
            vc.isComing = 0
            vc.callBack = { [weak self] image in
                
                guard let self = self else { return }
                self.imgVwPopupLogo.image = image
                if Store.LogoImage == UIImage(named: "") || Store.LogoImage == nil{
                    self.btnPopupLogo.setImage(UIImage(named: "Group25"), for: .normal)
                    self.isUploadLogoImg = false
                }else{
                    self.btnPopupLogo.setImage(UIImage(named: ""), for: .normal)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            ImagePicker().pickImage(self) { image in
                self.imgVwPopupLogo.image = image
                Store.LogoImage = image
                self.btnPopupLogo.setImage(UIImage(named: ""), for: .normal)
                self.isUploadLogoImg = true
            }
        }
    }
    
    @IBAction func actionAddPopupMarker(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateMarkerVC") as! CreateMarkerVC
        vc.shapedImg = imgVwPopupLogo.image
        vc.callBack = { (image) in
          
            self.imgVwMarker.image = image
         
            self.uploadCustomMarker = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAddProduct(_ sender: UIButton) {
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditProductVC") as! AddEditProductVC
        
        vc.callBack = { [weak self] productName, price, description, productImages,isHide in
            guard let self = self else { return }
            let isDuplicate: Bool
            if isComing {
                isDuplicate = self.arrEditProducts.contains(where: { $0.productName?.lowercased() == productName?.lowercased() })
            } else {
                isDuplicate = self.arrProducts.contains(where: { $0.name?.lowercased() == productName?.lowercased() })
            }

            if isDuplicate {
                showSwiftyAlert("", "This product name already exists.", false)
                print("Product name is the same: \(productName ?? "")")
                return
            }

            if isComing{
                self.vwAddProduct.isHidden = true
                self.tblVwProductList.isHidden = false
                self.arrEditProducts.append(AddProducts(productName: productName, price: price, id: "", description: description, image: [productImages ?? ""], isHide: isHide))
                self.heightProductList.constant = CGFloat(self.arrEditProducts.count * 94)
                self.tblVwProductList.reloadData()
            }else{
                self.vwAddProduct.isHidden = true
                self.tblVwProductList.isHidden = false
                self.arrProducts.append(Products(name: productName, price: price, images: productImages, description: description, isHide: isHide))
                self.heightProductList.constant = CGFloat(self.arrProducts.count * 94)
                self.tblVwProductList.reloadData()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionCreate(_ sender: UIButton) {
        if let text = txtFldDealingOffer.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty {
            let hasLetters = text.rangeOfCharacter(from: .letters) != nil
            let hasNumbers = text.rangeOfCharacter(from: .decimalDigits) != nil

            if hasLetters && hasNumbers {
                // If text contains both letters and numbers, call API directly
                apiCall()
            } else if let intValue = Int(text), intValue >= 1, intValue <= 100 {
                // If text contains only numbers and is within range, append "% off" and call API
                txtFldDealingOffer.text = "\(intValue)% off"
                apiCall()
            } else {
                // Invalid numeric value
                showSwiftyAlert("", "Please enter a valid deal value between 1 and 100", false)
            }
        } else {
            apiCall() // Call API if text field is empty
        }
        
    }

    private func apiCall(){
        
//        if productImg.count > 0{
//            productImg.remove(at: 0)
//        }
        
        if imgVwPopupLogo.image == UIImage(named: "") || imgVwPopupLogo.image == nil{
            showSwiftyAlert("", "Marker logo not selected. Choose an image to upload.", false)
        }else if txtFldName.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "Pop-up title is required.", false)
        }else if !(txtFldName.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your pop-up title should contain meaningful text", false)

        }else if txtVwDescription.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "Description of the pop-up is required.", false)
        }else if !(txtVwDescription.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your description should contain meaningful text", false)
        }else if txtFldPopupType.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "Select the pop-up type.", false)
        }else if txtFldLOcation.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "Location is required.", false)
        }else if txtFldStartDate.text?.trimWhiteSpace.isEmpty == true && txtFldStartTime.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "Start date and time are required.", false)
        }else if txtFldStartDate.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "Start date is required.", false)
        }else if txtFldStartTime.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "Start time is required.", false)
        }else if txtFldEndDate.text?.trimWhiteSpace.isEmpty == true && txtFldEndTime.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "End date and time are required.", false)
        }else if txtFldEndDate.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "End date is required.", false)
        }else if txtFldEndTime.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "End time is required.", false)
//        }else if txtFldAvailability.text == ""{
//            showSwiftyAlert("", "Please enter your availability.", false)
//
//        }else if arrProducts.isEmpty && arrEditProducts.isEmpty {
//                showSwiftyAlert("", "Add your product", false)
        }else{
            let startDateTimeString = "\(txtFldStartDate.text ?? "") \(txtFldStartTime.text ?? "")"
            let endDateTimeString = "\(txtFldEndDate.text ?? "") \(txtFldEndTime.text ?? "")"
            let startDateTimeUTC = convertToUTC(from: startDateTimeString, with: "dd-MM-yyyy h:mm a") ?? ""
            let endDateTimeUTC = convertToUTC(from: endDateTimeString, with: "dd-MM-yyyy h:mm a") ?? ""
            print("Start Time UTC:", startDateTimeUTC)
            print("End Time UTC:", endDateTimeUTC)
           
                    viewModel.AddPopUpApi(usertype: "user", place: txtFldLOcation.text ?? "", storeType: popUptype, name: txtFldName.text ?? "", business_logo: imgVwPopupLogo, startDate: startDateTimeUTC, endDate: endDateTimeUTC, lat: lat ?? 0.0,long: long ?? 0.0,deals: txtFldDealingOffer.text ?? "", availability: 0, description: txtVwDescription.text ?? "", categoryType: popUptype, addProducts: arrProducts, addItems: arrItems, closedDays: arrDays
                                          //, arrImages: productImg
                    ) { message in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                        vc.isSelect = 10
                        vc.message = message
                        myPopUpLat = self.lat ?? 0
                        myPopUpLong = self.long ?? 0
                        addPopUp = true
                        Store.tabBarNotificationPosted = false
                        vc.callBack = {[weak self] in
                            guard let self = self else { return }
                            isSelectAnother = false
                            SceneDelegate().PopupListVCRoot()
                            
                        }
                        vc.modalPresentationStyle = .overFullScreen
                        self.navigationController?.present(vc, animated: true)
                    }
                      

        }
    }
    func convertToUTC(from dateString: String, with format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = dateFormatter.date(from: dateString) {
            let utcFormatter = DateFormatter()
            utcFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            utcFormatter.timeZone = TimeZone(identifier: "UTC")
            utcFormatter.locale = Locale(identifier: "en_US_POSIX")
            return utcFormatter.string(from: date)
        }

        return nil
    }
    @IBAction func actionLocation(_ sender: UIButton) {
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentLocationVC") as! CurrentLocationVC
        vc.isComing = false
        vc.isUpdate = updateLocation
        vc.latitude = lat
        vc.longitude = long
        vc.callBack = { [weak self] location in
            guard let self = self else { return }
            self.updateLocation = true
            self.txtFldLOcation.text = location.placeName ?? ""
            self.lat = location.lat
            self.long = location.long
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAddItem(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddItemsVC") as! AddItemsVC
        vc.callBack = { [weak self] itemName, itemCategory, sellingType, totalStock,stockType,sellingPrice,image,descriptionq,isHide,discount,discountType in
            guard let self = self else { return }
          
            self.arrItems.insert(AddItems(itemName: itemName ?? "", price: Double(sellingPrice ?? 0), id: "", discount: discount, discountType: discountType, itemCategory: itemCategory, sellingPrice: Double(sellingPrice ?? 0), sellingType: sellingType, stockType: stockType, totalStock: totalStock, isSelected: false, description: "", image: image, soldItems: 0), at: 0)
            
            
            self.vwItems.isHidden = false
        
            self.collVwItems.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                    if self.arrItems.count > 0{
                        self.heightCollvwItems.constant = 220
                    }else{
                        self.heightCollvwItems.constant = 0
                    }
                
                if self.arrItems.count > 2{
                    self.btnSeeAll.isHidden = false
                }else{
                    self.btnSeeAll.isHidden = true
                }
            }
          
        }
        self.navigationController?.pushViewController(vc, animated:true)
    }
 
    @IBAction func actionSeeallItem(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ItemsListVC") as? ItemsListVC else { return }
          
          vc.isComingFrom = "seeAll"
          vc.isComingUpdate = isComing
          vc.arrAddItem = arrItems

          vc.callBackAdd = { [weak self] items in
              guard let self = self else { return }

              let updatedItems = items ?? []
              self.arrItems.removeAll { $0.id != "" }
              self.selectedItem.removeAll()

              // Remove all items where id is not empty
             

              // Append selected items to arrItems
              for i in items ?? [] {
                  
                  let newItem = AddItems(
                    itemName: i.itemName ?? "",
                      price: i.sellingPrice,
                      id: i.id ?? "",
                      discount: i.discount ?? 0,
                      discountType: i.discountType ?? 0,
                      itemCategory: i.itemCategory ?? "",
                      sellingPrice: i.sellingPrice ?? 0,
                      sellingType: i.sellingType ?? 0,
                      stockType: i.stockType ?? 0,
                      totalStock: i.totalStock ?? 0,
                      isSelected: false,
                      description: "",
                      image: i.image,
                      soldItems: Double(i.soldItems ?? 0)
                  )
                  self.arrItems.append(newItem)
                  
                  let newItemSelected = AllItem(popupID: "", item: Item(itemName: i.itemName ?? "", itemCategory: i.itemCategory ?? "", sellingType: i.sellingType ?? 0, stockType: i.stockType ?? 0, image: i.image, description: "", isHide: i.isHide, discountType: i.discountType ?? 0, id: i.id ?? "", discount: i.discount ?? 0, totalStock: i.totalStock ?? 0, sellingPrice: i.sellingPrice ?? 0, soldItems: i.soldItems ?? 0))
                  self.selectedItem.append(newItemSelected)
              }
         
              self.vwItems.isHidden = false
              self.collVwItems.reloadData()

              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  self.heightCollvwItems.constant = self.arrItems.isEmpty ? 0 : 220
                  self.btnSeeAll.isHidden = self.arrItems.count <= 2
                  self.view.layoutIfNeeded() // <-- Important
              }
          }

          navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionexistingItem(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemsListVC") as? ItemsListVC else { return }

        vc.isComingFrom = "existing"
        vc.selectedItems = self.selectedItem

        vc.callBack = { [weak self] selectedItems in
            guard let self = self else { return }

         

            self.selectedItem = selectedItems ?? []

            // Remove all items where id is not empty
            self.arrItems.removeAll { $0.id != "" }

            // Append selected items to arrItems
            for i in self.selectedItem {
                guard let item = i.item else { continue }

                let newItem = AddItems(
                    itemName: item.itemName ?? "",
                    price: item.sellingPrice,
                    id: item.id ?? "",
                    discount: item.discount ?? 0,
                    discountType: item.discountType ?? 0,
                    itemCategory: item.itemCategory ?? "",
                    sellingPrice: item.sellingPrice ?? 0,
                    sellingType: item.sellingType ?? 0,
                    stockType: item.stockType ?? 0,
                    totalStock: item.totalStock ?? 0,
                    isSelected: false,
                    description: "",
                    image: item.image,
                    soldItems: Double(item.soldItems ?? 0)
                )
                self.arrItems.append(newItem)
            }
            
            self.vwItems.isHidden = false
            self.collVwItems.reloadData()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.heightCollvwItems.constant = self.arrItems.isEmpty ? 0 : 220
                self.btnSeeAll.isHidden = self.arrItems.count <= 2
                self.view.layoutIfNeeded() // <-- Important
            }
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionChooseDays(_ sender: UIButton) {
        view.endEditing(true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "days"
        vc.modalPresentationStyle = .popover
        vc.callBack = { [weak self] type, title, id in
            guard let self = self else { return }
            self.collVwDays.isHidden = false
            self.arrDays.append(title)
            self.collVwDays.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.heightDaysCollVw.constant = self.collVwDays.contentSize.height
          
            }
        }
        vc.arrSelectedDays = arrDays
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(width: txtFldDays.frame.size.width, height: 350)
        self.present(vc, animated: false)
    }
}

extension AddPopUpVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwItems{
           
                if arrItems.count > 0{
                    return min(2, arrItems.count)
                }else{
                    return 0
                }
            
        }else{
            return arrDays.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwItems{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddItemCVC", for: indexPath) as! AddItemCVC
         
                cell.lblItemName.text = arrItems[indexPath.row].itemName ?? ""
                cell.imgVwItem.imageLoad(imageUrl: arrItems[indexPath.row].image?[0] ?? "")
                let itemData = arrItems[indexPath.row]
                cell.lblItemName.text = itemData.itemName ?? ""
              
                cell.imgVwItem.imageLoad(imageUrl: itemData.image?[0] ?? "")
               
                let sellingPrice = itemData.sellingPrice ?? 0
                let discount = itemData.discount ?? 0
                let discountType = itemData.discountType ?? 0
                if itemData.discount == 0{
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
                cell.vwBackground.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 3, offset:CGSize(width: 2, height: 2))
                cell.btnSelect.isHidden = true
                cell.btnDelete.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
                cell.btnDelete.tag = indexPath.row

            
            return cell
        }else{
            let cell = collVwDays.dequeueReusableCell(withReuseIdentifier: "SubCategoriesCVC", for: indexPath) as! SubCategoriesCVC
            cell.lblSubCategory.text = arrDays[indexPath.row]
            cell.btnCross.addTarget(self, action: #selector(deleteDays), for: .touchUpInside)
            cell.btnCross.tag = indexPath.row
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwItems{
            return CGSize(width: collVwItems.frame.width/2-2, height: 220)
        }else{
            return CGSize(width: 100, height: 34)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collVwItems{
            return 2
        }else{
            return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collVwItems{
            return 2
        }else{
            return 0
        }
    }
    @objc func deleteItem(sender:UIButton){
        let removedItem = arrItems[sender.tag]
        arrItems.remove(at: sender.tag)

        // Remove from selectedItem by matching itemName
        if let nameToRemove = removedItem.itemName {
            selectedItem.removeAll { $0.item?.itemName == nameToRemove }
        }
        collVwItems.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.heightCollvwItems.constant = self.collVwItems.contentSize.height
       
                if self.arrItems.count > 0{
                    self.heightCollvwItems.constant = 220
                }else{
                    self.heightCollvwItems.constant = 0
                }
            
    
        }
        if arrItems.count == 0{
            self.vwItems.isHidden = true
        }
    }
    @objc func deleteDays(sender:UIButton){
        arrDays.remove(at: sender.tag)
        self.collVwDays.reloadData()
        if arrDays.count == 0{
            self.collVwDays.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.heightDaysCollVw.constant = self.collVwDays.contentSize.height
      
        }
    }
    
}

//MARK: - UITableViewDelegate
extension AddPopUpVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComing == true{
            if arrEditProducts.count > 0{
                return arrEditProducts.count
            }else{
                return 0
            }
        }else{
            if arrProducts.count > 0{
                return arrProducts.count
            }else{
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddedProductListTVC", for: indexPath) as! AddedProductListTVC
        if isComing == true{
            if arrEditProducts[indexPath.row].isHide ?? false{
                cell.viewForHIdeOrNot.isHidden = false
            }else{
                cell.viewForHIdeOrNot.isHidden = true
            }
            cell.lblProductName.text = arrEditProducts[indexPath.row].productName ?? ""
            cell.lblPrice.text = "$\(arrEditProducts[indexPath.row].price ?? 0)"
            cell.imgVwProduct.imageLoad(imageUrl: arrEditProducts[indexPath.row].image?.first ?? "")
        }else{
            if arrProducts[indexPath.row].isHide ?? false{
                cell.viewForHIdeOrNot.isHidden = false
            }else{
                cell.viewForHIdeOrNot.isHidden = true
            }
            cell.lblProductName.text = arrProducts[indexPath.row].name ?? ""
            cell.lblPrice.text = "$\(arrProducts[indexPath.row].price ?? 0)"
            cell.imgVwProduct.imageLoad(imageUrl: arrProducts[indexPath.row].images ?? "")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        view.endEditing(true)
        
        let isHidden: Bool
        if isComing {
            isHidden = arrEditProducts[indexPath.row].isHide ?? false
        } else {
            isHidden = arrProducts[indexPath.row].isHide ?? false
        }

        let hideIcon = isHidden ? "hideProduct" : "unHide"

        // Hide Action
        let hideAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            self.handleHideAction(at: indexPath)
            completionHandler(true)
        }
        hideAction.image = UIImage(named: hideIcon)
        hideAction.backgroundColor = .white

        // Edit Action
        let editAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            self.handleEditAction(at: indexPath)
            completionHandler(true)
        }
        editAction.image = UIImage(named: "editProduct 1")
        editAction.backgroundColor = .white

        // Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.handleDeleteAction(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "deleteProduct 1")
        deleteAction.backgroundColor = .white

        let configuration = UISwipeActionsConfiguration(actions: [hideAction, editAction, deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    // MARK: - Action Handlers
    private func handleDeleteAction(at indexPath: IndexPath) {
        print("Delete action tapped at row \(indexPath.row)")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
        vc.isSelect = 26
        vc.callBack = { [weak self] in
            guard let self = self else { return }
            self.vwAddProduct.isHidden = true
            
            if isComing {
                self.arrEditProducts.remove(at: indexPath.row)
                self.heightProductList.constant = CGFloat(self.arrEditProducts.count * 94)
          
                self.vwAddProduct.isHidden = !self.arrEditProducts.isEmpty
            } else {
                self.arrProducts.remove(at: indexPath.row)
                self.heightProductList.constant = CGFloat(self.arrProducts.count * 94)
               
                self.vwAddProduct.isHidden = !self.arrProducts.isEmpty
            }
            self.tblVwProductList.reloadData()
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func handleEditAction(at indexPath: IndexPath) {
        print("Edit action tapped at row \(indexPath.row)")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditProductVC") as! AddEditProductVC
        vc.isEdit = true
        vc.index = indexPath.row
        vc.isComing = isComing
        if isComing {
            
            vc.arrEditProducts = arrEditProducts
            vc.callBack = { [weak self] productName, price, description, productImages, isHide in
                guard let self = self else { return }
                
                arrEditProducts = popupDetails?.addProducts  ?? []
                
                DispatchQueue.main.async {
                    self.arrEditProducts[indexPath.row] = AddProducts(productName: productName, price: price, id: "", description: description, image: [productImages ?? ""], isHide: isHide)
                    self.tblVwProductList.reloadData()
                }
            }
        } else {
            vc.arrProducts = arrProducts
            vc.callBack = { [weak self] productName, price, description, productImages, isHide in
                guard let self = self else { return }
                self.arrProducts[indexPath.row] = Products(name: productName, price: price, images: productImages, description: description, isHide: isHide)
                self.tblVwProductList.reloadData()
            }
        }

        if let navigationController = self.navigationController {
            navigationController.pushViewController(vc, animated: true)
        } else {
            let navVC = UINavigationController(rootViewController: vc)
            self.present(navVC, animated: true, completion: nil)
        }
    }

    private func handleHideAction(at indexPath: IndexPath) {
        print("Hide action tapped at row \(indexPath.row)")
        
        if isComing {
            arrEditProducts[indexPath.row].isHide?.toggle()
        } else {
            arrProducts[indexPath.row].isHide?.toggle()
        }
        
        tblVwProductList.reloadData()
    }

}

//MARK: - uitextfielddelegates
extension AddPopUpVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldName{
            txtFldName.resignFirstResponder()
            txtVwDescription.becomeFirstResponder()
        }
        return true
    }
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            // Check if the text field is `txtFldTitle`
//
//            if textField == txtFldName{
//                let allowedCharacters = CharacterSet.letters.union(CharacterSet.whitespaces)
//                return string.rangeOfCharacter(from: allowedCharacters) != nil || string.isEmpty
//            }
//
//            return true
//        }

}
//MARK: - UITextViewDelegate
extension AddPopUpVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        lblDescriptionCount.text = "\(characterCount)/250"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 250
    }
}
//MARK: - Handle textfields datepicker
extension AddPopUpVC {
    
    func setupDatePickers() {
        setupDatePicker(for: txtFldStartDate, mode: .date, selector: #selector(startDateDonePressed))
        setupDatePicker(for: txtFldEndDate, mode: .date, selector: #selector(endDateDonePressed))
        setupDatePicker(for: txtFldStartTime, mode: .time, selector: #selector(startTimeDonePressed))
        setupDatePicker(for: txtFldEndTime, mode: .time, selector: #selector(endTimeDonePressed))
    }

    func setupDatePicker(for textField: UITextField, mode: UIDatePicker.Mode, selector: Selector) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        textField.inputView = datePicker
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        if textField == txtFldStartDate || textField == txtFldEndDate {
            datePicker.minimumDate = Date()
        }

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
            updateTextField(txtFldStartDate, datePicker: sender)
            if let endPicker = txtFldEndDate.inputView as? UIDatePicker {
                endPicker.minimumDate = sender.date
            }
        case 2:
            updateTextField(txtFldEndDate, datePicker: sender)
            if let startPicker = txtFldStartDate.inputView as? UIDatePicker {
                startPicker.maximumDate = sender.date
            }
        case 3:
            updateTextField(txtFldStartTime, datePicker: sender)
        case 4:
            updateTextField(txtFldEndTime, datePicker: sender)
        default:
            break
        }
    }

    func updateTextField(_ textField: UITextField, datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if textField == txtFldStartDate || textField == txtFldEndDate {
            dateFormatter.dateFormat = "dd-MM-yyyy"
        } else if textField == txtFldStartTime || textField == txtFldEndTime {
            dateFormatter.dateFormat = "h:mm a"
        }
        textField.text = dateFormatter.string(from: datePicker.date)
        validateDateAndTime()
    }

    @objc func startDateDonePressed() {
        if let datePicker = txtFldStartDate.inputView as? UIDatePicker {
            updateTextField(txtFldStartDate, datePicker: datePicker)
            if let endDatePicker = txtFldEndDate.inputView as? UIDatePicker {
                endDatePicker.minimumDate = datePicker.date
            }
        }
        txtFldStartDate.resignFirstResponder()
    }

    @objc func endDateDonePressed() {
        if let datePicker = txtFldEndDate.inputView as? UIDatePicker {
            updateTextField(txtFldEndDate, datePicker: datePicker)
            if let startDatePicker = txtFldStartDate.inputView as? UIDatePicker {
                startDatePicker.maximumDate = datePicker.date
            }
        }
        txtFldEndDate.resignFirstResponder()
    }

    @objc func startTimeDonePressed() {
        if let datePicker = txtFldStartTime.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let currentDate = dateFormatter.string(from: Date())
            let selectedStartDateText = txtFldStartDate.text ?? ""
//            if selectedStartDateText == currentDate {
//                datePicker.minimumDate = Date()
//            } else {
//                datePicker.minimumDate = nil
//            }
            updateTextField(txtFldStartTime, datePicker: datePicker)
        }
        txtFldStartTime.resignFirstResponder()
    }

    @objc func endTimeDonePressed() {
        if let datePicker = txtFldEndTime.inputView as? UIDatePicker {
            updateTextField(txtFldEndTime, datePicker: datePicker)
        }
        txtFldEndTime.resignFirstResponder()
    }

    @objc func actionStartTime() {
        if let datePicker = txtFldStartTime.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "h:mm a"
            selectedStartTime = dateFormatter.string(from: datePicker.date)
            let currentDate = Date()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let currentDateString = dateFormatter.string(from: currentDate)
            if txtFldStartDate.text == currentDateString {
                if datePicker.date < currentDate {
                    datePicker.date = currentDate
                    txtFldStartTime.text = nil
                } else {
                    datePicker.minimumDate = currentDate
                    txtFldStartTime.text = selectedStartTime
                }
            } else {
                datePicker.minimumDate = nil
                txtFldStartTime.text = selectedStartTime
            }
        }
    }
    func validateDateAndTime() {
        guard
            let startDateText = txtFldStartDate.text, !startDateText.isEmpty,
            let endDateText = txtFldEndDate.text, !endDateText.isEmpty,
            let startTimeText = txtFldStartTime.text, !startTimeText.isEmpty,
            let endTimeText = txtFldEndTime.text, !endTimeText.isEmpty
        else {
            return
        }

        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateTimeFormatter.dateFormat = "dd-MM-yyyy h:mm a"

        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateOnlyFormatter.dateFormat = "dd-MM-yyyy"

        let now = Date()
        let currentDateStr = dateOnlyFormatter.string(from: now)

        guard
            let startDateTime = dateTimeFormatter.date(from: "\(startDateText) \(startTimeText)"),
            let endDateTime = dateTimeFormatter.date(from: "\(endDateText) \(endTimeText)"),
            let startDateOnly = dateOnlyFormatter.date(from: startDateText),
            let endDateOnly = dateOnlyFormatter.date(from: endDateText),
            let currentDateOnly = dateOnlyFormatter.date(from: currentDateStr)
        else {
            return
        }

        let isStartToday = Calendar.current.isDate(startDateOnly, inSameDayAs: currentDateOnly)
        let isSameStartEndDate = Calendar.current.isDate(startDateOnly, inSameDayAs: endDateOnly)

        // ✅ If start and end dates are the same and today
        if isStartToday && isSameStartEndDate {
            if endDateTime <= now {
                txtFldEndTime.text = nil
                showSwiftyAlert("", "End time must be greater than current time.", false)
                
                return
            }
            if endDateTime <= startDateTime {
                txtFldEndTime.text = nil
                showSwiftyAlert("", "End time must be greater than start time.", false)
                
                return
            }
        }
        // ✅ If just start and end date are the same (but not necessarily today)
        else if isSameStartEndDate {
            if endDateTime <= startDateTime {
                txtFldEndTime.text = nil
                showSwiftyAlert("", "End time must be greater than start time.", false)
                
                return
            }
        }
    }


    func convertDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if dateString.contains(".") {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func convertTimeString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if dateString.contains(".") {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }



}

   


//MARK: - CLLocationManagerDelegate
extension AddPopUpVC:CLLocationManagerDelegate{
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

// MARK: - Popup
extension AddPopUpVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
