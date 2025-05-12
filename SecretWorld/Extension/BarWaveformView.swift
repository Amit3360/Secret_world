//
//  BarWaveformView.swift
//  SecretWorld
//
//  Created by Ideio Soft on 08/04/25.
//

import Foundation
import UIKit

class BarWaveformView: UIView {
    private var wavePoints: [CGFloat] = []
    private let barWidth: CGFloat = 1.0
    private let spacing: CGFloat = 1
    private var maxBars: Int = 0
    private let scaleFactor: CGFloat = 0.05 // Reduce wave height
    var waveColor: UIColor = .red // ✅ Custom wave color

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        maxBars = Int(bounds.width / (barWidth + spacing))
    }

    func updateWave(with level: CGFloat) {
        if wavePoints.count >= maxBars {
            wavePoints.removeFirst()
        }

        let scaledLevel = max(2, min(level * (bounds.height / 2) * scaleFactor, bounds.height / 4))
        wavePoints.append(scaledLevel)

        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    func reset() {
        wavePoints.removeAll()
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), !wavePoints.isEmpty else { return }
        context.clear(rect)

        let midY = bounds.height / 2
        let startX: CGFloat = 0

        for (index, value) in wavePoints.enumerated() {
            let x = startX + CGFloat(index) * (barWidth + spacing)
            let y = midY - value

            let barRect = CGRect(x: x, y: y, width: barWidth, height: value * 2)
            context.setFillColor(waveColor.cgColor)
            context.fill(barRect)
        }
    }
}

