//
//  SelectedItemTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 01/05/25.
//

import UIKit

class SelectedItemTVC: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblQuantityPrice: UILabel!
    @IBOutlet weak var imgVwItem: UIImageView!
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblOff: UILabel!
    @IBOutlet weak var lblItemCategory: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var txtFldWeight: UITextField!
    @IBOutlet weak var vwWeight: UIView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var vwQuantity: UIView!
    
    
    var selectedItems = [AddItems]()
    var callBack:((_ value:Double?)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtFldWeight.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            if self.selectedItems[self.txtFldWeight.tag].stockType == 0{
                self.txtFldWeight.keyboardType = .numberPad
            }else{
                self.txtFldWeight.keyboardType = .decimalPad
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension SelectedItemTVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow backspace
        if string.isEmpty {
            return true
        }

        // Get new text after editing
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        // Allow only digits and at most one dot (if stockType == 1)
        guard let cellIndex = textField.tag as Int?, cellIndex < selectedItems.count else { return false }

        let item = selectedItems[cellIndex]
        let allowedCharacters: CharacterSet = item.stockType == 0
            ? CharacterSet(charactersIn: "0123456789")
            : CharacterSet(charactersIn: "0123456789.")

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

        // Prevent entering a value greater than totalStock
        if let enteredValue = Double(newText), let stock = item.totalStock {
            if enteredValue > Double(stock) {
                return false
            }
        }
        
        callBack?(Double(newText))
        return true
    }
}
