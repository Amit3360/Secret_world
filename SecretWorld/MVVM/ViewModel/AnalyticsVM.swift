//
//  AnalyticsVM.swift
//  SecretWorld
//
//  Created by Ideio Soft on 06/01/25.
//

import Foundation

class AnalyticsVM{
    func AnalyticsApi(type: Int,period: String,serviceId:String,onSccess: @escaping ((AnalyticsData?) -> ())) {
        
        let param: parameters = [
            "type": type,
            "period": period,
            "service_id":serviceId]
        print(param)
        
        WebService.service(API.getHitStats, param: param, service: .get, showHud: true, is_raw_form: true) { (model: AnalyticsModel, jsonData, jsonSer) in
            onSccess(model.data)
        }
    }
}
