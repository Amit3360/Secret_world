//
//  UserNotifcations.swift
//  SecretWorld
//
//  Created by meet sharma on 30/04/24.
//

import Foundation
import Foundation
import UserNotifications
import UserNotificationsUI
import CoreLocation

class UserNotifcations: NSObject , UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var timer: Timer?
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
       // NotificationCenter.default.post(name: Notification.Name("gigCreated"), object: nil)
        completionHandler([.alert,.sound, .badge])
    }
    
    @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
            
       print("did Receive----")
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
            didRecieveBackgroundPushNotificaion(response: response)
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
    }
   

    private  func didRecieveBackgroundPushNotificaion(response: UNNotificationResponse){

        let userInfo = response.notification.request.content.userInfo
        let apsDict = userInfo["aps"] as? NSDictionary
        let alert = apsDict?["alert"] as? NSDictionary
        let gigId = userInfo["gigId"] as? String
        let popUpId = userInfo["popUpId"] as? String
        let gigUserId = userInfo["gigUser"] as? String
        let status = userInfo["status"] as? String
        let businessId = userInfo["businessId"] as? String
        let serviceId = userInfo["serviceId"] as? String
        let popUpUser = userInfo["popUpUser"] as? String
        print("GigId---",gigId ?? "")
        print("PopUpID---",popUpId ?? "")
        print("status---",status ?? "")
        print("businessId---",businessId ?? "")
        print("serviceId---",serviceId ?? "")
        print("popUpUser---",popUpUser ?? "")
        print(userInfo)
        
        if status == "1"{
            if Store.userId == gigUserId{
                if Store.role == "b_user"{
                    let topController = UIApplication.topViewController()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc: ApplyGigVC = storyboard.instantiateViewController(withIdentifier: "ApplyGigVC") as! ApplyGigVC
//                    vc.hidesBottomBarWhenPushed = false
//                    vc.gigId = gigId ?? ""
//                    vc.isComing = 1
//                    topController?.navigationController?.pushViewController(vc, animated: true)
                    let vc: ViewTaskVC = storyboard.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                    vc.hidesBottomBarWhenPushed = false
                    vc.gigId = gigId ?? ""
                    vc.isComing = 1
                    topController?.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let topController = UIApplication.topViewController()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc: UserApplyGigVC = storyboard.instantiateViewController(withIdentifier: "UserApplyGigVC") as! UserApplyGigVC
//                    vc.hidesBottomBarWhenPushed = false
//                    vc.gigId = gigId ?? ""
//                    topController?.navigationController?.pushViewController(vc, animated: true)
                    let vc: ViewTaskVC = storyboard.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                    vc.hidesBottomBarWhenPushed = false
                    vc.gigId = gigId ?? ""
                    vc.isComing = 0
                    topController?.navigationController?.pushViewController(vc, animated: true)
                }
               
            }else{
                let topController = UIApplication.topViewController()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc: ApplyGigVC = storyboard.instantiateViewController(withIdentifier: "ApplyGigVC") as! ApplyGigVC
//                vc.hidesBottomBarWhenPushed = false
//                vc.gigId = gigId ?? ""
//                topController?.navigationController?.pushViewController(vc, animated: true)
                let vc: ViewTaskVC = storyboard.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                vc.hidesBottomBarWhenPushed = false
                vc.gigId = gigId ?? ""
                vc.isComing = 0
                topController?.navigationController?.pushViewController(vc, animated: true)
            }
           
            
        }else if status == "2"{
            if Store.userId == popUpUser{
                
                let topController = UIApplication.topViewController()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: PopupUserVC = storyboard.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
                vc.hidesBottomBarWhenPushed = false
                vc.popupId = popUpId ?? ""
//                vc.isComing = true
                topController?.navigationController?.pushViewController(vc, animated: true)
            }else{
                
                let topController = UIApplication.topViewController()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: PopupUserVC = storyboard.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
                vc.hidesBottomBarWhenPushed = false
                vc.popupId = popUpId ?? ""
                topController?.navigationController?.pushViewController(vc, animated: true)
            }

        }else if status == "3"{
            let topController = UIApplication.topViewController()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: ServiceDetailVC = storyboard.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
            vc.hidesBottomBarWhenPushed = false
            vc.serviceId = serviceId ?? ""
            topController?.navigationController?.pushViewController(vc, animated: true)

        }else if status == "4"{
            let topController = UIApplication.topViewController()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: TransactionHistoryVC = storyboard.instantiateViewController(withIdentifier: "TransactionHistoryVC") as! TransactionHistoryVC
            vc.hidesBottomBarWhenPushed = false
            topController?.navigationController?.pushViewController(vc, animated: true)

        }else if status == "5"{
            let topController = UIApplication.topViewController()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: ChatVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.hidesBottomBarWhenPushed = false
            topController?.navigationController?.pushViewController(vc, animated: true)
        }else if status == "6"{
            let topController = UIApplication.topViewController()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: AboutServicesVC = storyboard.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
            vc.businessId = businessId ?? ""
            Store.BusinessUserIdForReview = businessId
            vc.hidesBottomBarWhenPushed = false
            topController?.navigationController?.pushViewController(vc, animated: true)
            
        }else if status == "7"{
            let topController = UIApplication.topViewController()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: WalletVC = storyboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
            isAddFunds = false
            vc.hidesBottomBarWhenPushed = false
            vc.isComing = true
            topController?.navigationController?.pushViewController(vc, animated: true)
        }else{
            let topController = UIApplication.topViewController()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: NotificationsVC = storyboard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
            vc.hidesBottomBarWhenPushed = false
            topController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
  
    func getCityNameFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (_ city:String) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion("")
            } else if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    completion(city)
                } else {
                    print("City not found for the given coordinates.")
                    completion("")
                }
            } else {
                print("No placemarks found for the given coordinates.")
                completion("")
            }
        }
    }
}



