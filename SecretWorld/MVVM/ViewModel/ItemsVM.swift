//
//  ItemsVM.swift
//  SecretWorld
//
//  Created by Ideio Soft on 24/04/25.
//

import Foundation

class ItemsVM{
    
    func markSelectedItemApi(itemId:String,popupId:String,status:Bool,selectedQuantity:Double,showhud:Bool,onSuccess:@escaping(()->())){
        let param:parameters = ["popupId":popupId,"itemId":itemId,"status":status,"selectedQuantity":selectedQuantity]
        print(param)
        WebService.service(API.markSelectedItem,param: param,service: .post,showHud: showhud,is_raw_form: true) { (model:CommonModel,jsonSer,jsonData) in
            onSuccess()
        }
    }
    
    
    func addItemsCategoryApi(name:String,onSuccess:@escaping(()->())){
        let param:parameters = ["category":name]
        print(param)
        WebService.service(API.createItemCategory,param: param,service: .post,is_raw_form: true) { (model:CommonModel,jsonSer,jsonData) in
            onSuccess()
        }
    }
    func getAllItems(search:String,onSuccess:@escaping(([AllItem]?)->())){
        let param:parameters = ["search":search]
        print(param)
        WebService.service(API.getAllItems,param: param,service: .get,showHud: true,is_raw_form: true) { (model:GetAllItemModel,jsonSer,jsonData) in
            onSuccess(model.data?.allItems)
        }
    }
    
    func crateItemDiscountApi(discount:Double,discountType:Int,onSuccess:@escaping(()->())){
        let param:parameters = ["discount":discount,"discountType":discountType]
        print(param)
        WebService.service(API.createItemDiscount,param: param,service: .post,is_raw_form: true) { (model:CommonModel,jsonSer,jsonData) in
            onSuccess()
        }
    }
    
    func getItemsCategoryApi(onSuccess:@escaping((ItemCategoryData?)->())){
     
        WebService.service(API.getItemsCategory,service: .get,showHud: false,is_raw_form: true) { (model:ItemCategoryModel,jsonSer,jsonData) in
            onSuccess(model.data)
        }
    }
    func getItemdiscountApi(type:Int,onSuccess:@escaping((ItemDiscountData?)->())){
        let param:parameters = ["type":type]
        print(param)
        WebService.service(API.getitemdiscount,param: param,service: .get,showHud: false,is_raw_form: true) { (model:ItemDiscountModel,jsonSer,jsonData) in
            onSuccess(model.data)
        }
    }
    func editItemApi(popUpId:String,itemId:String,itemName:String,itemCategory:String,sellingType:Int,totalStock:Int,stockType:Int,sellingPrice:Double,image:[String],isHide:Bool,discount:Double,discountType:Int,onSuccess:@escaping(()->())){
        let param:parameters = ["popUpId":popUpId,"itemId":itemId,"itemName":itemName,"itemCategory":itemCategory,"sellingType":sellingType,"totalStock":totalStock,"stockType":stockType,"sellingPrice":sellingPrice,"image":image,"isHide":isHide,"discount":discount,"discountType":discountType,"description":""]
        print(param)
        WebService.service(API.editItem,param: param,service: .post,is_raw_form: true) { (model:ItemDiscountModel,jsonSer,jsonData) in
            onSuccess()
        }
    }
    func deleteItemAPi(popUpId:String,itemId:String,onSuccess:@escaping((String)->())){
        let param:parameters = ["popUpId":popUpId,"itemId":itemId]
        print(param)
        let id = "\(popUpId)/\(itemId)"
        WebService.service(API.deleteItem,urlAppendId: id,service: .delete,showHud: true,is_raw_form: true) { (model:CommonModel,jsonSer,jsonData) in
            onSuccess(model.message ?? "")
        }
    }
    func addSingleItemApi(popUpId:String,itemDetail:AddItems?,onSuccess:@escaping(()->())){
       
                let productInfo: [String: Any] = [
                    "itemName": itemDetail?.itemName ?? "",
                    "itemCategory": itemDetail?.itemCategory ?? "",
                    "sellingType" : itemDetail?.sellingType ?? 0,
                    "totalStock" : itemDetail?.totalStock ?? 0,
                    "stockType" : itemDetail?.stockType ?? 0,
                    "sellingPrice":itemDetail?.sellingPrice ?? 0,
                    "image": itemDetail?.image ?? [],
                    "description":itemDetail?.description ?? "",
                    "isHide": itemDetail?.isHide ?? false,
                    "discount":itemDetail?.discount ?? 0,
                    "discountType":itemDetail?.discountType ?? 0
                ]
              
            
      
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: productInfo)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                
                
                let param: [String: Any]
             
                    param = [
                     
                        //  "images":arrImages,
                        "item":productInfo,
                        "popUpId":popUpId]
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: param)
                
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(param)
                        
                        WebService.service(API.addSingleItem, param: jsonString, service: .post, showHud: true, is_raw_form: false) { (model: CommonModel, jsonData, jsonSer) in
                            onSuccess()
                        }
                    }
                }catch {
                print("Error: \(error)")
            }
      
        
        
    } else {
        print("Failed to convert JSON to string.")
    }
} catch {
    print("Error: \(error)")
}
    }
    
    func marksoldItemApi(popUpId:String,itemId:String,soldItems:Double,onSuccess:@escaping((String)->())){
        let param:parameters = ["popUpId":popUpId,"itemId":itemId,"soldItems":soldItems]
     
        print(param)
        WebService.service(API.markSoldItem,param: param,service: .post,showHud: true,is_raw_form: true) { (model:CommonModel,jsonSer,jsonData) in
            onSuccess(model.message ?? "")
        }
    }
}
