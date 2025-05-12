//
//  ContactUsVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 28/12/23.
//

import UIKit

class ContactUsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)

    }
    @objc func handleSwipe() {
               navigationController?.popViewController(animated: true)
           }

    @IBAction func actionContactus(_ sender: UIButton) {
        print("assfs")
        let email = "ideiosoft@gmail.com"
        
        if let url = URL(string: "mailto:\(email)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback for earlier iOS versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
