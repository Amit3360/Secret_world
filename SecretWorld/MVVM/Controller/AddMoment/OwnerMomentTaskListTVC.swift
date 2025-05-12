//
//  OwnerMomentTaskListTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 09/04/25.
//

import UIKit

class OwnerMomentTaskListTVC: UITableViewCell {

    @IBOutlet var heightViewCalculation: NSLayoutConstraint!
    @IBOutlet var viewPayout: UIView!
    @IBOutlet var viewBckShadow: UIView!
    @IBOutlet var viewBarter: UIView!
    @IBOutlet var lblRoleInstruction: UILabel!
    @IBOutlet var lblCalculation: UILabel!
    @IBOutlet var collVwAppliedUser: UICollectionView!
    @IBOutlet var lblBarter: UILabel!
    @IBOutlet var lblSpot: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnThreeDot: UIButton!
    @IBOutlet var lblTaskCount: UILabel!
    var momentTask: MomentTask? {
        didSet {
            collVwAppliedUser.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        handleProgressView()
    }
    func uiSet(){
        let nibImgs = UINib(nibName: "ReviewImagesCVC", bundle: nil)
        collVwAppliedUser.register(nibImgs, forCellWithReuseIdentifier: "ReviewImagesCVC")
        collVwAppliedUser.delegate = self
        collVwAppliedUser.dataSource = self
        collVwAppliedUser.reloadData()
    }
    func handleProgressView(){
        // Increase the height of progressView
        progressView.transform = CGAffineTransform(scaleX: 1, y: 1.5)
        progressView.progress = 0.0

        // Set the track (empty area) background color
        progressView.trackTintColor = UIColor(hex: "#D9D9D9")  // your desired background
        progressView.progressTintColor = UIColor.app     // your progress color

        // Rounded corners
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true

        if let progressLayer = progressView.layer.sublayers?.last {
            progressLayer.cornerRadius = 3
            progressLayer.masksToBounds = true
        }

        // Add custom shadow layer on track
        if let trackLayer = progressView.layer.sublayers?.first {
            let shadowLayer = CALayer()
            shadowLayer.frame = trackLayer.bounds
            shadowLayer.backgroundColor = UIColor(hex: "#D9D9D9").cgColor
            
            // Mimic box-shadow: 0px 2px 4px 0px #00000026 inset
            shadowLayer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
            shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
            shadowLayer.shadowRadius = 4
            shadowLayer.shadowOpacity = 1
            shadowLayer.cornerRadius = 3
            shadowLayer.masksToBounds = true

            trackLayer.insertSublayer(shadowLayer, at: 0)
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//MARK: - UICollectionViewDelegate
extension OwnerMomentTaskListTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return momentTask?.appliedParticipantsList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewImagesCVC", for: indexPath) as! ReviewImagesCVC
        
        let profileUrl = momentTask?.appliedParticipantsList?[indexPath.row].profilePhoto ?? ""
        cell.imgVwReview.imageLoad(imageUrl: profileUrl)
        cell.leadingImg.constant = 0
        cell.TrailingImg.constant = 0
        cell.topImg.constant = 0
        cell.bottomImg.constant = 0
        cell.imgVwReview.layoutIfNeeded()
        cell.imgVwReview.layer.cornerRadius = cell.imgVwReview.frame.width / 2
        cell.imgVwReview.clipsToBounds = true
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 25)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -12.5 // vertical spacing (row to row if multi-line)
    }


}
