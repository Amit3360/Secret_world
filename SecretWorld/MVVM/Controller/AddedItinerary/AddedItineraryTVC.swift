//
//  AddedItineraryTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 31/01/25.
//

import UIKit

class AddedItineraryTVC: UITableViewCell {

    @IBOutlet weak var imgVwMap: UIImageView!
    @IBOutlet weak var lblEarning: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddNewSecond: UILabel!
    @IBOutlet weak var btnAddSecond: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblRepeatFirst: UILabel!
    @IBOutlet weak var lblAddNewFirst: UILabel!
    @IBOutlet weak var btnAddFirst: UIButton!
    @IBOutlet weak var vwSecond: UIView!
    @IBOutlet weak var vwFirst: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
