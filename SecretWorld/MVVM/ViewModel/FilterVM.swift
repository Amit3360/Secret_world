//
//  FilterVM.swift
//  SecretWorld
//
//  Created by Ideio Soft on 13/01/25.
//

import Foundation
import Foundation

class FilterVM{
    func getTaskTypeList(type:String,onSccess: @escaping ((FilterTypeData?) -> ())) {
        
        let param: parameters = [
            "type": type]
        print(param)
    
        WebService.service(API.userFunctionsList, param: param, service: .post, showHud: false, is_raw_form: true) { (model: FilterTypeModel, jsonData, jsonSer) in
            onSccess(model.data)
        }
    }
}
