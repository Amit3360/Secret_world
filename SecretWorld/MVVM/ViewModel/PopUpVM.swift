//
//  PopUpVM.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 10/04/24.
//

import Foundation
import UIKit

class PopUpVM {
    var jsonString = ""
    func AddPopUpApi(usertype: String,
                     place:String,
                     storeType:Int,
                     name: String,
                     business_logo: UIImageView,
                     startDate: String,
                     endDate: String,
                     lat: Double,
                     long: Double,
                     deals:String,
                     availability:Int,
                     description: String,
                     categoryType:Int,
                     addProducts: [Products],
                     addItems: [AddItems],
                     closedDays:[String],
                   //  arrImages:[String],
                     onSuccess: @escaping ((_ message:String?) -> ())) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let imageInfo = ImageStructInfo(fileName: "Img\(date).jpeg", type: "jpeg", data: business_logo.image?.toData() ?? Data(), key: "business_logo")
        
        var productDict = [[String: Any]]()
        if categoryType == 5{
            for items in addItems {
                let productInfo: [String: Any] = [
                    "itemName": items.itemName ?? "",
                    "itemCategory": items.itemCategory ?? "",
                    "sellingType" : items.sellingType ?? 0,
                    "totalStock" : items.totalStock ?? 0,
                    "stockType" : items.stockType ?? 0,
                    "sellingPrice":items.sellingPrice ?? 0,
                    "image": items.image ?? [],
                    "description":items.description ?? "",
                    "isHide": items.isHide ?? false,
                    "discount":items.discount ?? 0,
                    "discountType":items.discountType ?? 0
                ]
                productDict.append(productInfo)
            }
        }else{
            for product in addProducts {
                let productInfo: [String: Any] = [
                    "productName": product.name ?? "",
                    "price": product.price ?? 0,
                    "image": product.images ?? [],
                    "description": product.description ?? "",
                    "isHide": product.isHide ?? false
                ]
                productDict.append(productInfo)
            }
        }
       
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: productDict)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                
                
                let param: [String: Any]
                if categoryType == 5{
                    param = [
                        "place": place,
                        "storeType": storeType,
                        "usertype": usertype,
                        "name": name,
                        "business_logo": imageInfo,
                        "startDate": startDate,
                        "endDate": endDate,
                        "lat": lat,
                        "deals":deals,
                        "availability":availability,
                        "long": long,
                        //  "images":arrImages,
                        "addItems":jsonString,
                        "closedDays":closedDays,
                        "description": description,
                        "categoryType":categoryType]
                }else{
                    param = [
                        "place": place,
                        "storeType": storeType,
                        "usertype": usertype,
                        "name": name,
                        "business_logo": imageInfo,
                        "startDate": startDate,
                        "endDate": endDate,
                        "lat": lat,
                        "deals":deals,
                        "availability":availability,
                        "long": long,
                        //  "images":arrImages,
                        "addProducts":jsonString,
                        "closedDays":closedDays,
                        "description": description,
                        "categoryType":categoryType]
                }
        print(param)
        
        WebService.service(API.addPopup, param: param, service: .post, showHud: true, is_raw_form: false) { (model: CommonModel, jsonData, jsonSer) in
            onSuccess(model.message)
        }
        
    } else {
        print("Failed to convert JSON to string.")
    }
} catch {
    print("Error: \(error)")
}
}
    
    func getPopupDetailApi(loader:Bool,popupId:String,onSuccess:@escaping((PopupDetailData?)->())){
        let param:parameters = ["popupId":popupId]
        print(param)
        WebService.service(API.popupDetail,param: param,service: .get,showHud: loader,is_raw_form: true) { (model:PopupDetailModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
    func deletePopuptApi(id:String,onSuccess:@escaping((_ message:String?)->())){
        WebService.service(API.deletePopup,urlAppendId: id,service: .delete,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSuccess(model.message)
        }
    }
    
    
    func UpdatePopUpApi(id:String,
                        usertype: String,
                        place:String,
                        storeType:Int,
                        name: String,
                        business_logo: UIImageView,
                        startDate: String,
                        endDate: String,
                        lat: Double,
                        long: Double,
                        deals:String,
                        availability:Int,
                        description: String,
                        categoryType:Int,
                        arrImages:[String],
                        addProducts: [AddProducts],
                        addItems: [AddItems],
                        onSuccess: @escaping ((_ message:String?) -> ())) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let imageInfo = ImageStructInfo(fileName: "Img\(date).jpeg", type: "jpeg", data: business_logo.image?.toData() ?? Data(), key: "business_logo")
        var productDict = [[String: Any]]()
        if categoryType == 5{
            for items in addItems {
                let productInfo: [String: Any] = [
                    "itemName": items.itemName ?? "",
                    "itemCategory": items.itemCategory ?? "",
                    "sellingType" : items.sellingType ?? 0,
                    "totalStock" : items.totalStock ?? 0,
                    "stockType" : items.stockType ?? 0,
                    "sellingPrice":items.sellingPrice ?? 0,
                    "image": items.image ?? [],
                    "description":items.description ?? "",
                    "isHide": items.isHide ?? false,
                    "discount":items.discount ?? 0,
                    "discountType":items.discountType ?? 0
                ]
                productDict.append(productInfo)
            }
        }else{
            for product in addProducts {
                let productInfo: [String: Any] = [
                    "productName": product.productName ?? "",
                    "price": product.price ?? 0,
                    "image": product.image ?? [],
                    "description": product.description ?? "",
                    "isHide": product.isHide ?? false
                    
                ]
                productDict.append(productInfo)
            }
        }
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: productDict)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)

                let param: [String: Any]
                if categoryType == 5{
                    param = [
                        "id":id,
                        "place": place,
                        "storeType": storeType,
                        "usertype": usertype,
                        "name": name,
                        "business_logo": imageInfo,
                        "startDate": startDate,
                        "endDate": endDate,
                        "lat": lat,
                        "deals":deals,
                        "availability":availability,
                        "long": long,
                        "images":arrImages,
                        "description": description,
                        "addItems":jsonString,
                        "categoryType":categoryType]
                }else{
                    param = [
                        "id":id,
                        "place": place,
                        "storeType": storeType,
                        "usertype": usertype,
                        "name": name,
                        "business_logo": imageInfo,
                        "startDate": startDate,
                        "endDate": endDate,
                        "lat": lat,
                        "deals":deals,
                        "availability":availability,
                        "long": long,
                        "images":arrImages,
                        "description": description,
                        "addProducts":jsonString,
                        "categoryType":categoryType]
                }
                print(param)
                WebService.service(API.updatePopup, param: param, service: .put, showHud: true, is_raw_form: false) { (model: CommonModel, jsonData, jsonSer) in
                    onSuccess(model.message)
                }
                
            } else {
                print("Failed to convert JSON to string.")
            }
        } catch {
            print("Error: \(error)")
        }
    }
    func acceptRejectPopupRequestApi(requestId:String,status:Int,onSuccess:@escaping(()->())){
        WebService.service(API.acceptRejectPopupRequests,urlAppendId: "\(requestId)/\(status)",service: .put,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSuccess()
        }
    }
    func getPopupRequestApi(popUpId:String,
                            offset:Int,
                            limit:Int,
                            type:Int,
                            loader:Bool,
                            onSuccess:@escaping((GetPopupRequestData?)->())){
        let param:parameters = ["popUpId":popUpId,
                                "offset":offset,
                                "limit":limit,
                                "type":type,]
        print(param)
        WebService.service(API.getPopupRequests,param: param,service: .get,showHud: loader,is_raw_form: true) { (model:GetPopupRequestModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
    func getPopupListApi(offset:Int,
                         limit:Int,
                         type:Int,
                         onSuccess:@escaping((GetPopupsData?)->())){
        let param:parameters = ["offset":offset,
                                "limit":limit,
                                "type":type,]
        print(param)
        WebService.service(API.GetPopupList,param: param,service: .get,showHud: true,is_raw_form: true) { (model:GetPopupsListModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
    func applyPopupApi(popupId:String,
                       message:String,typeName:String,
                       onSuccess:@escaping((_ message:String?)->())){
        let param:parameters = ["popupId":popupId,
                                "message":message,"type":"popup","typeId":popupId,"typeName":typeName]
        print(param)
        WebService.service(API.applyPopup,param: param,service: .post,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            
            onSuccess(model.message ?? "")
            
        }
    }
    func getAllPopupApi(offset:Int,
                        limit:Int,
                        name:String,
                        loader:Bool,
                        onSuccess:@escaping((PopupData?)->())){
        let param:parameters = ["offset":offset,
                                "limit":limit,
                                "name":name]
        print(param)
        WebService.service(API.getAllPopup,param: param,service: .get,showHud: loader,is_raw_form: true) { (model:SeeAllPopupModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
    func searchAllApi(offset:Int,
                      limit:Int,
                      search:String,
                      onSuccess:@escaping((GetSearchData?)->())){
        let param:parameters = ["offset":offset,
                                "limit":limit,
                                "search":search]
        print(param)
        WebService.service(API.searchAll,param: param,service: .get,showHud: false,is_raw_form: true) { (model:SearchAllModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
    func searchHomeApi(lat:Double,long:Double,search:String,onSucess:@escaping(([HomeSearch]?)->())){
        let param:parameters = ["lat":lat,"long":long,"search":search]
        WebService.service(API.searchHomeData,param: param,service: .get,showHud: false,is_raw_form: false) { (model:SearchHomeModel,jsonSer,josnData) in
            onSucess(model.data?.data)
        }
    }
    
    func deletePopupReview(reviewId:String,onSuccess:@escaping((_ message:String?)->())){
        let param:parameters = ["reviewId":reviewId]
        WebService.service(API.deletePopupReview,urlAppendId:reviewId,service: .delete,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSuccess(model.message)
        }
    }
    
    func openCloseStoreApi(popUpId:String,status:Bool,onSuccess:@escaping((_ message:String?)->())){
        let param:parameters = ["popUpId":popUpId,"status":status]
        WebService.service(API.openCloseStore,param: param,service: .post,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSuccess(model.message)
        }
    }

}



