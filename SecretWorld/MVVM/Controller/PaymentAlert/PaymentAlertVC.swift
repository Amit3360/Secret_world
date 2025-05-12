//
//  PaymentAlertVC.swift
//  SecretWorld
//
//  Created by meet sharma on 22/05/24.
//

import UIKit


class PaymentAlertVC: UIViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    var callBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

       uiSet()
    }
    func uiSet(){
        if Store.role == "b_user"{
            lblUserName.text = "Hey " + (Store.BusinessUserDetail?["userName"] as? String ?? "")
        }else{
            lblUserName.text = "Hey " +  (Store.UserDetail?["userName"] as? String ?? "")
        }
    }
    @IBAction func actionCancel(_ sender: UIButton) {
        paymentPopUp = true
        self.dismiss(animated: true)
       
    }
    
    @IBAction func actionPayNow(_ sender: UIButton) {
        paymentPopUp = true
        self.dismiss(animated: true)
        callBack?()
    }
    
}
