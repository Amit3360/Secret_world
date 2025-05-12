//
//  TransactionHistoryTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/08/24.
//

import UIKit

class TransactionHistoryTVC: UITableViewCell {
    @IBOutlet var imgVwArrow: UIImageView!
    @IBOutlet var lblAddedOrWithdra: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
