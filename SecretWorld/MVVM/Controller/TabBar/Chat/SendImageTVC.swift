//
//  SendImageTVC.swift
//  SecretWorld
//
//  Created by meet sharma on 16/04/24.
//

import UIKit
import AVFoundation

class SendImageTVC: UITableViewCell {

    @IBOutlet weak var bottomReactionVw: NSLayoutConstraint!
    @IBOutlet weak var vwReactionThird: UIView!
    @IBOutlet weak var vwReactionSecond: UIView!
    @IBOutlet weak var vwReactionFirst: UIView!
    @IBOutlet weak var vwNotch: UIView!
    @IBOutlet weak var imgVwTick: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var topMessage: NSLayoutConstraint!
    @IBOutlet weak var widthCollVw: NSLayoutConstraint!
    @IBOutlet weak var collVwImage: UICollectionView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwImg: UIView!
    @IBOutlet weak var heightCollVw: NSLayoutConstraint!
    @IBOutlet weak var heightProfileImg: NSLayoutConstraint!

    
    var arrImage = [String]()
    var callBack:((_ index:Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    override func prepareForReuse() {
        super.prepareForReuse()
//        imgVwProfile.image = nil  // Clear the image to avoid showing the wrong one momentarily
    }
    func uiSet(){
        print("ArrrImage-----",arrImage)
        
        collVwImage.delegate = self
        collVwImage.dataSource = self
        if arrImage.count == 0{
            widthCollVw.constant = 0
            heightCollVw.constant = 0 + lblMessage.frame.height
        }else if arrImage.count == 1{
            widthCollVw.constant = 200
            heightCollVw.constant = 270 + lblMessage.frame.height
        }else if arrImage.count >= 4{
            heightCollVw.constant = 297 + lblMessage.frame.height
            widthCollVw.constant = 284
        }else{
            heightCollVw.constant = 270 + lblMessage.frame.height
            widthCollVw.constant = UIScreen.main.bounds.width - 40
        }
      
        collVwImage.reloadData()
    }

    func generateThumbnail(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            do {
                let asset = AVURLAsset(url: url)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
                let thumbnail = UIImage(cgImage: thumbnailCGImage)
                
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                print("Error generating thumbnail: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }

}

extension SendImageTVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCVC", for: indexPath) as! ImagesCVC
       
        if arrImage[indexPath.row].contains(".png") || arrImage[indexPath.row].contains(".jpg") || arrImage[indexPath.row].contains(".jpeg"){
            cell.imgVwPlay.isHidden = true
//           cell.imgVwUpload.imageLoad(imageUrl: self.arrImage[indexPath.row])
            cell.imgVwUpload.sd_setImage(
                with: URL(string: self.arrImage[indexPath.row]),
                placeholderImage: UIImage(named: "Profile-Pic-Icon (1)"),
                options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
            )
        }else{
            
            cell.imgVwPlay.isHidden = false
            cell.imgVwUpload.kf.indicatorType = .activity
            cell.imgVwUpload.kf.indicator?.view.tintColor = UIColor.black
            cell.imgVwUpload.kf.indicator?.startAnimatingView()
            if let url = URL(string: arrImage[indexPath.row]){
                print("Url",url)
                generateThumbnail(url: url) { thumbnail in
                    if let thumbnail = thumbnail {
                        cell.imgVwUpload.kf.indicator?.stopAnimatingView()
                        DispatchQueue.main.asyncAfter(deadline: .now()){
                            cell.imgVwUpload.image = thumbnail
                        }
                        print("Thumbnail loaded")
                    } else {
                        print("Failed to load thumbnail")
                    }
                }
            }
           
        }
        if arrImage.count > 4{
            if indexPath.row == 3{
                cell.lblCount.isHidden = false
                cell.vwBackground.isHidden = false
                cell.lblCount.text = "+\(arrImage.count-4)"
            }else{
                cell.lblCount.isHidden = true
                cell.lblCount.text = ""
                cell.vwBackground.isHidden = true
            }
        }else{
            cell.lblCount.isHidden = true
            cell.lblCount.text = ""
            cell.vwBackground.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callBack?(indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrImage.count == 1{
            return CGSize(width: collVwImage.frame.width/1, height: 225)
        }else{
            return CGSize(width: collVwImage.frame.width/2-6, height: 117)
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
