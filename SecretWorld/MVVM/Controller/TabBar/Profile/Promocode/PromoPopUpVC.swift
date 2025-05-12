//
//  PromoPopUpVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/01/24.
//

import UIKit

class PromoPopUpVC: UIViewController {

    @IBOutlet var btnOk: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgVwTitle: UIImageView!
    
    var isComing = false
    var callBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
      uiSet()
    }
    func uiSet(){
        if isComing == true{
            //approve
            imgVwTitle.image = UIImage(named: "approve")
            lblTitle.text = "User promo code verification Successfully"
            btnOk.setTitle("Back", for: .normal)
        }else{
            //rejected
            imgVwTitle.image = UIImage(named: "rejected")
            lblTitle.text = "Your promo Code is not match our records. Please Verify again"
            btnOk.setTitle("Ok", for: .normal)
        }
    }

    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: false)
        callBack?()
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.dismiss(animated: false)
        callBack?()
    }
    
}
