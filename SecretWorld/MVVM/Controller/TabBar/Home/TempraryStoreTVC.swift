//
//  TempraryStoreTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 16/01/24.
//

import UIKit

class TempraryStoreTVC: UITableViewCell {
    @IBOutlet var viewShadow: UIView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblrating: UILabel!
    
    @IBOutlet var lblStoreName: UILabel!
    @IBOutlet var viewImgVwBack: UIView!
    @IBOutlet var imgVwStore: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
