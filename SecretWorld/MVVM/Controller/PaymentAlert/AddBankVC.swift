//
//  AddBankVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/09/24.
//

import UIKit

class AddBankVC: UIViewController {
    @IBOutlet var btnDefault: UISwitch!
    @IBOutlet var txtFldId: UITextField!
    @IBOutlet var lblScreentitle: UILabel!
    @IBOutlet var txtFldHolderName: UITextField!
    @IBOutlet var txtFldAccountNumber: UITextField!
    @IBOutlet var txtFldRoutingNumber: UITextField!
    
    @IBOutlet var txtFldEmail: UITextField!
    @IBOutlet var btnSuhbmitEdit: UIButton!
    var isComing = false
    var viewModel = PaymentVM()
    var bankId = ""
    var arrBank = [BankAccountDetailData]()
    var selectIndex = 0
    var isDefault = "false"
    var bankListCount = 0
    var isFromWallet = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        uiSet()
    }
    @objc func handleSwipe() {
        if isFromWallet == true{
            SceneDelegate().walletFromAddBankVCRoot()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func uiSet(){
        txtFldHolderName.delegate = self
        btnDefault.isOn = false
        if isComing == true{
            //edit
            txtFldHolderName.text = arrBank[selectIndex].accountHolderName ?? ""
            txtFldAccountNumber.text = "********\(arrBank[selectIndex].last4 ?? "")"
            txtFldRoutingNumber.text = arrBank[selectIndex].routingNumber ?? ""
            lblScreentitle.text = "Update Bank"
            btnSuhbmitEdit.setTitle("Update", for: .normal)
        }else{
            //add
            lblScreentitle.text = "Add Bank"
            btnSuhbmitEdit.setTitle("Submit", for: .normal)
        }

    }
    @IBAction func actionSubmit(_ sender: UIButton) {
        
         if txtFldHolderName.text == ""{
            showSwiftyAlert("", "Enter account holder name", false)
        }else if txtFldAccountNumber.text == ""{
            showSwiftyAlert("", "Enter account number", false)
        }else if txtFldRoutingNumber.text == ""{
            showSwiftyAlert("", "Enter routing number", false)
        }else if txtFldEmail.text == ""{
            showSwiftyAlert("", "Enter your email address.", false)
        }else if txtFldEmail.isValidEmail(txtFldEmail.text ?? "") == false{
            showSwiftyAlert("", "Please enter a valid email address.", false)
        }else  if txtFldId.text == ""{
            showSwiftyAlert("", "Enter id", false)
        }else{
        
            let bankDetails = BankDetaill(
                bankId: bankId,
                country: "US",
                currency: "USD",
                accountHolderName: txtFldHolderName.text ?? "",
                accountHolderType: "individual",
                routingNumber: txtFldRoutingNumber.text ?? "",
                accountNumber: txtFldAccountNumber.text ?? "",
                idNumber: txtFldId.text ?? "",
                email: txtFldEmail.text ?? "",
                isDefault: isDefault
            )
            
            if isComing == true{
                viewModel.EditBankApi(bankAccountDetails: bankDetails) { message in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isSelect = 10
                    vc.message = message
                    vc.callBack = { [weak self] in
                        guard let self = self else { return }
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.navigationController?.present(vc, animated: false)
                }
            }else{
                
                viewModel.addBankApi(bankAccountDetails: bankDetails) { data,message in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isSelect = 10
                    vc.message = message
                    vc.callBack = { [weak self] in
                        guard let self = self else { return }
                        if self.isFromWallet == true{
                            SceneDelegate().walletFromAddBankVCRoot()
                        }else{
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                    self.navigationController?.present(vc, animated: false)
                    
                }
                
            }
        }
    }
    
    @IBAction func actionDefault(_ sender: UISwitch) {
        if bankListCount > 0{
            if sender.isOn == true{
                isDefault = "true"
            }else{
                isDefault = "false"
            }
        }else{
            isDefault = "false"
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        if isFromWallet == true{
            SceneDelegate().walletFromAddBankVCRoot()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
//MARK: -UITextFieldDelegate
extension AddBankVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldHolderName {
            // Allow only a-z and A-Z
            let allowedCharacters = CharacterSet.letters
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldHolderName{
            txtFldHolderName.resignFirstResponder()
            txtFldAccountNumber.becomeFirstResponder()
        }else if textField == txtFldAccountNumber{
            txtFldAccountNumber.resignFirstResponder()
            txtFldRoutingNumber.becomeFirstResponder()
        }else if textField == txtFldRoutingNumber{
            txtFldRoutingNumber.resignFirstResponder()
            txtFldEmail.becomeFirstResponder()
        }else if textField == txtFldEmail{
            txtFldEmail.resignFirstResponder()
            txtFldId.becomeFirstResponder()
        }else{
            txtFldId.resignFirstResponder()
        }
        return true
    }
}
