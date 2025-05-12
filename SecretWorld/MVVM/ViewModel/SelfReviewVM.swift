//
//  SelfReviewVM.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 01/05/25.
//

import Foundation
struct RatingModel {
    var reliability: Int?
    var speed: Int?
    var attitude: Int?
    var communication: Int?
    var quality: Int?
    init(reliability: Int? = nil, speed: Int? = nil, attitude: Int? = nil, communication: Int? = nil, quality: Int? = nil) {
        self.reliability = reliability
        self.speed = speed
        self.attitude = attitude
        self.communication = communication
        self.quality = quality
    }
}

class SelfReviewVM{
    
    func AddSelfReviewApi(review:String,onSuccess:@escaping((_ message:String?)->())){
        let param:parameters = ["review":review]
        print(param)
        WebService.service(API.addSelfReview,param: param,service: .post,is_raw_form: true) { (model:CommonModel,jsonSer,jsonData) in
            onSuccess(model.message)
        }
    }
    func getSelfReviewApi(userId:String,onSuccess:@escaping((SelfReviewData?)->())){
        
        WebService.service(API.getSelfReview,urlAppendId: userId,service: .get,is_raw_form: true) { (model:SelfReviewModel,jsonSer,jsonData) in
            
            onSuccess(model.data)
        }
    }
    
    func addReviewApi(momentId: String,
                      taskId: String,
                      businessUserId: String,
                      comment: String,
                      media: String,
                      rating: RatingModel,
                      onSccess: @escaping (_ message: String?) -> ()) {

        let ratingDict: [String: Int] = [
            "reliability": rating.reliability ?? 0,
            "speed": rating.speed ?? 0,
            "attitude": rating.attitude ?? 0,
            "communication": rating.communication ?? 0,
            "quality": rating.quality ?? 0
        ]

        let param: [String: Any] = [
            "momentId": momentId,
            "taskId": taskId,
            "businessUserId": businessUserId,
            "comment": comment,
            "media": media,
            "rating": ratingDict  // ✅ Use dictionary directly
        ]

        print("Parameters: \(param)")

        WebService.service(API.createMOmentReview,
                           param: param,
                           service: .post,
                           showHud: true,
                           is_raw_form: true) { (model: CommonModel, jsonData, jsonSer) in
            onSccess(model.message ?? "")
        }
    }
    func getUserMomentReviews(userId:String,onSuccess:@escaping((ReviewDatas?)->())){
        let param:parameters = ["userId":userId]
        print(param)
        WebService.service(API.getusermomentreviews,param: param,service: .get, showHud: true,is_raw_form: true) { (model:UserSelfReviewDetails,jsonSer,jsonData) in
            onSuccess(model.data)
        }
    }
    
    func getCommentsApi(page:Int,limit:Int,onSuccess:@escaping((CommentsData?)->())){
        let param:parameters = ["page":page,"limit":limit]
        print(param)
        WebService.service(API.getReviewComments,param: param,service: .get, showHud: false,is_raw_form: true) { (model:GetCommentModel,jsonSer,jsonData) in
            onSuccess(model.data)
        }
    }
    func getMediaApi(page:Int,limit:Int,onSuccess:@escaping((MediaData?)->())){
        let param:parameters = ["page":page,"limit":limit]
        print(param)
        WebService.service(API.getReviewMedia,param: param,service: .get, showHud: false,is_raw_form: true) { (model:GetReviewMediaModel,jsonSer,jsonData) in
            onSuccess(model.data)
        }
    }



}
