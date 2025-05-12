//
//  BorderShimmerView.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 18/10/24.
//

import Foundation
import UIKit
import UIKit

class BorderShimmerView: UIView {
    
    private var borderLayer: CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // Create a border layer
        borderLayer = CALayer()
        borderLayer.borderWidth = 2
        borderLayer.borderColor = UIColor.white.cgColor // Change color as needed
        borderLayer.frame = bounds
        borderLayer.cornerRadius = 10 // Optional: add corner radius
        layer.addSublayer(borderLayer)
        
        // Start the shimmer animation
        startShimmerAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = bounds
        borderLayer.cornerRadius = 10 // Match corner radius if set
    }
    
    private func startShimmerAnimation() {
        // Create the shimmer animation
        let shimmerAnimation = CABasicAnimation(keyPath: "borderColor")
        shimmerAnimation.fromValue = UIColor.clear.cgColor
        shimmerAnimation.toValue = UIColor.white.withAlphaComponent(0.5).cgColor // Change color as needed
        shimmerAnimation.duration = 1.0
        shimmerAnimation.repeatCount = .infinity
        shimmerAnimation.autoreverses = true
        shimmerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Add the animation to the border layer
        borderLayer.add(shimmerAnimation, forKey: "shimmerAnimation")
    }
}
