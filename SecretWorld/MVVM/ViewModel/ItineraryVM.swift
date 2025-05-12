//
//  ItineraryVM.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/25.
//

import Foundation

class ItineraryVM{

    func AddItitneraryApi(gigId: String,
                          type:Int,
                              title: String,
                              endTime:String,
                              description: String,
                              location: String,
                              repeatType:String,
                              notes:String,
                              urgent:Bool,
                              lat:Double,
                              long:Double,
                              earning:String,
                              reminderTime: String,
                          onSccess: @escaping ((_ message:String?) -> ())) {
        var param:parameters = [:]
        if type == 1{
             param = [
                "type":type,
                "gigId": gigId,
                "title": title,
                "endTime":endTime,
                "notes":notes,
                "urgent":urgent,
                "description": description,
                "location": location,
                "reminderTime": reminderTime,
                "lat":lat,
                "long":long,
                "earning":earning
            ]
        }else{
             param = [
                "type":type,
                "repeat":repeatType,
                "title": title,
                "endTime":endTime,
                "notes":notes,
                "urgent":urgent,
                "description": description,
                "reminderTime": reminderTime
            ]
        }
      
        print(param)
        
        WebService.service(API.addItitnerary, param: param, service: .post, showHud: true, is_raw_form: true) { (model: CommonModel, jsonData, jsonSer) in
            onSccess(model.message)
        }
    }
    func GetItineraryApi(type:Int,date:String,onSccess:@escaping((ItirenaryData?)->())){
        let param:parameters = ["type":type,"date":date]
        WebService.service(API.getItitnerary,param: param,service: .get,showHud: true,is_raw_form: true) { (model:ItirenaryModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func deleteItinerary(id:String,date:String,onSccess:@escaping((_ message:String?)->())){
//        let param:parameters = ["id":id,"date":date]
        var param = ""
        if id == ""{
            param = "{id}/\(date)"
        }else if date == ""{
        param = "\(id)/{date}"
        }else{
            param = "\(id)/\(date)"
        }
      
        WebService.service(API.deleteItinerary,urlAppendId: param,service: .delete,showHud: true,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.message ?? "")
        }
    }
    
    func UpdateItitneraryApi(itineraryId:String,gigId: String,
                          type:Int,
                              title: String,
                              endTime:String,
                              description: String,
                              location: String,
                              repeatType:String,
                              notes:String,
                              urgent:Bool,
                              lat:Double,
                              long:Double,
                              earning:String,
                              reminderTime: String,
                             onSccess: @escaping ((_ messsage:String?) -> ())) {
        var param:parameters = [:]
        if type == 1{
             param = [
                "type":type,
                "gigId": gigId,
                "title": title,
                "endTime":endTime,
                "notes":notes,
                "urgent":urgent,
                "description": description,
                "location": location,
                "reminderTime": reminderTime,
                "lat":lat,
                "long":long,
                "earning":earning
            ]
        }else{
             param = [
                "type":type,
                "repeat":repeatType,
                "title": title,
                "endTime":endTime,
                "notes":notes,
                "urgent":urgent,
                "description": description,
                "reminderTime": reminderTime
            ]
        }
      
        print(param)
        
        WebService.service(API.updateItinerary, urlAppendId: itineraryId,param: param, service: .put, showHud: true, is_raw_form: true) { (model: CommonModel, jsonData, jsonSer) in
            onSccess(model.message)
        }
    }
}
