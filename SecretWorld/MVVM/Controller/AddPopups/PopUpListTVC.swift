//
//  PopUpListTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//

import UIKit

class PopUpListTVC: UITableViewCell {

    
    @IBOutlet weak var imgVwApprove: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var imgVwPopup: UIImageView!
    
    @IBOutlet var viewBack: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
