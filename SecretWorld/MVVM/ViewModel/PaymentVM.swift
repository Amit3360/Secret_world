//
//  PaymentVM.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/09/24.
//

import Foundation

// Struct for BankAccountDetails
struct BankDetaill{
    let bankId: String?
    let country: String?
    let currency: String?
    let accountHolderName: String?
    let accountHolderType: String?
    let routingNumber: String?
    let accountNumber: String?
    let idNumber: String?
    let email: String?
    let isDefault: String?

    init(bankId: String?, country: String?, currency: String?, accountHolderName: String?, accountHolderType: String?, routingNumber: String?, accountNumber: String?, idNumber: String?, email: String?, isDefault: String?) {
        self.bankId = bankId
        self.country = country
        self.currency = currency
        self.accountHolderName = accountHolderName
        self.accountHolderType = accountHolderType
        self.routingNumber = routingNumber
        self.accountNumber = accountNumber
        self.idNumber = idNumber
        self.email = email
        self.isDefault = isDefault
    }
    }


class PaymentVM{
    func AddWalletApi(amount:Int,type:Int,onSccess:@escaping((_ url:String?)->())){
        let param: parameters = ["amount": amount,"paymentMethod":type]
        print(param)
        WebService.service(API.addWallet,param: param,service: .post,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSccess(model.data?.url)
        }
    }
    func getWalletAmount(loader:Bool,onSuccess:@escaping((GetWalletData?)->())){
        WebService.service(API.getWallet,service: .get,showHud: loader,is_raw_form: true) { (model:GetWalletAmountModel,jsonData,jsonSer) in
            onSuccess(model.data)
        }
    }
    func WithdrawRequestApi(requestAmount:Int,onSccess:@escaping((WithdrawalRequestData?,_ message:String?)->())){
        let param: parameters = ["requestAmount": requestAmount]
        print(param)
        WebService.service(API.withdrawRequest,param: param,service: .post,is_raw_form: true) { (model:WithdrawRequestModel,jsonData,jsonSer) in
            onSccess(model.data,model.message)
        }
    }
    func GetComissionApi(onSccess:@escaping((GetComissionData?)->())){
        WebService.service(API.getComission,service: .get,showHud: false,is_raw_form: true) { (model:GetCommisionModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func addBankApi(bankAccountDetails: BankDetaill, onSuccess: @escaping ((GetBankAccountData?, _ message: String?) -> ())) {
        do {
            let isDefault = bankAccountDetails.isDefault ?? ""
            let country = bankAccountDetails.country ?? ""
            let currency = bankAccountDetails.currency ?? ""
            let accountHolderName = bankAccountDetails.accountHolderName ?? ""
            let accountHolderType = bankAccountDetails.accountHolderType ?? ""
            let routingNumber = bankAccountDetails.routingNumber ?? ""
            let accountNumber = bankAccountDetails.accountNumber ?? ""
            let email = bankAccountDetails.email ?? ""
            let idNumber = bankAccountDetails.idNumber ?? ""
            
            let bankAccountDetailsDict: [String: Any] = [
                "country": country,
                "currency": currency,
                "account_holder_name": accountHolderName,
                "account_holder_type": accountHolderType,
                "routing_number": routingNumber,
                "account_number": accountNumber,
                "email": email,
                "idNumber": idNumber,
                "isDefault": isDefault
            ]
            
            let param: [String: Any] = [
                "bankAccountDetails": bankAccountDetailsDict
            ]
            
            print("Parameters: \(param)")
            
            // Convert the dictionary to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON String: \(jsonString)")
                
                WebService.service(API.addBank, param: jsonString, service: .post, is_raw_form: true) { (model: BankAccountsModel, jsonData, jsonSer) in
                    onSuccess(model.bankAccount, model.message)
                }
            }
        } catch {
            print("Error converting parameters to JSON: \(error)")
        }
    }
    func getBankDetailsApi(onSccess:@escaping((ExternalAccounts?)->())){
        WebService.service(API.getBankDetail,service: .get,is_raw_form: true) { (model:BankAccountDetailModel,jsonData,jsonSer) in
            onSccess(model.data?.externalAccounts)
        }
    }
    func EditBankApi(bankAccountDetails: BankDetaill, onSuccess: @escaping (( _ message: String?) -> ())) {
        do {
            let param: [String: Any] = [
                "bankAccountId":bankAccountDetails.bankId ?? "",
                "bankAccountDetails": [
                    "country": bankAccountDetails.country ?? "",
                    "currency": bankAccountDetails.currency ?? "",
                    "account_holder_name": bankAccountDetails.accountHolderName ?? "",
                    "account_holder_type": bankAccountDetails.accountHolderType ?? "",
                    "routing_number": bankAccountDetails.routingNumber ?? "",
                    "account_number": bankAccountDetails.accountNumber ?? ""
                ]
            ]
            
        
        print("Parameters: \(param)")
        
        
            let jsonData = try JSONSerialization.data(withJSONObject: param)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON String: \(jsonString)")
                
                WebService.service(API.editBankDetail, param: jsonString, service: .post, is_raw_form: true) { (model: CommonModel, jsonData, jsonSer) in
                    onSuccess(model.message)
                }
            }
        } catch {
            print("Error converting parameters to JSON: \(error)")
        }
 
    }
    func DeleteBankApi(bankAccountId:String,onSuccess:@escaping(( _ message: String?)->())){
        let param:parameters = ["bankAccountId":bankAccountId]
        print(param)
        WebService.service(API.deleteBank,param: param,service: .post,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSuccess(model.message)
        }
    }
    func GetTransactionApi(onSccess:@escaping((GetTransationData?)->())){
        WebService.service(API.getTransaction,service: .get,is_raw_form: true) { (model:TransactionModel,jsonData,jsonSer) in
            onSccess(model.data)
        }
    }
    func DefaultBankApi(bankAccountId:String,onSuccess:@escaping(( _ message: String?)->())){
        let param:parameters = ["bankAccountId":bankAccountId]
        print(param)
        WebService.service(API.defaultBank,param: param,service: .post,is_raw_form: true) { (model:CommonModel,jsonData,jsonSer) in
            onSuccess(model.message)
        }
    }
}
