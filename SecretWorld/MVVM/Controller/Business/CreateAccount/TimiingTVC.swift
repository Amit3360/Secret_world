//
//  TimiingTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 11/02/25.
//

import UIKit
import MaterialComponents

class TimiingTVC: UITableViewCell {
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var txtFldEndTime: MDCOutlinedTextField!
    @IBOutlet var txtFldStartTime: MDCOutlinedTextField!
    @IBOutlet weak var lblDay: UILabel!
    
    var indexxPathh = 0
    var callBack:((_ section:Int)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func uiSet(){
        txtFldStartTime.delegate = self
        txtFldEndTime.delegate = self
        configureOutlinedTextField(txtFldStartTime, placeholder: "Opening")
        configureOutlinedTextField(txtFldEndTime, placeholder: "Closing")

        
    }

    private func configureOutlinedTextField(_ textField: MDCOutlinedTextField, placeholder: String) {
        textField.label.text = placeholder
        textField.setOutlineColor(UIColor(hex: "#CCCCCC"), for: .normal)
        textField.setOutlineColor(UIColor(hex: "#CCCCCC"), for: .editing)
        textField.setNormalLabelColor(UIColor(hex: "#CCCCCC"), for: .normal)
        textField.setFloatingLabelColor(UIColor(hex: "#6E6E6C"), for: .editing)
        textField.setTextColor(.black, for: .normal) // ✅ Text color
        textField.setLeadingAssistiveLabelColor(.red, for: .normal) // ✅ Assistive text color (if any)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension TimiingTVC:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        callBack?(indexxPathh)
        return true
    }
    
}
