//
//  RangeSliderFilter.swift
//  SecretWorld
//
//  Created by Ideio Soft on 19/12/24.
//

import Foundation
import UIKit

class RangeSliderFilter: UIControl {

    let trackLayer = CALayer()
    let rangeLayer = CALayer()
    let minimumThumb = UIView()
    let maximumThumb = UIView()
    let minimumLabel = UILabel()
    let maximumLabel = UILabel()
    var index = 0
    var type = 0
    
    var minValue: CGFloat = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    var maxValue: CGFloat = 100 {
        didSet {
            updateLayerFrames()
        }
    }
    var lowerValue: CGFloat = 25 {
        didSet {
            updateLayerFrames()
        }
    }
    var upperValue: CGFloat = 75 {
        didSet {
            updateLayerFrames()
        }
    }
    private let thumbSize: CGFloat = 20.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // Configure track
        trackLayer.backgroundColor = UIColor.app.cgColor
        layer.addSublayer(trackLayer)

        // Configure range highlight
        rangeLayer.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(rangeLayer)

      
        configureThumb(minimumThumb, label: minimumLabel, color: UIColor.app)
        configureThumb(maximumThumb, label: maximumLabel, color: UIColor.app)

        updateLayerFrames()
    }

    private func configureThumb(_ thumb: UIView, label: UILabel, color: UIColor) {
        thumb.backgroundColor = color
        thumb.layer.cornerRadius = thumbSize / 2
        addSubview(thumb)

        // Configure label
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor(hex: "#E7F3E6")
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        addSubview(label)

        // Add pan gesture for dragging
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleThumbPan(_:)))
        thumb.addGestureRecognizer(panGesture)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerFrames()
    }

    private func updateLayerFrames() {
        // Update track frame
        let trackHeight: CGFloat = 4
        trackLayer.frame = CGRect(
            x: 0,
            y: bounds.midY - trackHeight / 2,
            width: bounds.width,
            height: trackHeight
        )
        trackLayer.cornerRadius = trackHeight / 2
        
        // Update range layer
        let lowerThumbCenter = positionForValue(lowerValue)
        let upperThumbCenter = positionForValue(upperValue)
        rangeLayer.frame = CGRect(
            x: lowerThumbCenter,
            y: bounds.midY - trackHeight / 2,
            width: upperThumbCenter - lowerThumbCenter,
            height: trackHeight
        )

        // Update thumb and label positions
        minimumThumb.frame = CGRect(
            x: positionForValue(lowerValue) - thumbSize / 2,
            y: bounds.midY - thumbSize / 2,
            width: thumbSize,
            height: thumbSize
        )
        minimumThumb.borderWid = 2
        minimumThumb.borderCol = .white
        minimumLabel.frame = CGRect(
            x: minimumThumb.center.x - 20,
            y: minimumThumb.frame.minY - 30,
            width: 45,
            height: 25
        )
        if type == 1{
            if index == 2{
          
                minimumLabel.text = "\(Int(lowerValue))H"
            }else if index == 1{
             
                minimumLabel.text = "$\(Int(lowerValue))"
            }
        }else{
           
           minimumLabel.text = "$\(Int(lowerValue))"
            
        }
       
     
        maximumThumb.borderWid = 2
        maximumThumb.borderCol = .white
        maximumThumb.frame = CGRect(
            x: positionForValue(upperValue) - thumbSize / 2,
            y: bounds.midY - thumbSize / 2,
            width: thumbSize,
            height: thumbSize
        )
        maximumLabel.frame = CGRect(
            x: maximumThumb.center.x - 20,
            y: maximumThumb.frame.minY - 30,
            width: 45,
            height: 25
        )
   
        if type == 1{
            if index == 2{
                
                maximumLabel.text = "\(Int(upperValue))H"
            }else if index == 1{
             
                maximumLabel.text = "$\(Int(upperValue))"
            }
        }else{
         
            maximumLabel.text = "$\(Int(upperValue))"
            
        }
        
    }

    private func positionForValue(_ value: CGFloat) -> CGFloat {
        let width = bounds.width - thumbSize
        return width * (value - minValue) / (maxValue - minValue) + thumbSize / 2
    }

    @objc private func handleThumbPan(_ gesture: UIPanGestureRecognizer) {
        guard let thumb = gesture.view else { return }
        let translation = gesture.translation(in: self).x
        gesture.setTranslation(.zero, in: self)

        // Update values based on thumb movement
        if thumb == minimumThumb {
            let newValue = lowerValue + (maxValue - minValue) * translation / bounds.width
            lowerValue = max(minValue, min(newValue, upperValue - 1))
        } else if thumb == maximumThumb {
            let newValue = upperValue + (maxValue - minValue) * translation / bounds.width
            upperValue = min(maxValue, max(newValue, lowerValue + 1))
        }

        if type == 1{
            if index == 2{
                minTime = Int(lowerValue)
                maxTime = Int(upperValue)
                isSelectGigTime = true
          
            }else if index == 1{
               
                minPrice = Int(lowerValue)
                maxPrice = Int(upperValue)
                isSelectGigPrice = true
            }
        }else{
            minDeal = Int(lowerValue)
            maxDeal = Int(upperValue)
            isSelectDealing = true
 
            
        }
       
        // Send value changed event
        sendActions(for: .valueChanged)
    }
}
