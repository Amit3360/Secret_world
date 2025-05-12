//
//  AfterFeedbackPopUpVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/04/24.
//

import UIKit

class AfterFeedbackPopUpVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var callBack:(()->())?
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
    }
    
    func uiSet(){
        if isUpdate == true{
            lblTitle.text = "Review updated successfully"
        }else{
            lblTitle.text = "Thank you for your valuable feedback"
        }
    }
    
    @IBAction func actionOk(_ sender: UIButton) {
        self.dismiss(animated: false)
        callBack?()
    }
    
}
