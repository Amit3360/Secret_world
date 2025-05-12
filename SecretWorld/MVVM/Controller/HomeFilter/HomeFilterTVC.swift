//
//  HomeFilterTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 16/12/24.
//

import UIKit
import RangeSeekSlider

class HomeFilterTVC: UITableViewCell {

    @IBOutlet weak var singleSlider: CustomSlider!
    @IBOutlet weak var doubleSlider: RangeSliderFilter!
    @IBOutlet weak var collVwPopular: UICollectionView!
    @IBOutlet weak var popularVw: UIView!
    @IBOutlet weak var doubleThumbVw: UIView!
    @IBOutlet weak var singleThumbVw: UIView!
    @IBOutlet weak var imgVwDropdown: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var isSelectIndex = 0
    var arrTitle = ["Newly Opened","Most Clicked"]
    var  callBacK:((_ selectIndex:Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    func uiSet(){
        collVwPopular.delegate = self
        collVwPopular.dataSource = self
        collVwPopular.reloadData()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
extension HomeFilterTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularFilterCVC", for: indexPath) as! PopularFilterCVC
        cell.lblTitle.text = arrTitle[indexPath.row]
        if isSelectIndex == indexPath.row{
            cell.vwBackground.backgroundColor = UIColor(hex: "#3E9C35")
            cell.lblTitle.textColor = .white
        }else{
            cell.vwBackground.backgroundColor = UIColor(hex: "#E7F3E6")
            cell.lblTitle.textColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 32)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        isSelectIndex = indexPath.row
        popularity = indexPath.row+1
        isSelectPopularity = true
        
        callBacK?(indexPath.row)
    }
}
