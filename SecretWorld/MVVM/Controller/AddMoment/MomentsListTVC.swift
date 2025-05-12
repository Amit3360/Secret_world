//
//  MomentsListTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 10/04/25.
//

import UIKit

class MomentsListTVC: UITableViewCell {

    @IBOutlet var viewShadow: UIView!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTaskCount: UILabel!
    @IBOutlet var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
