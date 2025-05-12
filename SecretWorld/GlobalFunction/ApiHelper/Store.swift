//
//  Store.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/24.
//

import Foundation
import UIKit
class Store {

    class var ProductsImages: [String]? {
        set {
            Store.saveValue(newValue, .ProductsImages)
        }
        get {
            return (Store.getValue(.ProductsImages) as? [String]) ?? []
        }
    }
    class var CurrentUserId: String? {
        set {
            Store.saveValue(newValue, .CurrentUserId)
        }
        get {
            return (Store.getValue(.CurrentUserId) as? String) ?? ""
        }
    }

    class var ServiceImg: [Any]?{
        set{
            Store.saveValue(newValue, .ServiceImg)
        }
        get{
            return Store.getValue(.ServiceImg) as? [Any]
        }
    }
    class var GigType: Int? {
        set {
            Store.saveValue(newValue, .GigType)
        }
        get {
            return (Store.getValue(.GigType) as? Int) ?? 2
        }
    }

    class var AddGigImage: UIImage?{
        set{
            Store.saveValue(newValue, .AddGigImage)
        }
        get{
            return Store.getValue(.AddGigImage) as? UIImage
        }
    }
    class var AddGigDetail: [String:Any]?{
        set{
            Store.saveValue(newValue, .AddGigDetail)
        }get{
            return Store.getValue(.AddGigDetail) as? [String:Any] ?? [:]
        }
    }
    class var WalletAmount: Double?{
        set{
            Store.saveValue(newValue, .WalletAmount)
        }get{
            return Store.getValue(.WalletAmount) as? Double
        }
    }
    class var commisionAmount: String?{
        set{
            Store.saveValue(newValue, .commisionAmount)
        }get{
            return Store.getValue(.commisionAmount) as? String
        }
    }
    class var GigFees: Int?{
        set{
            Store.saveValue(newValue, .GigFees)
        }get{
            return Store.getValue(.GigFees) as? Int
        }
    }
    class var VerificationStatus: Int?{
        set{
            Store.saveValue(newValue, .VerificationStatus)
        }get{
            return Store.getValue(.VerificationStatus) as? Int
        }
    }

    class var userNotificationCount: Int?{
        set{
            Store.saveValue(newValue, .userNotificationCount)
        }
        get{
            return Store.getValue(.userNotificationCount) as? Int
        }
    }
    class var BusinessServicesList: GetBusinessServiceData?{
        set{
            Store.saveUserDetails(newValue, .userDetails)
        }get{
            return Store.getUserDetails(.userDetails)
        }
    }
    class var UserServiceDetailData: ServiceDetailsData?{
        set{
            Store.saveUserDetails(newValue, .userDetails)
        }get{
            return Store.getUserDetails(.userDetails)
        }
    }
 
    class var getBusinessDetail: GetBusinessDetail?{
        set{
            Store.saveUserDetails(newValue, .userDetails)
        }get{
            return Store.getUserDetails(.userDetails)
        }
    }
    
    class var userId: String?{
        set{
            Store.saveValue(newValue, .userId)
        }get{
            return Store.getValue(.userId) as? String
        }
    }
    class var recevrID: String?{
        set{
            Store.saveValue(newValue, .recevrID)
        }get{
            return Store.getValue(.recevrID) as? String
        }
    }
    class var ExploreData: GetExploreData?{
        set{
            Store.saveUserDetails(newValue, .userDetails)
        }get{
            return Store.getUserDetails(.userDetails)
        }
    }
    
    class var NotificationData: [Notifications]?{
        set{
            Store.saveUserDetails(newValue, .userDetails)
        }get{
            return Store.getUserDetails(.userDetails)
        }
    }
    
    class var userLatLong: [String:Any]?{
        set{
            Store.saveValue(newValue, .userLatLong)
        }get{
            return Store.getValue(.userLatLong) as? [String:Any] ?? [:]
        }
    }
  
    class var filterData: [String:Any]?{
        set{
            Store.saveValue(newValue, .filterData)
        }get{
            return Store.getValue(.filterData) as? [String:Any] ?? [:]
        }
    }
    
    class var filterDataPopUp: [String:Any]?{
        set{
            Store.saveValue(newValue, .filterDataPopUp)
        }get{
            return Store.getValue(.filterDataPopUp) as? [String:Any] ?? [:]
        }
    }
    
