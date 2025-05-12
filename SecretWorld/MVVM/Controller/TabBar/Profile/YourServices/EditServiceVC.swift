//
//  EditServiceVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/01/24.
//

import UIKit
import IQKeyboardManagerSwift
import AlignedCollectionViewFlowLayout

class EditServiceVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet var txtFldAddOwnServices: UITextField!
    @IBOutlet var heightTxtFldAddownService: NSLayoutConstraint!
    @IBOutlet var heightBtnAddOwnSubcategory: NSLayoutConstraint!
    @IBOutlet var btnAddOwnSubCategories: UIButton!
    @IBOutlet var heightCollvWServiceImgs: NSLayoutConstraint!
    @IBOutlet var collVwServiceImages: UICollectionView!
    @IBOutlet var txtFldDiscount: UITextField!
    @IBOutlet var txtFldSearch: UITextField!
    @IBOutlet var heightSelectedSubCat: NSLayoutConstraint!
    @IBOutlet var heightSuggestSubCat: NSLayoutConstraint!
    @IBOutlet var collVwSuggestSubCate: UICollectionView!
    @IBOutlet var collVwSubcategory: UICollectionView!
    @IBOutlet var btnAddEdit: UIButton!
    @IBOutlet var lblTextCount: UILabel!
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var txtFldAmount: UITextField!
    @IBOutlet var txtvwDescription: IQTextView!
    @IBOutlet var txtFldServicename: UITextField!
    @IBOutlet var txtFldName: UITextField!
    
    //MARK: - VARIABLES
    var viewModelUpload = UploadImageVM()
    var editServiceDetail:GetServiceDataaa?
    var offset = 1
    var limit = 100
    var viewModel = AddServiceVM()
    var isComing = false
    var isUploading = true
    var serviceId = ""
    var isGetCategories = false
    var callBack:(()->())?
    var arrEdit = [Any]()
    var arrSubCategories = [Subcategory]()
    var arrServiceImages = [""]
    var arrUploadImg = [UIImage]()
    var arrSelectSubCate = [Subcategoryz]()
    var arrDeletedImg:[String]?
    var isCreate = false
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }

    func uiSet(){
        txtFldAddOwnServices.delegate = self
        getServiceApi(text: "")
        Store.ServiceImg = nil
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        txtvwDescription.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        registedNibs()
        setCollectionviewsLayout()
        if isComing == true{
            lblScreenTitle.text = "Create a Service"
            lblTextCount.text = "0/250"
            btnAddEdit.setTitle("Save", for: .normal)
           // getCategoryApi()
        }else{
            for i in editServiceDetail?.serviceImages ?? []{
                arrServiceImages.append(i)
            }
            lblScreenTitle.text = "Edit Service"
            btnAddEdit.setTitle("Update", for: .normal)
            txtFldServicename.text = editServiceDetail?.serviceName ?? ""
            txtFldAmount.text = "\(editServiceDetail?.price ?? 0)"
            txtFldDiscount.text = "\(editServiceDetail?.discount ?? 0)"
            txtvwDescription.text = editServiceDetail?.description ?? ""
            let textViewTextCount = txtvwDescription.text.count
            print("Character count: \(textViewTextCount)")
            lblTextCount.text = "\(textViewTextCount)/250"
        }
        collVwSubcategory.reloadData()
        updateCollectionViewHeight(for: collVwSubcategory, heightConstraint: heightSelectedSubCat)
        adjustCollectionViewHeight()

    }
    @objc func handleSwipe() {
        if isCreate{
            SceneDelegate().tabbarRoots(SelectedIndex: 3)
        }else{
            self.navigationController?.popViewController(animated: true)
        }

        Store.SubCategoriesId = nil
          }
    private func registedNibs(){
        let nibServiceImgs = UINib(nibName: "ProductsCVC", bundle: nil)
        collVwServiceImages.register(nibServiceImgs, forCellWithReuseIdentifier: "ProductsCVC")
        let nibSubCat = UINib(nibName: "SubCategoriesCVC", bundle: nil)
        collVwSubcategory.register(nibSubCat, forCellWithReuseIdentifier: "SubCategoriesCVC")
        let nibSuggestCate = UINib(nibName: "SuggestCategoriesCVC", bundle: nil)
        collVwSuggestSubCate.register(nibSuggestCate, forCellWithReuseIdentifier: "SuggestCategoriesCVC")

    }
    private func setCollectionviewsLayout(){
        let alignedFlowLayoutCollVw = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwSubcategory.collectionViewLayout = alignedFlowLayoutCollVw
        if let flowLayout = collVwSubcategory.collectionViewLayout as? UICollectionViewFlowLayout {
               flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 40)
           }
           
           collVwSubcategory.isScrollEnabled = true // Ensure scrolling is enabled
        if let flowLayout = collVwSubcategory.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 40)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        let customLayout = CustomCollectionViewFlowLayout()
        collVwSuggestSubCate.collectionViewLayout = customLayout
    }
    private func updateHashtagsHeight() {
        guard let flowLayout = collVwSuggestSubCate.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        // Total number of items
        let numberOfItems = arrSubCategories.count
        // Assuming 2 items per row
        let itemsPerRow: CGFloat = 2
        // Calculate number of rows
        let numberOfRows = ceil(CGFloat(numberOfItems) / itemsPerRow)
        // Cell height (you may need to adjust based on design)
        let itemHeight: CGFloat = 40 // Replace with the actual height of your cell
        // Spacing adjustments
        let lineSpacing = flowLayout.minimumLineSpacing
        let sectionInsets = flowLayout.sectionInset

        // Total height calculation
        let totalHeight = (numberOfRows * itemHeight) +
            ((numberOfRows - 1) * lineSpacing)
        heightSuggestSubCat.constant = totalHeight
        self.view.layoutIfNeeded()
    }

    private func getServiceApi(text:String){
        viewModel.getSubCatories(type: 1, offset: offset, limit: limit, search:text) { data in
            self.arrSubCategories = data?.subcategorylist ?? []
            if self.arrSubCategories.count > 0{
                self.heightBtnAddOwnSubcategory.constant = 0
                self.heightTxtFldAddownService.constant = 0
                self.txtFldAddOwnServices.text = ""
            }else{
                self.heightBtnAddOwnSubcategory.constant = 36
                //self.view.endEditing(true)
               // self.heightTxtFldAddownService.constant = 36
            }
            self.collVwSuggestSubCate.reloadData()
            self.updateHashtagsHeight()
        }

    }
    private func updateCollectionViewHeight(for collectionView: UICollectionView, heightConstraint: NSLayoutConstraint) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height
            heightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }

    
    //MARK: - BUTTON ACTIONS
    @IBAction func actionAddOwnServices(_ sender: UIButton) {
        heightTxtFldAddownService.constant = 36
    }
    @IBAction func actionUploadImgs(_ sender: UIButton) {
    }
    @IBAction func actionBack(_ sender: UIButton) {
        if isCreate{
            SceneDelegate().tabbarRoots(SelectedIndex: 3)
            callBack?()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
       // self.navigationController?.popViewController(animated: true)
        Store.SubCategoriesId = nil
    }
    
    
    @IBAction func actionCreate(_ sender: UIButton) {
        var arrSelectedIds = [String]()
        for i in arrSelectSubCate{
            arrSelectedIds.append(i.id)
        }
        if isComing == true{
             if txtFldServicename.text == ""{
                showSwiftyAlert("", "Enter service name", false)
            }else if !(txtFldServicename.text ?? "").isValidInput{
                showSwiftyAlert("", "Invalid Input: your service name should contain meaningful text", false)
            }else if txtvwDescription.text == ""{
                showSwiftyAlert("", "Enter service description", false)
            }else if !(txtvwDescription.text ?? "").isValidInput{
                showSwiftyAlert("", "Invalid Input: your description should contain meaningful text", false)
            }else if arrSelectedIds.count == 0{
                showSwiftyAlert("", "Select service category", false)
            }else if txtFldAmount.text == ""{
                showSwiftyAlert("", "Enter service amount", false)
            }else if Double(txtFldAmount.text ?? "0") ?? 0 <= 0 {
                showSwiftyAlert("", "Enter valid service amount", false)
            }else if arrUploadImg.count == 0{
                showSwiftyAlert("", "Upload service images", false)
            }else{
                viewModel.addServiceApi(serviceName: txtFldServicename.text ?? "", price: txtFldAmount.text ?? "", discount: txtFldDiscount.text ?? "", description: txtvwDescription.text ?? "", serviceImages: arrUploadImg, catSubcatArr: arrSelectedIds) { data,message in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isSelect = 10
                    vc.message = message
                    vc.callBack = {
                        Store.SubCategoriesId = nil
                        SceneDelegate().tabbarRoots(SelectedIndex: 3)
                        self.callBack?()
                        //self.navigationController?.popViewController(animated: true)
                       // SceneDelegate().tabBarMenuVCRoot()
                    }
                    self.navigationController?.present(vc, animated: false)
                }
                
            }
        }else{
                 if txtFldServicename.text == ""{
                    showSwiftyAlert("", "Enter service name", false)
                }else if !(txtFldServicename.text ?? "").isValidInput{
                    showSwiftyAlert("", "Invalid Input: your service name should contain meaningful text", false)
                }else if txtvwDescription.text == ""{
                    showSwiftyAlert("", "Enter service description", false)
                }else if !(txtvwDescription.text ?? "").isValidInput{
                    showSwiftyAlert("", "Invalid Input: your description should contain meaningful text", false)
                }else if arrSelectedIds.count == 0{
                    showSwiftyAlert("", "Select service category", false)
                }else if txtFldAmount.text == ""{
                    showSwiftyAlert("", "Enter service amount", false)
                }else if Double(txtFldAmount.text ?? "0") ?? 0 <= 0 {
                    showSwiftyAlert("", "Enter valid service amount", false)
                }else if arrServiceImages.count == 1{
                    showSwiftyAlert("", "Upload service images", false)
                }else{
                        self.viewModel.EdiServiceApi(service_id: self.serviceId, serviceName: self.txtFldServicename.text ?? "", price: self.txtFldAmount.text ?? "", discount: self.txtFldDiscount.text ?? "", description: self.txtvwDescription.text ?? "", catSubcatArr: arrSelectedIds, serviceImage: self.arrUploadImg, deletedserviceImages: self.arrDeletedImg ?? []) { message in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                            vc.modalPresentationStyle = .overFullScreen
                            vc.isSelect = 10
                            vc.message = message
                            vc.callBack = {
                                self.navigationController?.popViewController(animated: true)
                                self.callBack?()
                            }
                            self.navigationController?.present(vc, animated: false)
                    }
            }
        }
    }
}
//MARK: - UITextViewDelegate
extension EditServiceVC: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        
        lblTextCount.text = "\(characterCount)/250"
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 250
        
    }
}
//MARK: - UICollectionViewDelegate
extension EditServiceVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwSubcategory{
            return  arrSelectSubCate.count
        }else if collectionView == collVwSuggestSubCate{
            return arrSubCategories.count
        }else{
            if arrServiceImages.count > 0{
                return  arrServiceImages.count
            }else{
                return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwSubcategory{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoriesCVC", for: indexPath) as! SubCategoriesCVC
            cell.lblSubCategory.text = arrSelectSubCate[indexPath.item].subcategoryName
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(actionDeleteSubCategory), for: .touchUpInside)

            return cell

        }else if collectionView == collVwSuggestSubCate{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestCategoriesCVC", for: indexPath) as! SuggestCategoriesCVC
            let subCategory = arrSubCategories[indexPath.item]
            let isSelected = arrSelectSubCate.contains { $0.id == subCategory.id }
//            cell.viewSelect.backgroundColor = isSelected ? .app : .white
//            cell.viewSelect.borderWid = isSelected ? 0 : 1
//            cell.viewSelect.borderCol = isSelected ? .clear : .app
            cell.btnSelect.isSelected = isSelected
            cell.lblSubCategory.text = subCategory.name
            return cell

        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCVC", for: indexPath) as! ProductsCVC
            if indexPath.row == 0{
                cell.vwAddProduct.isHidden = false
                cell.imgVwDelete.isHidden = true
                cell.btnDelete.isHidden = true
                cell.imgVwProduct.isHidden = true
                cell.btnAddProduct.addTarget(self, action: #selector(addProductImg), for: .touchUpInside)
                cell.btnAddProduct.tag = 0
            }else{
                cell.vwAddProduct.isHidden = true
                cell.imgVwDelete.isHidden = false
                cell.btnDelete.isHidden = false
                cell.imgVwProduct.isHidden = false
                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(ActionDeleteProduct), for: .touchUpInside)
                cell.imgVwProduct.imageLoad(imageUrl: arrServiceImages[indexPath.row])
            }
             
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwSuggestSubCate {
            let selectedSubCategory = arrSubCategories[indexPath.item]
            let isAlreadySelected = arrSelectSubCate.contains { $0.id == selectedSubCategory.id }
            if !isAlreadySelected {
                arrSelectSubCate.append(Subcategoryz(id: selectedSubCategory.id ?? "", subcategoryName: selectedSubCategory.name ?? ""))
                collVwSuggestSubCate.reloadData()
                collVwSubcategory.reloadData()
                DispatchQueue.main.async {
                                self.updateCollectionViewHeight(for: self.collVwSubcategory, heightConstraint: self.heightSelectedSubCat)
                            }
            }
        }
    }
    @objc func ActionDeleteProduct(sender: UIButton) {
        let indexToDelete = sender.tag
        guard indexToDelete >= 0, indexToDelete < arrServiceImages.count else { return }
        if isComing == false {
            let deletedImage = arrServiceImages[indexToDelete]
            arrServiceImages.remove(at: indexToDelete)
            arrDeletedImg = arrDeletedImg ?? []
            arrDeletedImg?.append(deletedImage)
            adjustCollectionViewHeight()
            collVwServiceImages.reloadData()
        } else {
            arrServiceImages.remove(at: indexToDelete)
            adjustCollectionViewHeight()
            collVwServiceImages.reloadData()
        }
    }
     func adjustCollectionViewHeight() {
        switch arrServiceImages.count {
        case 1, 2:
            heightCollvWServiceImgs.constant = 160
        case 3, 4:
            heightCollvWServiceImgs.constant = 330
        default:
            heightCollvWServiceImgs.constant = 500
        }
    }
    @objc func addProductImg(sender:UIButton){
        if arrServiceImages.count >= 6 {
            showSwiftyAlert("", "You can upload a maximum of 5 images.", false)
            return
          }
        
            ImagePicker().pickImage(self) { image in
                self.viewModelUpload.uploadProductImagesApi(Images: image) { data in
                    self.arrUploadImg.append(image)
                    self.arrServiceImages.insert(data?.imageUrls?[0] ?? "", at: 1)
                    self.adjustCollectionViewHeight()
                    self.collVwServiceImages.reloadData()
                }
                
                
            }
            }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwSuggestSubCate{
            let collectionWidth = collectionView.frame.width
            let itemWidth = (collectionWidth / 2) - 5 // Adjust spacing here
            let itemHeight: CGFloat = 40 // Set a fixed height for all items
            return CGSize(width: itemWidth, height: itemHeight)
        }else if collectionView == collVwSubcategory{
   
            return CGSize(width:0, height: 40)
        }else{
            if self.arrServiceImages.count == 1{
                return CGSize(width: collVwServiceImages.frame.size.width/1, height: 160)
            }else{
                return CGSize(width: collVwServiceImages.frame.size.width/2-5 , height: 160)
            }

        }
    }
    @objc func actionDeleteSubCategory(sender:UIButton){
            let index = sender.tag
            
            if index < arrSelectSubCate.count {
                arrSelectSubCate.remove(at: index)
                collVwSuggestSubCate.reloadData()
                collVwSubcategory.reloadData()
                updateCollectionViewHeight(for: collVwSubcategory, heightConstraint: heightSelectedSubCat)
            }
    }
}

