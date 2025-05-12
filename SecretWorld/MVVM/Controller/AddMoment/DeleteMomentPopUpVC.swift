//
//  DeleteMomentPopUpVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 11/04/25.
//

import UIKit

class DeleteMomentPopUpVC: UIViewController {
    @IBOutlet var lblTitleMsg: UILabel!
    
    var callBack:(()->())?
    var isSelect = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    private func uiSet(){
        if isSelect == 0{
            lblTitleMsg.text = "Are you sure, you want to delete it?"

        }else if isSelect == 1{
            lblTitleMsg.text = "Are you sure, you want to accept."

        }else{
            lblTitleMsg.text = "Are you sure, you want to reject."

        }
    }
    @IBAction func actionYes(_ sender: UIButton) {
        self.dismiss(animated: true)
        callBack?()
    }
    
    @IBAction func actionNo(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
