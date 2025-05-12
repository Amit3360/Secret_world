//
//  MemberlistTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 09/05/25.
//

import UIKit
import AlignedCollectionViewFlowLayout

class MemberlistTVC: UITableViewCell {

    @IBOutlet weak var vwOnOff: UIView!
    @IBOutlet weak var heightService: NSLayoutConstraint!
    @IBOutlet weak var heightPriceType: NSLayoutConstraint!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var collVwService: UICollectionView!
    @IBOutlet weak var lblBenefits: UILabel!
    @IBOutlet weak var collVwPriceType: UICollectionView!
    @IBOutlet weak var lblMembershipName: UILabel!
    @IBOutlet weak var btnOnOff: UIButton!
    @IBOutlet weak var vwBackground: UIView!
    
    var arrPriceType = [Plan]()
    var arrService = [ServiceMembership]()
    override func awakeFromNib() {
        super.awakeFromNib()
        collVwService.delegate = self
        collVwService.dataSource = self
        collVwPriceType.delegate = self
        collVwPriceType.dataSource = self
        let nib = UINib(nibName: "SkillToolsCVC", bundle: nil)
        collVwService.register(nib, forCellWithReuseIdentifier: "SkillToolsCVC")
        collVwPriceType.register(nib, forCellWithReuseIdentifier: "SkillToolsCVC")
    }

    func configure(plans:[Plan]?,services:[ServiceMembership]?){
        self.arrService.removeAll()
        self.arrPriceType.removeAll()
        self.arrService = services ?? []
        self.arrPriceType = plans ?? []
        
        collVwPriceType.reloadData()
        collVwService.reloadData()
        setCollectionViewHeight()
    }
    func setCollectionViewHeight(){
        let alignedFlowLayoutCollVwPricing = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwPriceType.collectionViewLayout = alignedFlowLayoutCollVwPricing
        
        
        if let flowLayout = collVwPriceType.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 20)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        if let layout = collVwService.collectionViewLayout as? UICollectionViewFlowLayout {
               layout.estimatedItemSize = .zero // disable auto sizing
            layout.itemSize = CGSize(width: collVwService.frame.width/2-0, height: 25) // dummy value; real value will come from delegate
               layout.scrollDirection = .vertical
               layout.minimumLineSpacing = 0
               layout.minimumInteritemSpacing = 0
           }
        
        let heighPriceType = self.collVwPriceType.collectionViewLayout.collectionViewContentSize.height
        self.heightPriceType.constant = heighPriceType
        let heighService = self.collVwService.collectionViewLayout.collectionViewContentSize.height
        self.heightService.constant = heighService
     
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MemberlistTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == collVwService ? arrService.count : arrPriceType.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillToolsCVC", for: indexPath) as! SkillToolsCVC

        if collectionView == collVwService {
            let service = arrService[safe: indexPath.row]
            cell.lblTitle.text = "• \(service?.name ?? "")"
            cell.lblTitle.textColor = UIColor(hex: "#363636")
            cell.lblTitle.font = UIFont(name: "Poppins-Medium", size: 12)
            cell.contentView.backgroundColor = UIColor(hex: "#F5FAF5")
        } else {
            let plan = arrPriceType[safe: indexPath.row]
            cell.lblTitle.text = "$\(plan?.price ?? 0)/\(plan?.type ?? "")"
            cell.lblTitle.textColor = UIColor(hex: "#3E9C35")
            cell.contentView.backgroundColor = UIColor(hex: "#E6F2E5")
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwService {
            let itemWidth = (collectionView.frame.width - 10) / 2
            return CGSize(width: itemWidth, height: 25)
        }
        return CGSize(width: 30, height: 20)
    }
}
