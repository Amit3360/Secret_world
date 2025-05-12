//
//  UserProfileVM.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 09/02/24.
//

import Foundation
import UIKit
class UserProfileVM{
    func GetUserProfile(id:String,onSccess:@escaping((UserProfileData?)->())){
       
        WebService.service(API.getUserProfile,urlAppendId: id,service: .get,is_raw_form: true) { (model:GetUserProfileModel,jsonData,jsonSer) in
            
            onSccess(model.data)
            
        }
        
    }
    
    func GetUserProfileView(onSccess:@escaping((UserProfileData?)->())){
       
        WebService.service(API.getUserProfileView,service: .get,showHud: false,is_raw_form: true) { (model:GetUserProfileModel,jsonData,jsonSer) in
            
            onSccess(model.data)
            
        }
        
    }
    
    
    func getUserPolicyTermApi(type:String,onSccess:@escaping((GetPolicyTermData?)->())){
        let param: parameters = ["type":type]
        print(param)
        WebService.service(API.getPolicyTerm,urlAppendId: type,service: .get,showHud: true,is_raw_form: true) { (model:PloicyTermModel,jsonData,jsonSer) in
            
            onSccess(model.data)
            
        }
        
    }
    func getHelpCenterApi(type:String,onSccess:@escaping((GetHelpCenterData?)->())){
       
        WebService.service(API.getHelpCenter,urlAppendId: type,service: .get,showHud: false,is_raw_form: true) { (model:GetHelpCenterModel,jsonData,jsonSer) in
            
            onSccess(model.data)
            
        }
        
    }
    func logOutApi(deviceId:String,onSccess:@escaping(()->())){
        let param: parameters = ["deviceId":deviceId]
        print(param)
        WebService.service(API.logout,param: param,service: .post,showHud: false,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            
            onSccess()
            
        }
        
    }
    
    func UpdateUserProfileApi(name:String,
                              about:String,
                              dob:String,
                              gender:String,
                              place:String,
                              city:String,
                              country:String,
                              zipCode:String,
                              lat:Double,
                              long:Double,
                              profile_photo:UIImageView,
                              interests:[String],
                              specialization:[String],
                              dietary:[String],
                              onSccess:@escaping(()->())){
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        let date = formatter.string(from: Date())
        let imageInfo : ImageStructInfo
    
        imageInfo = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: profile_photo.image?.toData() ?? Data(), key: "profile_photo")
        
        var interestsDictArray = [[String: String]]()
        var specializationDictArray = [[String: String]]()
        var dietaryDictArray = [[String: String]]()
        
        for interest in interests {
            interestsDictArray.append(["id": interest])
        }
        
        for specializationItem in specialization {
            specializationDictArray.append(["id": specializationItem])
        }
        
        for dietaryItem in dietary {
            dietaryDictArray.append(["id": dietaryItem])
        }
        
        do {
                let interestJsonData = try JSONSerialization.data(withJSONObject: interestsDictArray)
                let specializeJsonData = try JSONSerialization.data(withJSONObject: specializationDictArray)
                let dietaryJsonData = try JSONSerialization.data(withJSONObject: dietaryDictArray)
                
                guard let interestJsonString = String(data: interestJsonData, encoding: .utf8),
                      let dietaryJsonString = String(data: dietaryJsonData, encoding: .utf8),
                      let specializeJsonString = String(data: specializeJsonData, encoding: .utf8) else {
                    print("Failed to convert JSON to string.")
                    return
                }
                
                let json: [String: Any] = ["name": name,
                                           "about": about,
                                           "dob": dob,
                                           "zipCode":zipCode,
                                           "city":city,
                                           "country":country,
                                           "gender": gender,
                                           "place":place,
                                           "lat": lat,
                                           "long":long,
                                           "profile_photo": imageInfo,
                                           "interests": interestJsonString,
                                           "specialization": specializeJsonString,
                                           "dietary": dietaryJsonString
                ]
               print(json)
                
//                let jsonData = try JSONSerialization.data(withJSONObject: json)
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print(jsonString)
              
                WebService.service(API.updateUserProfile,param: json,service: .put,is_raw_form: false) { (model:CommonModel,jsonData,jsonSer) in
                    
                    onSccess()
                }
//            } else {
//                print("Failed to convert JSON to string.")
//            }
        } catch {
            print("Error: \(error)")
        }
    }
}
