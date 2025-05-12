//
//  GlowingGradientView.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 18/10/24.
//

import Foundation
import UIKit

class GlowingGradientView: UIView {
  private var gradientLayer: CAGradientLayer!
  private let borderWidth: CGFloat = 5
  private var animationDuration = 2.0
  private var blurView: UIVisualEffectView!
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupGradientLayer()
    setupBlurEffect() // Add blur effect
    addGlowEffect()
    startGradientAnimation()
    startGlowAnimation() // Add glow animation
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupGradientLayer()
    setupBlurEffect() // Add blur effect
    addGlowEffect()
    startGradientAnimation()
    startGlowAnimation() // Add glow animation
  }
  private func setupGradientLayer() {
    gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors = [UIColor.purple.cgColor,
                UIColor.systemIndigo.cgColor,
                UIColor.blue.cgColor,
                UIColor.green.cgColor,
                UIColor.yellow.cgColor,
                UIColor.orange.cgColor,
                UIColor.red.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    gradientLayer.cornerRadius = 20
    let maskLayer = CAShapeLayer()
    maskLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2),
                   cornerRadius: layer.cornerRadius).cgPath
    maskLayer.fillColor = UIColor.clear.cgColor
    maskLayer.strokeColor = UIColor.white.cgColor
    maskLayer.lineWidth = borderWidth
    gradientLayer.mask = maskLayer
    layer.addSublayer(gradientLayer)
  }
  private func setupBlurEffect() {
    let blurEffect = UIBlurEffect(style: .light)
    blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = bounds
    blurView.layer.cornerRadius = layer.cornerRadius
    blurView.clipsToBounds = true
    blurView.layer.borderWidth = borderWidth
    blurView.layer.borderColor = UIColor.clear.cgColor
    addSubview(blurView)
    sendSubviewToBack(blurView) // Make sure the blur is behind the glow and gradient
  }
  private func addGlowEffect() {
    // Apply shadow to the main view's layer
    layer.shadowRadius = 20
    layer.shadowOpacity = 1.0
    layer.shadowOffset = .zero
    layer.shadowColor = UIColor.red.cgColor
    layer.masksToBounds = false // Make sure shadows are drawn outside the view bounds
    layer.cornerRadius = 20
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
    gradientLayer.mask?.frame = bounds
    (gradientLayer.mask as? CAShapeLayer)?.path = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2), cornerRadius: layer.cornerRadius).cgPath
    blurView.frame = bounds
    blurView.layer.cornerRadius = layer.cornerRadius
  }
  private func startGradientAnimation() {
    let animation = CABasicAnimation(keyPath: "colors")
    animation.fromValue = [UIColor.purple.cgColor,
                UIColor.systemIndigo.cgColor,
                UIColor.blue.cgColor,
                UIColor.green.cgColor,
                UIColor.yellow.cgColor,
                UIColor.orange.cgColor,
                UIColor.red.cgColor]
    animation.toValue = [UIColor.red.cgColor,
               UIColor.orange.cgColor,
               UIColor.yellow.cgColor,
               UIColor.green.cgColor,
               UIColor.blue.cgColor,
               UIColor.systemIndigo.cgColor,
               UIColor.purple.cgColor]
    animation.duration = animationDuration
    animation.repeatCount = .infinity
    animation.autoreverses = true
    gradientLayer.add(animation, forKey: "gradientAnimation")
  }
  private func startGlowAnimation() {
    let glowAnimation = CAKeyframeAnimation(keyPath: "shadowColor")
    glowAnimation.values = [
      UIColor.purple.cgColor,
      UIColor.systemIndigo.cgColor,
      UIColor.blue.cgColor,
      UIColor.green.cgColor,
      UIColor.yellow.cgColor,
      UIColor.orange.cgColor,
      UIColor.red.cgColor
    ]
    glowAnimation.duration = animationDuration
    glowAnimation.keyTimes = [0, 0.16, 0.33, 0.5, 0.66, 0.83, 1] // Defines when each color appears
    glowAnimation.autoreverses = true
    glowAnimation.repeatCount = .infinity
    layer.add(glowAnimation, forKey: "glowAnimation")
  }
}
