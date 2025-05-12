//
//  ServiceTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 17/01/24.
//

import UIKit

class ServiceTVC: UITableViewCell {
    
    @IBOutlet var lblOff: UILabel!
    @IBOutlet var lblPrevPrice: UILabel!
    @IBOutlet var collVwSubcat: UICollectionView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet var viewShadow: UIView!
    @IBOutlet var imgVwService: UIImageView!
    
    var arrSubCategories = [String]()
    var indexpath = 0
    var arrUserSubCategories = [UserSubCategoryy]()
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
        collVwSubcat.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        if let flowLayout = collVwSubcat.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 16)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            
        }
        collVwSubcat.delegate = self
        collVwSubcat.dataSource = self
    }
    func uiSet() {
        if Store.role == "b_user" {
            arrSubCategories.removeAll()
            let data = Store.BusinessServicesList?.service ?? []
            
            if indexpath < data.count {
                for i in data[indexpath].userSubCategories ?? [] {
                    arrSubCategories.append(i.name ?? "")
                }
            } else {
                print("⚠️ indexpath \(indexpath) is out of bounds for data.count \(data.count)")
            }
            
            collVwSubcat.reloadData()
        } else {
            collVwSubcat.reloadData()
        }
    }

}
//MARK: - UICollectionViewDelegate
extension ServiceTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Store.role == "b_user"{
            if arrSubCategories.count > 0{
                return arrSubCategories.count
            }else{
                return 0
            }
        }else{
            
            if arrUserSubCategories.count > 0{
                return arrUserSubCategories.count
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
     
        cell.vwBg.layer.cornerRadius = 2
        cell.lblName.font = UIFont.systemFont(ofSize: 9)
        cell.widthBtnCross.constant = 0
        if Store.role == "b_user"{
            cell.lblName.text = arrSubCategories[indexPath.row]
            cell.vwBg.backgroundColor = UIColor(red: 230/255, green: 242/255, blue: 229/255, alpha: 1.0)

            cell.lblName.textColor = UIColor.app
        }else{
            cell.lblName.text = arrUserSubCategories[indexPath.row].name ?? ""
            cell.vwBg.backgroundColor = UIColor(hex: "#E6F2E5")
            cell.lblName.textColor = UIColor.black.withAlphaComponent(0.8)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collVwSubcat.frame.size.width / 3, height: 16)
    }
    
    
}
