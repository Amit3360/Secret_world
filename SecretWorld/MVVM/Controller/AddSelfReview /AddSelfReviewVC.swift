//
//  AddSelfReviewVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/04/25.
//

import UIKit
import IQKeyboardManagerSwift

class AddSelfReviewVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var viewBack: UIView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var txtVwAbout: IQTextView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    
    //MARK: - variables
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    private func uiSet(){
        lblName.text =  "@\(Store.UserDetail?["userName"] as? String ?? "")"
        imgVwUser.imageLoad(imageUrl: Store.UserDetail?["profileImage"] as? String ?? "")
        
        viewBack.layer.shadowColor = UIColor.black.cgColor
        viewBack.layer.shadowOpacity = 0.1  // Reduced from 0.25 to 0.1
        viewBack.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewBack.layer.shadowRadius = 3     // Slightly less blur
        viewBack.layer.masksToBounds = false


    }
    //MARK: - IBAction
    @IBAction func actionSave(_ sender: UIButton) {
    }
    @IBAction func actionBAck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
