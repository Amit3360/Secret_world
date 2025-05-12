//
//  WaveformView.swift
//  SecretWorld
//
//  Created by Ideio Soft on 09/04/25.
//

import Foundation
import UIKit

class WaveformView: UIView {
    var samples: [Float] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    var progress: Float = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    var waveformColor: UIColor = UIColor(hex: "#2C2C2E")
    var progressColor: UIColor = UIColor(hex: "#3E9C35")

    override func draw(_ rect: CGRect) {
        guard !samples.isEmpty else { return }

        let context = UIGraphicsGetCurrentContext()
        let widthPerSample = rect.width / CGFloat(samples.count)
        let centerY = rect.midY

        for (i, sample) in samples.enumerated() {
            let height = CGFloat(sample) * rect.height
            let x = CGFloat(i) * widthPerSample
            let y = centerY - height / 2
            let barRect = CGRect(x: x, y: y, width: widthPerSample, height: height)

            let isFilled = Float(i) / Float(samples.count) <= progress
            let color = isFilled ? progressColor : waveformColor
            context?.setFillColor(color.cgColor)
            context?.fill(barRect)
        }
    }
}
