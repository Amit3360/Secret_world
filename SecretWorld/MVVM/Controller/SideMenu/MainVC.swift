//
//  MainVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 20/11/24.
//

import UIKit
import LGSideMenuController

class MainVC: LGSideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homevc =  self.storyboard?.instantiateViewController(withIdentifier: "TabBarController" ) as! TabBarController
        let sidevc =  self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC" ) as! SideMenuVC
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeNavigation") as? UINavigationController
        navigationController?.setViewControllers([homevc], animated: true)
        self.leftViewWidth = 100
        self.rootViewController = navController
        self.leftViewController = sidevc
        self.leftViewPresentationStyle = .scaleFromBig
        self.isLeftViewSwipeGestureEnabled = false
    }
    


}
