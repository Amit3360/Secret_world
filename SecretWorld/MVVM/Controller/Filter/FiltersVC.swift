//
//  FiltersVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 23/12/23.
//

import UIKit
import SwiftRangeSlider
import RangeSeekSlider


class FiltersVC: UIViewController {
    
    @IBOutlet var slider: RangeSlider!
    
    @IBOutlet var lblMinValue: UILabel!
    @IBOutlet var lblMaxValue: UILabel!
    @IBOutlet var collVwCategoy: UICollectionView!
    @IBOutlet var collVwPrice: UICollectionView!
    
    //MARK: - Varibales
    var serviceCategories: [ServiceCategory] = [
        ServiceCategory(name: "Cleaning", imageName: "Cleaning"),
        ServiceCategory(name: "Repairing", imageName: "Repairing"),
        ServiceCategory(name: "Plumbing", imageName: "Plumbing"),
        ServiceCategory(name: "Shifting", imageName: "Shifting"),
        ServiceCategory(name: "Food", imageName: "Food"),
        ServiceCategory(name: "Painting", imageName: "Painting"),
        ServiceCategory(name: "Laundry", imageName: "Laundry"),
        ServiceCategory(name: "AC Repair", imageName: "AC Repair"),
        ServiceCategory(name: "Car Repair", imageName: "Car Repair"),
        ServiceCategory(name: "Electrician", imageName: "Electrician"),
        ServiceCategory(name: "Carpainter", imageName: "Carpainter"),
        ServiceCategory(name: "Iron", imageName: "Iron"),
        ServiceCategory(name: "Beauty", imageName: "Beauty"),
        ServiceCategory(name: "Gardening", imageName: "Gardening"),
        ServiceCategory(name: "Security", imageName: "Security"),
        ServiceCategory(name: "Events", imageName: "Events")
    ]
    var arrSelectedImgs = ["selectclean","selectRepair","selectPlumb","selectShifting","selectfood","selectPaint","selectLaundry","selectAcrepair","selectCarrepair","selectElect","selectcarpaintr","selectIrrn","selectBeuty","selectgardn","selectsecurity","selecteven"]
    override func viewDidLoad() {
        super.viewDidLoad()
       uiSet()
        
    }
    func uiSet(){
        let nib = UINib(nibName: "CategoriesCVC", bundle: nil)
               collVwCategoy.register(nib, forCellWithReuseIdentifier: "CategoriesCVC")
        lblMinValue.text = "$\(Int(slider.lowerValue))"
        lblMaxValue.text = "- $\(Int(slider.upperValue))"
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    
    }
    @objc func sliderValueChanged(_ sender: RangeSlider) {
           lblMinValue.text = "$\(Int(sender.lowerValue))"
           lblMaxValue.text = "- $\(Int(sender.upperValue))"
       }
    @IBAction func actionResetTopBtn(_ sender: UIButton) {
    }
    @IBAction func actionCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionCheckmarkReview(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func actionApply(_ sender: UIButton) {
    }
  
    @IBAction func actionReset(_ sender: UIButton) {
    }
    @IBAction func actionSeeAll(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllCategoryVC") as! AllCategoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - UICollectionViewDelegate
extension FiltersVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwPrice{
            
            return 5
            
        }else{
            
            return serviceCategories.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collVwPrice{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceRangeCVC", for: indexPath) as! PriceRangeCVC
//            cell.contentView.layer.cornerRadius = 35
            cell.viewBg.backgroundColor = .clear
            cell.viewBg.borderWid = 0
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCVC", for: indexPath) as! CategoriesCVC
            let category = serviceCategories[indexPath.row]
            cell.imgVwCategory.image = UIImage(named: category.imageName)
            cell.lblName.text = category.name
            
            return cell
            
        }
        
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collVwPrice{
            
            return CGSize(width: collVwPrice.frame.size.width / 5, height: 70)
            
        }else{
            
            return CGSize(width: collVwCategoy.frame.size.width / 5, height: 100)
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwCategoy {
            let cell = collectionView.cellForItem(at: indexPath) as! CategoriesCVC

            // Change image on selection
            cell.imgVwCategory.image = UIImage(named: arrSelectedImgs[indexPath.row])

            // Handle deselection
            for visibleIndexPath in collectionView.indexPathsForVisibleItems {
                if visibleIndexPath != indexPath {
                    let deselectedCell = collectionView.cellForItem(at: visibleIndexPath) as? CategoriesCVC
                    deselectedCell?.imgVwCategory.image = UIImage(named: serviceCategories[visibleIndexPath.row].imageName)
                }
            }
        }
    }
    
    
}
