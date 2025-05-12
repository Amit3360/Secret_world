//
//  ProductListTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//

import UIKit

class ProductListTVC: UITableViewCell {

    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var widthEditBtn: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
