//
//  ChangePasswordVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 26/12/23.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet var txtFldCurrentPasswd: UITextField!
    @IBOutlet var txtFldNewPasswd: UITextField!
    @IBOutlet var txtFldConfirmPasswd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        uiSet()
    }
    
    func uiSet(){
       
    }
    @objc func handleSwipe() {
              navigationController?.popViewController(animated: true)
          }

    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionEyeCurrentPasswd(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            txtFldCurrentPasswd.isSecureTextEntry = false
                  
        }else{
            txtFldCurrentPasswd.isSecureTextEntry = true
        }
    }
    @IBAction func actionEyeNewPasswd(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            txtFldNewPasswd.isSecureTextEntry = false
                  
        }else{
            txtFldNewPasswd.isSecureTextEntry = true
        }
    }
    @IBAction func actionEyeConfirmPasswrd(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            txtFldConfirmPasswd.isSecureTextEntry = false
                  
        }else{
            txtFldConfirmPasswd.isSecureTextEntry = true
        }
    }
   
    @IBAction func actionSave(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ChangePasswordVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          // Check if the text field is secure and not empty
        
          if textField.isSecureTextEntry, !string.isEmpty {
              // Update the text with asterisk (*) characters
              textField.text = String(repeating: "*", count: string.count)

              // Return false to prevent the actual characters from being added
              return false
          }

          // For other text fields or empty strings, allow normal behavior
          return true
      }
}
