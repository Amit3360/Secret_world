//
//  WithdrawAmountVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/09/24.
//

import UIKit

class WithdrawAmountVC: UIViewController {

    @IBOutlet var viewBack: UIView!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnWithdraw: UIButton!
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var txtFldAmount: UITextField!
    
    var isComing = false
    var callBack:((_ amount:Int,_ message:String,_ isBalance:Bool)->())?
    var viewModel = PaymentVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = 35
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
               tapGesture.cancelsTouchesInView = false
               view.addGestureRecognizer(tapGesture)
        setupOverlayView()
           
        if isComing == true{
            //withdraw
            lblScreenTitle.text = "Withdraw Amount"
            lblSubTitle.text = "How much would you like to withdraw"
            btnWithdraw.setTitle("Withdraw", for: .normal)
        }else{
            //add wallet
            lblScreenTitle.text = "Add Amount"
            lblSubTitle.text = "How much would you like to add to your wallet."
            btnWithdraw.setTitle("Proceed", for: .normal)
        }
    }
    func setupOverlayView() {
        viewBack = UIView(frame: self.view.bounds)
        viewBack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        viewBack.addGestureRecognizer(tapGesture)
        self.view.insertSubview(viewBack, at: 0)
    }
    @objc func overlayTapped() {
          self.dismiss(animated: true)
      }

    @objc func dismissKeyboardWhileClick() {
           view.endEditing(true)
       }
    @IBAction func actionEnterAmount(_ sender: Any) {
        txtFldAmount.becomeFirstResponder()
    }

    @IBAction func actionWithdraw(_ sender: UIButton) {
        
        if txtFldAmount.text == ""{
            showSwiftyAlert("", "Enter amount", false)
        }else if Int(txtFldAmount.text ?? "") ?? 0 <= 0 {
            showSwiftyAlert("", "Enter valid amount", false)
        }else{
            if isComing == true{
                
                if Double(txtFldAmount.text ?? "") ?? 0 <= Store.WalletAmount ?? 0{
                    isWithdrawWithBank = true
                    viewModel.WithdrawRequestApi(requestAmount: Int(txtFldAmount.text ?? "") ?? 0) { data,message in
                        self.dismiss(animated: true)
                        self.callBack?(Int(self.txtFldAmount.text ?? "") ?? 0, message ?? "", true)
                    }
                }else{
                    self.dismiss(animated: true)
                    callBack?(Int(txtFldAmount.text ?? "") ?? 0, "", false)
                   
                }
                
            }else{
                
                self.dismiss(animated: true)
                callBack?(Int(txtFldAmount.text ?? "") ?? 0, "", false)
            }
        }
    }
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
//MARK: - UITextFieldDelegate
extension WithdrawAmountVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldAmount{
            let currentText = textField.text ?? ""
            
            // Prevent entering '0' at the beginning (unless it's followed by a decimal)
            if string == "0" && currentText.isEmpty {
                return false
            }

        }
        return true
    }
}
