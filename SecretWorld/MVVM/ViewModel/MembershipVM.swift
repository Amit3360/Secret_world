//
//  MembershipVM.swift
//  SecretWorld
//
//  Created by Ideio Soft on 09/05/25.
//



import Foundation

class MembershipVM{
    
    func createMembershipApi(membershipName: String, arrPlan: [Membership], service: [MembershipService], onSuccess: @escaping (_ message:String?) -> ()) {
        var membershipDict = [[String: Any]]()
        var servicesDict = [[String: Any]]()
        
        for item in arrPlan {
            let membershipInfo: [String: Any] = [
                "type": item.priceType ?? "",
                "price": item.price ?? "",
                "benefits": item.benefits ?? 0
            ]
            membershipDict.append(membershipInfo)
        }
        
        for item in service {
            let serviceInfo: [String: Any] = [
                "serviceId": item.serviceId ?? "",
                "name": item.name ?? ""
            ]
            servicesDict.append(serviceInfo)
        }
        
        // Prepare final request parameters
        let params: [String: Any] = [
            "name": membershipName,
            "plans": membershipDict,
            "services": servicesDict
        ]
        
        print("Request Params: \(params)")
        
        WebService.service(API.createMembership, param: params, service: .post, is_raw_form: true) { (model: CommonModel, jsonSer, jsonData) in
            onSuccess(model.message ?? "")
        }
    }
    
    func editMembershipApi(id:String,membershipName: String, arrPlan: [Membership], service: [MembershipService], onSuccess: @escaping (_ message:String) -> ()) {
        var membershipDict = [[String: Any]]()
        var servicesDict = [[String: Any]]()
        
        for item in arrPlan {
            let membershipInfo: [String: Any] = [
                "type": item.priceType ?? "",
                "price": item.price ?? "",
                "benefits": item.benefits ?? 0
            ]
            membershipDict.append(membershipInfo)
        }
        
        for item in service {
            let serviceInfo: [String: Any] = [
                "serviceId": item.serviceId ?? "",
                "name": item.name ?? ""
            ]
            servicesDict.append(serviceInfo)
        }
        
        // Prepare final request parameters
        let params: [String: Any] = [
            "name": membershipName,
            "plans": membershipDict,
            "services": servicesDict
        ]
        
        print("Request Params: \(params)")
        
        WebService.service(API.editMembership,urlAppendId: id, param: params, service: .put, is_raw_form: true) { (model: CommonModel, jsonSer, jsonData) in
            onSuccess(model.message ?? "")
        }
    }
    
    func getAllMembershipApi(page: Int, limit: Int, onSuccess: @escaping ((MembershipListData?) -> ())) {
        let param: parameters = ["page": page, "limit": limit]
        WebService.service(API.getMembership, param: param, service: .get, is_raw_form: true) { (model: MembershipListModel, jsonSer, jsonData) in
            onSuccess(model.data) // <-- correctly access the inner `data` array
        }
    }
    
    func deleteMembershipApi(id:String,onSuccess: @escaping ((_ message:String?) -> ())) {
        WebService.service(API.deleteMembership,urlAppendId: id,service: .delete,showHud: true,is_raw_form: true) {(model: CommonModel, jsonSer, jsonData) in
            onSuccess(model.message ?? "")
        }
    }
    func updateMembershipStatus(id:String,status:Bool,onSuccess: @escaping ((_ message:String?) -> ())) {
        let param: parameters = ["status":status]
        print(param)
        WebService.service(API.updateMembershipStatus,urlAppendId: id,param: param,service: .put,showHud: true,is_raw_form: true) {(model: CommonModel, jsonSer, jsonData) in
            onSuccess(model.message ?? "")
        }
    }
}
