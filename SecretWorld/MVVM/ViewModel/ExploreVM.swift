//
//  ExploreVM.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/03/24.
//

import Foundation
import UIKit
class ExploreVM{
    func GetAllBusinessApi(offset:Int,limit:Int,Businessname:String,latitude:Double,longitude:Double,hideHud:Bool,onSccess:@escaping((GetAllBusinessDataa?)->())){
        let param:parameters = ["offset":offset,"limit":limit,"businessname":Businessname,"latitude":latitude,"longitude":longitude]
        print(param)
        WebService.service(API.getAllBusiness,param: param,service:.get,showHud: hideHud,is_raw_form: true) { (model:SeeAllBusinessModel,jsonData,jsonSer) in
            
            onSccess(model.data)
        }
        
    }
    func GetUserExploreApi(latitude:Double,longitude:Double,onSccess:@escaping((GetExploreData?)->())){
        let param:parameters = ["latitude":latitude,"longitude":longitude]
        print(param)
        WebService.service(API.getUserExplore,param: param,service: .get,showHud: false,is_raw_form: true) { (model:GetUserExploreModel,jsonData,jsonSer) in
            Store.ExploreData = model.data
            onSccess(model.data)
        }
        
    }
    
    func GetUserServiceDetailApi(user_id:String,loader:Bool,onSccess:@escaping((ServiceDetailsData?)->())){
        let param: parameters = ["user_id": user_id]
        print(param)
        WebService.service(API.getUserServiceDetail,param: param,service: .get,showHud: loader,is_raw_form: true) { (model:GetUserServiceDetail,jsonData,jsonSer) in
            Store.UserServiceDetailData = model.data
            Store.BusinessDetailData = model.data
            NotificationCenter.default.post(name: Notification.Name("GetStoreUserServices"), object: nil)
            
            
            onSccess(model.data)
        }
        
    }
    
    func AddBusinessReviewApi(businessUserId:String,
                              media:UIImageView,
                              comment:String,
                              starCount:String,
                              isUploading:Bool,
                              onSccess:@escaping(()->())){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let imageInfo : ImageStructInfo
        
        imageInfo = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: media.image?.toData() ?? Data(), key: "media")
        if isUploading == true{
            let param: parameters = ["businessUserId": businessUserId,
                                     "media": imageInfo,
                                     "comment": comment,
                                     "starCount": starCount,
                                     "isUploading":isUploading]
            print(param)
            WebService.service(API.addBusinessReview,param: param,service: .post,showHud: false,is_raw_form: false) { (model:CommonModel,jsonData,jsonSer) in
                
                onSccess()
            }
        }else{
            let paramWithImg: parameters = ["businessUserId": businessUserId,
                                            "comment": comment,
                                            "starCount": starCount,
                                            "isUploading":isUploading]
            print(paramWithImg)
            WebService.service(API.addBusinessReview,param: paramWithImg,service: .post,showHud: false,is_raw_form: false) { (model:CommonModel,jsonData,jsonSer) in
                
                onSccess()
            }
        }
        
        
    }
    func AddGigReviewApi(gigId:String,
                         businessUserId:String,
                         media:UIImageView,
                         comment:String,
                         starCount:String,
                         reviewType:Int,
                         isUploading:Bool,
                         onSccess:@escaping(()->())){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let imageInfo : ImageStructInfo
        
        imageInfo = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: media.image?.toData() ?? Data(), key: "media")
        if isUploading == true{
            let param: parameters = ["gigId": gigId,
                                     "businessUserId": businessUserId,
                                     "media": imageInfo,
                                     "comment": comment,
                                     "reviewType": reviewType,
                                     "starCount": starCount,
                                     "isUploading":isUploading]
            print(param)
            WebService.service(API.addGigReviewUserSide,param: param,service: .post,showHud: true,is_raw_form: false) { (model:CommonModel,jsonData,jsonSer) in
                
                onSccess()
            }
        }else{
            let paramWithImg: parameters = ["gigId": gigId,
                                            "businessUserId": businessUserId,
                                            "comment": comment,
                                            "starCount": starCount,
                                            "reviewType": reviewType,
                                            "isUploading":isUploading]
            print(paramWithImg)
            WebService.service(API.addGigReviewUserSide,param: paramWithImg,service: .post,showHud: false,is_raw_form: false) { (model:CommonModel,jsonData,jsonSer) in
                
                onSccess()
            }
        }
        
        
    }
    func GetReviewsApi(businessUserId:String,onSccess:@escaping((GetReviewData?)->())){
        let param: parameters = ["businessUserId": businessUserId]
        print(param)
        WebService.service(API.getReviews,param: param,service: .get,showHud: false,is_raw_form: true) { (model:GetReviewModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
        
    }
    
    func AddServiceReviewApi(service_id:String,
                              media:UIImageView,
                              comment:String,
                              starCount:String,
                              isUploading:Bool,
                              onSccess:@escaping(()->())){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let imageInfo : ImageStructInfo
        
        imageInfo = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: media.image?.toData() ?? Data(), key: "media")
        if isUploading == true{
            let param: parameters = ["service_id": service_id,
                                     "media": imageInfo,
                                     "comment": comment,
                                     "starCount": starCount,
                                     "isUploading":isUploading]
            print(param)
            WebService.service(API.addServiceReview,param: param,service: .post,showHud: false,is_raw_form: false) { (model:CommonModel,jsonData,jsonSer) in
                
                onSccess()
            }
        }else{
            let paramWithImg: parameters = ["service_id": service_id,
                                            "comment": comment,
                                            "starCount": starCount,
                                            "isUploading":isUploading]
            print(paramWithImg)
            WebService.service(API.addServiceReview,param: paramWithImg,service: .post,showHud: false,is_raw_form: false) { (model:CommonModel,jsonData,jsonSer) in
                
                onSccess()
            }
        }
        
        
    }
   // "targetType": "gig , business, service ",
    func updateReviewApi(targetType:String,
                         targetId:String,
                         comment:String,
                         starCount:String,
                         media:UIImageView,
                              isUploading:Bool,
                         onSccess:@escaping((_ message:String?)->())){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let imageInfo : ImageStructInfo
        
        imageInfo = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: media.image?.toData() ?? Data(), key: "media")
        if isUploading == true{
            let param: parameters = ["targetType": targetType,
                                     "targetId": targetId,
                                     "comment": comment,
                                     "starCount": starCount,
                                     "media": imageInfo,
                                     "isUploading":isUploading]
            print(param)
            WebService.service(API.updateReview,param: param,service: .put,showHud: true,is_raw_form: false) { (model:CommonModel,jsonData,jsonSer) in
                
                onSccess(model.message)
            }
        }else{
            let paramWithImg: parameters = ["targetType": targetType,
                                            "targetId": targetId,
                                            "comment": comment,
                                            "starCount": starCount,
                                            "isUploading":isUploading]
            print(paramWithImg)
            WebService.service(API.updateReview,param: paramWithImg,service: .put,showHud: true,is_raw_form: false) { (model:CommonModel,jsonData,jsonSer) in
                
                onSccess(model.message)
            }
        }
        
        
    }
}

