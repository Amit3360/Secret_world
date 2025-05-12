//
//  ReceiverProductMenuTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 03/04/25.
//

import UIKit

class ReceiverProductMenuTVC: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var vwPrice: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var vwProduct: UIView!
    @IBOutlet weak var imgVwProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
