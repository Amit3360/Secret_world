//
//  CommonPopUpVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 05/01/24.
//

import UIKit

class CommonPopUpVC: UIViewController {

    @IBOutlet var widthImgVw: NSLayoutConstraint!
    @IBOutlet var heightImgVw: NSLayoutConstraint!
    @IBOutlet var viewBack: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet var btnOk: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgVw: UIImageView!
    
    var isSelect = 0
    var callBack:(()->())?
    var viewModel = AuthVM()
    var message:String?
    var callBackMsg:((_ message:String?)->())?
    var isSuccess = false
    var isEditMoment = false
    override func viewDidLoad() {
        super.viewDidLoad()

       uiSet()
    }
    func uiSet(){
        switch isSelect{
        case 0:
            btnOk.isHidden = false
            btnCancel.isHidden = false
            lblTitle.text = "Your profile is not verified by admin,after verification you will add your service."
            btnOk.setTitle("Request", for: .normal)
            imgVw.image = UIImage(named: "notverify")
            
        case 1:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Your request is not verified by admin."
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "notverify")
            
        case 2:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Your service added successfully."
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        
        case 3:
            btnOk.isHidden = false
            btnCancel.isHidden = false
            lblTitle.text = "Your profile is not verified by admin, after verification you can add your moment, popups and moment."
            btnOk.setTitle("Request", for: .normal)
            imgVw.image = UIImage(named: "notverify")
            
        case 4:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Your profile is not verified by admin, after verification you can add your moment, popups and moment."
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "notverify")
        case 5:
            btnOk.isHidden = false
            btnCancel.isHidden = false
            lblTitle.text = "Our team is still reviewing your profile. We will update you shortly. If you want to put the reminder again please request again."
            btnCancel.setTitle("Ok", for: .normal)
            btnOk.setTitle("Request again", for: .normal)
            imgVw.image = UIImage(named: "notverify")
        case 6:
            btnOk.isHidden = false
            btnCancel.isHidden = false
            lblTitle.text = "Your profile is not verified by admin, after verification you can add your moment, popups and moment."
            btnOk.setTitle("Request", for: .normal)
            imgVw.image = UIImage(named: "notverify")
            
        case 7:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Congratulations your task is posted successfully."
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        case 19:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Congratulations your task is added successfully."
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        case 8:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Congratulations, your task is updated successfully!"
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        case 9:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Congratulations your popup is update successfully."
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        case 10:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = message
            btnOk.setTitle("Ok", for: .normal)
            if isSuccess{
                heightImgVw.constant = 50
                widthImgVw.constant = 50
                imgVw.image = UIImage(named: "success")
            }else{
                heightImgVw.constant = 100
                widthImgVw.constant = 110
                imgVw.image = UIImage(named: "servicecreated")
            }
            
        
        case 11:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Thank you for your valuable feedback."
            if let customFont = UIFont(name: "Nunito-SemiBold", size: 20) {
                        lblTitle.font = customFont
                    }
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "notverify")
            
        case 12:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Your service is updated successfully."
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        case 13:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Payment is successfully done now your task is active for all task worker."
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        case 14:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            btnOk.setTitle("Ok", for: .normal)
            lblTitle.text = "Product added successfully."
            imgVw.image = UIImage(named: "servicecreated")
        case 15:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            btnOk.setTitle("Ok", for: .normal)
            lblTitle.text = "Product updated successfully."
            imgVw.image = UIImage(named: "servicecreated")
        case 16:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            btnOk.setTitle("Ok", for: .normal)
            lblTitle.text = "Product deleted successfully."
            imgVw.image = UIImage(named: "servicecreated")
        case 17:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            btnOk.setTitle("Ok", for: .normal)
            lblTitle.text = "Task completed successfully."
            imgVw.image = UIImage(named: "completeGig")
        case 18:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            btnOk.setTitle("Ok", for: .normal)
            lblTitle.text = "Task has been applied successfully."
            imgVw.image = UIImage(named: "servicecreated")
        case 20:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Payment failed!"
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        case 21:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = "Payment added successfully!"
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        case 22:
            btnOk.isHidden = false
            btnCancel.isHidden = false
            lblTitle.text = message
            btnOk.setTitle("Add Fund", for: .normal)
            imgVw.image = UIImage(named: "funds")
        case 23:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = message
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "notverify")
        case 24:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            lblTitle.text = message
            btnOk.setTitle("Ok", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        case 25:
            btnOk.isHidden = false
            btnCancel.isHidden = false
            lblTitle.text = "Your profile is not verified by admin, after verification you can add your moment."
            btnOk.setTitle("Request", for: .normal)
            imgVw.image = UIImage(named: "notverify")
        case 26:
            btnOk.isHidden = false
            btnCancel.isHidden = false
            lblTitle.text = "Are you sure you want to delete this product."
            btnOk.setTitle("Delete", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
        case 27:
            btnOk.isHidden = false
            btnCancel.isHidden = true
            if isEditMoment{
                lblTitle.text = message
            }else{
                lblTitle.text = "We have collected your moment data , click on Proceed to Payment for creating moment"
            }
            btnOk.setTitle("Proceed to Payment", for: .normal)
            imgVw.image = UIImage(named: "servicecreated")
            
        default:
            break
        }
    }
    
    @IBAction func actionOk(_ sender: UIButton) {
        switch isSelect{
        case 0:

            viewModel.verificationRequest {
                self.callBack?()
            }
        case 2:
            self.callBack?()
            
        case 3:
            viewModel.verificationRequest {
                self.callBack?()
            }
        case 4:
            self.callBack?()
        case 5:
            viewModel.verificationRequest {
                self.callBack?()
            }
        case 6:
            viewModel.verificationRequest {
                self.callBack?()
            }
        case 7:
            self.callBack?()
        case 8:
            self.callBack?()
        case 9:
            self.callBack?()
        case 10:
            self.callBack?()
        case 11:
            self.callBack?()
        case 12:
            self.callBack?()
        case 13:
            self.callBack?()
        case 17:
            self.callBack?()
        case 18:
            self.callBack?()
        case 19,20,21,22,24,26,27:
            self.callBack?()
        case 23:
            self.callBack?()
        case 25:
            viewModel.verificationRequest {
                self.callBack?()
            }
        default:
            break
        }
        self.dismiss(animated: false)
        
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismiss(animated: false)
        
    }
    
}
