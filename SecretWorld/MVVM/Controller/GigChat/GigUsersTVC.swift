//
//  GigUsersTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 27/09/24.
//

import UIKit

class GigUsersTVC: UITableViewCell {

    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var imgVwSelect: UIImageView!
    @IBOutlet var imgVwUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
