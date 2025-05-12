//
//  BrezerPathRight.swift
//  SecretWorld
//
//  Created by Ideio Soft on 04/04/25.
//

import Foundation
import UIKit

class BrezerPathRight: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
        backgroundColor = .clear
    }

    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.masksToBounds = false
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        
        let notchWidth: CGFloat = 10
        let notchHeight: CGFloat = 10
        let cornerRadius: CGFloat = 5

        bezierPath.move(to: CGPoint(x: rect.minX - 5, y: rect.minY)) // Start slightly left for shadow
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.minX + notchWidth, y: rect.minY + notchHeight))
        bezierPath.addLine(to: CGPoint(x: rect.minX + notchWidth, y: rect.maxY - cornerRadius))
        bezierPath.addQuadCurve(to: CGPoint(x: rect.minX + notchWidth + cornerRadius, y: rect.maxY),
                                controlPoint: CGPoint(x: rect.minX + notchWidth, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
        bezierPath.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius),
                                controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))
        bezierPath.addQuadCurve(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY),
                                controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.minX + notchWidth + cornerRadius, y: rect.minY))
        bezierPath.close()

        UIColor(hex: "#DBDDDB").setFill()
        bezierPath.fill()

        self.layer.shadowPath = bezierPath.cgPath
    }
    }
