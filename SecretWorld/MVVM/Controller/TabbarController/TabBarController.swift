//
//  TabBarController.swift
//  SecretWorld
//
//  Created by Ideio Soft on 19/03/25.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    private let centerButton = UIButton()
    var viewModel = AuthVM()
    var isStatus = 0
    var imageView = UIImageView()
    var selectedTabIndex: Int = 0
    var isComing  = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupViewControllers()
      
        var tabFrame = tabBar.frame
        self.delegate = self
        let deviceHasNotch = UIApplication.shared.hasNotch
        if deviceHasNotch{
            tabFrame.size.height = 66  // Adjust height as needed
            tabFrame.origin.y = view.frame.height - tabFrame.height - view.safeAreaInsets.bottom // Use safe area insets
            tabBar.frame = tabFrame
            if let items = tabBar.items {
                for item in items {
                    item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0) // Move title up
                    item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0) // Adjust image
                }
            }
        }else{
            tabFrame.size.height = 60  // Adjust height as needed
            tabFrame.origin.y = view.frame.height - tabFrame.height - view.safeAreaInsets.bottom // Use safe area insets
            tabBar.frame = tabFrame
            if let items = tabBar.items {
                for item in items {
                    item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3) // Move title up
                    item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // Adjust image
                }
            }
        }
        setupCenterButton()
