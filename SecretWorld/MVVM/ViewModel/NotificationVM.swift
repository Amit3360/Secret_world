//
//  NotificationVM.swift
//  SecretWorld
//
//  Created by meet sharma on 28/05/24.
//

import Foundation

class NotificationVM{
    func getNotification(onSuccess:@escaping((NotificationData?)->())){
        
        WebService.service(API.getNotification,service: .get,showHud: true,is_raw_form: true) { (model:NotificationModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
}