    class var filterDataBusiness: [String:Any]?{
        set{
            Store.saveValue(newValue, .filterDataBusiness)
        }get{
            return Store.getValue(.filterDataBusiness) as? [String:Any] ?? [:]
        }
    }
    class var businessLatLong: [String:Any]?{
        set{
            Store.saveValue(newValue, .businessLatLong)
        }get{
            return Store.getValue(.businessLatLong) as? [String:Any] ?? [:]
        }
    }
    class var SearchResult: [String]{
        set{
            Store.saveValue(newValue, .searchResult)
        }get{
            return Store.getValue(.searchResult) as? [String] ?? []
        }
    }
    class var taskMiles: [Int]{
        set{
            Store.saveValue(newValue, .taskMiles)
        }get{
            return Store.getValue(.taskMiles) as? [Int] ?? []
        }
    }
    class var ServiceId: String?{
        set{
            Store.saveValue(newValue, .ServiceId)
        }get{
            return Store.getValue(.ServiceId) as? String
        }
    }
    class var BusinessUserIdForReview: String?{
        set{
            Store.saveValue(newValue, .BusinessUserIdForReview)
        }get{
            return Store.getValue(.BusinessUserIdForReview) as? String
        }
    }
    class var BusinessDetailData: ServiceDetailsData?{
        set{
            Store.saveBusinessDetail(newValue, .businessDetail)
        }get{
            return Store.getBusinessDetail(.businessDetail)
        }
    }
    class var ServiceDetailData: GetServiceDetailDataa?{
        set{
            Store.saveUserDetails(newValue, .userDetails)
        }get{
            return Store.getUserDetails(.userDetails)
        }
    }
    class var SubCategoriesId: [String:Any]?{
        set{
            Store.saveValue(newValue, .SubCategoriesId)
        }get{
            return Store.getValue(.SubCategoriesId) as? [String:Any] ?? [:]
        }
    }
    class var UserDetail: [String:Any]?{
        set{
            Store.saveValue(newValue, .UserDetail)
        }get{
            return Store.getValue(.UserDetail) as? [String:Any] ?? [:]
        }
    }
    class var BusinessUserDetail: [String:Any]?{
        set{
            Store.saveValue(newValue, .BusinessUserDetail)
        }get{
            return Store.getValue(.BusinessUserDetail) as? [String:Any] ?? [:]
        }
    }
    class var SearchCategories: [String]?{
        set{
            Store.saveValue(newValue, .SearchCategories)
        }get{
            return Store.getValue(.SearchCategories) as? [String]
        }
    }
    class var role: String?{
        set{
            Store.saveValue(newValue, .role)
        }
        get{
            return Store.getValue(.role) as? String
        }
    }
    
    class var gigDetail: [String:Any]?{
        set{
            Store.saveValue(newValue, .gigDetail)
        }get{
            return Store.getValue(.gigDetail) as? [String:Any] ?? [:]
        }
    }
   
    class var GigChatDetail: [GroupChatModel]?{
        set{
            Store.saveUserDetails(newValue, .userDetails)
        }get{
            return Store.getUserDetails(.userDetails)
        }
    }
    class var aboutHeight: CGFloat?{
        set{
            Store.saveValue(newValue, .aboutHeight)
        }
        get{
            return Store.getValue(.aboutHeight) as? CGFloat ?? 0
        }
    }
    
    class var reviewHeight: CGFloat?{
        set{
            Store.saveValue(newValue, .reviewHeight)
        }
        get{
            return Store.getValue(.reviewHeight) as? CGFloat ?? 0
        }
    }
  
    class var tabBarNotificationPosted: Bool?{
        set{
            Store.saveValue(newValue, .tabBarNotificationPosted)
        }
        get{
            return Store.getValue(.tabBarNotificationPosted) as? Bool
        }
    }
    class var isUserParticipantsList: Bool?{
        set{
            Store.saveValue(newValue, .isUserParticipantsList)
        }
        get{
            return Store.getValue(.isUserParticipantsList) as? Bool
        }
    }
    class var isSelectTab: Bool?{
        set{
            Store.saveValue(newValue, .isSelectTab)
        }
        get{
            return Store.getValue(.isSelectTab) as? Bool ?? false
        }
    }
    
    class var isSelectGigFilter: Bool?{
        set{
            Store.saveValue(newValue, .isSelectGigFilter)
        }
        get{
            return Store.getValue(.isSelectGigFilter) as? Bool ?? false
        }
    }
    class var isSelectPopUpFilter: Bool?{
        set{
            Store.saveValue(newValue, .isSelectPopUpFilter)
        }
        get{
            return Store.getValue(.isSelectPopUpFilter) as? Bool ?? false
        }
    }
    class var isSelectBusinessFilter: Bool?{
        set{
            Store.saveValue(newValue, .isSelectBusinessFilter)
        }
        get{
            return Store.getValue(.isSelectBusinessFilter) as? Bool ?? false
        }
    }
    class var getPopUp: Bool?{
        set{
            Store.saveValue(newValue, .getPopUp)
        }
        get{
            return Store.getValue(.getPopUp) as? Bool
        }
    }
    
    class var isLocationSelected: Bool?{
        set{
            Store.saveValue(newValue, .isLocationSelected)
        }
        get{
            return Store.getValue(.isLocationSelected) as? Bool ?? false
        }
    }
    
