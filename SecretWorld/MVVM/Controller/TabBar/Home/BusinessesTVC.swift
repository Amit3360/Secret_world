//
//  BusinessesTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 16/01/24.
//

import UIKit
import SkeletonView
import AlignedCollectionViewFlowLayout
class BusinessesTVC: UITableViewCell {
    @IBOutlet var leadingCollvw: NSLayoutConstraint!
    @IBOutlet var heightCollvwCategories: NSLayoutConstraint!
    @IBOutlet var widthTimeImg: NSLayoutConstraint!
    @IBOutlet var heightTimeImg: NSLayoutConstraint!
    @IBOutlet var widthLocationImg: NSLayoutConstraint!
    @IBOutlet var heightLocationImg: NSLayoutConstraint!
    @IBOutlet weak var imgVwClock: UIImageView!
  @IBOutlet weak var imgVwStar: UIImageView!
  @IBOutlet weak var imgVwLocation: UIImageView!
  @IBOutlet var lblTiming: UILabel!
  @IBOutlet var lblPlace: UILabel!
  @IBOutlet var lblrating: UILabel!
  @IBOutlet var lblBusinessName: UILabel!
  @IBOutlet var imgVwService: UIImageView!
  @IBOutlet var collVwCategry: UICollectionView!
  @IBOutlet var viewShadow: UIView!
  var arrBusiness = [Businessss]()
  var arrCategories = [String]()
  var loadData = false
  var indexx = 0
    var arrSearchBusiness = [SearchList]()
    var isComing = false
  override func awakeFromNib() {
    super.awakeFromNib()
    let nib = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
    collVwCategry.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
      
    collVwCategry.delegate = self
    collVwCategry.dataSource = self
  }
  func uiSet(load:Bool){
      if isComing == true{
         
          self.arrCategories = arrBusiness[indexx].categoryName ?? []
          
      }else{
          self.arrCategories = arrSearchBusiness[indexx].categoryName ?? []
      }
  
      
   collVwCategry.reloadData()
      
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
//MARK: - UICollectionViewDelegate
extension BusinessesTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrCategories.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
    cell.vwBg.layer.cornerRadius = 2
    cell.lblName.font = UIFont.systemFont(ofSize: 9)
    cell.vwBg.backgroundColor = UIColor(red: 0xEF/255.0, green: 0xEF/255.0, blue: 0xEF/255.0, alpha: 1.0)
    cell.widthBtnCross.constant = 0
      cell.lblLeading.constant = 0
      cell.lblTrailing.constant = 0
    cell.lblName.text = arrCategories[indexPath.row]
    return cell
  }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = arrCategories[indexPath.item]
        let textWidth = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9)]).width
        let width = textWidth + 26 
        return CGSize(width: width, height: 16)
      }
}









