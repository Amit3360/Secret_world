//
//  AllCategoryVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 25/12/23.
//

import UIKit

class AllCategoryVC: UIViewController {

    @IBOutlet var collVwCateories: UICollectionView!
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                   swipeRight.direction = .right
                   view.addGestureRecognizer(swipeRight)

        let nib = UINib(nibName: "CategoriesCVC", bundle: nil)
        collVwCateories.register(nib, forCellWithReuseIdentifier: "CategoriesCVC")
    }
    
    @objc func handleSwipe() {
              navigationController?.popViewController(animated: true)
          }


    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
//MARK: - UICollectionViewDelegate

extension AllCategoryVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return serviceCategories.count
            
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCVC", for: indexPath) as! CategoriesCVC
            let category = serviceCategories[indexPath.row]
        cell.imgVwCategory.image = UIImage(named: category.imageName)
            cell.lblName.text = category.name
            return cell
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            return CGSize(width: collVwCateories.frame.size.width / 4-10, height: 100)
            
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
//
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
