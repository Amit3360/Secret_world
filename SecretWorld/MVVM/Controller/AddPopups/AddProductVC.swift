//
// AddProductVC.swift
// SecretWorld
//
// Created by IDEIO SOFT on 24/01/24.
//
import UIKit
class AddProductVC: UIViewController {
  //MARK: - OUTLETS
  @IBOutlet var collVwProductImgs: UICollectionView!
  @IBOutlet var viewUploadPhoto: UIView!
  @IBOutlet var lblScreenTitle: UILabel!
  @IBOutlet var btnCancel: UIButton!
  @IBOutlet var viewBack: UIView!
  @IBOutlet var txtFldProductName: UITextField!
  @IBOutlet var txtFldPrice: UITextField!
  @IBOutlet weak var btnAdd: UIButton!
  //MARK: - variables
  var callBack:((_ productName:String,_ price:Int,_ isEdit:Bool,_ images:[String])->())?
  var isComing = false
//  var arrProducts = [Products]()
  var selectedIndex = 0
  var arrEditProducts = [AddProducts]()
  var viewModel = UploadImageVM()
  var arrProductsImages = [String]()
  var callBackDidSelect:((_ arrProductImg:[String])->())?
  override func viewDidLoad() {
    super.viewDidLoad()
    uiSet()
  }
  func uiSet(){
    txtFldProductName.delegate = self
    txtFldPrice.delegate = self
    viewBack.layer.cornerRadius = 35
    viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    if isComing == true{
      lblScreenTitle.text = "Add Product"
      btnAdd.setTitle("Add", for: .normal)
    }else{
      print(selectedIndex)
      lblScreenTitle.text = "Edit Product"
//      if arrEditProducts.count > 0{
//        txtFldProductName.text = arrEditProducts[selectedIndex].productName ?? ""
//        let price = arrEditProducts[selectedIndex].price ?? 0
//        txtFldPrice.text = "\(price)"
//        arrProductsImages = arrEditProducts[selectedIndex].image ?? []
//      }
//      if arrProducts.count > 0{
//        txtFldProductName.text = arrProducts[selectedIndex].name ?? ""
//        let price = arrProducts[selectedIndex].price ?? 0
//        txtFldPrice.text = "\(price)"
//        arrProductsImages = arrProducts[selectedIndex].images ?? []
//      }
    }
    collVwProductImgs.reloadData()
  }
  //MARK: - BUTTON ACTIONS
  @IBAction func actionUploadImage(_ sender: UIButton) {
    if arrProductsImages.count >= 5 {
        showSwiftyAlert("", "You can upload a maximum of 5 images.", false)
        return
      }
    ImagePicker().pickImage(self) { image in
      self.viewModel.uploadProductImagesApi(Images: image){ data in
        self.arrProductsImages.insert(contentsOf: data?.imageUrls ?? [], at: 0)
        self.collVwProductImgs.reloadData()
      }
    }
  }
  @IBAction func actionCancel(_ sender: UIButton) {
    if isComing == true{
      self.dismiss(animated: true)
    }else{
      self.dismiss(animated: true)
    }
  }
  @IBAction func actionAdd(_ sender: UIButton) {
    if txtFldProductName.text == "" {
      showSwiftyAlert("", "Please enter the product name", false)
    }else if txtFldPrice.text == "" {
      showSwiftyAlert("", "Please enter the product price", false)
    }else if Int(txtFldPrice.text ?? "0") ?? 0 <= 0 {
      showSwiftyAlert("", "Please enter valid product price", false)
    }else{
      if isComing == true{
            self.dismiss(animated: true)
            self.callBack?(self.txtFldProductName.text ?? "",
                    Int(self.txtFldPrice.text ?? "") ?? 0,
                    false,
                    arrProductsImages)
      }else{
        self.dismiss(animated: true)
        self.callBack?(self.txtFldProductName.text ?? "",
                Int(self.txtFldPrice.text ?? "") ?? 0,
                false,
                arrProductsImages)
      }
    }
  }
}
//MARK: - UITextFieldDelegate
extension AddProductVC:UITextFieldDelegate{
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == txtFldProductName{
      let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
      let characterSet = CharacterSet(charactersIn: string)
      return allowedCharacters.isSuperset(of: characterSet)
    }else{
      let allowedCharacters = CharacterSet(charactersIn: "0123456789")
          let characterSet = CharacterSet(charactersIn: string)
          return allowedCharacters.isSuperset(of: characterSet)
    }
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    txtFldProductName.resignFirstResponder()
    txtFldPrice.becomeFirstResponder()
    return true
  }
}
//MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension AddProductVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if arrProductsImages.count > 0{
      return min(5, arrProductsImages.count)
    }else{
      return 0
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImagesCVC", for: indexPath) as! ProductImagesCVC
    if arrProductsImages.count > 0{
      cell.btnDelete.tag = indexPath.row
      cell.btnDelete.addTarget(self, action: #selector(ActionDeleteProduct), for: .touchUpInside)
        if let image = arrProductsImages[indexPath.row] as? UIImage {
          cell.imgVwUpload.image = arrProductsImages[indexPath.row] as? UIImage
        }else{
          cell.imgVwUpload.imageLoad(imageUrl: arrProductsImages[indexPath.row] as? String ?? "")
        }
  }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  @objc func ActionDeleteProduct(sender:UIButton){
      let indexToDelete = sender.tag
      arrProductsImages.remove(at: indexToDelete)
      collVwProductImgs.reloadData()
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collVwProductImgs.frame.size.width/2, height: 90)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    dismiss(animated: true)
//    callBackDidSelect?(arrProductsImages)
  }
}
