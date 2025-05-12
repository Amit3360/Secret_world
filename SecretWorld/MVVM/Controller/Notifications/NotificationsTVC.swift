//
//  NotificationsTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 26/12/23.
//

import UIKit

class NotificationsTVC: UITableViewCell {

    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgVwNotification: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
