//
//  ChangePhotoVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 09/02/24.
//

import UIKit

class ChangePhotoVC: UIViewController {
//MARK: - OUTLETS
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnChnageAndUploadPhoto: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var imgVWUpload: UIImageView!
    
    //MARK: - VARIABLES
    var isSelect = 0
    var callBack:((_ image:UIImage?)->())?
    var isComing = 0
    var img:Any?
    var callBackServiceImg:((_ image:Any?,_ itemType:Any?)->())?
    var itemType:Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)

        
        uiSet()
    }
    @objc func handleSwipe() {
        uiSet()
        self.navigationController?.popViewController(animated: true)
        if isComing == 0{
            callBack?(Store.LogoImage)
        }else if isComing == 1{
            callBack?(Store.BusinessIdImage)
        }else if isComing == 2{
            callBack?(Store.CoverImage)
        }else if isComing == 4{
            callBack?(Store.GigImg)
        }else if isComing == 5{
            if itemType as? any Any.Type == String.self{
                callBackServiceImg?(img as? String, itemType)
            }else{
                callBackServiceImg?(img as? UIImage, itemType)
            }
        }else if isComing == 9{
            callBack?(Store.MarkerLogo)
        }
    }

    func uiSet(){
        
           
        if isComing == 0{
            imgVWUpload.image = Store.LogoImage
            btnCancel.isHidden = true
            btnBack.isHidden = false
            btnDelete.isHidden = false
            btnChnageAndUploadPhoto.setTitle("Change photo", for: .normal)
        }else if isComing == 1{
            imgVWUpload.image = Store.BusinessIdImage
            btnCancel.isHidden = true
            btnBack.isHidden = false
            btnDelete.isHidden = false
            btnChnageAndUploadPhoto.setTitle("Change photo", for: .normal)
        }else if isComing == 2{
            imgVWUpload.image = Store.CoverImage
            btnCancel.isHidden = true
            btnBack.isHidden = false
            btnDelete.isHidden = false
            btnChnageAndUploadPhoto.setTitle("Change photo", for: .normal)
        }else if isComing == 3{
            imgVWUpload.image = Store.UserProfileImage
            btnCancel.isHidden = true
            btnBack.isHidden = false
            btnDelete.isHidden = false
            btnChnageAndUploadPhoto.setTitle("Change photo", for: .normal)
        }else if isComing == 4{
            imgVWUpload.image = Store.GigImg
            btnCancel.isHidden = true
            btnBack.isHidden = false
            btnDelete.isHidden = false
            btnChnageAndUploadPhoto.setTitle("Change photo", for: .normal)
        }else if isComing == 5{
            if itemType as? any Any.Type == String.self{
                
                imgVWUpload.imageLoad(imageUrl: img as! String)
                
            }else{
                imgVWUpload.image = img as? UIImage
                
                
            }
            btnCancel.isHidden = true
            btnBack.isHidden = false
            btnDelete.isHidden = false
            btnChnageAndUploadPhoto.isHidden = true
        }else if isComing == 7{
            btnCancel.isHidden = true
            btnBack.isHidden = false
            btnDelete.isHidden = true
            btnChnageAndUploadPhoto.isHidden = true
        }else if isComing == 9{
            imgVWUpload.image = Store.MarkerLogo
            btnCancel.isHidden = true
            btnBack.isHidden = false
            btnDelete.isHidden = false
            btnChnageAndUploadPhoto.setTitle("Change photo", for: .normal)
        }else{
            btnCancel.isHidden = true
            btnBack.isHidden = false
            btnDelete.isHidden = false
            btnChnageAndUploadPhoto.setTitle("Change photo", for: .normal)
            imgVWUpload.image = Store.UserProfileViewImage
            
        }
             isSelect = 0
    }
    //MARK: - BUTTON ACTIONS
    @IBAction func actionDelete(_ sender: UIButton) {

        if isComing == 0{
            Store.LogoImage = nil
        }else if isComing == 1{
            Store.BusinessIdImage = nil
        }else if isComing == 2{
            Store.CoverImage = nil
        }else if isComing == 4{
            Store.GigImg = nil
        }else if isComing == 5{
            img = nil
        }else if isComing == 9{
            Store.MarkerLogo = nil
        }
        self.navigationController?.popViewController(animated: true)
        
        if isComing == 0{
            callBack?(Store.LogoImage)
        }else if isComing == 1{
            callBack?(Store.BusinessIdImage)
        }else if isComing == 2{
            callBack?(Store.CoverImage)
        }else if isComing == 4{
            callBack?(Store.GigImg)
        }else if isComing == 5{
            
            if itemType as? any Any.Type == String.self{
                callBackServiceImg?(img as? String, itemType)
            }else{
                callBackServiceImg?(img as? UIImage, itemType)
            }
            
        }else if isComing == 9{
            callBack?(Store.MarkerLogo)
        }
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        uiSet()
    }
    @IBAction func actionBack(_ sender: UIButton) {
        uiSet()
        self.navigationController?.popViewController(animated: true)
        if isComing == 0{
            callBack?(Store.LogoImage)
        }else if isComing == 1{
            callBack?(Store.BusinessIdImage)
        }else if isComing == 2{
            callBack?(Store.CoverImage)
        }else if isComing == 4{
            callBack?(Store.GigImg)
        }else if isComing == 5{
            if itemType as? any Any.Type == String.self{
                callBackServiceImg?(img as? String, itemType)
            }else{
                callBackServiceImg?(img as? UIImage, itemType)
            }
        }else if isComing == 9{
            callBack?(Store.MarkerLogo)
        }
    }
    
    @IBAction func actionUploadAndChange(_ sender: UIButton) {
        if isSelect == 1{
            self.navigationController?.popViewController(animated: true)
            if isComing == 0{
                Store.LogoImage = imgVWUpload.image
            }else if isComing == 1{
                Store.BusinessIdImage = imgVWUpload.image
            }else if isComing == 2{
                Store.CoverImage = imgVWUpload.image
            }else if isComing == 4{
                Store.GigImg = imgVWUpload.image
            }else if isComing == 5{
                if itemType as? any Any.Type == String.self{
                    callBackServiceImg?(img as? String, itemType)
                }else{
                    callBackServiceImg?(img as? UIImage, itemType)
                }
            }else if isComing == 9{
                Store.MarkerLogo = imgVWUpload.image
            }else{
                Store.UserProfileViewImage = imgVWUpload.image
            }
            
            callBack?(imgVWUpload.image)
        }else{
            
            ImagePicker().pickImage(self) { image in
                self.imgVWUpload.image = image
                self.btnChnageAndUploadPhoto.setTitle("Upload", for: .normal)
                self.btnCancel.isHidden = false
                self.btnBack.isHidden = true
                self.btnDelete.isHidden = true
                self.isSelect = 1
            }
        }
    }
    
}
