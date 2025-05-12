//
//  GigCompleteVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 18/10/24.
//

import UIKit

class GigCompleteVC: UIViewController {
    var callBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func actionOk(_ sender: UIButton) {
        self.dismiss(animated: true)
        callBack?()
    }
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
        callBack?()
    }

}
