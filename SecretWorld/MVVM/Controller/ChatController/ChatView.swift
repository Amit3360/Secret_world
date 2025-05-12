//
//  ChatView.swift
//  SecretWorld
//
//  Created by Ideio Soft on 31/03/25.
//

import UIKit

class ChatView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = getBezierPath(width: bounds.maxX, height: bounds.maxY)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
  
    private func getBezierPath(width: Double, height: Double) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 4, y: 0))
        
        // TopLine
        path.addLine(to: CGPoint(x: width - 12, y: 0))
        
        // Top-right arc
        path.addArc(
            withCenter: CGPoint(x: width - 12, y: 4),
            radius: 4,
            startAngle: CGFloat(Double.pi * 3 / 2),
            endAngle: CGFloat(0),
            clockwise: true
        )
        
        // RightLine
        path.addLine(to: CGPoint(x: width - 8, y: height - 16))
        
        // SlantLine (Tail)
        path.addLine(to: CGPoint(x: width, y: height - 4))
        
        // Bottom-right arc
        path.addArc(
            withCenter: CGPoint(x: width - 4, y: height - 4),
            radius: 4,
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi / 2),
            clockwise: true
        )
        
        // BottomLine
        path.addLine(to: CGPoint(x: 4, y: height))
        
        // Bottom-left arc
        path.addArc(
            withCenter: CGPoint(x: 4, y: height - 4),
            radius: 4,
            startAngle: CGFloat(Double.pi / 2),
            endAngle: CGFloat(Double.pi),
            clockwise: true
        )
        
        // LeftLine
        path.addLine(to: CGPoint(x: 0, y: 4))
        
        // Top-left arc
        path.addArc(
            withCenter: CGPoint(x: 4, y: 4),
            radius: 4,
            startAngle: CGFloat(Double.pi),
            endAngle: CGFloat(Double.pi * 3 / 2),
            clockwise: true
        )
        
        path.close()
        return path
    }
}
