//
//  AddedProductListTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 01/04/25.
//

import UIKit

class AddedProductListTVC: UITableViewCell {

    @IBOutlet var viewForHIdeOrNot: UIView!
    @IBOutlet var imgVwProduct: UIImageView!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblProductName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
