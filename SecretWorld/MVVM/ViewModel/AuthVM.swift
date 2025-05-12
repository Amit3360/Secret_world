//
//  AuthVM.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//

import Foundation
import UIKit

struct OpeningHour :Codable{
    let day:String?
    let startTime:String?
    let endTime:String?
    let status:String?
    enum CodingKeys: String, CodingKey {
        case day,startTime,endTime,status
    }
    
}

class AuthVM{
    var serviceJson = String()
    var openingHourJson = String()
    func SendMobileVerificationOtp(mobile:String,
                                   countrycode:String,
                                   deviceType:String,
                                   deviceId:String,
                                   onSccess:@escaping((GetVerficationdata?)->())){
        
        let param: parameters = ["mobile": mobile,
                                 "countrycode": countrycode,
                                 "deviceType": deviceType,
                                 "deviceId": deviceId]
        print(param)
        
        WebService.service(API.sendMobileOtp,param: param,service: .post,is_raw_form: true) { (model:MobileVerification,jsonData,jsonSer) in
            Store.authKey = model.data?.token ?? ""
            Store.userId = model.data?.newUser?.id ?? ""
            onSccess(model.data)
            
        }
        
    }
    func VerifyMobileOtp(otp:String,onSccess:@escaping((GetVerifyData?)->())){
        let param: parameters = ["otp": otp]
        print(param)
        WebService.service(API.mobileVerificationOtp,param: param,service: .post,is_raw_form: true) { (model:MobileVerifyModel,jsonData,jsonSer) in
            
            onSccess(model.data)
        }
        
    }
    func ResendOtp(onSccess:@escaping((DataClass?)->())){
        WebService.service(API.resendOtp,service: .post,showHud: false,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
        
    }
    
    
    
    func CreateAccountApi(usertype:String,
                          fullname:String,
                          dob:String,
                          gender:String,
                          profile_photo:UIImageView,
                          onSuccess:@escaping((GetUserData?)->())){
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let imageInfo : ImageStructInfo
        
        imageInfo = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: profile_photo.image?.toData() ?? Data(), key: "profileImage")
        var param = [String:Any]()
        
        param = ["usertype": usertype,
                 "fullname": fullname,
                 "dob":dob,
                 "gender": gender,
                 "profile_photo": imageInfo]
        
        print(param)
        
        WebService.service(API.createAccount,param: param,service: .post,is_raw_form: false){(model:CreateAccountModel,jsonData,jsonSer) in
            
            onSuccess(model.data)
        }
    }
    func UserFunstionsListApi(type:String,
                              offset:Int,
                              limit:Int,
                              search:String,
                              onSccess:@escaping((GetUserFunctionsData?)->())){
        
        let param: parameters = ["type": type,
//                                 "offset": offset,
//                                 "limit": limit,
                                 "search":search]
        print(param)
        
        WebService.service(API.userFunctionsList,param: param,service: .post,showHud: false,is_raw_form: true) { (model:UserFunctionsModel,jsonData,jsonSer) in
            
            onSccess(model.data)
            
        }
        
    }
    
