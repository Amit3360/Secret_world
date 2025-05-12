//
//  SliderForReview.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/04/25.
//

import UIKit

class SliderForReview: UISlider {
    private var thumbTextLabel: UILabel = UILabel()
    private let labelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E7F3E6")
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()

    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        return thumb
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let containerWidth: CGFloat = 40
        let containerHeight: CGFloat = 24

        let thumbCenterX = thumbFrame.origin.x + (thumbFrame.size.width / 2)
        let containerX = thumbCenterX - (containerWidth / 2)
        let containerY = thumbFrame.origin.y - containerHeight - 8

        labelContainerView.frame = CGRect(x: containerX, y: containerY, width: containerWidth, height: containerHeight)
        thumbTextLabel.frame = labelContainerView.bounds

        setValue()
    }
    private func setValue() {
        let intValue = Int(self.value)
        if intValue == 0 {
            thumbTextLabel.text = "00"
        } else {
            thumbTextLabel.text = "\(intValue)"
        }
        thumbTextLabel.textColor = UIColor(hex: "#202020")
    }

//    private func setValue() {
//        let intValue = Int(self.value) // Convert the value to an integer
//        let formattedValue = String(format: "%d", intValue) // Format it as an integer string
//        thumbTextLabel.textColor = UIColor(hex: "#202020")
//        thumbTextLabel.text = "\(formattedValue)" // Use the integer value in the label
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupThumbTextLabel()
        configureSliderAppearance()
        addSliderShadow()  // Add shadow configuration
    }
    
    private func setupThumbTextLabel() {
        addSubview(labelContainerView)
        labelContainerView.addSubview(thumbTextLabel)

        thumbTextLabel.textAlignment = .center
        thumbTextLabel.textColor = .white
        thumbTextLabel.adjustsFontSizeToFitWidth = true
        
        if let poppinsFont = UIFont(name: "Nunito-Medium", size: 13) {
            thumbTextLabel.font = poppinsFont
        }
    }

    private func configureSliderAppearance() {
        // Set the thumb image
        if let thumbImage = UIImage(named: "thumb") {
            setThumbImage(thumbImage, for: .normal)
        }
        
        // Set custom images for the minimum and maximum tracks
        if let minTrackImage = UIImage(named: "reviewTrackk"),
           let maxTrackImage = UIImage(named: "reviewTrackk") {
            setMinimumTrackImage(minTrackImage, for: .normal)
            setMaximumTrackImage(maxTrackImage, for: .normal)
        }
    }
    
    // Adjust the track height
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let originalTrackRect = super.trackRect(forBounds: bounds)
        let customHeight: CGFloat = 10 // Desired track height
        let yOffset = (originalTrackRect.height - customHeight) / 2
        return CGRect(x: originalTrackRect.origin.x, y: originalTrackRect.origin.y + yOffset, width: originalTrackRect.width, height: customHeight)
    }
    
    // Add shadow to the slider
    private func addSliderShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4) // Shadow offset (horizontal, vertical)
        layer.shadowRadius = 4 // Shadow blur radius
        layer.shadowOpacity = 0.25 // Shadow opacity (the alpha value)
        layer.masksToBounds = false // Ensure the shadow is outside the bounds of the slider
    }
}
