//
//  RejectedParticipantTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 21/04/25.
//

import UIKit

class RejectedParticipantTVC: UITableViewCell {

    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
