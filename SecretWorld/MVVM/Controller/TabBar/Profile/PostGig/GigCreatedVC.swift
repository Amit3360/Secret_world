//
//  GigCreatedVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 11/06/24.
//

import UIKit

class GigCreatedVC: UIViewController {
    var callBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func actionOk(_ sender: UIButton) {
        
        self.dismiss(animated: false)
        callBack?()
    }
    
}
