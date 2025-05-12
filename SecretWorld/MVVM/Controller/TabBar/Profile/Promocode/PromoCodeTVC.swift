//
//  PromoCodeTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/01/24.
//

import UIKit

class PromoCodeTVC: UITableViewCell {
    @IBOutlet var viewShadow: UIView!
    @IBOutlet var btnCopy: UIButton!
    @IBOutlet var imgVwPromoStatus: UIImageView!
    @IBOutlet var viewPromoStatus: UIView!
    @IBOutlet var lblPromoOff: UILabel!
    @IBOutlet var lblExpiryDate: UILabel!
    @IBOutlet var lblPromoCode: UILabel!
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
