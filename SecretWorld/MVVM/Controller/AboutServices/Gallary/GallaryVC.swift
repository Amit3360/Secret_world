//
//  GallaryVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 23/12/23.
//

import UIKit

class GallaryVC: UIViewController {
    //MARK: OUTLETS
    @IBOutlet var collVwGallary: UICollectionView!
    @IBOutlet var lblNoData: UILabel!
    //MARK: VARIABLES
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet var lblImgCount: UILabel!
    var arrServiceImgs = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("GetStoreServiceData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationUser(notification:)), name: Notification.Name("GetStoreUserServices"), object: nil)
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        uiSet()
    }
    @objc func methodOfReceivedNotificationUser(notification: Notification) {
        uiSet()
    }

    func uiSet(){
        
        if Store.role == "b_user"{
            for serviceImgs in Store.ServiceDetailData?.service ?? []{
                arrServiceImgs = serviceImgs.serviceImages ?? []
                if arrServiceImgs.count > 0 {
                    lblNoData.isHidden = true
                }else{
                    lblNoData.isHidden = false
                    
                }
                collVwGallary.reloadData()
                let serviceAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black
                ]
                let serviceText = NSAttributedString(string: "Gallary ", attributes: serviceAttributes)
                let countAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.app
                ]
                let countString = "(\(serviceImgs.serviceImages?.count ?? 0))"
                let countText = NSAttributedString(string: countString, attributes: countAttributes)
                let combinedString = NSMutableAttributedString()
                combinedString.append(serviceText)
                combinedString.append(countText)
                self.lblImgCount.attributedText = combinedString
                
            }
        }else{
            let serviceImgs = Store.UserServiceDetailData
                arrServiceImgs = serviceImgs?.serviceImagesArray ?? []
            
            if arrServiceImgs.count > 0 {
                lblNoData.isHidden = true
                
                lblImgCount.isHidden = false
                let serviceAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black
                ]
                let serviceText = NSAttributedString(string: "Images ", attributes: serviceAttributes)
                let countAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.app
                ]
               let countString = "(\(serviceImgs?.serviceImagesArray?.count ?? 0))"
                let countText = NSAttributedString(string: countString, attributes: countAttributes)
                let combinedString = NSMutableAttributedString()
                combinedString.append(serviceText)
                combinedString.append(countText)
                self.lblImgCount.attributedText = combinedString
            }else{
                lblNoData.isHidden = false
                
                lblImgCount.isHidden = true
            }
            if arrServiceImgs.count > 10{
                btnViewAll.isHidden = false
            }else{
                btnViewAll.isHidden = true
            }
                collVwGallary.reloadData()
                
                
            }
        
    }
    //MARK: BVUTTON ACTIONS
    @IBAction func actionViewAll(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GallaryImagesVC") as! GallaryImagesVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = true
        vc.callBack = { [weak self] index in
            guard let self = self else { return }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
            vc.arrImage = self.arrServiceImgs
            vc.index = index
//            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
        self.navigationController?.present(vc, animated: true)
    }
    
}
//MARK: - UICollectionViewDelegate
extension GallaryVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(arrServiceImgs.count,10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GallaryCVC", for: indexPath) as! GallaryCVC
            cell.imgVwServic.imageLoad(imageUrl: arrServiceImgs[indexPath.row])
            return cell
        
        
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collVwGallary.frame.size.width / 2-5, height: 110)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
        vc.index = indexPath.row
        vc.arrImage = self.arrServiceImgs
//        self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
       }
}

