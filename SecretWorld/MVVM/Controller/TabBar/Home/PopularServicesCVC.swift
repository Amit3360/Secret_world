//
//  PopularServicesCVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//

import UIKit
import AlignedCollectionViewFlowLayout

class PopularServicesCVC: UICollectionViewCell {

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet var imgVwBlueTick: UIImageView!
   
    @IBOutlet weak var widthCategoryVw: NSLayoutConstraint!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblServiceName: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var vwShadow: UIView!
    
    var arrCategories = [String]()
    var indexpath = 0
    var isComing = false
    override func awakeFromNib() {
        super.awakeFromNib()
       
     
    }
  

}
