//
//  BankListTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/09/24.
//

import UIKit

class BankListTVC: UITableViewCell {
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var lblAccountNumber: UILabel!
    @IBOutlet var lblBankName: UILabel!
    @IBOutlet var viewBack: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