    class var connectSocket: Bool?{
        set{
            Store.saveValue(newValue, .connectSocket)
        }
        get{
            return Store.getValue(.connectSocket) as? Bool ?? false
        }
    }
    class var LogoImage: UIImage?{
        set{
            Store.saveValue(newValue, .LogoImage)
        }
        get{
            return Store.getValue(.LogoImage) as? UIImage
        }
    }
    class var MarkerLogo: UIImage?{
        set{
            Store.saveValue(newValue, .MarkerLogo)
        }
        get{
            return Store.getValue(.MarkerLogo) as? UIImage
        }
    }
    class var GigImg: UIImage?{
        set{
            Store.saveValue(newValue, .GigImg)
        }
        get{
            return Store.getValue(.GigImg) as? UIImage
        }
    }
    class var ServiceImages: UIImage?{
        set{
            Store.saveValue(newValue, .ServiceImages)
        }
        get{
            return Store.getValue(.ServiceImages) as? UIImage
        }
    }
    class var EditUserProfileImag: UIImage?{
        set{
            Store.saveValue(newValue, .EditUserProfileImag)
        }
        get{
            return Store.getValue(.EditUserProfileImag) as? UIImage
        }
    }
    class var UserProfilePicSignupTime: UIImage?{
        set{
            Store.saveValue(newValue, .UserProfilePicSignupTime)
        }
        get{
            return Store.getValue(.UserProfilePicSignupTime) as? UIImage
        }
    }
    class var UserProfileImage: UIImage?{
        set{
            Store.saveValue(newValue, .LogoImage)
        }
        get{
            return Store.getValue(.LogoImage) as? UIImage
        }
    }
    class var UserProfileViewImage: UIImage?{
        set{
            Store.saveValue(newValue, .UserProfileViewImage)
        }
        get{
            return Store.getValue(.UserProfileViewImage) as? UIImage
        }
    }
    class var BusinessIdImage: UIImage?{
        set{
            Store.saveValue(newValue, .BusinessIdImage)
        }
        get{
            return Store.getValue(.BusinessIdImage) as? UIImage
        }
    }
    class var CoverImage: UIImage?{
        set{
            Store.saveValue(newValue, .CoverImage)
        }
        get{
            return Store.getValue(.CoverImage) as? UIImage
        }
    }
    class var autoLogin: Int?{
        set{
            Store.saveValue(newValue, .autoLogin)
        }get{
            return Store.getValue(.autoLogin) as? Int
        }
    }
    
  
    class var authKey: String?{
        set{
            Store.saveValue(newValue, .authKey)
        }get{
            return Store.getValue(.authKey) as? String
        }
    }
  
  
    class var deviceToken: String?{
        set{
            Store.saveValue(newValue, .deviceToken)
        }
        get{
            return Store.getValue(.deviceToken) as? String
        }
    }
    
   
    static var remove: DefaultKeys!{
        didSet{
            Store.removeKey(remove)
        }
    }
    
    //MARK:-  Private Functions
    
    private class func removeKey(_ key: DefaultKeys){
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        if key == .userDetails{
            UserDefaults.standard.removeObject(forKey: DefaultKeys.authKey.rawValue)
        }
        UserDefaults.standard.synchronize()
    }
    
    private class func saveValue(_ value: Any?, _ key: DefaultKeys) {
        guard let value = value else { return } // Return if value is nil
        
        var data: Data?
        do {
            data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
        } catch {
            print("Error archiving value for \(key): \(error)")
        }

        UserDefaults.standard.set(data, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
 
    //For model
    private class func saveUserDetails<T: Codable>(_ value: T?, _ key: DefaultKeys) {
        guard let value = value else { return } // Return if value is nil
        
        do {
            let data = try PropertyListEncoder().encode(value)
            Store.saveValue(data, key)
        } catch {
            print("Error encoding object for \(key): \(error)")
        }
    }

    private class func getUserDetails<T: Codable>(_ key: DefaultKeys) -> T? {
        if let data = self.getValue(key) as? Data {
            do {
                let model = try PropertyListDecoder().decode(T.self, from: data)
                return model
            } catch {
                print("Error decoding object for \(key): \(error)")
                return nil
            }
        }
        return nil
    }
    private class func saveBusinessDetail<T: Codable>(_ value: T?, _ key: DefaultKeys) {
        guard let value = value else { return } // Return if value is nil
        
        do {
            let data = try PropertyListEncoder().encode(value)
            Store.saveValue(data, key)
        } catch {
            print("Error encoding object for \(key): \(error)")
        }
    }

    private class func getBusinessDetail<T: Codable>(_ key: DefaultKeys) -> T? {
        if let data = self.getValue(key) as? Data {
            do {
                let model = try PropertyListDecoder().decode(T.self, from: data)
                return model
            } catch {
                print("Error decoding object for \(key): \(error)")
                return nil
            }
        }
        return nil
    }
    private class func getValue(_ key: DefaultKeys) -> Any {
        if let data = UserDefaults.standard.value(forKey: key.rawValue) as? Data {
            do {
                if let value = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) {
                    return value
                } else {
                    return "" // Handle if value could not be unarchived
                }
            } catch {
                print("Error unarchiving value for \(key): \(error)")
                return "" // Handle error case
            }
        } else {
            return "" // Return empty string if no data is found for the key
        }
    }
    
}
