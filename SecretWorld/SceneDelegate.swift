//
//  SceneDelegate.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit
import CoreLocation
import LGSideMenuController
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
        // Check for incoming deep link URL
//        if Store.autoLogin == 1{
//            accountTypeVCRoot()
//        }else if Store.autoLogin == 2{
//            
//            if Store.role == "b_user"{
//                completeSignupBusinessUserVCRoot()
//            }else{
//                completeSignupUserVCRoot()
//            }
//        }else if Store.autoLogin == 3{
//            
//            Store.SubCategoriesId = nil
//            userRoot()
//        }else if Store.autoLogin == 0{
//            
//            OnboardingThirdVCRoot()
//        }else{
//            
//            OnboardingFirstVCRoot()
//        }
//
       
        if let userActivity = connectionOptions.userActivities.first,
           userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let urlinfo = userActivity.webpageURL {
            print ("Universial Link Open at SceneDelegate on App Start ::::::: \(urlinfo)")
            openLink(url: urlinfo)
        }
        
        if connectionOptions.urlContexts.first?.url != nil {
            if let urlinfo = connectionOptions.urlContexts.first?.url {
                openLink(url: urlinfo)
            }
        }
    
     
    }

  
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                // Handle the URL
                print("App opened with URL: \(url.absoluteString)")
                if let url = URL(string: url.absoluteString) {
                    openLink(url: url)
                }
            }
        }
    }
  
//
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
//        if !isCall{
//            UIApplication.shared.applicationIconBadgeNumber = 0
//            if Store.userId != "" {
//                let status = CLLocationManager.authorizationStatus()
//                switch status {
//                case .restricted, .denied:
//                    NotificationCenter.default.post(name: Notification.Name("locationDenied"), object: nil)
//                case .authorizedWhenInUse, .authorizedAlways:
//                    print("Location permission allowed")
//
//                    NotificationCenter.default.post(name: Notification.Name("locationAllow"), object: nil)
//
//                default:
//                    print("Location permission not determined")
//                }
//            }
//        }
        
    }
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
    }
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    func tabbarRoots(SelectedIndex:Int){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        nextVC.selectedTabIndex = SelectedIndex
        nextVC.isComing = true
        
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func addServiceRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "EditServiceVC") as! EditServiceVC
        nextVC.isComing = true
        nextVC.isCreate = true
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func MomentListRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "OwnerMomentsListVC") as! OwnerMomentsListVC
        nextVC.isComing = true
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }

    func MenuVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func MyServicesVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "MyServicesVC") as! MyServicesVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func SignupVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func OnboardingThirdVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "OnboardingThirdVC") as! OnboardingThirdVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func OnboardingFirstVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "OnboardingFirstVC") as! OnboardingFirstVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    
    func signupFirstStepVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func accountTypeVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "AccountTypeVC") as! AccountTypeVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func completeSignupUserVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "CompleteSignupVC") as! CompleteSignupVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func completeSignupBusinessUserVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "CreateBusinessAcVC") as! CreateBusinessAcVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func tabBarProfileRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func tabBarChatRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
       
//        nextVC.selectedButtonTag = 4
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func userRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//        nextVC.selectedButtonTag = 0
//        
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
   
    func tabBarExploreByUpdateGigRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
       
//        nextVC.selectedButtonTag = 2
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func tabBarExploreRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//        nextVC.selectedButtonTag = 2
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func tabBarHomeRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//        NotificationCenter.default.post(name: Notification.Name("TabBar"), object: nil)
        Store.tabBarNotificationPosted = false
