//
//  WebService.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//

import Foundation
import UIKit
import NVActivityIndicatorView

struct WebService {
    static var spinner : NVActivityIndicatorView?
    static let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
    
    static func service<Model: Codable>(_ api:API,urlAppendId: Any? = nil,param: Any? = nil, service: Services = .post ,showHud: Bool = true, headerAppendId: String? = nil,is_raw_form:Bool = false,isLogin:Bool = false,response:@escaping (Model,Data,Any) -> Void)
    {
        if Reachability.isConnectedToNetwork()
        {
            var fullUrlString = baseURL + api.rawValue
            if let idAppend =  urlAppendId {
                fullUrlString =  baseURL + api.rawValue + "/\(idAppend)"
            }
            
            if service == .get {
                if let param = param {
                    if let paramDict = param as? [String: Any] {
                        fullUrlString += self.getString(from: paramDict)
                    } else if let paramString = param as? String {
                        fullUrlString += "?\(paramString)"
                    } else {
                        assertionFailure("Parameter must be a Dictionary or String.")
                    }
                }
            }
            print(fullUrlString)
            guard let encodedString = fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
                return
            }
            
            var request = URLRequest(url: URL(string: encodedString)!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 2000)
            
            request.httpMethod = service.rawValue
            
            if Store.authKey != "" {
                request.setValue(Store.authKey ?? "", forHTTPHeaderField: DefaultKeys.Authorization.rawValue)
            }
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if service == .delete {
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                if let param = param {
                    if let paramString = param as? String {
                      
                        let postData = NSMutableData(data: paramString.data(using: .utf8)!)
                      
                        request.httpBody = postData as Data
                    } else if let paramDict = param as? [String: Any] {
                        var paramStr = self.getString(from: paramDict)
                        paramStr.removeFirst()
                        let postData = NSMutableData(data: paramStr.data(using: .utf8)!)
                        request.httpBody = postData as Data
                    }
                }
            }
            if service == .post  {
                if let parameter = param {
                    if let paramString = parameter as? String {
                        request.httpBody = paramString.data(using: .utf8)
                    } else if let paramDict = parameter as? [String: Any] {
                        if is_raw_form {
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            let postData = try? JSONSerialization.data(withJSONObject: paramDict, options: .prettyPrinted)
                            request.httpBody = postData
                        } else {
                            let body = createMultipartFormData(paramDict)
                            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                            request.httpBody = body
                        }
                    } else {
                        assertionFailure("Parameter must be a Dictionary or String.")
                    }
                }
            }
            if service == .put{
                if let parameter = param {
                    if let paramString = parameter as? String {
                        request.httpBody = paramString.data(using: .utf8)
                    } else if let paramDict = parameter as? [String: Any] {
                        if is_raw_form {
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            let postData = try? JSONSerialization.data(withJSONObject: paramDict, options: .prettyPrinted)
                            request.httpBody = postData
                        } else {
                            let body = createMultipartFormData(paramDict)
                            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                            request.httpBody = body
                        }
                    } else {
                        assertionFailure("Parameter must be a Dictionary or String.")
                    }
                }
            }
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            if showHud{
                showLoader()
            }
            session.dataTask(with: request) { (data, jsonResponse, error) in
                if showHud{
                    DispatchQueue.main.async {
                        hideLoader()
                    }
                }
                if error != nil{
//                    DispatchQueue.main.async{
//                        SceneDelegate().CommonPopupRoot(message: error!.localizedDescription)
//                    }
                    WebService.showAlert(error!.localizedDescription)
                }else{
                    if let jsonData = data{
                        do{
                            let jsonSer = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String: Any]
                            print(jsonSer)
                            let status = jsonSer["statusCode"] as? Int ?? 0
                            let error = jsonSer["message"] as? String ?? ""
                            if status == 200{
                                let decoder = JSONDecoder()
                                let model = try decoder.decode(Model.self, from: jsonData)
                                DispatchQueue.main.async {
                                    response(model,jsonData,jsonSer)
                                }
                            }else if status == 400{
                                if verifyPromo == true{
                                    
                                    //Reject promo code
                                    DispatchQueue.main.async {
                                        SceneDelegate().RejectPromoVCRoot()
                                    }
                                }else if isAddFunds == true{
                                    
                                        //insufficent balance in wallet while add gig
                                        DispatchQueue.main.async{
                                            SceneDelegate().addWalletPopupRoot(message: error)
                                        }
                                    }else if isOtpInvalid == true{
                                        //invalid otp
                                        
                                        DispatchQueue.main.async{
                                            SceneDelegate().invalidOtp(message: error)
                                        }
                                    }else{
                                        
                                        DispatchQueue.main.async{
                                            SceneDelegate().CommonPopupRoot(message: error)
                                        }
//                                        showAlert(error)
                                    }
                                    
                                
                           
                                
                            }else{
                                if isWithdrawWithBank == true{
                                    if error == "You already have a pending withdrawal request."{
                                        DispatchQueue.main.async{
                                            SceneDelegate().CommonPopupRoot(message: error)
                                        }
                                    }else{
                                        if error == "Unable to add the bank account. Please ensure your details are correct."{
                                            DispatchQueue.main.async{
                                                SceneDelegate().CommonPopupRoot(message: error)
                                            }
                                        }else{
                                            DispatchQueue.main.async{
                                                SceneDelegate().addBankRoot(message: error)
                                            }
                                        }
                                    }
                                   
                                }else{
                                    DispatchQueue.main.async{
                                        SceneDelegate().CommonPopupRoot(message: error)
                                    }
//                                    showAlert(error)
                                }
                            }
                            
                        }catch let err{
                            print(err)
                            WebService.showAlert(err.localizedDescription)
                        }
                    }
                }
            }.resume()
        }
        
        else
        {
            SceneDelegate().NoInternetVCRoot()
            
        }
    }
    
    private static func showAlert(_ message: String){
        DispatchQueue.main.async {
            showSwiftyAlert("", message, false)
        }
    }
     static func showLoader() {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        // Set up a background view to cover the entire screen
        let loaderBackgroundView = UIView(frame: keyWindow.frame)
        loaderBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0) // semi-transparent background
        loaderBackgroundView.tag = 999 // A unique tag to identify and remove this view later

        let spinnerSize: CGSize = UIDevice.current.userInterfaceIdiom == .pad
            ? CGSize(width: 100, height: 100)
            : CGSize(width: 80, height: 80)

        // Initialize the spinner and add to loader background
        spinner = NVActivityIndicatorView(
            frame: CGRect(
                x: (keyWindow.frame.width - spinnerSize.width) / 2,
                y: (keyWindow.frame.height - spinnerSize.height) / 2,
                width: spinnerSize.width,
                height: spinnerSize.height
            ),
            type: .circleStrokeSpin,
            color: UIColor(hex: "3E9C35"),
            padding: 20
        )

        spinner?.startAnimating()
        loaderBackgroundView.addSubview(spinner!)
        keyWindow.addSubview(loaderBackgroundView)
    }

    static func hideLoader() {
        DispatchQueue.main.async {
            // Stop the spinner animation
            spinner?.stopAnimating()
            
            // Remove loader background view from the key window
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
               let loaderBackgroundView = keyWindow.viewWithTag(999) {
                loaderBackgroundView.removeFromSuperview()
            }
        }
    }
    private static func getString(from dict: Dictionary<String,Any>) -> String{
        var stringDict = String()
        stringDict.append("?")
        for (key, value) in dict{
            let param = key + "=" + "\(value)"
            stringDict.append(param)
            stringDict.append("&")
        }
        stringDict.removeLast()
        return stringDict
    }
    private static func createMultipartFormData(_ parameters: [String: Any]) -> Data {
        var formData = Data()
        
        for (key, value) in parameters {
            if let imageInfo = value as? ImageStructInfo {
                formData.append("--\(boundary)\r\n")
                formData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(imageInfo.fileName)\"\r\n")
                formData.append("Content-Type: \(imageInfo.type)\r\n\r\n")
                formData.append(imageInfo.data)
                formData.append("\r\n")
            } else if let images = value as? [ImageStructInfo] {
                for imageInfo in images {
                    formData.append("--\(boundary)\r\n")
                    formData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(imageInfo.fileName)\"\r\n")
                    formData.append("Content-Type: \(imageInfo.type)\r\n\r\n")
                    formData.append(imageInfo.data)
                    formData.append("\r\n")
                }
            } else {
                formData.append("--\(boundary)\r\n")
                formData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                formData.append("\(value)\r\n")
            }
        }
        
        formData.append("--\(boundary)--\r\n")
        return formData
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
}

extension UIImage {
    func toData() -> Data? {
        return self.jpegData(compressionQuality: 0.5)
    }
    
    func isEqualToImage(image: UIImage) -> Bool {
        guard let data1 = self.pngData(),
              let data2 = image.pngData() else {
            return false
        }
        return data1 == data2
    }
}

struct ImageStructInfo: Codable {
    let fileName: String
    let type: String
    let data: Data
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case fileName
        case type
        case data
        case key
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileName, forKey: .fileName)
        try container.encode(type, forKey: .type)
        try container.encode(data, forKey: .data)
        try container.encode(key, forKey: .key)
    }
}
