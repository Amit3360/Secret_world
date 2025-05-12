//
//  BankDetailTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/09/24.
//

import UIKit

class BankDetailTVC: UITableViewCell {
    @IBOutlet var btnDefault: UIButton!
    @IBOutlet var lblDefault: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lblAccountNumber: UILabel!
    @IBOutlet var lblBankName: UILabel!
    @IBOutlet var lblRoutingNumber: UILabel!
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