// MARK: - UITextFieldDelegate
extension EditServiceVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldAddOwnServices{
            if txtFldServicename.text == ""{
               showSwiftyAlert("", "Enter service name", false)
           }else if !(txtFldServicename.text ?? "").isValidInput{
               showSwiftyAlert("", "Invalid Input: your service name should contain meaningful text", false)
           }else  if txtFldAddOwnServices.text == ""{
               showSwiftyAlert("", "Enter own sub service name", false)
           }else if !(txtFldAddOwnServices.text ?? "").isValidInput{
               showSwiftyAlert("", "Invalid Input: your own sub service name should contain meaningful text", false)
           }else{
               viewModel.createSubServicesApi(serviceName: txtFldServicename.text ?? "", name: txtFldAddOwnServices.text ?? "") { data in
                   self.view.endEditing(true)
                   self.txtFldAddOwnServices.text = ""
                   self.txtFldSearch.text = ""
                   self.heightBtnAddOwnSubcategory.constant = 0
                   self.heightTxtFldAddownService.constant = 0
                   self.uiSet()
               }
           }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldAmount {
            let currentText = textField.text ?? ""
            
            // Prevent entering '0' at the beginning (unless it's followed by a decimal)
            if string == "0" && currentText.isEmpty {
                return false
            }
            
        }else if textField == txtFldSearch{
                let currentText = txtFldSearch.text ?? ""
                let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
                if newText.isEmpty {
                    getServiceApi(text: "")
                    self.heightBtnAddOwnSubcategory.constant = 0
                    self.heightTxtFldAddownService.constant = 0

                } else {
                    let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
                    getServiceApi(text: newString)
                }
                collVwSuggestSubCate.reloadData()

            }else if textField == txtFldDiscount{
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                if !allowedCharacters.isSuperset(of: characterSet) {
                    return false
                }
                let currentText = textField.text ?? ""
                guard let stringRange = Range(range, in: currentText) else { return true }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                if let value = Int(updatedText) {
                    return value >= 1 && value <= 100
                }
            }
        return true
    }
}
