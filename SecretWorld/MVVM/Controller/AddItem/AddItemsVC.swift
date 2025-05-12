//
//  AddItemsVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 23/04/25.
//

import UIKit
import QBImagePickerController
import TOCropViewController

struct DiscountData {
    let id: String?
    let discount: String?
    let discountType:Int?
}

class AddItemsVC: UIViewController{
    
    @IBOutlet weak var lblSellingPrice: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgPickerVw: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var vwAddNewDiscount: UIView!
    @IBOutlet weak var imgVwItem: UIImageView!
    @IBOutlet weak var txtFldNewDiscount: UITextField!
    @IBOutlet weak var txtFldDiscount: UITextField!
    @IBOutlet weak var btnDiscountPer: UIButton!
    @IBOutlet weak var btnDiscounPrice: UIButton!
    @IBOutlet weak var txtFldPrice: UITextField!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var txtFldUnit: UITextField!
    @IBOutlet weak var btnKg: UIButton!
    @IBOutlet weak var btnGram: UIButton!
    @IBOutlet weak var txtFldSellingType: UITextField!
    @IBOutlet weak var vwNewCategory: UIView!
    @IBOutlet weak var txtFldNewCategory: UITextField!
    @IBOutlet weak var txtFldCategoryName: UITextField!
    @IBOutlet weak var txtFldItemName: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    
    var arrCategory = [Skills]()
    var selectedCategory = [Skills]()
    
    var arrDiscout = [DiscountData]()
    var arrSelectedDiscount = [DiscountData]()
    
    private var getCategory = false
    private var viewModel = ItemsVM()
    private var viewModelImg = UploadImageVM()
    private var discountType = 0
    private var sellingType = 0
    private var stockType = 0
    private var ishidden = false
    private var arrImg = [String]()
    private var uploadImg = false
    private var discount:Double = 0
    private var categoryId:String = ""
    var callBack:((_ itemName:String?,_ itemCategory:String?,_ sellingType:Int,_ totalStock:Double?,_ stockType:Int?,_ sellingPrice:Double?,_ image:[String]?,_ description:String?,_ isHide:Bool?,_ discount:Double?,_ discountType:Int?)->())?
    
