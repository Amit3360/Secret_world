//
//  PopupReviewVM.swift
//  SecretWorld
//
//  Created by Ideio Soft on 22/01/25.
//

import Foundation
import UIKit

class PopupReviewVM{
    func AddPopupReview(popupId: String,media: UIImageView,comment:String,starCount:Int,onSccess: @escaping (() -> ())) {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let imageInfo : ImageStructInfo
        
        imageInfo = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: media.image?.toData() ?? Data(), key: "media")
        let param: parameters = [
            "popupId": popupId,
            "media": imageInfo,
            "comment":comment,"starCount":starCount]
        print(param)
        
        WebService.service(API.addPopupReview, param: param, service: .post, showHud: true, is_raw_form: false) { (model: CommonModel, jsonData, jsonSer) in
            onSccess()
        }
    }
    func UpdatePopupReview(reviewId: String,media: UIImageView,comment:String,starCount:Int,onSccess: @escaping (() -> ())) {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let imageInfo : ImageStructInfo
        
        imageInfo = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: media.image?.toData() ?? Data(), key: "media")
        let param: parameters = [
            "id": reviewId,
            "media": imageInfo,
            "comment":comment,"starCount":starCount]
        print(param)
        
        WebService.service(API.updatePopupReview, param: param, service: .put, showHud: true, is_raw_form: false) { (model: CommonModel, jsonData, jsonSer) in
            onSccess()
        }
    }
}
