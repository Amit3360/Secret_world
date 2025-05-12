//
//  MagnifierView.swift
//  SecretWorld
//
//  Created by Ideio Soft on 26/03/25.
//

import Foundation
import UIKit

class MagnifierView: UIView {
    
    var magnificationScale: CGFloat = 2.0  // Adjust the zoom level
    private let imageView = UIImageView()
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = frame.width / 2
        self.clipsToBounds = true
        self.backgroundColor = .clear
        
        // Configure ImageView
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(
            x: -frame.width * (magnificationScale - 1) / 2,
            y: -frame.height * (magnificationScale - 1) / 2,
            width: frame.width * magnificationScale,
            height: frame.height * magnificationScale
        )
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMagnifier(at point: CGPoint) {
        self.center = point
        imageView.frame.origin = CGPoint(
            x: -point.x * magnificationScale + self.frame.width / 2,
            y: -point.y * magnificationScale + self.frame.height / 2
        )
    }
}
