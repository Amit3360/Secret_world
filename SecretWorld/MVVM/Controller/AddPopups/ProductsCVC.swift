//
//  ProductsCVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 17/12/24.
//

import UIKit

class ProductsCVC: UICollectionViewCell {
    @IBOutlet weak var vwAddProduct: UIView!
    @IBOutlet weak var btnAddProduct: UIButton!
    @IBOutlet var widthEditBtn: NSLayoutConstraint!
    @IBOutlet var widthDeleteBtn: NSLayoutConstraint!
    @IBOutlet var viewDetail: UIView!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var imgVwProduct: UIImageView!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var imgVwEdit: UIImageView!
    @IBOutlet var imgVwDelete: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
