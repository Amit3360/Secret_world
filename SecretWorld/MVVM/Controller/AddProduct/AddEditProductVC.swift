//
//  AddEditProductVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 20/03/25.
//

import UIKit
import IQKeyboardManagerSwift
class AddEditProductVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var btnHide: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var txtVwDescription: IQTextView!
    @IBOutlet weak var txtFldPrice: UITextField!
    @IBOutlet weak var txtFldProductName: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: - variables
    var viewModel = UploadImageVM()
    var productImg = ""
    var callBack:((_ name:String?,_ price:Int?,_ description:String?,_ img:String?,_ isHide:Bool)->())?
    var arrProducts = [Products]()
    var index = 0
    var isEdit = false
    var isHide = false
    var arrEditProducts = [AddProducts]()
    var isComing = false
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    private func uiSet(){
        txtFldPrice.delegate = self
        txtFldPrice.keyboardType = .numberPad
        if isEdit{
            if isComing{
                lblTitle.text = "Add Product"
                btnAdd.setTitle("Add", for: .normal)
                txtFldProductName.text = arrEditProducts[index].productName ?? ""
                txtFldPrice.text = "\(arrEditProducts[index].price ?? 0)"
                txtVwDescription.text = arrEditProducts[index].description ?? ""
                imgVwProduct.imageLoad(imageUrl: arrEditProducts[index].image?.first ?? "")
                productImg = arrEditProducts[index].image?.first ?? ""
                isHide = arrEditProducts[index].isHide ?? false
                btnHide.isSelected = arrEditProducts[index].isHide ?? false

            }else{
                lblTitle.text = "Update Product"
                btnAdd.setTitle("Update", for: .normal)
                txtFldProductName.text = arrProducts[index].name ?? ""
                txtFldPrice.text = "\(arrProducts[index].price ?? 0)"
                txtVwDescription.text = arrProducts[index].description ?? ""
                imgVwProduct.imageLoad(imageUrl: arrProducts[index].images ?? "")
                productImg = arrProducts[index].images ?? ""
                isHide = arrProducts[index].isHide ?? false
                btnHide.isSelected = arrProducts[index].isHide ?? false

            }
        }
    }
    //MARK: - IBAction
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionHideShow(_ sender: UIButton) {
        sender.isSelected.toggle()
        isHide = sender.isSelected
    }
    
    @IBAction func actionAddImage(_ sender: UIButton) {
        view.endEditing(true)
        ImagePicker().pickImage(self) { image in
            self.viewModel.uploadProductImagesApi(Images: image){ data in
                if let imageUrl = data?.imageUrls?.first {
                    self.productImg = imageUrl
                    self.imgVwProduct.imageLoad(imageUrl: imageUrl)
                }
            }
        }
    }

    @IBAction func actionAdd(_ sender: UIButton) {
        if txtFldProductName.text == ""{
            showSwiftyAlert("", "Please enter the product name", false)
        }else if !(txtFldProductName.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your product name should contain meaningful text", false)
        }else  if txtFldPrice.text == ""{
            showSwiftyAlert("", "Please enter the product price", false)
        }else  if txtVwDescription.text == ""{
            showSwiftyAlert("", "Please enter the product description", false)
        }else if !(txtVwDescription.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your product description should contain meaningful text", false)
        }else  if imgVwProduct.image == UIImage(named: ""){
            showSwiftyAlert("", "Please upload the product image", false)
        }else{
            self.navigationController?.popViewController(animated: true)
            self.callBack?(txtFldProductName.text ?? "",Int(txtFldPrice.text ?? ""),txtVwDescription.text ?? "",productImg, isHide)
        }
    }
    @IBAction func actionDelete(_ sender: UIButton) {
    }
    
}
// MARK: - UITextFieldDelegate Method
extension AddEditProductVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the text field is the price field
        if textField == txtFldPrice {
            if string.isEmpty {
                return true
            }
            
            // Get new text after editing
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Allow only digits and at most one dot (if stockType == 1)
      
            
            
            let allowedCharacters: CharacterSet = CharacterSet(charactersIn: "0123456789")
                
            if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
                return false
            }
           
            return true
        }
        return true
    }
}
