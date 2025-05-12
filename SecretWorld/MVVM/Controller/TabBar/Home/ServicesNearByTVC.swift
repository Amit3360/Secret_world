//
//  ServicesNearByTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 23/12/23.
//

import UIKit

class ServicesNearByTVC: UITableViewCell {

    @IBOutlet var lblSubCategory: UILabel!
    @IBOutlet var widthBtnFavourite: NSLayoutConstraint!
    @IBOutlet var heightLocationIcon: NSLayoutConstraint!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var heighViewServiceNames: NSLayoutConstraint!
    @IBOutlet var btnBookMark: UIButton!
    @IBOutlet var lblRatingCount: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblServiceName: UILabel!
    @IBOutlet var imgVwService: UIImageView!
    @IBOutlet var viewShadow: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