    var isComingEdit = false
    var addSingleItem = false
    var itemDetail:AddItems?
    var addItemDetail:AddItems?
    var popupId:String?
    var callBackEdit:((_ message:String?)->())?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
        
    }
    
    func uiSet(){
        txtFldNewDiscount.delegate = self
        self.txtFldUnit.delegate = self
        self.txtFldPrice.delegate = self
        self.txtFldPrice.keyboardType = .decimalPad
        self.txtFldNewDiscount.delegate = self
        self.txtFldNewDiscount.keyboardType = .decimalPad
        getItemsCategoryApi()
        getItemDiscountApi()
        if isComingEdit{
            self.lblHeader.text = "Edit item"
         
            self.txtFldItemName.text = itemDetail?.itemName ?? ""
            self.txtFldCategoryName.text = itemDetail?.itemCategory ?? ""
         
            txtFldSellingType.text = (itemDetail?.sellingType == 0) ? "By weight" : "By unit"
            self.txtFldUnit.text = "\(itemDetail?.totalStock ?? 0)"
            self.txtFldPrice.text = "\(itemDetail?.sellingPrice ?? 0)"
            
            self.txtFldDiscount.text = (itemDetail?.discountType == 0) ?  "$\(itemDetail?.discount ?? 0)" : "\(itemDetail?.discount ?? 0)%"
         
            self.arrImg.insert(contentsOf: itemDetail?.image ?? [], at: 0)
            self.imgVwItem.imageLoad(imageUrl: itemDetail?.image?[0] ?? "")
            self.uploadImg = true
            self.selectedCategory.removeAll()
            self.selectedCategory.insert(Skills(id: "0", name: "Add new category"), at: 0)
            self.selectedCategory.insert(Skills(id: "", name: itemDetail?.itemCategory ?? ""), at: 1)
            self.btnSave.setTitle("Edit item", for: .normal)
            self.btnDelete.isHidden = false
        
            if itemDetail?.sellingType == 0{
                stockType = 0
                btnGram.backgroundColor = UIColor(hex: "#C7E2C4")
                btnKg.backgroundColor = .white
                btnGram.isHidden = false
                btnKg.isHidden = false
                if itemDetail?.stockType == 0{
                    self.lblUnit.text = "g"
                    self.txtFldUnit.keyboardType = .numberPad
                }else{
                    self.lblUnit.text = "kg"
                    self.txtFldUnit.keyboardType = .decimalPad
                }
                sellingType = 0
            }else{
                stockType = 1
                
                btnKg.backgroundColor = UIColor(hex: "#C7E2C4")
                btnGram.backgroundColor = .white
                sellingType = 1
                btnGram.isHidden = true
                btnKg.isHidden = true
                self.lblUnit.text = "unit"
            }
            self.arrSelectedDiscount.removeAll()
            self.arrSelectedDiscount.insert(DiscountData(id: "", discount: "Add new discount", discountType: discountType), at: 0)
            self.arrSelectedDiscount.insert(DiscountData(id: "", discount: "\(itemDetail?.discount ?? 0)", discountType: itemDetail?.discountType ?? 0), at: 1)
            self.discount = itemDetail?.discount ?? 0
        }else{
            
            self.btnDelete.isHidden = true
            self.lblHeader.text = "Add item"
            self.btnSave.setTitle("Save item", for: .normal)
        }
    }
    
    func getItemsCategoryApi(){
        viewModel.getItemsCategoryApi { data in
            self.arrCategory.removeAll()
            self.arrCategory.insert(Skills(id: "0", name: "Add new category"), at: 0)
            self.selectedCategory.insert(Skills(id: "0", name: "Add new category"), at: 0)
            
            
            for i in data?.categories ?? []{
                self.arrCategory.append(Skills(id: i.id, name: i.name))
            }
        }
    }
    
    func getItemDiscountApi(){
        viewModel.getItemdiscountApi(type: discountType) { data in
            self.arrDiscout.removeAll()
            self.arrDiscout.insert(DiscountData(id: "0", discount: "Add new discount", discountType: self.discountType), at: 0)
            self.arrSelectedDiscount.insert(DiscountData(id: "0", discount: "Add new discount", discountType: self.discountType), at: 0)
            
            for i in data?.discounts ?? []{
                self.arrDiscout.append(DiscountData(id: i.id, discount: "\(i.discount ?? 0)",discountType: i.discountType ?? 0))
            }
        }
    }
    
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.async {
                
                let picker: UIImagePickerController = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                self.addChild(picker)
                picker.didMove(toParent: self)
                self.view!.addSubview(picker.view!)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Camera not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        let imagePickerController = QBImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.mediaType = .image
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func actionHideShow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            ishidden = true
        }else{
            ishidden = false
        }
    }
    
    @IBAction func actionUploadImage(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose an option", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Upload From Gallery", style: .default) { _ in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        
        alertController.addAction(cancelAction)
        
        // For iPad support
        alertController.popoverPresentationController?.sourceView = sender
        alertController.popoverPresentationController?.sourceRect = sender.bounds
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionChooseCategory(_ sender: UIButton) {
        view.endEditing(true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "itemCategory"
        vc.arrGetCategories = self.arrCategory
        vc.arrSelectedSkills = self.selectedCategory
        vc.modalPresentationStyle = .popover
        vc.callBack = { [weak self] type, title, id in
            guard let self = self else { return }
            if title == "Add new category"{
                self.selectedCategory.removeAll()
                self.selectedCategory.insert(Skills(id: "0", name: "Add new category"), at: 0)
                self.vwNewCategory.isHidden = false
                self.txtFldCategoryName.text = ""
            }else{
                self.selectedCategory.removeAll()
                self.selectedCategory.insert(Skills(id: "0", name: "Add new category"), at: 0)
                self.selectedCategory.insert(Skills(id: id, name: title), at: 1)
                self.txtFldCategoryName.text = title
                self.vwNewCategory.isHidden = true
            }
            
        }
        let height = CGFloat(arrCategory.count * 50)
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(width: txtFldCategoryName.frame.size.width, height: height)
        self.present(vc, animated: false)
    }
    
    @IBAction func actionAddNewCategory(_ sender: UIButton) {
        if txtFldNewCategory.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "Enter category name.", false)
        }else{
            viewModel.addItemsCategoryApi(name: txtFldNewCategory.text ?? "") {
                self.txtFldCategoryName.text = self.txtFldNewCategory.text
                self.txtFldNewCategory.text = ""
                self.vwNewCategory.isHidden = true
                self.getItemsCategoryApi()
            }
        }
    }
    
    @IBAction func actionSellingType(_ sender: UIButton) {
        view.endEditing(true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "sellingType"
        vc.matchTitle = txtFldSellingType.text ?? ""
        vc.modalPresentationStyle = .popover
        vc.callBack = { [weak self] type, title, id in
            guard let self = self else { return }
            txtFldSellingType.text = title
            if title == "By weight"{
                btnGram.isHidden = false
                btnKg.isHidden = false
                lblUnit.isHidden = false
                if stockType == 0{
                    self.lblUnit.text = "g"
                    self.lblSellingPrice.text = "Selling price(g)"
                }else{
                    self.lblUnit.text = "kg"
                    self.lblSellingPrice.text = "Selling price(kg)"
                }
                sellingType = 0
            }else{
                sellingType = 1
                btnGram.isHidden = true
                btnKg.isHidden = true
                lblUnit.isHidden = false
                self.lblUnit.text = "unit"
                self.lblSellingPrice.text = "Selling price"
              
            }
        }
        let height = CGFloat(100)
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(width: txtFldSellingType.frame.size.width, height: height)
        self.present(vc, animated: false)
        
    }
    
    @IBAction func actionChooseDiscount(_ sender: UIButton) {
        if txtFldPrice.text?.trimWhiteSpace.isEmpty == true {
            showSwiftyAlert("", "Enter selling price", false)
         
        }else{
            view.endEditing(true)
            let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
            vc.type = "itemDiscount"
            vc.arrItemDiscount = self.arrDiscout
            vc.arrSelectedItemDiscount = self.arrSelectedDiscount
            vc.modalPresentationStyle = .popover
            vc.callBack = { [weak self] type, title, id in
                guard let self = self else { return }
                if title == "Add new discount"{
                    self.arrSelectedDiscount.removeAll()
                    self.arrSelectedDiscount.insert(DiscountData(id: "", discount: "Add new discount", discountType: discountType), at: 0)
                    self.vwAddNewDiscount.isHidden = false
                    self.txtFldNewDiscount.text = ""
                }else{
                    self.arrSelectedDiscount.removeAll()
                    self.arrSelectedDiscount.insert(DiscountData(id: "", discount: "Add new discount", discountType: discountType), at: 0)
                    self.arrSelectedDiscount.insert(DiscountData(id: id, discount: title, discountType: 0), at: 1)
                   
                    let sellingPrice = Double(txtFldPrice.text ?? "") ?? 0
                    let discountValue = Double(title) ?? 0
                    
                    if discountType == 0 {
                        // Discount amount must not exceed selling price
                        if discountValue > sellingPrice {
                            showSwiftyAlert("", "Discount should not be more than selling price", false)
                            
                        }else{
                            self.txtFldDiscount.text = "$\(title)"
                            self.discount = Double(title) ?? 0
                            self.vwAddNewDiscount.isHidden = true
                        }
                    } else {
                        // Discount percentage must not exceed 100
                        if discountValue > 100 {
                            showSwiftyAlert("", "Discount cannot be more than 100%", false)
                           
                        }else{
                            self.txtFldDiscount.text = "\(title)%"
                            self.discount = Double(title) ?? 0
                            self.vwAddNewDiscount.isHidden = true
                        }
                    }
               
                
                }
                
            }
            let height = CGFloat(arrDiscout.count * 50)
            let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
            popOver.sourceView = sender
            popOver.delegate = self
            popOver.permittedArrowDirections = .up
            vc.preferredContentSize = CGSize(width: txtFldDiscount.frame.size.width, height: height)
            self.present(vc, animated: false)
        }
    }
    
    @IBAction func actionAddDiscount(_ sender: UIButton) {
     
        if txtFldNewDiscount.text?.trimWhiteSpace.isEmpty == true{
            showSwiftyAlert("", "Enter discount.", false)
        }else{
            let discount = Double(txtFldNewDiscount.text ?? "")
            viewModel.crateItemDiscountApi(discount: discount ?? 0, discountType: discountType) {
                
                if self.discountType == 0{
                    self.txtFldDiscount.text = "$\(self.txtFldNewDiscount.text ?? "")"
                }else{
                    self.txtFldDiscount.text = "\(self.txtFldNewDiscount.text ?? "")%"
                }
                self.discount = Double(self.txtFldNewDiscount.text ?? "") ?? 0
                self.txtFldNewDiscount.text = ""
                self.vwAddNewDiscount.isHidden = true
                self.getItemDiscountApi()
            }
        }
        
    }
    
    @IBAction func actionDeleteItem(_ sender: UIButton) {
        viewModel.deleteItemAPi(popUpId:popupId ?? "", itemId: itemDetail?.id ?? "") { message in
            self.navigationController?.popViewController(animated: true)
            self.callBackEdit?(message)
        }
    }
    
    @IBAction func actionSaveItem(_ sender: UIButton) {
        guard let itemName = txtFldItemName.text?.trimWhiteSpace, !itemName.isEmpty else {
            showSwiftyAlert("", "Please enter the item name.", false); return
        }
        guard let categoryName = txtFldCategoryName.text?.trimWhiteSpace, !categoryName.isEmpty else {
            showSwiftyAlert("", "Please enter the category name", false); return
        }
        guard let sellingTypes = txtFldSellingType.text?.trimWhiteSpace, !sellingTypes.isEmpty else {
            showSwiftyAlert("", "Please enter the selling type", false); return
        }
        guard let stockText = txtFldUnit.text?.trimWhiteSpace, !stockText.isEmpty, let stock = Double(stockText) else {
            showSwiftyAlert("", "Please enter the total stock", false); return
        }
        if sellingType == 0 && stockType == 0 && stock < 10 {
            showSwiftyAlert("", "Enter total stock more than 10g", false); return
        }
        guard let priceText = txtFldPrice.text?.trimWhiteSpace, !priceText.isEmpty, let price = Double(priceText), price > 0 else {
            showSwiftyAlert("", "Please enter valid item selling price", false); return
        }
        guard uploadImg else {
            showSwiftyAlert("", "Please upload item image", false); return
        }
            if isComingEdit{
                viewModel.editItemApi(popUpId: popupId ?? "", itemId: itemDetail?.id ?? "", itemName: itemDetail?.itemName ?? "", itemCategory: itemDetail?.itemCategory ?? "", sellingType: self.sellingType, totalStock: Int(txtFldUnit.text ?? "") ?? 0, stockType: self.stockType, sellingPrice: Double(self.txtFldPrice.text ?? "") ?? 0, image: self.arrImg, isHide: ishidden, discount: Double(self.discount), discountType: self.discountType) {
                    self.navigationController?.popViewController(animated: true)
                    self.callBackEdit?("")
                }
            }else{
                if addSingleItem{
                   
                    addItemDetail = AddItems(itemName: txtFldItemName.text ?? "", price: Double(txtFldPrice.text ?? ""), id: "", discount: self.discount, discountType: discountType, itemCategory: txtFldCategoryName.text ?? "", sellingPrice: Double(txtFldPrice.text ?? ""), sellingType: sellingType, stockType: stockType, totalStock: Double(txtFldUnit.text ?? ""), isSelected: false, description: "", image: arrImg, soldItems: 0)
                    DispatchQueue.main.asyncAfter(deadline: .now()){
                        self.viewModel.addSingleItemApi(popUpId: self.popupId ?? "", itemDetail: self.addItemDetail) {
                            self.navigationController?.popViewController(animated: true)
                            self.callBackEdit?("")
                        }
                    }
                    
                }else{
                    self.navigationController?.popViewController(animated: true)
                    self.callBack?(txtFldItemName.text ?? "", txtFldCategoryName.text ?? "", sellingType, Double(txtFldUnit.text ?? ""), stockType,Double(txtFldPrice.text ?? ""), arrImg, "", ishidden, Double(self.discount), discountType)
                   
                }
             
            }
        
    }
    
    @IBAction func actionDiscountType(_ sender: UIButton) {
        if sender.tag == 0{
            discountType = 0
            txtFldDiscount.text = "$\(discount)"
            btnDiscounPrice.backgroundColor = UIColor(hex: "#C7E2C4")
            btnDiscountPer.backgroundColor = .white
        }else{
            txtFldDiscount.text = "\(discount)%"
            discountType = 1
            btnDiscountPer.backgroundColor = UIColor(hex: "#C7E2C4")
            btnDiscounPrice.backgroundColor = .white
        }
    }
    
    @IBAction func actionChooseWeight(_ sender: UIButton) {
        if sender.tag == 0{
            stockType = 0
            btnGram.backgroundColor = UIColor(hex: "#C7E2C4")
            btnKg.backgroundColor = .white
            self.lblUnit.text = "g"
            self.lblSellingPrice.text = "Selling price(g)"
            txtFldUnit.keyboardType = .numberPad
        }else{
            stockType = 1
            btnKg.backgroundColor = UIColor(hex: "#C7E2C4")
            btnGram.backgroundColor = .white
            self.lblUnit.text = "kg"
            self.lblSellingPrice.text = "Selling price(kg)"
            txtFldUnit.keyboardType = .decimalPad
        }
    }
}

