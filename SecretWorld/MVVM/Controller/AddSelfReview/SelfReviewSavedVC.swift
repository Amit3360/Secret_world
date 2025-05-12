//
//  SelfReviewSavedVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/04/25.
//

import UIKit

class SelfReviewSavedVC: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    var isSelect = 0
    var callBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        if isSelect == 1{
            lblTitle.text = "Your review has been successfully submitted! 🎉"
        }else{
            lblTitle.text = "Your self review has been successfully saved! 🎉"
        }
    }
    @IBAction func actionOk(_ sender: UIButton) {
        self.dismiss(animated: true)
        callBack?()
    }
    
}
