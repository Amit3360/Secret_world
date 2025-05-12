import UIKit

class BrezerPath: UIView {

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

        bezierPath.move(to: CGPoint(x: rect.maxX + 5, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX - notchWidth, y: rect.minY + notchHeight))
        bezierPath.addLine(to: CGPoint(x: rect.maxX - notchWidth, y: rect.maxY - cornerRadius))
        bezierPath.addQuadCurve(to: CGPoint(x: rect.maxX - notchWidth - cornerRadius, y: rect.maxY),
                                controlPoint: CGPoint(x: rect.maxX - notchWidth, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        bezierPath.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius),
                                controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        bezierPath.addQuadCurve(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY),
                                controlPoint: CGPoint(x: rect.minX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX - notchWidth - cornerRadius, y: rect.minY))
        bezierPath.close()

        UIColor(hex: "#AEDCAA").setFill()
        bezierPath.fill()

        // Optional: If you want the shadow to match the shape
        self.layer.shadowPath = bezierPath.cgPath
    }
}

