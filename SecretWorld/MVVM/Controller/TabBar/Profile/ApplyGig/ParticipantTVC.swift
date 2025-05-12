//
//  ParticipantTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/24.
//

import UIKit

class ParticipantTVC: UITableViewCell {

    @IBOutlet var viewBack: UIView!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var widthBtnMessage: NSLayoutConstraint!
    @IBOutlet var heightStackvw: NSLayoutConstraint!
    @IBOutlet var btnHere: UIButton!
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var btnMessage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
