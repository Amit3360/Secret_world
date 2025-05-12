//
//  RoundedTrackSlider.swift
//  SecretWorld
//
//  Created by Ideio Soft on 24/01/25.
//

import Foundation
import UIKit
class RoundedTrackSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y+10, width: bounds.size.width, height: 4) // Custom height
        return customBounds
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Apply corner radius to the track
        if let minimumTrackView = self.subviews.first(where: { $0 is UIImageView }) {
            minimumTrackView.layer.cornerRadius = 2 // Adjust radius as needed
            minimumTrackView.clipsToBounds = true
        }
    }
}
