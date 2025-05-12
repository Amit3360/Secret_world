
// MomentsVM.swift
// SecretWorld
//
// Created by IDEIO SOFT on 10/04/25.
//
import Foundation
class MomentsVM{
    func addMomentApi(usertype: String,
                      name: String,
                      title: String,
                      startDate: String,
                      lat: Double,
                      long: Double,
                      startTime: String,
                      place: String,
                      address: String,
                      exactLocation: Bool,
                      type: String,
                      tasks: [AddMomentModel],
                      onSccess: @escaping (CommonModel?) -> ()) {
        var taskArray: [[String: Any]] = []
        for task in tasks {
            var parameters: [String: Any] = [:]
            parameters["role"] = task.role ?? ""
            parameters["roleType"] = Int(task.roleType ?? "")
            parameters["roleInstruction"] = task.RoleInstruction ?? ""
            parameters["taskDuration"] = task.duration ?? ""
            parameters["personNeeded"] = Int(task.personRequired ?? "")
            parameters["taskPaymentMethod"] = Int(task.paymentType ?? "")
            switch Int(task.paymentType ?? "") {
            case 0:
                parameters["amount"] = Int(task.amount ?? "")
                parameters["paymentTerms"] = Int(task.paymentTerm ?? "")
            case 1:
                parameters["barterProposal"] = task.OfferBarter ?? ""
//                parameters["paymentTerms"] = -1
//                parameters["amount"] = 0
            case 2:
                parameters["amount"] = Int(task.amount ?? "")
                parameters["paymentTerms"] = Int(task.paymentTerm ?? "")
                parameters["barterProposal"] = task.OfferBarter ?? ""
            default:
                break
            }
            taskArray.append(parameters)
        }
        //    do {
        //
        //      let jsonData = try JSONSerialization.data(withJSONObject: taskArray)
        //      print("jsonData",jsonData)
        //      if let jsonString = String(data: jsonData, encoding: .utf8) {
        //        print("jsonString",jsonString)
        let param: [String: Any]
        param = [
            "usertype": usertype,
            "name": name,
            "title": title,
            "startDate": startDate,
            "lat": lat,
            "long": long,
            "exactLocation": exactLocation,
            "address": address,
            "place": place,
            "startTime": startTime,
            "type": type,
            "tasks": taskArray
        ]
        print("Parameters: \(param)")
        WebService.service(API.addMoment,
                           param: param,
                           service: .post,
                           showHud: true,
                           is_raw_form: true) { (model: CommonModel, jsonData, jsonSer) in
            onSccess(model)
        }
        //      } else {
        //        print("Failed to convert JSON to string.")
        //      }
        //    } catch {
        //      print("Error: \(error)")
        //    }
    }
    func getMomentDetails(id:String,onSccess:@escaping((MomentData?)->())){
        let param: parameters = ["id": id]
        print(param)
        WebService.service(API.getMomentDeatils,urlAppendId: id,service: .get,showHud: true,is_raw_form: true) { (model:GetMOmentDetailModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func getMomentsList(type:Int,offset:Int,limit:Int,onSccess:@escaping((MomentListData?)->())){
        let param: parameters = ["type": type,
                                 "offset": offset,
                                 "limit": limit]
        print(param)
        WebService.service(API.getMomentList,param: param,service: .get,is_raw_form: true) { (model:MomentListModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func getAppliedMomentsList(type:Int,offset:Int,limit:Int,onSccess:@escaping((MomentsData?)->())){
        let param: parameters = ["type": type,
                                 "offset": offset,
                                 "limit": limit]
        print(param)
        WebService.service(API.appliedMoments,param: param,service: .get,is_raw_form: true) { (model:AppliedMomentsModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func deleteMomentApi(id:String,onSccess:@escaping((_ message:String)->())){
        let param: parameters = ["id": id]
        print(param)
        WebService.service(API.deleteMOment,urlAppendId: id,service: .delete,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message ?? "")
        }
    }
    func updateMomentApi(momentId: String,
                         usertype: String,
                         name: String,
                         title: String,
                         address: String,
                         type: String,
                         startDate: String,
                         lat: Double,
                         long: Double,
                         startTime: String,
                         place: String,
                         exactLocation: Bool,
                         tasks: [AddMomentModel],
                         onSccess: @escaping (CommonModel?) -> ()) {
        var taskArray: [[String: Any]] = []
        for task in tasks {
            var parameters: [String: Any] = [:]
            parameters["_id"] = task._id ?? ""
            parameters["role"] = task.role ?? ""
            parameters["roleType"] = Int(task.roleType ?? "")
            parameters["roleInstruction"] = task.RoleInstruction ?? ""
            parameters["taskDuration"] = task.duration ?? ""
            parameters["personNeeded"] = Int(task.personRequired ?? "")
            parameters["personAccepted"] = Int(task.personAccepted ?? "")
            parameters["taskPaymentMethod"] = Int(task.paymentType ?? "")
            switch Int(task.paymentType ?? "") {
            case 0:
                parameters["amount"] = Int(task.amount ?? "")
                parameters["paymentTerms"] = Int(task.paymentTerm ?? "")
                parameters["barterProposal"] = ""
            case 1:
                parameters["barterProposal"] = task.OfferBarter ?? ""
                parameters["paymentTerms"] = -1
                parameters["amount"] = 0
            case 2:
                parameters["amount"] = Int(task.amount ?? "")
                parameters["paymentTerms"] = Int(task.paymentTerm ?? "")
                parameters["barterProposal"] = task.OfferBarter ?? ""
            default:
                break
            }
            taskArray.append(parameters)
        }
        //    do {
        //      let jsonData = try JSONSerialization.data(withJSONObject: taskArray)
        //      print("jsonData",jsonData)
        //      if let jsonString = String(data: jsonData, encoding: .utf8) {
        //        print("jsonString",jsonString)
        let param: [String: Any]
        param = ["momentId": momentId,
                 "usertype": usertype,
                 "name": name,
                 "title": title,
                 "startDate": startDate,
                 "lat": lat,
                 "long": long,
                 "exactLocation": exactLocation,
                 "place": place,
                 "address": address,
                 "startTime": startTime,
                 "type": type,
                 "tasks": taskArray
        ]
        print("Parameters: \(param)")
        WebService.service(API.updateMoment,
                           param: param,
                           service: .post,
                           showHud: true,
                           is_raw_form: true) { (model: CommonModel, jsonData, jsonSer) in
            onSccess(model)
        }
        //      } else {
        //        print("Failed to convert JSON to string.")
        //      }
        //    } catch {
        //      print("Error: \(error)")
        //    }
    }
    func applyMomentApi(momentId:String,
                        taskId:String,
                        message:String,
                        type:String,
                        typeName:String,
                        typeId:String,
                        userid:String,
                        timezone:String,
                        onSccess:@escaping((_ message:String?)->())){
        let param: parameters = [
            "momentId": momentId,
            "taskId": taskId,
            "message": message,
            "type": type,
            "typeName": typeName,
            "typeId": typeId,
            "userid": userid,
            "timezone": timezone
        ]
        print(param)
        WebService.service(API.applyMoment,param: param,service: .post,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message)
        }
    }
    func getMomentParticipantsApi(momentId:String, status:Int,loader:Bool,onSccess:@escaping(([TaskUserData]?)->())){
        let param: parameters = ["momentId": momentId,
                                 "status": status]
        print(param)
        WebService.service(API.momentParticipants,param: param,service: .get,showHud: loader,is_raw_form: true) { (model:MomentRequestModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func rejectRequestApi(requestId:String,userId:String,onSccess:@escaping(()->())){
        let fullPath = "\(requestId)/\(userId)"
        WebService.service(API.rejectMomentRequest,urlAppendId: fullPath,service: .put,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess()
        }
    }
    func acceptRequestApi(momentid:String,userid:String,onSccess:@escaping(()->())){
        let fullPath = "\(momentid)/\(userid)"
        WebService.service(API.acceptMomentRequest,urlAppendId: fullPath,service: .put,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess()
        }
    }
    func checAddMoment(price:Double,momentId:String,onSuccess:@escaping(CheckMomentAddModel?)->()){
        let param:parameters = ["price":price,"momentId":momentId]
        print(param)
        WebService.service(API.checkMomentAdd,param: param,service: .post,showHud: true,is_raw_form: true){(model:CheckMomentAddModel,jsonData,jsonSer) in
            onSuccess(model)
        }
    }
    func addMomentReviewByUser(momentId:String,businessUserId:String,media:String,comment:String,starCount:Int,onSccess:@escaping((_ message:String?)->())){
        let param: parameters = ["momentId": momentId,
                                 "businessUserId": businessUserId,
                                 "media": media,
                                 "comment": comment,
                                 "starCount": starCount]
        print(param)
        WebService.service(API.addReviewByUser,param: param,service: .post,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message)
        }
    }

}
