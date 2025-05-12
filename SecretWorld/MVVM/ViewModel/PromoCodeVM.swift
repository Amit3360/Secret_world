//
//  PromoCodeVM.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 09/04/24.
//

import Foundation
class PromoCodeVM{
    func GetUserPromoCodeListApi(onSccess:@escaping(([GetUserPromoCodeData]?)->())){
        WebService.service(API.GetUserPromoCodes,service: .get,showHud: true,is_raw_form: true) { (model:PromoCodeModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
        
    }
    func VerifyPromoCodeApi(promocode:String,onSccess:@escaping((CommonModel?)->())){
        WebService.service(API.verifyPromoCode,urlAppendId: promocode,service: .put,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
           
            onSccess(model)
        }
        
    }
}
