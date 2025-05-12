//
//  GigListCVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/12/23.
//

import UIKit

class GigListCVC: UICollectionViewCell {
    
    @IBOutlet var imgComplete: UIImageView!
    @IBOutlet weak var lblPaymentStatus: UILabel!
    @IBOutlet var heightImgVwStartRating: NSLayoutConstraint!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblUserCount: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgVwGig: UIImageView!
    @IBOutlet var vwShadow: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
