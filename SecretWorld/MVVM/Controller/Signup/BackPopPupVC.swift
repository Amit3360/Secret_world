//
//  BackPopPupVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//

import UIKit

class BackPopPupVC: UIViewController {
    //MARK: - Outlets
   
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
  
    //MARK: - Button Actions
    @IBAction func actionYes(_ sender: UIButton) {
        SceneDelegate().OnboardingThirdVCRoot()
    }
    @IBAction func actionNo(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    

}
