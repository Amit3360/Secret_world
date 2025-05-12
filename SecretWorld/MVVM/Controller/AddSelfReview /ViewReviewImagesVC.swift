//
//  ViewReviewImagesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/04/25.
//

import UIKit

class ViewReviewImagesVC: UIViewController {

    @IBOutlet var collVwImgs: UICollectionView!
    var arrImgs = [String]()
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
        }
    }

    @IBAction func actionLeft(_ sender: UIButton) {
        if index > 0 {
            index -= 1
            let indexPath = IndexPath(item: index, section: 0)
            collVwImgs.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
        cell.imgVwReview.image = UIImage(named: arrImgs[indexPath.row])
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 290)
    }
}