//        if !isComing{
//            imageView = UIImageView(image: UIImage(named: "homeLoader"))
//            imageView.contentMode = .scaleAspectFill
//            imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//            view.addSubview(imageView)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
//                self.imageView.removeFromSuperview()
//            }
//
//            NotificationCenter.default.addObserver(self, selector: #selector(self.mapLoaded(notification:)), name: Notification.Name("MapLoaded"), object: nil)
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedTabIndex < viewControllers?.count ?? 0 {
            self.selectedIndex = selectedTabIndex
        }
    }

    @objc func mapLoaded(notification:Notification){
        self.imageView.removeFromSuperview()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

       
    }
    private func setupTabBarAppearance() {
        let tabBar = self.tabBar
           tabBar.layer.masksToBounds = false
           tabBar.clipsToBounds = false
           tabBar.layer.cornerRadius = 10
           tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

           // Shadow properties (only top side)
           tabBar.layer.shadowColor = UIColor.black.cgColor
           tabBar.layer.shadowOpacity = 0.25
           tabBar.layer.shadowOffset = CGSize(width: 0, height: -3) // Negative offset moves shadow up
           tabBar.layer.shadowRadius = 10

           // Set a custom shadowPath to restrict shadow to top only
           let shadowRect = CGRect(x: 0, y: -5, width: tabBar.bounds.width, height: 5)
           tabBar.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath

           tabBar.backgroundColor = .white
        
        // Adjust tab bar item width
        let totalItems = 5 // Four tabs + center button space
        let tabBarItemWidth = tabBar.bounds.width / CGFloat(totalItems)
        UITabBar.appearance().itemWidth = tabBarItemWidth
    }

    private func setupViewControllers() {
        if Store.role == "b_user"{
            let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
    //        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "logo (1) 125"), tag: 0)
            firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "logo (1) 125")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "logo (1) 125")?.withRenderingMode(.alwaysOriginal))
            firstVC.tabBarItem.tag = 0
            
            let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
            secondVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "chatt")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "selectChat")?.withRenderingMode(.alwaysOriginal))
            secondVC.tabBarItem.tag = 1
            
            let emptyVC = UIViewController()
            emptyVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "transparent"), tag: 2)
            emptyVC.tabBarItem.tag = 2
            
            let thirdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
            thirdVC.tabBarItem = UITabBarItem(title: "Store", image: UIImage(named: "menuunselect")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "menuselect")?.withRenderingMode(.alwaysOriginal))
            thirdVC.tabBarItem.tag = 3
            
            let fourthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
          
            fourthVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profiletab")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "selectProfile")?.withRenderingMode(.alwaysOriginal))
            fourthVC.tabBarItem.tag = 4
            
            self.viewControllers = [
                UINavigationController(rootViewController: firstVC),
                UINavigationController(rootViewController: secondVC),
                UINavigationController(rootViewController: emptyVC), // Empty space for center button
                UINavigationController(rootViewController: thirdVC),
                UINavigationController(rootViewController: fourthVC)
            ]
            for vc in self.viewControllers ?? [] {
                (vc as? UINavigationController)?.setNavigationBarHidden(true, animated: false)
            }
        }else{
            let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
    //        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "logo (1) 125"), tag: 0)
            firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "logo (1) 125")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "logo (1) 125")?.withRenderingMode(.alwaysOriginal))
            firstVC.tabBarItem.tag = 0
            
            let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
            secondVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "chatt")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "selectChat")?.withRenderingMode(.alwaysOriginal))
            secondVC.tabBarItem.tag = 1
            
            let emptyVC = UIViewController()
            emptyVC.tabBarItem.tag = 2
            emptyVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "transparent"), tag: 2)
           
            
            let thirdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItinerariesVC") as! ItinerariesVC
            thirdVC.tabBarItem = UITabBarItem(title: "Itinerary", image: UIImage(named: "itinerary 1")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "greenItinerary")?.withRenderingMode(.alwaysOriginal))
            thirdVC.tabBarItem.tag = 3
            
            let fourthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
          
            fourthVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profiletab")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "selectProfile")?.withRenderingMode(.alwaysOriginal))
            fourthVC.tabBarItem.tag = 4
            self.viewControllers = [
                UINavigationController(rootViewController: firstVC),
                UINavigationController(rootViewController: secondVC),
                UINavigationController(rootViewController: emptyVC), // Empty space for center button
                UINavigationController(rootViewController: thirdVC),
                UINavigationController(rootViewController: fourthVC)
            ]
            for vc in self.viewControllers ?? [] {
                (vc as? UINavigationController)?.setNavigationBarHidden(true, animated: false)
            }
        }
       
    }

    private func setupCenterButton() {
      
        let deviceHasNotch = UIApplication.shared.hasNotch
        if deviceHasNotch{
            let buttonSize: CGFloat = 46  // Adjust as needed
            let tabBar = self.tabBar
            centerButton.frame = CGRect(
                x: (tabBar.bounds.width / 2) - (buttonSize / 2),  // Center horizontally in tab bar
                y: -buttonSize / 2 + 30, // Raise it slightly to sit on top of the tab bar
                width: buttonSize,
                height: buttonSize
            )
            centerButton.layer.cornerRadius = buttonSize / 2
            centerButton.clipsToBounds = true
        }else{
            let buttonSize: CGFloat = 44  // Adjust as needed
            let tabBar = self.tabBar
            centerButton.frame = CGRect(
                x: (tabBar.bounds.width / 2) - (buttonSize / 2),  // Center horizontally in tab bar
                y: -buttonSize / 2 + 25, // Raise it slightly to sit on top of the tab bar
                width: buttonSize,
                height: buttonSize
            )
            centerButton.layer.cornerRadius = buttonSize / 2
            centerButton.clipsToBounds = true
        }
        centerButton.setImage(UIImage(named: "adddd"), for: .normal)
        

        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)

        // Ensure button is on top of tab bar
        tabBar.addSubview(centerButton)
        tabBar.bringSubviewToFront(centerButton)

        // Enable user interaction if disabled
        tabBar.isUserInteractionEnabled = true
        centerButton.isUserInteractionEnabled = true
    }

    @objc private func centerButtonTapped() {
        print("Center button tapped!")
        centerButtonSelected()
    }
    func centerButtonSelected(){
        if Store.role == "user"{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SelectServiceTypeVC") as! SelectServiceTypeVC
            vc.modalPresentationStyle = .overFullScreen
            
            vc.callBack = { [weak self] type in
                
                guard let self = self else { return }
                self.viewModel.verificationStatus{ data in
                    self.isStatus = data?.verificationStatus ?? 0
                    if self.isStatus == 0{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                        vc.modalPresentationStyle = .overFullScreen
                        if type == 1{
                            vc.isSelect = 6
                        }else{
                            vc.isSelect = 3
                        }
                        vc.callBack = {[weak self] in
                            
                            guard let self = self else { return }
                            self.viewModel.verificationStatus{ data in
                                self.isStatus = data?.verificationStatus ?? 0
                            }
                        }
                        self.navigationController?.present(vc, animated: false)
                    }else if self.isStatus == 1{
                        //gig //popup
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.isSelect = 5
                        vc.callBack = {[weak self] in
                            
                            guard let self = self else { return }
                            self.viewModel.verificationStatus{ data in
                                self.isStatus = data?.verificationStatus ?? 0
                            }
                        }
                        self.navigationController?.present(vc, animated: false)
                    }else{
                        if type == 1{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPopUpVC") as! AddPopUpVC
                            vc.isComing = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else if type == 2{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMomentTypeVC") as! AddMomentTypeVC
                            vc.modalPresentationStyle = .overFullScreen
                            vc.callBack = { type in
                                DispatchQueue.main.async {
                                    let vc = storyboard.instantiateViewController(withIdentifier: "AddMomentVC") as! AddMomentVC
                                    vc.momentType = type
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            self.present(vc, animated: false)
                        }
                    }
                }
            }
            self.present(vc, animated: true)
        }else{
            
            self.viewModel.verificationStatus{ data in
                self.isStatus = data?.verificationStatus ?? 0
                if self.isStatus == 0{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isSelect = 25
                    vc.callBack = {[weak self] in
                        
                        guard let self = self else { return }
                        self.viewModel.verificationStatus{ data in
                            self.isStatus = data?.verificationStatus ?? 0
                        }
                    }
                    self.navigationController?.present(vc, animated: false)
                }else if self.isStatus == 1{
                    //gig //popup
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isSelect = 5
                    vc.callBack = {[weak self] in
                        
                        guard let self = self else { return }
                        self.viewModel.verificationStatus{ data in
                            self.isStatus = data?.verificationStatus ?? 0
                        }
                    }
                    self.navigationController?.present(vc, animated: false)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
                    //                            vc.isComing = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
           if let index = viewControllers?.firstIndex(of: viewController), index == 2 {
               print("Empty tab selected")
               centerButtonSelected()
               return false // Prevent switching to emptyVC
           }
           return true
       }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         selectedIndex = tabBarController.selectedIndex
        print("Selected tab index: \(selectedIndex)")
        
        // Handle based on selected index
        switch selectedIndex {
        case 0:
            NotificationCenter.default.post(name: Notification.Name("callHomeSocket"), object: nil)
            print("Home tab selected")
        case 1:
            print("Chat tab selected")
        case 2:
            print("Center (empty) tab selected")
        case 3:
            print(Store.role == "b_user" ? "Store tab selected" : "Itinerary tab selected")
            NotificationCenter.default.post(name: Notification.Name("CallMenuApi"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("callHomeSocket"), object: nil)
        case 4:
            print("Profile tab selected")
        default:
            break
        }
    }

}
