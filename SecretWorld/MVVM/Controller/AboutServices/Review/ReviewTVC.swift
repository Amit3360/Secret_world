//
//  ReviewTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 25/12/23.
//

import UIKit
import FloatRatingView

class ReviewTVC: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet var viewShadow: UIView!
    @IBOutlet var heightImgVw: NSLayoutConstraint!
    @IBOutlet var ratingView: FloatRatingView!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imgVwReview: UIImageView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
