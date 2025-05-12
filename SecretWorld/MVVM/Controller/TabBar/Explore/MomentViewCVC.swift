//
//  MomentViewCVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 28/04/25.
//

import UIKit

class MomentViewCVC: UICollectionViewCell {

    @IBOutlet weak var lblMomentName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
