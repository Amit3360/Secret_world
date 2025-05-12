//
//  SelectGigImageOptionVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 20/12/24.
//

import UIKit

class SelectGigImageOptionVC: UIViewController {

    @IBOutlet var viewBack: UIView!
    var isSelectBtn = 0
    var callBack:((_ btnSelect:Int)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = 35
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    @IBAction func actionCamera(_ sender: UIButton) {
        callBack?(2)
        
    }
    @IBAction func actionWithAI(_ sender: UIButton) {
        callBack?(1)
    }
    @IBAction func actionDismiss(_ sender: UIButton) {
        
        callBack?(0)
       
    }

}
