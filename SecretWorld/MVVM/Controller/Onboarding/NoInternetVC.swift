//
//  NoInternetVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit

class NoInternetVC: UIViewController {

    @IBOutlet var lblMsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMsg.font = UIFont(name: "Nunito-Regular", size: 18)
    }
    //MARK: - Button Actions
    @IBAction func actionTryAgain(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork(){
            self.dismiss(animated: false)
            
        }
    }
}
