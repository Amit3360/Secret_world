//
//  BusinessTimingTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 02/02/24.
//

import UIKit

class BusinessTimingTVC: UITableViewCell {

    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var txtFldEndTime: UITextField!
    @IBOutlet var txtFldStartTime: UITextField!
    @IBOutlet var txtFldDay: UITextField!
    
    var indexxPathh = 0
    var callBack:((_ section:Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    func uiSet(){
        txtFldStartTime.delegate = self
        txtFldEndTime.delegate = self
        txtFldDay.delegate = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension BusinessTimingTVC:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        callBack?(indexxPathh)
        return true
    }
    
}
