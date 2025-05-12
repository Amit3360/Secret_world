//
//  GallaryImagesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 28/12/23.
//

import UIKit
import CollectionViewWaterfallLayout

class GallaryImagesVC: UIViewController {

    @IBOutlet var viewBg: UIView!
    @IBOutlet var collVw: UICollectionView!
    
    
    var arrServiceImgs = [String]()
    var isComing = false
    var callBack:((_ index:Int)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
       
            uiSet()
    }
    func uiSet(){
                
        viewBg.layer.cornerRadius = 35
        viewBg.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}
//MARK: - UICollectionViewDelegate
// MARK: - UICollectionViewDataSource
extension GallaryImagesVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isComing == true{
            return Store.UserServiceDetailData?.serviceImagesArray?.count ?? 0
        }else{
            return arrServiceImgs.count
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GallaryImagesCVC", for: indexPath) as! GallaryImagesCVC
        if isComing == true{
            cell.imgVwService.imageLoad(imageUrl: Store.UserServiceDetailData?.serviceImagesArray?[indexPath.row] ?? "")
        }else{
            cell.imgVwService.imageLoad(imageUrl: arrServiceImgs[indexPath.row])
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.dismiss(animated: true)
        self.callBack?(indexPath.row)
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collVw.frame.size.width / 2 - 10, height: 170)
        
    }

    
}


