//
//  GigViewCVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/11/24.
//

import UIKit

class GigViewCVC: UICollectionViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var imgVwMedal: UIImageView!
    @IBOutlet weak var lblImmediate: UILabel!
    @IBOutlet weak var imgVwFire: UIImageView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblParticipants: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblTaskDuration: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    // @IBOutlet var viewMore: UIView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet var widthCollVwParticipanst: NSLayoutConstraint!
    @IBOutlet var collVwParticipants: UICollectionView!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblPayout: UILabel!
    @IBOutlet var lblParticipantsCount: UILabel!
    @IBOutlet var lblNameProvider: UILabel!
    @IBOutlet var lblGigName: UILabel!
    @IBOutlet var imgVwServiceProvider: UIImageView!
    @IBOutlet var btnDismiss: UIButton!
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var btnViewMore: UIButton!
    //MARK: - Variables
   
    var arrParticipanstList = [Participantzz]()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: "GigParticipanstsCVC", bundle: nil)
        collVwParticipants.register(nib, forCellWithReuseIdentifier: "GigParticipanstsCVC")
        collVwParticipants.delegate = self
        collVwParticipants.dataSource = self

        
    }
    
    func uiSet() {
        collVwParticipants.reloadData()
    }
}
//MARK: - UICollectionViewDelegate

extension GigViewCVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrParticipanstList.count > 0{
            return min(arrParticipanstList.count, 3)
        }else{
            return 0
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GigParticipanstsCVC", for: indexPath) as! GigParticipanstsCVC
        if arrParticipanstList.count > 0{
            cell.imgVwUser.imageLoad(imageUrl: arrParticipanstList[indexPath.row].profilePhoto ?? "")
            cell.imgVwUser.layer.cornerRadius = 10
        }
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 20, height: 20)
    }
    func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return arrParticipanstList.count > 1 ? -10 : 0
    }

}
