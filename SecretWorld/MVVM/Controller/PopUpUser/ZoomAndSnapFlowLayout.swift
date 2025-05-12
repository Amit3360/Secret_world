//
//  ZoomAndSnapFlowLayout.swift
//  SecretWorld
//
//  Created by Ideio Soft on 26/02/25.
//

import UIKit

class CardsCollectionFlowLayout: UICollectionViewFlowLayout {
    private let itemHeight: CGFloat = 160
    private var itemWidth: CGFloat = 280

    override func prepare() {
        guard let collectionView = collectionView else { return }
        itemWidth = collectionView.frame.width-40
        scrollDirection = .horizontal
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let horizontalInsets = (collectionView.frame.width - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: 0, left: horizontalInsets, bottom: 0, right: horizontalInsets)

        let peekingItemWidth = itemSize.width / 10
        minimumLineSpacing = horizontalInsets - peekingItemWidth
    }
}
