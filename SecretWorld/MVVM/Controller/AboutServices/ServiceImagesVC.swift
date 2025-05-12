//
//  ServiceImagesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 07/03/24.
//

import UIKit

class ServiceImagesVC: UIViewController {

    @IBOutlet var collVwImages: UICollectionView!
    
    var arrServiceImgs = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
    }
    @objc func handleSwipe() {
                navigationController?.popViewController(animated: true)
            }

    @IBAction func actionBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
  

}
//MARK: - UICollectionViewDelegate
extension ServiceImagesVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrServiceImgs.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceImagesCVC", for: indexPath) as! ServiceImagesCVC
        cell.imgVwService.imageLoad(imageUrl: arrServiceImgs[indexPath.row])
            return cell
        
        
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as!  ViewImageVC
        vc.arrImage = arrServiceImgs
        vc.index = indexPath.row
//        self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collVwImages.frame.size.width / 2 - 10, height: 170)
        
    }
}