//        nextVC.selectedButtonTag = 1
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func addGigRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "NewGigAddVC") as! NewGigAddVC
        nextVC.isComing = true
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }

    func tabBarMenuVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//        nextVC.selectedButtonTag = 6
      
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func GigListVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "GigListVC") as! GigListVC
        nextVC.isComing = 2
        Store.isUserParticipantsList = true
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func PopupListVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "PopUpListVC") as! PopUpListVC
        nextVC.isCreate = true
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    
    func NoInternetVCRoot() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
        nextVC.modalPresentationStyle = .overFullScreen
        let nav = UINavigationController(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .overFullScreen
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(nav, animated: false, completion: nil)
            rootVC.modalPresentationStyle = .overFullScreen
        }
    }
    
    
    func RejectPromoVCRoot() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "PromoPopUpVC") as! PromoPopUpVC
        nextVC.modalPresentationStyle = .overFullScreen
        let nav = UINavigationController(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .overFullScreen
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(nav, animated: false, completion: nil)
            rootVC.modalPresentationStyle = .overFullScreen
        }
    }
    func addWalletPopupRoot(message: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.isSelect = 22
        nextVC.message = message
        
        // Callback: present WalletVC
        nextVC.callBack = {
            let walletVC = mainStoryboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
            walletVC.isComing = true
            walletVC.modalPresentationStyle = .overFullScreen

            // Dismiss popup first, then present WalletVC
            nextVC.dismiss(animated: true) {
                if let topVC = UIApplication.shared.topMostViewController() {
                    topVC.present(walletVC, animated: false, completion: nil)
                }
            }
        }

        // Wrap popup in nav controller (optional, for custom nav UI)
        let nav = UINavigationController(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .overFullScreen

        // Present popup from topmost view controller
        if let topVC = UIApplication.shared.topMostViewController() {
            topVC.present(nav, animated: false, completion: nil)
        }
    }
    func invalidOtp(message:String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.isSelect = 24
        nextVC.message = message
        let nav = UINavigationController(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .overFullScreen
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(nav, animated: false, completion: nil)
            rootVC.modalPresentationStyle = .overFullScreen
        }
    }
    func WalletVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func BusinessProfileVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "BusinessProfileVC") as! BusinessProfileVC
        nextVC.isComing = true
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func AddBankVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "AddBankVC") as! AddBankVC
        nextVC.isComing = false
        nextVC.isFromWallet = true
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func walletFromAddBankVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        nextVC.isBank = true
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }

    func addBankRoot(message: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "CommonPopUpVC") as? CommonPopUpVC else {
            print("Failed to instantiate CommonPopUpVC from storyboard")
            return
        }
        nextVC.isSelect = 10
        nextVC.message = message
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.callBack = {
            self.AddBankVCRoot()
        }
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            if let presentedVC = rootVC.presentedViewController {
                presentedVC.dismiss(animated: false) {
                    rootVC.present(nextVC, animated: false, completion: nil)
                }
            } else {
                rootVC.present(nextVC, animated: false, completion: nil)
            }
        }
    }
    func CommonPopupRoot(message: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "CommonPopUpVC") as? CommonPopUpVC else {
            print("Failed to instantiate CommonPopUpVC from storyboard")
            return
        }
        nextVC.isSelect = 23
        nextVC.message = message
        nextVC.modalPresentationStyle = .overFullScreen
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            if let presentedVC = rootVC.presentedViewController {
                presentedVC.dismiss(animated: false) {
                    rootVC.present(nextVC, animated: false, completion: nil)
                }
            } else {
                rootVC.present(nextVC, animated: false, completion: nil)
            }
        }
    }
    func servicesVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func AboutVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func GallaryRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "GallaryVC") as! GallaryVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func ReviewVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
    func GigsListVCRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "GisgsListVC") as! GisgsListVC
        let nav = UINavigationController.init(rootViewController: nextVC)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
    }
   
}


//MARK: EXTENSION
extension SceneDelegate {
    func openLink(url: URL?) {
        guard let url = url else { return }
        
        // Ensure the scheme and host match the expected values
        if url.scheme?.localizedCaseInsensitiveCompare("https") == .orderedSame,
           url.host?.localizedCaseInsensitiveCompare("api.secretworld.ai") == .orderedSame {
            
            // Extract the path and parse the taskId
            let pathComponents = url.pathComponents
            if let taskIdIndex = pathComponents.firstIndex(of: "taskId"),
               taskIdIndex + 1 < pathComponents.count {
                let taskId = pathComponents[taskIdIndex + 1]
                print("URL: \(url.absoluteString)")
                print("Task ID: \(taskId)")
                
                // Check if the user is authenticated
                if let authKey = Store.authKey, !authKey.isEmpty {
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    
                    // Home screen (TabBarVC)
                    let userHome = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                    let navigationController = UINavigationController(rootViewController: userHome)
                    navigationController.navigationBar.isHidden = true
                    
                    // Details screen (ApplyGigVC)
                    let bookDetailsVC = storyboard.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                    bookDetailsVC.gigId = taskId
                    bookDetailsVC.isComingDeepLink = true
                    navigationController.pushViewController(bookDetailsVC, animated: false)
                    
                    // Set as rootViewController
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = navigationController
                        window.makeKeyAndVisible()
                    }
                } else {
                    print("User not authenticated")
                }
            } else {
                print("Invalid URL path or missing taskId")
            }
        } else {
            print("Invalid URL scheme or host")
        }
    }
}

extension UIApplication {
    func topMostViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topMostViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }
        return base
    }
}
