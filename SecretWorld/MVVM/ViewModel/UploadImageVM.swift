//
//  UploadImageVM.swift
//  SecretWorld
//
//  Created by meet sharma on 16/04/24.
//

import Foundation
import UIKit

class UploadImageVM{
    func uploadImageApi(image:[Any],onSuccess:@escaping((ImageData?)->())){
        
        var imageStructArr = [ImageStructInfo]()
        for (index, mediaItem) in image.enumerated() {
            if let image = mediaItem as? UIImage {
                // Handle UIImage (Image)
                let imgStruct = ImageStructInfo(
                    fileName: "\(index).png",
                    type: "image/png",
                    data: image.toData() ?? Data() ,
                    key: "media"
                )
                imageStructArr.append(imgStruct)
                
            } else if let videoURL = mediaItem as? URL {
                if let videoData = try? Data(contentsOf: videoURL) {
                    
                    let videoFileName = "\(index).MOV"
                    let videoStruct = ImageStructInfo(
                        fileName: videoFileName,
                        type: "video/MOV",
                        data: videoData,
                        key: "media"
                    )
                    imageStructArr.append(videoStruct)
                    
                }
            }
        }
        let param: parameters = ["Images": imageStructArr]
        
        print(param)
        
        WebService.service(API.uploadImage, param: param, service: .post, is_raw_form: false) { (model:UploadImageModel, jsonData, jsonSer) in
            
            onSuccess(model.data)
        }
    }
    
    func uploadProductImagesApi(Images:Any,onSuccess:@escaping((ImageData?)->())){
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        let date = formatter.string(from: Date())
        
        var imageStructArr = [ImageStructInfo]()
      
        if let image = Images as? UIImage {
                let imgStruct = ImageStructInfo(
                    fileName: "\(String(describing: index)).png",
                    type: "image/png",
                    data: image.toData() ?? Data() ,
                    key: "Images"
                )
                imageStructArr.append(imgStruct)
                
            }
        
        let param: parameters = ["Images": imageStructArr]
        
        print(param)
        
        WebService.service(API.uploadImage, param: param, service: .post, is_raw_form: false) { (model:UploadImageModel, jsonData, jsonSer) in
            
            onSuccess(model.data)
        }
    }

    
    func addReport(reson:String,reportUserId:String,reasonId:String,onSuccess:@escaping((_ message:String?)->())){
        let param:parameters = ["reason":reson,"reportUserId":reportUserId,"reasonId":reasonId]
        print(param)
        WebService.service(API.addReport,param: param,service: .post,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSuccess(model.message)
        }
    }
   
    func getUserDetail(receiverId:String,onSuccess:@escaping((UserDetailData?)->())){
        let param:parameters = ["Id":receiverId]
        WebService.service(API.getUserDetail,param: param,service: .get,showHud: false,is_raw_form: true) { (model:UserDetailModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
    func getReportResason(onSuccess:@escaping(([Report]?)->())){
        WebService.service(API.getReportReason,service: .get,showHud: false,is_raw_form: true) { (model:ReportReasonModel,jsonData,jsonSer) in
            onSuccess(model.data?.reports)
        }
    }
}

