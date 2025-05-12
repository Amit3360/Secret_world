//
//  MembershipDetailVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 12/05/25.
//

import UIKit

class MembershipDetailVC: UIViewController {
    @IBOutlet weak var widthPrice: NSLayoutConstraint!
    
    @IBOutlet weak var heightCollVwService: NSLayoutConstraint!
    @IBOutlet weak var collVwService: UICollectionView!
    @IBOutlet weak var lblBenefits: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgVwType: UIImageView!
    
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        let nib = UINib(nibName: "SkillToolsCVC", bundle: nil)
        collVwService.register(nib, forCellWithReuseIdentifier: "SkillToolsCVC")
     
        if type == 0{
            imgVwType.image = UIImage(named: "monthly")
            lblType.text = "Monthly Membership"
        }else if type == 1{
            imgVwType.image = UIImage(named: "quarterly")
            lblType.text = "Quarterly Membership"
        }else if type == 2{
            imgVwType.image = UIImage(named: "biAnnually")
            lblType.text = "Bi-annually Membership"
        }else{
            imgVwType.image = UIImage(named: "annually")
            lblType.text = "Annually Membership"
        }
    }

    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionMessage(_ sender: UIButton) {
    }
    
}

extension MembershipDetailVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillToolsCVC", for: indexPath) as! SkillToolsCVC
        cell.lblTitle.text = "• Service"
        cell.lblTitle.textColor = UIColor(hex: "#363636")
        cell.lblTitle.font = UIFont(name: "Poppins-Medium", size: 12)
        cell.contentView.backgroundColor = UIColor(hex: "#F5FAF5")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collVwService.frame.width/2 - 5, height: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
