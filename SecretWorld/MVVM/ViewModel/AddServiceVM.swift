//
//  AddServiceVM.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 05/02/24.
//

import Foundation
import UIKit
class AddServiceVM{
    func GetServiceDetailUserSideApi(service_id:String,onSccess:@escaping((GetServiceDataaa?)->())){
        let param: parameters = ["service_id": service_id]
        print(param)
        WebService.service(API.getServiceDetailUserSide,param: param,service: .get,is_raw_form: true) { (model:GetServiceDetailUserModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
        
    }
    func DeleteServiceApi(id:String,onSccess:@escaping((_ messsage:String?)->())){
        
        WebService.service(API.deleteService,urlAppendId: id,service: .delete,showHud: false,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message)
        }
        
    }
    func getBusinessServiceDetailApi(service_id:String,onSccess:@escaping((GetServiceDetailDataa?)->())){
        let param: parameters = ["service_id": service_id]
        WebService.service(API.getServiceDetail,param: param,service: .get,is_raw_form: true) { (model:GetBServiceDetailModel,jsonData,jsonSer) in
            Store.ServiceDetailData = model.data
            NotificationCenter.default.post(name: Notification.Name("GetStoreServiceData"), object: nil)

            onSccess(model.data)
        }
        
    }
    
    func getSelectedeCtegoriesApi(onSccess:@escaping((GetCategoryData?)->())){
        
        WebService.service(API.getSelectedCategory,service: .get,showHud: false,is_raw_form: true) { (model:GetSelectedCategoryModel,jsonData,jsonSer) in
            
            onSccess(model.data)
        }
        
    }
    func getServiceCtegoriesApi(offset:Int,
                                limit:Int,
                                search:String,
                                onSccess:@escaping((GetCategoriesData?)->())){
        
        let param: parameters = ["offset": "",
                                 "limit": "",
                                 "search": search]
        
        WebService.service(API.getServiceCategories,param: param,service: .get,showHud: false,is_raw_form: true) { (model:GetServiceCategoryModel,jsonData,jsonSer) in
            
            onSccess(model.data)
        }
        
    }
    func getSubCtegoriesApi(service_id:String,
                            offset:Int,
                            limit:Int,
                            search:String,
                            onSccess:@escaping((GetSubCategoryData?)->())){
        
        let param: parameters = ["service_id":service_id,
                                 "offset": offset,
                                 "limit": limit,
                                 "search": search,]
        
        WebService.service(API.getSubcategory,param: param,service: .get,showHud: false,is_raw_form: true) { (model:GetSubCategoryModel,jsonData,jsonSer) in
            
            onSccess(model.data)
        }
        
    }
    func getSubCatories(type:Int,
                        offset:Int,
                        limit:Int,
                        search:String,
                        onSccess:@escaping((SubCategoryData?)->())){
        let param: parameters = ["offset": offset,
                                 "limit": limit,
                                 "search": search]
        
        WebService.service(API.getSubcategory,param: param,service: .get,showHud: false,is_raw_form: true) { (model:SubCategoryModel,jsonData,jsonSer) in
            
            onSccess(model.data)
        }
    }
    
    func addServiceApi(serviceName: String,
                       price: String,
                       discount: String,
                       description: String,
                       serviceImages: [UIImage],
                       catSubcatArr: [String], // Changed type to [String]
                       onSuccess: @escaping ((GetUserData?,String) -> Void)) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.fullDate.rawValue
        let currentDate = dateFormatter.string(from: Date())

        let imageStructArr: [ImageStructInfo] = serviceImages.enumerated().map { index, image in
            ImageStructInfo(
                fileName: "\(index).png",
                type: "image/png",
                data: image.toData() ?? Data(),
                key: "media"
            )
        }

     
        let params: [String: Any] = [
            "serviceName": serviceName,
            "price": price,
            "discount": discount,
            "description": description,
            "serviceImage": imageStructArr,
            "catSubcatArr": catSubcatArr // Sending as JSON string
        ]
        print(params)
        WebService.service(API.addService, param: params, service: .post, is_raw_form: false) { (model: CreateAccountModel, _, _) in
            onSuccess(model.data, model.message ?? "")
        }
    }
    
    func getAllService(loader:Bool,offSet:Int,limit:Int,onSuccess:@escaping((GetBusinessServiceData?)->())){
      
//        let param:parameters = ["offset":offSet,"limit":limit]
        WebService.service(API.getAllBusinessService,service: .get, showHud: loader,is_raw_form: true) { (model:GetBusinessServiceModel,jsonData,jsonSer)in
           
            onSuccess(model.data)
        }
    }
    func EdiServiceApi(service_id: String,
                       serviceName: String,
                       price: String,
                       discount: String,
                       description: String,
                       catSubcatArr:[String],
                       serviceImage: [Any],
                       deletedserviceImages: [Any],
                       onSuccess: @escaping((_ message:String?) -> ())) {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        let date = formatter.string(from: Date())
        
        var imageStructArr = [ImageStructInfo]()
        for (index, mediaItem) in serviceImage.enumerated() {
            if let image = mediaItem as? UIImage {
                let imgStruct = ImageStructInfo(
                    fileName: "\(index).png",
                    type: "image/png",
                    data: image.toData() ?? Data() ,
                    key: "serviceImage"
                )
                imageStructArr.append(imgStruct)
                
            }
        }
        
        do {
            
                let param: [String: Any] = ["service_id":service_id,
                                           "serviceName": serviceName,
                                           "price": price,
                                            "discount": discount,
                                           "description": description,
                                           "serviceImage": imageStructArr,
                                            "catSubcatArr": catSubcatArr,
                                           "deletedserviceImages": deletedserviceImages
                ]
          print(param)
                WebService.service(API.UpdateService, param: param, service: .put, is_raw_form: false) { (model: CommonModel, jsonData, jsonSer) in
                    onSuccess(model.message)
                }
            }
        }
    
    func createSubServicesApi(serviceName:String,
                              name:String,
                                onSccess:@escaping((SubServiceData?)->())){
        
        let param: parameters = ["serviceName": serviceName,
                                 "name": name]
        print(param)
        WebService.service(API.createSubServices,param: param,service: .post,showHud: false,is_raw_form: true) { (model:GetSubServiceModel,jsonData,jsonSer) in
            
            onSccess(model.message)
        }
        
    }

}
