//
//  AddMomentTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 08/04/25.
//

import UIKit
import IQKeyboardManagerSwift

class AddMomentTVC: UITableViewCell,UITextViewDelegate {
    //MARK: - IBOutlet
    @IBOutlet var stackVwPayAndPaymerntTerm: UIStackView!
    @IBOutlet var txtFldPaymentTerm: UITextField!
    @IBOutlet var viewPaymentTerm: UIView!
    @IBOutlet var heightLblTotal: NSLayoutConstraint!
    @IBOutlet var lblPlaceholderPerperson: UILabel!
    @IBOutlet var txtFldRoleDuration: UITextField!
    @IBOutlet var txtFldRoleType: UITextField!
    @IBOutlet var viewRoleType: UIView!
    @IBOutlet var viewRoleDuiration: UIView!
    @IBOutlet var viewPersonRequired: UIView!
    @IBOutlet var viewOfferBarter: UIView!
    @IBOutlet var viewAmount: UIView!
    @IBOutlet var txtFldAmount: UITextField!
    @IBOutlet var viewPaymentMethod: UIView!
    @IBOutlet var txtVwRoleInstructions: IQTextView!
    @IBOutlet var txtFldPersonRequired: UITextField!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var txtVwOfferBarter: IQTextView!
    @IBOutlet var lblTaskNumber: UILabel!
    @IBOutlet var txtfldRole: UITextField!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var txtFldPaymentMethod: UITextField!
    
    // MARK: - Callbacks
    var onTapPaymentTerm: ((AddMomentTVC) -> Void)?
    var onTapPaymentMethod: ((AddMomentTVC) -> Void)?
    var onTapDuration: ((AddMomentTVC) -> Void)?
    var onTapRoleType: ((AddMomentTVC) -> Void)?
    var onTextFieldUpdate: ((String, String) -> Void)? // (fieldName, value)
    var onTextViewUpdate: ((String, String) -> Void)? // (fieldName, value)
      override func awakeFromNib() {
          super.awakeFromNib()
          txtFldAmount.delegate = self
          txtFldPersonRequired.delegate = self
          txtVwRoleInstructions.delegate = self
          txtFldPersonRequired.delegate = self
          txtFldRoleType.delegate = self
          txtVwOfferBarter.delegate = self
          
          txtFldPaymentTerm.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
          txtFldRoleType.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
          txtfldRole.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
          txtFldAmount.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
          txtFldPersonRequired.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
          txtFldPaymentMethod.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
//          txtfldDuration.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
//          txtfldPersonRequired.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
//          txtfldWhatToDo.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
//          txtfldWatchOut.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
          setupTapGestures()
      }
    func textViewDidChange(_ textView: UITextView) {
        if textView == txtVwRoleInstructions {
            onTextViewUpdate?("roleInstructions", textView.text ?? "")
        } else if textView == txtVwOfferBarter {
            onTextViewUpdate?("offerBarter", textView.text ?? "")
        }
    }

    @objc func textChanged(_ sender: UITextField) {
        switch sender {
        case txtfldRole:
            onTextFieldUpdate?("role", sender.text ?? "")
        case txtFldPersonRequired:
            onTextFieldUpdate?("personRequired", sender.text ?? "")
        case txtFldPaymentMethod:
            onTextFieldUpdate?("paymentType", sender.text ?? "")
        case txtFldAmount:
            onTextFieldUpdate?("amount", sender.text ?? "")
        case txtFldRoleType:
            onTextFieldUpdate?("roleType", sender.text ?? "")
        case txtFldRoleDuration:
            onTextFieldUpdate?("duration", sender.text ?? "")
        case txtFldPaymentTerm:
            onTextFieldUpdate?("paymentTerm", sender.text ?? "")
        default:
            break
        }
    }

      private func setupTapGestures() {
          addTap(to: viewPaymentMethod, action: #selector(handlePaymentTypeTap))
          addTap(to: viewRoleDuiration, action: #selector(handleDurationTap))
          addTap(to: viewRoleType, action: #selector(handleRoleTypeTap))
          addTap(to: viewPaymentTerm, action: #selector(handlePaymentTermTap))
      }

      private func addTap(to view: UIView, action: Selector) {
          let tap = UITapGestureRecognizer(target: self, action: action)
          view.addGestureRecognizer(tap)
          view.isUserInteractionEnabled = true
      }
    
    @objc private func handlePaymentTermTap() {
        onTapPaymentTerm?(self)
    }

    @objc private func handlePaymentTypeTap() {
        onTapPaymentMethod?(self)
    }

    @objc private func handleDurationTap() {
        onTapDuration?(self)
    }

    @objc private func handleRoleTypeTap() {
        onTapRoleType?(self)
    }


      override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)
      }
  }
//MARK: - UITextFieldDelegate
extension AddMomentTVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  textField == txtFldPersonRequired || textField == txtFldAmount{
            let currentText = textField.text ?? ""
            
            // Prevent entering '0' at the beginning (unless it's followed by a decimal)
            if string == "0" && currentText.isEmpty {
                return false
            }
            if textField == txtFldPersonRequired {
                print("Person Required Updated Text: \(currentText)")
                onTextFieldUpdate?("personRequired", currentText)
            } else if textField == txtFldAmount {
                print("Amount Updated Text: \(currentText)")
                onTextFieldUpdate?("amount", currentText)
            }

        }
        return true
    }

}
