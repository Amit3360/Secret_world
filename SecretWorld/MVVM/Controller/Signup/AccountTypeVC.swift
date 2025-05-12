//
//  AccountTypeVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit

class AccountTypeVC: UIViewController {
    //MARK: - Outlets
    
    @IBOutlet var btnUser: UIButton!
    @IBOutlet var btnOwner: UIButton!
    @IBOutlet var lblUser: UILabel!
    @IBOutlet var lblOwner: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var imgVwOwner: UIImageView!
    @IBOutlet var vwOwnerBg: UIView!
    @IBOutlet var vwUserBg: UIView!
    @IBOutlet var btnConinue: UIButton!
    @IBOutlet var transparentVw: UIView!
    //true business
    //false = user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        uiSet()
    }
    @objc func handleSwipe() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        SceneDelegate().OnboardingThirdVCRoot()
    }
    func uiSet(){
        
        transparentVw.isHidden = false
        
    }
    
    //MARK: - Button Actions
    @IBAction func actionBack(_ sender: UIButton) {
        
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        SceneDelegate().OnboardingThirdVCRoot()
    }
    
    @IBAction func actionContinue(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    @IBAction func actionOwner(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true{
            Store.role  = "b_user"
            imgVwOwner.image = UIImage(named: "selectedUser")
            transparentVw.isHidden = true
            vwOwnerBg.backgroundColor = .app
            lblOwner.textColor = .white
            btnUser.isSelected = false
            vwUserBg.backgroundColor = .white
            lblUser.textColor = .black
            
            
        }else{
            Store.role  = "user"
            imgVwOwner.image = UIImage(named: "user")
            transparentVw.isHidden = false
            vwOwnerBg.backgroundColor = .white
            lblOwner.textColor = .black
        }
        
    }
    
    
    @IBAction func actionUser(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            Store.role  = "user"
            imgVwUser.image = UIImage(named: "userrrsel")
            transparentVw.isHidden = true
            vwUserBg.backgroundColor = .app
            lblUser.textColor = .white
            btnOwner.isSelected = false
            vwOwnerBg.backgroundColor = .white
            lblOwner.textColor = .black
            
        }else{
            Store.role  = "b_user"
            imgVwUser.image = UIImage(named: "userunsell")
            transparentVw.isHidden = false
            vwUserBg.backgroundColor = .white
            lblUser.textColor = .black
            
        }
        
    }
}
