//
//  ItinerariesTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/01/25.
//

import UIKit

class ItinerariesTVC: UITableViewCell {

    @IBOutlet var viewBack: UIView!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var viewDeletBtn: UIView!
    @IBOutlet var lblItemsCount: UILabel!
    @IBOutlet var lblTimig: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