// MARK: - Popup
extension AddItemsVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}

extension AddItemsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
     
        picker.view!.removeFromSuperview()
        picker.removeFromParent()
        if let image = info[.originalImage] as? UIImage {
            let cropVC = TOCropViewController(image: image)
            cropVC.delegate = self
            
            addChild(cropVC)
            cropVC.view.frame = imgPickerVw.bounds
            imgPickerVw.addSubview(cropVC.view)
            cropVC.didMove(toParent: self)
            
         
            
            imgPickerVw.isHidden = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //        picker.dismiss(animated: true, completion: nil)
        picker.view!.removeFromSuperview()
        picker.removeFromParent()
        
    }
    
}

extension AddItemsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Only validate txtFldNewDiscount field
        if textField == txtFldNewDiscount{
            guard textField == txtFldNewDiscount else { return true }
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // If selling price is empty, block editing and show alert
            if txtFldPrice.text?.trimWhiteSpace.isEmpty == true {
                showSwiftyAlert("", "Enter selling price", false)
                return false
            }
            
            // Parse selling price and updated discount safely
            let sellingPrice = Double(txtFldPrice.text ?? "") ?? 0
            let discountValue = Double(updatedText) ?? 0
            
            if discountType == 0 {
                // Discount amount must not exceed selling price
                if discountValue > sellingPrice {
                    showSwiftyAlert("", "Discount should not be more than selling price", false)
                    return false
                }
            } else {
                // Discount percentage must not exceed 100
                if discountValue > 100 {
                    showSwiftyAlert("", "Discount cannot be more than 100%", false)
                    return false
                }
            }
            
            return true
        }else if textField == txtFldUnit{
            if string.isEmpty {
                return true
            }
            
            // Get new text after editing
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Allow only digits and at most one dot (if stockType == 1)
      
            
            
            let allowedCharacters: CharacterSet = self.stockType == 0
                ? CharacterSet(charactersIn: "0123456789")
                : CharacterSet(charactersIn: "0123456789.")
                
            if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
                return false
            }
            
            // Prevent multiple dots
            let dotCount = newText.filter { $0 == "." }.count
            if dotCount > 1 {
                return false
            }
            
            // Limit to 2 decimal places
            if let dotIndex = newText.firstIndex(of: ".") {
                let decimalPart = newText[newText.index(after: dotIndex)...]
                if decimalPart.count > 2 {
                    return false
                }
            }
            
           
          
            return true
        }else if textField == txtFldPrice || textField == txtFldNewDiscount{
            if string.isEmpty {
                return true
            }
            
            // Get new text after editing
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Allow only digits and at most one dot (if stockType == 1)
      
            
            
            let allowedCharacters: CharacterSet = CharacterSet(charactersIn: "0123456789.")
                
            if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
                return false
            }
            
            // Prevent multiple dots
            let dotCount = newText.filter { $0 == "." }.count
            if dotCount > 1 {
                return false
            }
            
            // Limit to 2 decimal places
            if let dotIndex = newText.firstIndex(of: ".") {
                let decimalPart = newText[newText.index(after: dotIndex)...]
                if decimalPart.count > 2 {
                    return false
                }
            }
            
           
          
            return true
        }
        return true
    }
}
extension AddItemsVC: QBImagePickerControllerDelegate {
   
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        
        guard let selectedAssets = assets as? [PHAsset], !selectedAssets.isEmpty else {
            return
        }
        
   
        
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false  // Allow async processing
        requestOptions.deliveryMode = .highQualityFormat // High-quality image
        requestOptions.resizeMode = .none // Keep original size
        
