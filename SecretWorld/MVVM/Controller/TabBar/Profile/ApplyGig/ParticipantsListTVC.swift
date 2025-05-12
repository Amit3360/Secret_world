//
//  ParticipantsListTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 01/04/25.
//

import UIKit

class ParticipantsListTVC: UITableViewCell {

    @IBOutlet var heightBtnChatCastProfile: NSLayoutConstraint!
    @IBOutlet var hieghtStackVwBTns: NSLayoutConstraint!
    @IBOutlet var widthBtnCastProfileChat: NSLayoutConstraint!
    @IBOutlet var btnChatForCastProfiles: UIButton!
    @IBOutlet var btnReject: UIButton!
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var btnAccept: UIButton!
    @IBOutlet var lblDesciption: UILabel!
    @IBOutlet var lblRatingReview: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblTaskCompleted: UILabel!
    @IBOutlet var lblUserNAme: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTime: UILabel!
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
