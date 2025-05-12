//
//  AddProductTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 20/03/25.
//

import UIKit

class AddProductTVC: UITableViewCell {

    @IBOutlet weak var bottomDecription: NSLayoutConstraint!
    @IBOutlet weak var topDescription: NSLayoutConstraint!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var widthPriceVw: NSLayoutConstraint!
    @IBOutlet weak var topPriceVw: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