        for asset in selectedAssets {
            if asset.mediaType == .image {
                
                let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                imageManager.requestImage(
                    for: asset,
                    targetSize: targetSize,
                    contentMode: .aspectFill,
                    options: requestOptions
                ) { [weak self] (image, _) in
                    guard let self = self else { return }
                    if let image = image {
                       
                        let cropVC = TOCropViewController(image: image)
                        cropVC.delegate = self
                        
                        addChild(cropVC)
                        cropVC.view.frame = imgPickerVw.bounds
                        imgPickerVw.addSubview(cropVC.view)
                        cropVC.didMove(toParent: self)
                        
                     
                        
                        imgPickerVw.isHidden = false
                    }
                    
                   
                }
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        
        dismiss(animated: true, completion: nil)
    }
    
  
    
  
}


extension AddItemsVC: TOCropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.willMove(toParent: nil)
        cropViewController.view.removeFromSuperview()
        cropViewController.removeFromParent()
       
        imgPickerVw.isHidden = true

        self.viewModelImg.uploadProductImagesApi(Images: image){ data in
            self.arrImg.insert(contentsOf: data?.imageUrls ?? [], at: 0)
            self.imgVwItem.imageLoad(imageUrl: data?.imageUrls?[0] ?? "")
            self.uploadImg = true
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.willMove(toParent: nil)
        cropViewController.view.removeFromSuperview()
        cropViewController.removeFromParent()
        
//        self.currentCroppingIndex += 1
//        self.cropContainerView.isHidden = true
//
//        self.presentCropperForNextImage()
    }
}
