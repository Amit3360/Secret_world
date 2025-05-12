//
//  GigNearByTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/24.
//

import UIKit

class GigNearByTVC: UITableViewCell {
    @IBOutlet weak var leadingCategory: NSLayoutConstraint!
    @IBOutlet weak var widthSkillVw: NSLayoutConstraint!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVwGig: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblRatingReview: UILabel!
    @IBOutlet weak var imgVwAlarm: UIImageView!
    @IBOutlet weak var collVwSkill: UICollectionView!
    @IBOutlet var viewShadow: UIView!
 
    
var arrCategory = [SkillsCategory]()
    
override func awakeFromNib() {
  super.awakeFromNib()
  let nib = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
    collVwSkill.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
    
    collVwSkill.delegate = self
    collVwSkill.dataSource = self
}
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.widthSkillVw.constant = self.collVwSkill.collectionViewLayout.collectionViewContentSize.width
            self.layoutIfNeeded()
        }
    }
    func uiSet(load: Bool) {
        collVwSkill.reloadData()
      
        DispatchQueue.main.async {
            self.widthSkillVw.constant = self.collVwSkill.collectionViewLayout.collectionViewContentSize.width
            self.layoutIfNeeded() // Ensure layout updates
        }
    }
    
override func setSelected(_ selected: Bool, animated: Bool) {
  super.setSelected(selected, animated: animated)
  // Configure the view for the selected state
}
}
//MARK: - UICollectionViewDelegate
extension GigNearByTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrCategory.count
}
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
    cell.lblName.text = arrCategory[indexPath.row].name ?? ""
  cell.vwBg.layer.cornerRadius = 2
  cell.lblName.textColor = UIColor(hex: "#585858")
  cell.lblName.font = UIFont.systemFont(ofSize: 8)
  cell.vwBg.backgroundColor = UIColor(red: 0xEF/255.0, green: 0xEF/255.0, blue: 0xEF/255.0, alpha: 1.0)
  cell.widthBtnCross.constant = 0
  cell.lblLeading.constant = 3
   cell.lblTrailing.constant = 0
 
  return cell
}
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let text = arrCategory[indexPath.item].name ?? ""
      let textWidth = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9)]).width
      let width = textWidth + 10
 
      return CGSize(width: width, height: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}





