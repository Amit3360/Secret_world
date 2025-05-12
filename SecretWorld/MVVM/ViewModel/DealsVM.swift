//
//  DealsVM.swift
//  SecretWorld
//
//  Created by Ideio Soft on 05/02/25.
//

import Foundation

class DealsVM{
    func createDealsApi(title:String,validTo:String,bUserServicesIds:[String],onSccess:@escaping((_ message:String?)->())){
        let param:parameters = ["title":title,"validTo":validTo,"bUserServicesIds":bUserServicesIds]
        print(param)
        WebService.service(API.createDeals,param: param,service: .post,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message)
        }
    }
    
    func getDealsApi(onSccess:@escaping(([GetDealsData]?)->())){
        WebService.service(API.getDeals,service: .get,showHud: true,is_raw_form: true) { (model:GetDealsModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func updateDealsApi(dealId:String,title:String,validTo:String,bUserServicesIds:[String],status:Int,onSccess:@escaping((_ message:String?)->())){
        let param:parameters = ["title":title,"validTo":validTo,"bUserServicesIds":bUserServicesIds,"status":status]
        print(param)
        WebService.service(API.updateDeals,urlAppendId: dealId,param: param,service: .put,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message)
        }
    }
    func deleteDealsApi(dealId:String,onSccess:@escaping((_ message:String?)->())){
        WebService.service(API.deleteDeals,urlAppendId: dealId,service: .delete,showHud: false,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message)
        }
    }
}
