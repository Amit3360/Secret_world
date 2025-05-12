//
//  MembershipTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 12/05/25.
//

import UIKit

class MembershipTVC: UITableViewCell {

    @IBOutlet weak var lblMembership: UILabel!
    @IBOutlet weak var widthPrice: NSLayoutConstraint!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgVwType: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
