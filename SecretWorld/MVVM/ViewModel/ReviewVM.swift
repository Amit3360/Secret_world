//
//  ReviewVM.swift
//  SecretWorld
//
//  Created by meet sharma on 07/06/24.
//

import Foundation

class ReviewVM{
    func getUserGigReviewDetails(gigId:String,onSuccess:@escaping(()->())){
        WebService.service(API.getReviews,urlAppendId: gigId,service: .get,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSuccess()
        }
    }
}
