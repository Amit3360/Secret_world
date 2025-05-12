//
//  UserSideMomentTaskListTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 09/04/25.
//

import UIKit

class UserSideMomentTaskListTVC: UITableViewCell {
    @IBOutlet var collVwAppliedUser: UICollectionView!
    @IBOutlet var viewAmount: UIView!
    @IBOutlet var lblRoleInstruction: UILabel!
    @IBOutlet var viewDurationProgress: UIView!
    @IBOutlet var viewOfferBarter: UIView!
    @IBOutlet var viewRole: UIView!
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var lblSpots: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var lblTaskCount: UILabel!
    @IBOutlet var lblRole: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblOfferBarter: UILabel!
    private var customProgressBar = PlainHorizontalProgressBar()
    var momentTask: MomentTask? {
        didSet {
            collVwAppliedUser.reloadData()
        }
    }
    func uiSet(){
        let nibImgs = UINib(nibName: "ReviewImagesCVC", bundle: nil)
        collVwAppliedUser.register(nibImgs, forCellWithReuseIdentifier: "ReviewImagesCVC")
        collVwAppliedUser.delegate = self
        collVwAppliedUser.dataSource = self
        collVwAppliedUser.reloadData()
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        customProgressBar = PlainHorizontalProgressBar(frame: CGRect(x: 0, y: 0, width: viewDurationProgress.bounds.width, height: viewDurationProgress.bounds.height))
        viewDurationProgress.addSubview(customProgressBar)
        
        handleProgressView()
    }
    // Update the progress of the custom progress bar
    func updateCustomProgressBar(progress: CGFloat) {
        // Ensure progress is within bounds of 0 to 1
        customProgressBar.progress = progress
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
//MARK: - PlainHorizontalProgressBar
class PlainHorizontalProgressBar: UIView {

    var progress: CGFloat = 0 {
        didSet { updateProgressLayer() }
    }

    private let gradientLayer = CAGradientLayer()
    private let maskLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }

    private func setupGradientLayer() {
        // Set gradient colors (lighter start color)
        gradientLayer.colors = [
          UIColor(hex: "#F2F9F2").cgColor, // Lighter green
          UIColor(hex: "#ABFFA4").cgColor
        ]
        // Set color stops to match CSS gradient's color stop percentages
        gradientLayer.locations = [NSNumber(value: 0.0059), NSNumber(value: 0.9545)]
        // Angle matching 270.75deg (CSS), from right to left with a slight tilt
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        layer.addSublayer(gradientLayer)
        // Mask layer to clip gradient based on progress
        gradientLayer.mask = maskLayer
      }


    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateProgressLayer()
    }

    private func updateProgressLayer() {
        let width = bounds.width * min(max(progress, 0), 1)
        maskLayer.frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        maskLayer.backgroundColor = UIColor.black.cgColor
    }
}
//MARK: - UICollectionViewDelegate
extension UserSideMomentTaskListTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
