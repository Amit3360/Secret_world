//
//  VerifyPhoneNumberVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit

class VerifyPhoneNumberVC: UIViewController {
    // MARK: - OUTLETS
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet var btnCodeTiming: UIButton!
    @IBOutlet var txtFldCode: UITextField!
    @IBOutlet var lblTitleWithPhone: UILabel!
    
    // MARK: - VARIABLES
    
    var phoneNumber:String?
    var countryCode:String?
    var timer: Timer?
    var secondsRemaining = 60
    var isTimerRunning = false
    var isComing = false
    var viewModel = AuthVM()
    var isSelect = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("BusinessUserDetail","\(Store.BusinessUserDetail?["countryCode"] as? String ?? "") \(Store.BusinessUserDetail?["mobile"] as? Int ?? 0)")
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        uiSet()
        startTimer()
    }
    @objc func handleSwipe() {
             navigationController?.popViewController(animated: true)
         }

    func uiSet() {
        print("Store.role:==\(Store.role ?? "")")
        txtFldCode.delegate = self
        if let phoneNumber = phoneNumber {
            let secureNumber = securePhoneNumber(phoneNumber)
            
            let fullText = "We have sent the verification code to \n\(countryCode ?? "") \(secureNumber)"
            let attributedText = NSMutableAttributedString(string: fullText)
            
            // Set attributes for the country code
            let countryCodeRange = (fullText as NSString).range(of: countryCode ?? "")
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: lblTitleWithPhone.font.pointSize), range: countryCodeRange)
            attributedText.addAttribute(.foregroundColor, value: UIColor.app, range: countryCodeRange)
            
            let secureNumberRange = (fullText as NSString).range(of: secureNumber)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: lblTitleWithPhone.font.pointSize), range: secureNumberRange)
            attributedText.addAttribute(.foregroundColor, value: UIColor.app, range: secureNumberRange)
            
            lblTitleWithPhone.attributedText = attributedText
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
                      tapGesture.cancelsTouchesInView = false
                      view.addGestureRecognizer(tapGesture)
           }
           @objc func dismissKeyboardWhileClick() {
                  view.endEditing(true)
              }
    
      func securePhoneNumber(_ phoneNumber: String) -> String {
          let visibleDigitsCount = 4
          let maskedCount = phoneNumber.count - visibleDigitsCount
          let maskedPart = String(repeating: "*", count: maskedCount)
          let visiblePart = phoneNumber.suffix(visibleDigitsCount)
          return "\(maskedPart)\(visiblePart)"
        }
   
    // MARK: - BUTTON ACTIONS
    @IBAction func actionResendOtp(_ sender: UIButton) {
        if isSelect == true{
            print("isSelect:--\(isSelect)")
                viewModel.ResendOtp { data in
                    showSwiftyAlert("", "Enter otp : \(data?.otp ?? "")", true)
                }
        }else{
            print("timer")
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func actionContinue(_ sender: UIButton) {
        
        if isComing == true{
            viewModel.VerifyChangeMobileNumberWithOtpApi(otp: txtFldCode.text ?? "") {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MobileNumberChangedVC") as! MobileNumberChangedVC
                vc.phoneNumber = self.phoneNumber
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            
            if txtFldCode.text == ""{
                
                showSwiftyAlert("", "Please enter your verification code", false)
                
            }else{
                isOtpInvalid = true
                viewModel.VerifyMobileOtp(otp: txtFldCode.text ?? "") { data in
                    
                    Store.autoLogin = data?.user?.profileStatus
                    Store.role = data?.user?.usertype ?? ""
                    Store.userId = data?.user?.id ?? ""
                    
                    if Store.autoLogin == 1{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountTypeVC") as! AccountTypeVC
                        isComingSocial = false
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }else if Store.autoLogin == 2{
                        
                        if Store.role == "b_user"{
                            
                            SceneDelegate().completeSignupBusinessUserVCRoot()
                            
                        }else{
                            
                            SceneDelegate().completeSignupUserVCRoot()
                            
                        }
                        
                        
                    }else{
                        SceneDelegate().userRoot()
                        isSelectAnother = false
                    }
                }
            }
        }
    }
    @IBAction func actionRefreshCode(_ sender: UIButton) {
        print("timer")
        if timer == nil{
            
            btnCodeTiming.setImage(UIImage(named: ""), for: .normal)
            
            startTimer()
            
            
        }
    }
    func startTimer() {
        btnCodeTiming.isHidden = true
        lblTime.isHidden = false
           timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
       }

       func stopTimer() {
           
           timer?.invalidate()
           timer = nil
           secondsRemaining = 60
           updateTimerLabel()
           isTimerRunning = false
           btnCodeTiming.setImage(UIImage(named: "refresh25"), for: .normal)
           isSelect = true
           lblTime.text = ""
           lblTime.isHidden = true
           btnCodeTiming.isHidden = false
       }

    @objc func updateTimer() {
        if secondsRemaining > 0 {
            isSelect = false
            secondsRemaining -= 1
            updateTimerLabel()
        } else {
            stopTimer()
        }
    }
    
    func updateTimerLabel() {
        DispatchQueue.main.async {
            let minutes = self.secondsRemaining / 60
            let seconds = self.secondsRemaining % 60
            let title = String(format: "0%1d:%02d", minutes, seconds)
            self.lblTime.text = title
        }
    }
}
// MARK: - UITextFieldDelegate
extension VerifyPhoneNumberVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only digits (0-9) and limit to 4 characters
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        
        if newLength == 4 { DispatchQueue.main.async { textField.resignFirstResponder() } }
        
        return isNumber && newLength <= 4
    }
}
