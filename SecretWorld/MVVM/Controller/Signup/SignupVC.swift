//
//  SignupVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit

class SignupVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet var lblDOBTZitle: UILabel!
    @IBOutlet var lblFullNameTitle: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var lblUpload: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var txtFldGender: UITextField!
    @IBOutlet var txtFldDateOfBirth: UITextField!
    @IBOutlet var txtFldName: UITextField!
    @IBOutlet var viewgender: UIView!
    
    var viewModel = AuthVM()
    var isUploadImage = false
    var dateBirth = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)

        uiSet()
    }
    @objc func handleSwipe() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BackPopPupVC") as! BackPopPupVC
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)
          }

    func uiSet(){
        btnUpload.layer.shadowColor = UIColor.black.cgColor
        btnUpload.layer.shadowOpacity = 0.16
        btnUpload.layer.shadowOffset = CGSize(width: 0, height: 5)
        btnUpload.layer.shadowRadius = 10
        btnUpload.layer.masksToBounds = false
        btnEdit.isUserInteractionEnabled = false
        if isComingSocial == true{
            self.btnUpload.backgroundColor = .clear
            
            imgVwUser.imageLoad(imageUrl: socialDetail["profile"] as? String ?? "")
            txtFldName.text = socialDetail["name"] as? String ?? ""
            self.btnUpload.setImage(UIImage(named: ""), for: .normal)
        }else{
            if Store.role == "b_user"{
                btnUpload.setImage(UIImage(named: "cameraa"), for: .normal)
                lblUpload.text = "Upload logo photo"
                viewgender.isHidden = true
                
                setLabelText(label: lblDOBTZitle, text: "Business since")
                setLabelText(label: lblFullNameTitle, text: "Wish to display business name")
                txtFldName.placeholder = "Wish to display business name"
                
                
            }else{
                txtFldName.placeholder = "Full Name"
                setLabelText(label: lblDOBTZitle, text: "Date of birth")
                setLabelText(label: lblFullNameTitle, text: "Full name")
                viewgender.isHidden = false
                btnUpload.setImage(UIImage(named: "uss"), for: .normal)
                lblUpload.text = "Upload profile photo"
            }
        }
        func setLabelText(label: UILabel, text: String, textColor: UIColor = .black, fontSize: CGFloat = 18) {
            let combinedAttributedString = NSMutableAttributedString(
                string: text,
                attributes: [.foregroundColor: textColor, .font: UIFont.systemFont(ofSize: fontSize)]
            )
            combinedAttributedString.append(NSAttributedString(
                string: " *",
                attributes: [.foregroundColor: UIColor(hex: "#FF4E44"), .font: UIFont.systemFont(ofSize: fontSize)]
            ))
            label.attributedText = combinedAttributedString
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboardWhileClick() {
        view.endEditing(true)
    }
    
    func getImageFromURL(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load image from URL:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Failed to convert data to image")
                completion(nil)
            }
        }.resume()
    }
    
   private func convertDateFormat(inputDate: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM dd, yyyy"
            return outputFormatter.string(from: date)
        }
        
        return nil
    }

    
    //MARK: - Button Actions
    @IBAction func actionEdit(_ sender: UIButton) {
        ImagePicker().pickImage(self) { image in
            self.imgVwUser.image = image
            Store.LogoImage = image
            self.btnUpload.setImage(UIImage(named: ""), for: .normal)
            self.btnUpload.backgroundColor = .clear
            
        }
    }

    @IBAction func actionContinue(_ sender: UIButton) {
        
        
        if Store.role == "b_user"{ //business
            if imgVwUser.image == UIImage(named: ""){
                showSwiftyAlert("", "Upload your logo picture", false)
                
            }else if txtFldName.text == "" {
                
                showSwiftyAlert("", "Enter your business name", false)
                
            }else if !(txtFldName.text ?? "").isValidInput{
                
                showSwiftyAlert("", "Invalid Input: your business name should contain meaningful text", false)
                
            }else if txtFldDateOfBirth.text == "" {
                
                showSwiftyAlert("", "Select your business establish date", false)
                
            }else{
                
                viewModel.CreateAccountApi(usertype:"business", fullname: txtFldName.text ?? "", dob: txtFldDateOfBirth.text ?? "", gender: "", profile_photo: imgVwUser) { data in
                    Store.autoLogin = data?.user?.profile_status
                    Store.userId = data?.user?.id ?? ""
                    Store.BusinessUserDetail = ["userName":data?.user?.name ?? "",
                                                "profileImage":data?.user?.profilePhoto ?? "","userId":data?.user?.id ?? "","mobile":data?.user?.mobile ?? 0,
                                                "countryCode":data?.user?.countrycode ?? ""]
                    if let profilePhoto = data?.user?.profilePhoto  as? UIImage {
                        Store.LogoImage = profilePhoto
                    }
                    WebService.hideLoader()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateBusinessAcVC") as! CreateBusinessAcVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{//user
            if imgVwUser.image == UIImage(named: ""){
                
                showSwiftyAlert("", "No image selected. Please choose an image to upload", false)
                
            }else if txtFldName.text == "" {
                
                showSwiftyAlert("", "Enter your full name", false)
                
            }else if !(txtFldName.text ?? "").isValidInput{
                
                showSwiftyAlert("", "Invalid Input: your full name should contain meaningful text", false)
                
            }else if txtFldDateOfBirth.text == "" {
                
                showSwiftyAlert("", "Enter your date of birth", false)
                
            } else if txtFldGender.text == "" {
                
                showSwiftyAlert("", "Gender selection is required", false)
                
            }else{
                
                viewModel.CreateAccountApi(usertype:"user", fullname: txtFldName.text ?? "", dob: self.dateBirth, gender: txtFldGender.text ?? "", profile_photo: imgVwUser) { data in
                    
                    Store.autoLogin = data?.user?.profile_status
                    Store.userId = data?.user?.id ?? ""
                    Store.UserDetail = ["userName":data?.user?.name ?? "",
                                        "profileImage":data?.user?.profilePhoto ?? "","userId":data?.user?.id ?? "","mobile":data?.user?.mobile ?? 0,
                                        "countryCode":data?.user?.countrycode ?? ""]
                    Store.userLatLong = ["lat":data?.user?.latitude ?? 0,"long":data?.user?.longitude ?? 0]
                    if let profilePhoto = data?.user?.profilePhoto  as? UIImage {
                        Store.LogoImage = profilePhoto
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteSignupVC") as! CompleteSignupVC
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        
        
    }
    @IBAction func actionCalender(_ sender: UIButton) {
        txtFldName.resignFirstResponder()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerVC
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = { date in
            let convertDate = self.convertDateFormat(inputDate: date ?? "")
            self.txtFldDateOfBirth.text = convertDate
            self.dateBirth = date ?? ""
//            self.txtFldDateOfBirth.text = date
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionUploadImage(_ sender: UIButton) {
        if isUploadImage == true{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePhotoVC") as! ChangePhotoVC
            vc.isComing = 0
            vc.callBack = { image in
                self.imgVwUser.image = image
                
                if Store.LogoImage == UIImage(named: "") || Store.LogoImage == nil{
                    if Store.role == "b_user"{
                        self.btnUpload.setImage(UIImage(named: "cameraa"), for: .normal)
                    }else{
                        self.btnUpload.setImage(UIImage(named: "uss"), for: .normal)
                    }
                    self.btnUpload.backgroundColor = .white
                    self.isUploadImage = false
                }else{
                    self.btnUpload.setImage(UIImage(named: ""), for: .normal)
                    
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            ImagePicker().pickImage(self) { image in
                
                self.btnUpload.backgroundColor = .clear
                self.imgVwUser.image = image
                self.btnEdit.isUserInteractionEnabled = true
                self.isUploadImage = true
                Store.LogoImage = image
                if Store.LogoImage == UIImage(named: "") || Store.LogoImage == nil{
                    self.btnUpload.setImage(UIImage(named: "uss"), for: .normal)
                }else{
                    self.btnUpload.setImage(UIImage(named: ""), for: .normal)
                }
                
            }
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BackPopPupVC") as! BackPopPupVC
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)
    }
    @IBAction func actionGender(_ sender: UIButton) {
        txtFldName.resignFirstResponder()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenderVC") as! GenderVC
        vc.modalPresentationStyle = .overFullScreen
        vc.genderTxt = txtFldGender.text ?? ""
        vc.callBack = { gender in
            self.txtFldGender.text = gender
        }
        self.navigationController?.present(vc, animated: true)
    }
}
