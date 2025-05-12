//
//  OnboardingFirstVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit

class OnboardingFirstVC: UIViewController {
    
//MARK: - Outlets
    
    @IBOutlet var vwShadow: UIView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
                self.view.addGestureRecognizer(swipeGesture)
    }
 
    @objc func handleSwipe(_ gesture: UIPanGestureRecognizer) {
           let translation = gesture.translation(in: view)

           if translation.x < 0 {
               if gesture.state == .ended {
                   
                   let vc = storyboard?.instantiateViewController(withIdentifier: "OnboardingSecondVC") as! OnboardingSecondVC
                   navigationController?.pushViewController(vc, animated: true)
               }
           }
       }

    //MARK: - Button Actions
    
    @IBAction func actionSkip(_ sender: UIButton) {
        
        SceneDelegate().OnboardingThirdVCRoot()
        
    }
    @IBAction func actionNext(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnboardingSecondVC") as! OnboardingSecondVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
