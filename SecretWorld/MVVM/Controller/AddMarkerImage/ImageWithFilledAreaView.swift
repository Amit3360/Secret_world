//
//  ImageWithFilledAreaView.swift
//  SecretWorld
//
//  Created by Ideio Soft on 31/12/24.
//

import Foundation
import UIKit

class ImageWithFilledAreaView: UIView {

    var image: UIImage?
    var fillColor: UIColor = .red // Default fill color
    var fillRect: CGRect = CGRect(x: 50, y: 50, width: 100, height: 100) // Example rectangle for fill

    override func draw(_ rect: CGRect) {
        guard let image = image else { return }
        
        // Draw the image
        image.draw(in: rect)
        
        // Fill the prescribed area with the fill color (e.g., a rectangle)
        fillColor.setFill()
        UIRectFillUsingBlendMode(fillRect, .sourceIn)
    }
}
