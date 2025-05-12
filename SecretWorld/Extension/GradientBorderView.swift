
// GradientBorderView.swift
// StylishMap
//
// Created by Ideio Soft on 17/10/24.
//
import UIKit

class GradientBorderView: UIView {
    private var gradientLayer: CAGradientLayer!
    private let borderWidth: CGFloat = 10
    private var animationDuration = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradientLayer()
    }

    private func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.purple.cgColor,
            UIColor.systemIndigo.cgColor,
            UIColor.blue.cgColor,
            UIColor.green.cgColor,
            UIColor.yellow.cgColor,
            UIColor.orange.cgColor,
            UIColor.red.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth = borderWidth
        gradientLayer.mask = maskLayer
        
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.mask?.frame = bounds
        (gradientLayer.mask as? CAShapeLayer)?.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    func animateGradient() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = [
            UIColor.red.cgColor,
            UIColor.orange.cgColor,
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor,
            UIColor.systemIndigo.cgColor,
            UIColor.purple.cgColor
        ]
        animation.duration = CFTimeInterval(animationDuration)
        animation.repeatCount = .infinity
        animation.autoreverses = true
        gradientLayer.add(animation, forKey: "gradientAnimation")
    }
}

