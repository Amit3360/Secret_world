//
//  ViewReviewImagesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/04/25.
//

import UIKit

class ViewReviewImagesVC: UIViewController {

    @IBOutlet var lblComment: UILabel!
    @IBOutlet var lblQuality: UILabel!
    @IBOutlet var lblVibe: UILabel!
    @IBOutlet var lblSetup: UILabel!
    @IBOutlet var lblReliability: UILabel!
    @IBOutlet var lblService: UILabel!
    @IBOutlet var collVwImgs: UICollectionView!
    var arrImgs = [ReviewMedia]()
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibImgs = UINib(nibName: "ReviewImagesCVC", bundle: nil)
        collVwImgs.register(nibImgs, forCellWithReuseIdentifier: "ReviewImagesCVC")
        collVwImgs.isPagingEnabled = true
        collVwImgs.collectionViewLayout = createLayout()
        
        let indexPath = IndexPath(item: index, section: 0)
        DispatchQueue.main.async {
            self.collVwImgs.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            
        }
        setLablesData(index: index)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collVwImgs.contentOffset, size: collVwImgs.bounds.size)
        if let visibleIndexPath = collVwImgs.indexPathForItem(at: CGPoint(x: visibleRect.midX, y: visibleRect.midY)) {
            index = visibleIndexPath.item
            setLablesData(index: index)
        }
    }

    func setLablesData(index: Int) {
        let rating = arrImgs[index].rating
        lblComment.text = arrImgs[index].comment ?? ""
        lblQuality.attributedText = styledRatingText(title: "Quality", value: rating?.quality ?? 0)
        lblVibe.attributedText = styledRatingText(title: "Attitude", value: rating?.attitude ?? 0)
        lblSetup.attributedText = styledRatingText(title: "Speed", value: rating?.speed ?? 0)
        lblReliability.attributedText = styledRatingText(title: "Reliability", value: rating?.reliability ?? 0)
        lblService.attributedText = styledRatingText(title: "Communication", value: rating?.communication ?? 0)


    }
    func styledRatingText(title: String, value: Double) -> NSAttributedString {
        let titleFont = UIFont(name: "Nunito-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12)
        let valueFont = UIFont(name: "Nunito-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: valueFont,
            .foregroundColor: UIColor(hex: "#828282")
        ]
        
        let attributedString = NSMutableAttributedString(string: "\(title): ", attributes: titleAttributes)
        let valueString = NSAttributedString(string: "\(value)", attributes: valueAttributes)
        
        attributedString.append(valueString)
        
        return attributedString
    }

    func createLayout() -> UICollectionViewLayout {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           layout.minimumLineSpacing = 0
           layout.minimumInteritemSpacing = 0
           return layout
       }

    @IBAction func actionBAck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func actionRight(_ sender: UIButton) {
        if index < arrImgs.count - 1 {
            index += 1
            let indexPath = IndexPath(item: index, section: 0)
            collVwImgs.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            setLablesData(index: index)
        }
    }

    @IBAction func actionLeft(_ sender: UIButton) {
        if index > 0 {
            index -= 1
            let indexPath = IndexPath(item: index, section: 0)
            collVwImgs.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            setLablesData(index: index)
        }
    }

}
//MARK: - UICollectionViewDelegate
extension ViewReviewImagesVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewImagesCVC", for: indexPath) as! ReviewImagesCVC
        cell.imgVwReview.imageLoad(imageUrl: arrImgs[indexPath.row].media ?? "")
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 290)
    }
}
