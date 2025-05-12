//
//  AddMembershipTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 09/05/25.
//

import UIKit
import IQKeyboardManagerSwift

class AddMembershipTVC: UITableViewCell {

    @IBOutlet weak var vwPlan: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var txtVwDescription: IQTextView!
    @IBOutlet weak var txtFldPrice: UITextField!
    @IBOutlet weak var btnDropdownPrice: UIButton!
    @IBOutlet weak var txtFldPlanType: UITextField!
    @IBOutlet weak var lblPlan: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtFldPrice.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension AddMembershipTVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
      
            if string.isEmpty {
                return true
            }
            
            // Get new text after editing
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Allow only digits and at most one dot (if stockType == 1)
      
            
            
            let allowedCharacters: CharacterSet = CharacterSet(charactersIn: "0123456789.")
                
            if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
                return false
            }
            
            // Prevent multiple dots
            let dotCount = newText.filter { $0 == "." }.count
            if dotCount > 1 {
                return false
            }
            
            // Limit to 2 decimal places
            if let dotIndex = newText.firstIndex(of: ".") {
                let decimalPart = newText[newText.index(after: dotIndex)...]
                if decimalPart.count > 2 {
                    return false
                }
            }
            
           
          
            return true
      
    }
}
