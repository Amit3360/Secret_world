//
//  ApiClass.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//

import Foundation
import UIKit
class ApiClass{
 static func servicePost<Model: Codable>(url:String,param:[String:Any],responseData:@escaping (Model,Data,Any) -> Void){
        let urlString = url
        
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            return
        }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            print("Error: Unable to encode parameters")
            return
        }
        var request = URLRequest(url: url)
        
        request.httpBody = httpBody
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
         session.dataTask(with: request) { (data, jsonResponse, error) in
         
         if error != nil{
      
         }else{
             if let jsonData = data{
                 do{
                     let jsonSer = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String: Any]
                     print(jsonSer)
                     let status = jsonSer["statusCode"] as? Int ?? 0
                     let error = jsonSer["message"] as? String ?? ""
                     if status == 0{
                    
                     }
                    
         
                     else{
                         let decoder = JSONDecoder()
                         let model = try decoder.decode(Model.self, from: jsonData)
                         DispatchQueue.main.async {
                             responseData(model,jsonData,jsonSer)
                         }
                     }
                 }catch let err{
                     print(err)
                     
                    
                 }
             }
         }
     }.resume()
 }
 
    
    
       func serviceGet<Model: Decodable>(url:String,param:[String:Any],response:@escaping (Model,Data,Any) -> Void){
         let Url = String(format: url)
         guard let serviceUrl = URL(string: Url) else { return }
         var request = URLRequest(url: serviceUrl)
         request.httpMethod = "GET"
         request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
         let session = URLSession.shared
         session.dataTask(with: request) { (data, response, error) in
             if let response = response {
                 print(response)
             }
             if let data = data {
                 do {
                     let json = try JSONSerialization.jsonObject(with: data, options: [])
                     print(json)
                 } catch {
                     print(error)
                 }
             }
         }.resume()
     }
}
