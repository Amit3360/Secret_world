//
//  SelfReviewTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 02/05/25.
//

import UIKit

class SelfReviewTVC: UITableViewCell {
    @IBOutlet var viewShadow: UIView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblCommunincation: UILabel!
    @IBOutlet var lblQuality: UILabel!
    @IBOutlet var lblAttitude: UILabel!
    @IBOutlet var lblSpeed: UILabel!
    @IBOutlet var lblReliability: UILabel!
    @IBOutlet var lblComment: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblRatingType: UILabel!
    @IBOutlet var imgVwRate: UIImageView!
    @IBOutlet var imgVwUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
