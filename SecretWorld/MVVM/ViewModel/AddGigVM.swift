//
//  AddGigVM.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 07/03/24.
//
import Foundation
import UIKit
class AddGigVM{
    //UserType :-- user/business_user
    //type :- worldwide/inMyLocation
    func UpdatePromoStatusApi(gigid:String,userid:String,onSccess:@escaping(()->())){
        let param: parameters = ["gigid": gigid,"userid": userid]
        print(param)
        WebService.service(API.promoCodeStatus,param: param,service: .put,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess()
        }
    }
    func GetCompleteGigParticipantsListApi(loader:Bool,gigId:String,onSccess:@escaping(([GetRequestData]?)->())){
        WebService.service(API.completeGigRequests,urlAppendId: gigId,service: .get,showHud: loader,is_raw_form: true) { (model:CompleteGigRequestModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func createGig(gigId:String,price:Double,onSuccess:@escaping((CreateGigData?)->())){
        let  param:parameters = ["gigId": gigId,"currency":"USD","usertype":"","price":price]
        print(param)
        WebService.service(API.addGig,param: param,service: .post,is_raw_form: true){(model:CreateGigModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
    func checAddGig(price:Double,onSuccess:@escaping(_ message:String)->()){
        let  param:parameters = ["price":price]
        print(param)
        WebService.service(API.checkGigAdd,param: param,service: .post,showHud: false,is_raw_form: true){(model:CreateGigModel,jsonData,jsonSer) in
            onSuccess(model.message ?? "")
        }
    }
    func checUpdateGig(gigId:String,price:Double,onSuccess:@escaping(_ message:String)->()){
        let  param:parameters = ["price":price,"id":gigId]
        print(param)
        WebService.service(API.checkGigUpdate,param: param,service: .post,showHud: false,is_raw_form: true){(model:CreateGigModel,jsonData,jsonSer) in
            onSuccess(model.message ?? "")
        }
    }
    func AddGigApi(usertype:String,
                   image:UIImageView,
                   name:String,
                   title:String,
                   serviceName:String,
                   serviceDuration:String,
                   startDate:String,
                   place:String,
                   lat:Double,
                   long:Double,
                   participants:String,
                   type:String,
                   price:Int,
                   about:String,
                   isImageNil:Bool,
                   onSuccess:@escaping((CreateGigData?)->())){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        var param = [String:Any]()
        if isImageNil{
            param = ["usertype": usertype,
                     "name":name,
                     "title": title,
                     "serviceName": serviceName,
                     "serviceDuration": serviceDuration,
                     "startDate": startDate,
                     "place": place,
                     "lat": lat,
                     "long":long,
                     "participants": participants,
                     "type": type,
                     "price":price,
                     "about": about]
        }else{
            let imageInfo : ImageStructInfo
            imageInfo = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: image.image?.toData() ?? Data(), key: "profileImage")
            param = ["usertype": usertype,
                     "image": imageInfo,
                     "name":name,
                     "title": title,
                     "serviceName": serviceName,
                     "serviceDuration": serviceDuration,
                     "startDate": startDate,
                     "place": place,
                     "lat": lat,
                     "long":long,
                     "participants": participants,
                     "type": type,
                     "price":price,
                     "about": about]
        }
        print(param)
        WebService.service(API.addGig,param: param,service: .post,is_raw_form: false){(model:CreateGigModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
    
    func AddNewGigApi(usertype: String,
                      image: UIImageView,
                      name: String,
                      type: String,
                      title: String,
                      serviceName: String,
                      serviceDuration: String,
                      startDate: String,
                      place: String,
                      lat: Double,
                      long: Double,
                      participants: String,
                      about: String,
                      price: Double,
                      gigId: String,
                      experience: String,
                      address: String,
                      paymentTerms: Int,
                      paymentMethod: Int,
                      category: String,
                      skills: [String],
                      tools: [String],
                      dressCode: String,
                      personNeeded: Int,
                      description: String,
                      safetyTips: String,
                      startTime: String,
                      isCancellation: Int,
                      isImageNil: Bool,
                      availability:Int,
                      avoidDescription:String,
                      onSuccess: @escaping ((CreateGigData?) -> ())) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        var param: [String: Any] = [
            "usertype": usertype,
            "name": name,
            "type": type,
            "title": title,
            "serviceName": serviceName,
            "serviceDuration": serviceDuration,
            "startDate": startDate,
            "place": place,
            "lat": lat,
            "long": long,
            "participants": participants,
            "about": about,
            "price": price,
            "gigId": gigId,
            "experience": experience,
            "address": address,
            "paymentTerms": paymentTerms,
            "paymentMethod": paymentMethod,
            "category": category,
            "skills": skills,
            "tools": tools,
            "dressCode": dressCode,
            "personNeeded": personNeeded,
            "description": description,
            "safetyTips": safetyTips,
            "startTime": startTime,
            "isCancellation": isCancellation,
            "availability":availability,
            "avoidDescription":avoidDescription
        ]
        
        if isImageNil {
            let imageInfo = ImageStructInfo(
                fileName: "Img\(date).jpeg",
                type: "jpeg",
                data: image.image?.toData() ?? Data(),
                key: "profileImage"
            )
            param["image"] = imageInfo
        }else{
            let imageInfo = ImageStructInfo(
                fileName: "dummyimage.jpg",
                type: "jpg",
                data: image.image?.toData() ?? Data(),
                key: "profileImage"
            )
            param["image"] = imageInfo
        }
        
        print(param)
        
        WebService.service(API.addGig, param: param, service: .post, is_raw_form: false) { (model: CreateGigModel, jsonData, jsonSer) in
            onSuccess(model.data)
        }
    }

    func UpdateNewGigApi(id:String,usertype: String,
                      image: UIImageView,
                      name: String,
                      type: String,
                      title: String,
                      serviceName: String,
                      serviceDuration: String,
                      startDate: String,
                      place: String,
                      lat: Double,
                      long: Double,
                      participants: String,
                      about: String,
                    price: Double,
                      gigId: String,
                      experience: String,
                      address: String,
                      paymentTerms: Int,
                      paymentMethod: Int,
                      category: String,
                      skills: [String],
                      tools: [String],
                      dressCode: String,
                      personNeeded: Int,
                      description: String,
                      safetyTips: String,
                      startTime: String,
                      isCancellation: Int,
                      isImageNil: Bool,
                      availability:Int,
                    avoidDescription:String,
                      onSuccess: @escaping ((CreateGigModel?) -> ())) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        var param: [String: Any] = [
            "id":gigId,
            "usertype": usertype,
            "name": name,
            "type": type,
            "title": title,
            "serviceName": serviceName,
            "serviceDuration": serviceDuration,
            "startDate": startDate,
            "place": place,
            "lat": lat,
            "long": long,
            "participants": participants,
            "about": about,
            "price": price,
            "gigId": gigId,
            "experience": experience,
            "address": address,
            "paymentTerms": paymentTerms,
            "paymentMethod": paymentMethod,
            "category": category,
            "skills": skills,
            "tools": tools,
            "dressCode": dressCode,
            "personNeeded": personNeeded,
            "description": description,
            "safetyTips": safetyTips,
            "startTime": startTime,
            "isCancellation": isCancellation,
            "availability":availability,
            "avoidDescription":avoidDescription
        ]
        
        if isImageNil {
            let imageInfo = ImageStructInfo(
                fileName: "Img\(date).jpeg",
                type: "jpeg",
                data: image.image?.toData() ?? Data(),
                key: "profileImage"
            )
            param["image"] = imageInfo
        }else{
            let imageInfo = ImageStructInfo(
                fileName: "dummyimage.jpg",
                type: "jpg",
                data: image.image?.toData() ?? Data(),
                key: "profileImage"
            )
            param["image"] = imageInfo
        }
        
        print(param)
        
        WebService.service(API.updateGig, param: param, service: .put, is_raw_form: false) { (model: CreateGigModel, jsonData, jsonSer) in
            onSuccess(model)
        }
    }
    
    func GetGigApi(offset:Int,
                   limit:Int,
                   type:Int,
                   latitude:Double,
                   longitude:Double,
                   onSccess:@escaping((GetGigData?)->())){
        let param: parameters = ["offset": offset,
                                 "limit": limit,
                                 "type": type,
                                 "latitude": latitude,
                                 "longitude": longitude]
        print(param)
        WebService.service(API.getGigList,param: param,service: .get,showHud: false,is_raw_form: true) { (model:GetGigListModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func GetBuisnessGigListApi(onSccess:@escaping(([GigsDetailData]?)->())){
        WebService.service(API.getBusinessGigs,service: .get,showHud: false,is_raw_form: true) { (model:GetBUserGigsModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func GetBuisnessGigDetailApi(gigId:String,onSccess:@escaping((GetGigDetailData?)->())){
        let param: parameters = ["gigId": gigId]
        print(param)
        WebService.service(API.businessGigDetails,param: param,service: .get,is_raw_form: true) { (model:BGigDetailModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
  
    func GetUserGigDetailApi(gigId:String,showLoader:Bool,onSccess:@escaping((GetUserGigData?)->())){
        let param: parameters = ["gigId": gigId]
        print(param)
        WebService.service(API.UserGigDetails,param: param,service: .get,showHud: showLoader,is_raw_form: true) { (model:GetUserGigDetailModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    
    func GetPopUpGigDetailApi(gigId:String,onSccess:@escaping((GetUserGigData?)->())){
        let param: parameters = ["gigId": gigId]
        print(param)
        WebService.service(API.UserGigDetails,param: param,service: .get,showHud: false,is_raw_form: true) { (model:GetUserGigDetailModel,jsonData,jsonSer) in
            
            onSccess(model.data)
        }
    }
    func ApplyGigApi(gigId:String,message:String,typeName:String,onSccess:@escaping((_ message:String?)->())){
        let param: parameters = ["gigId": gigId,
                                 "message": message,"type":"task","typeName":typeName,"typeId":gigId]
        print(param)
        
        WebService.service(API.applyGig,param: param,service: .post,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message)
        }
    }
    func GetUserParticipantsListApi(gigId:String,onSccess:@escaping(([GetParticipantsData]?)->())){
        let param: parameters = ["gigId": gigId]
        print(param)
        WebService.service(API.getUserParticipants,param: param,service: .get,showHud: false,is_raw_form: true) { (model:GetUserParticipantsModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func GetUserGroupParticipantsListApi(gigId:String,onSccess:@escaping((GetGroupParticipantData?)->())){
        WebService.service(API.getGroupParticipant,urlAppendId:gigId,service:.get,is_raw_form: true) { (model:GetGroupParticipantModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func GetBusinessParticipantsListApi(gigId:String,type:Int,onSccess:@escaping((GetBusinessPaticipantsData?)->())){
        let param: parameters = ["gigId": gigId,"type":type]
        print(param)
        WebService.service(API.getBusinessParticipants,param: param,service: .get,showHud: true,is_raw_form: true) { (model:GetBusinessParticipantsModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func UpdateGigApi(id:String,
                      image:UIImageView,
                      name:String,
                      title:String,
                      serviceName:String,
                      serviceDuration:String,
                      startDate:String,
                      place:String,
                      lat:Double,
                      long:Double,
                      type:String,
                      participants:String,
                      price:Int,
                      about:String,
                      isImageNil:Bool,
                      onSuccess:@escaping((_ message:String?)->())){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.fullDate.rawValue
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        var param = [String:Any]()
        if isImageNil{
            param = ["id": id,
                     "name":name,
                     "title": title,
                     "serviceName": serviceName,
                     "serviceDuration": serviceDuration,
                     "startDate": startDate,
                     "place": place,
                     "lat": lat,
                     "long":long,
                     "participants": participants,
                     "type":type,
                     "price":price,
                     "about": about]
        }else{
            let imageInfo : ImageStructInfo
            imageInfo = ImageStructInfo.init(fileName: "Img\(date).jpeg", type: "jpeg", data: image.image?.toData() ?? Data(), key: "profileImage")
            param = ["id": id,
                     "image": imageInfo,
                     "name":name,
                     "title": title,
                     "place": place,
                     "lat": lat,
                     "long":long,
                     "serviceName": serviceName,
                     "serviceDuration": serviceDuration,
                     "startDate": startDate,
                     "participants": participants,
                     "type":type,
                     "price":price,
                     "about": about]
        }
        print(param)
        WebService.service(API.updateGig,param: param,service: .put,is_raw_form: false){(model:CommonModel,jsonData,jsonSer) in
            onSuccess(model.message)
        }
    }
    func HireForGigApi(gigid:String,
                       userid:String,onSccess:@escaping(()->())){
        WebService.service(API.hireForGig,urlAppendId: "\(gigid)/\(userid)",service: .put,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess()
        }
    }
    func CancelGigApi(id:String,onSccess:@escaping((_ message:String?)->())){
        WebService.service(API.cancelGig,urlAppendId: id,service: .delete,showHud: false,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message)
        }
    }
   // 0= upcomming, 1= ongoing, 2= completed
    func GetBusinessAllGigsListApi(loader:Bool,offset:Int,limit:Int,type:Int,onSccess:@escaping((GetGigsListData?)->())){
        let param: parameters = ["offset": offset,"limit": limit,"type": type]
        print(param)
        WebService.service(API.getBusiessallGigsList,param: param,service: .get,showHud: loader,is_raw_form: true) { (model:GetAllGigsListModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func GetUserAppliedGigApi(offset:Int,limit:Int,type:Int,onSccess:@escaping((getAppliedGigData?)->())){
        let param: parameters = ["offset": offset,"limit": limit,"type": type]
        print(param)
        WebService.service(API.getAppliedGig,param: param,service: .get,showHud: false,is_raw_form: true) { (model:getAppliedGigModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    
    func CompleteGigApi(gigid:String,onSccess:@escaping((_ message:String?)->())){
        WebService.service(API.completeGig,urlAppendId: gigid,service: .put,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message)
        }
    }
    
    func rejectedTask(gigid:String,
                       userid:String,onSccess:@escaping(()->())){
        WebService.service(API.gigRejected,urlAppendId: "\(gigid)/\(userid)",service: .put,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess()
        }
    }
}
