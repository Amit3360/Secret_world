//
//  AppDelegate.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import FirebaseCore
import GoogleSignInSwift
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    lazy var notificationDelegate = UserNotifcations()
       static let sharedAppDelegate: AppDelegate = {
           guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
               fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
           }
           return delegate
       }()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Store.AddGigDetail = nil
        Store.AddGigImage = nil
        GMSPlacesClient.provideAPIKey("AIzaSyBV343YslRWhvjzOoV9DgUE9Ik1m1If75I")
        GMSServices.provideAPIKey("AIzaSyBV343YslRWhvjzOoV9DgUE9Ik1m1If75I")

//        GMSPlacesClient.provideAPIKey("AIzaSyBV343YslRWhvjzOoV9DgUE9Ik1m1If75I")
//        GMSServices.provideAPIKey("AIzaSyBV343YslRWhvjzOoV9DgUE9Ik1m1If75I")

//        GMSPlacesClient.provideAPIKey("AIzaSyB8Jo13V8hcS7wKGuRsDbNgM9Fp6TAnCeE")
//        GMSServices.provideAPIKey("AIzaSyB8Jo13V8hcS7wKGuRsDbNgM9Fp6TAnCeE")
        FirebaseApp.configure()
    
        GoogleSignIn.shared.clientId = "195240213154-822jq5rbi39v16o889egecbd50ssjiiv.apps.googleusercontent.com"
        
        //GoogleSignIn.shared.clientId = "64784249708-7vs00q0h5ds78f0tnmsgvm4ri5hged3n.apps.googleusercontent.com"
       // GoogleSignIn.shared.clientId = "com.googleusercontent.apps.195240213154-2j508k5mukgjtd93vgju6hoqnf34g91v"
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.placeholderColor = .clear
        configureNotification()
//        Thread.sleep(forTimeInterval: 2.0)
      
        
        return true
    }
   
    // This method is called when your app is opened via a Universal Link
     func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
         if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
             if let url = userActivity.webpageURL {
                 // Handle the deep link URL here
                 print("Deep link URL: \(url)")
              
             }
         }
         return true
     }

    // MARK: UISceneSession Lifecycle

    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
   
        Messaging.messaging().apnsToken = deviceToken
        if let token = Messaging.messaging().fcmToken {
            Store.deviceToken = token
            print("APNs fcm token 11: \(token)")
            
        }
        

    }
  
    func configureNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.alert, .sound, .badge]){ (granted, error) in }
            center.delegate = notificationDelegate
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil))
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
        
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("APNs fcm token-----22: \(fcmToken ?? "")")
     
        Store.deviceToken = fcmToken
    }
}


extension UIApplication {
    var hasNotch: Bool {
        if let window = UIApplication.shared.windows.first {
            let topInset = window.safeAreaInsets.top
            return topInset > 20
        }
        return false
    }
}
extension UIDevice {
    
    // Get this value after sceneDidBecomeActive
    var hasDynamicIsland: Bool {
        // 1. dynamicIsland only support iPhone
        guard userInterfaceIdiom == .phone else {
            return false
        }
               
        // 2. Get key window, working after sceneDidBecomeActive
        guard let window = (UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first { $0.isKeyWindow}) else {
            print("Do not found key window")
            return false
        }
       
        // 3.It works properly when the device orientation is portrait
        return window.safeAreaInsets.top >= 51
    }
}