    func CreateUserFunction(type:String,name:String,onSuccess:@escaping((CreateUserFunctionData?)->())){
        let param:parameters = ["type":type,"name":name]
        WebService.service(API.createUserFuntion,param: param,service: .post,is_raw_form: true) { (model:CreateUserFunctionModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
    func signUpApi(about: String, interests: [String], specialization: [String], dietary: [String], place: String, lat: Double, long: Double,deviceId:String, country:String,zipcode:String,city:String,onSuccess: @escaping ((GetSignupData?) -> ())) {
        
        
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
        
        let json: [String: Any] = [
            "about": about,
            "interests": interestsDictArray,
            "specialization": specializationDictArray,
            "dietary": dietaryDictArray,
            "place": place,
            "zipCode": zipcode,
            "city": city,
            "country": country,
            "lat": lat,
            "long": long,
            "deviceId": deviceId
        ]
        print(json)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                
                print(jsonString)
                
                WebService.service(API.completeUserAccount, param: jsonString, service: .post,showHud: false, is_raw_form: true) { (model: CompleteSignupModel, jsonData, jsonSer) in
                    onSuccess(model.data)
                }
            } else {
                print("Failed to convert JSON to string.")
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func GetServiceApi(offset:Int,
                       limit:Int,
                       search:String,
                       onSccess:@escaping((GetServiceData?)->())){
        
        let param: parameters = ["offset": offset,
                                 "limit": limit,
                                 "search": search]
        WebService.service(API.getServies,param: param,service: .get,showHud: false,is_raw_form: true) { (model:GetServiceModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
        
    }
    
    
    
    func CreateBusinessAccountApi(about: String,
                                  deviceId:String,
                                  businessname: String,
                                  place: String,
                                  lat: Double,
                                  long: Double,
                                  category:Int,
                                  business_id: UIImageView,
                                  cover_photo: UIImageView,
                                  services: [[String:String]],
                                  openinghours: [[String:String]],
                                  feature:[String],
                                  onSuccess: @escaping ((GetBusinessUserData?) -> ())) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        do {
            
            let outputArray = services.map { dictionary in
                return dictionary as [String: String]
            }
            
            let openingHourArray = openinghours.map { dictionary in
                return dictionary as [String:String]
            }
            if let jsonData = try? JSONSerialization.data(withJSONObject: outputArray, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("data===",jsonString)
                serviceJson = jsonString
            } else {
                print("Error converting array to JSON.")
            }
            
            if let jsonHourData = try? JSONSerialization.data(withJSONObject: openingHourArray, options: .prettyPrinted),
               let jsonString = String(data: jsonHourData, encoding: .utf8) {
                print("data===",jsonString)
                openingHourJson = jsonString
            } else {
                print("Error converting array to JSON.")
            }
            
            let imageInfoBusinessId : ImageStructInfo
            
            imageInfoBusinessId = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: business_id.image?.toData() ?? Data(), key: "business_id")
            
            let imageInfoCoverPhoto : ImageStructInfo
            
            imageInfoCoverPhoto = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: cover_photo.image?.toData() ?? Data(), key: "cover_photo")
            
            
            
            let param:parameters = ["about": about,
                                    "deviceId":deviceId,
                                    "businessname": businessname,
                                    "place": place,
                                    "lat": lat,
                                    "long": long,
                                    "business_id": imageInfoBusinessId,
//                                    "cover_photo": imageInfoCoverPhoto,
//                                    "services": "[]",
                                    "category":category,
                                    "openinghours": openingHourJson,"typesOfCategoryDetails":feature]
            
            //             print(services)
            print(param)
            
            WebService.service(API.createBusinessAccount, param: param, service: .post, is_raw_form: false) { (model: CreateBusinessAcModel, jsonData, jsonSer) in
                
                onSuccess(model.data)
                
            }
        } catch {
            print("Error converting dictionary to JSON: \(error)")
        }
        
        
        
    }
    func ChangeMobileNumberApi(mobile:String,countrycode:String,onSccess:@escaping((GetVerficationdata?)->())){
        
        let param: parameters = ["mobile": mobile,
                                 "countrycode": countrycode]
        print(param)
        
        WebService.service(API.chnageMobileNumber,param: param,service: .post,is_raw_form: true) { (model:MobileVerification,jsonData,jsonSer) in
            
            onSccess(model.data)
            
        }
        
    }
    func VerifyChangeMobileNumberWithOtpApi(otp:String,onSccess:@escaping(()->())){
        
        let param: parameters = ["otp": otp]
        
        print(param)
        
        WebService.service(API.otpForChangeMObileNumber,param: param,service: .post,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            
            onSccess()
            
        }
        
    }
    func verificationStatus(onSuccess:@escaping((VerificationStatusData?)->())){
        WebService.service(API.verificationStatus,service: .get,showHud: false,is_raw_form: true) { (model:VerificationStatusModel,jsonData,jsonSer) in
            Store.VerificationStatus = model.data?.verificationStatus ?? 0
            onSuccess(model.data)
        }
    }
    func verificationRequest(onSuccess:@escaping(()->())){
        WebService.service(API.verificationRequest,service: .post,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSuccess()
        }
    }
    
    func socialLoginApi(socialId:String,
                        name:String,
                        profile_photo:String,
                        socialType:String,
                        usertype:String,
                        latitude:String,
                        longitude:String,
                        mobile:String,
                        fcmToken:String,
                        onSuccess:@escaping((SocialLoginData?)->())){
        
        var param = [String:Any]()
        
        param = ["socialId":socialId,"name":name,"profile_photo":profile_photo,"socialType":socialType,"usertype":usertype,"latitude":latitude,"longitude":longitude,"mobile":mobile,"fcmToken":fcmToken]
        
        print(param)
        
        WebService.service(API.socialLogin,param: param,service: .post,is_raw_form: true){(model:SocialLoginModel,jsonData,jsonSer) in
            
            onSuccess(model.data)
        }
    }
}
