//
//  NewReviewVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/04/25.
//

import UIKit

class NewReviewVC: UIViewController {

    @IBOutlet var sliderQuality: SliderForReview!
    @IBOutlet var sliderCommunication: SliderForReview!
    @IBOutlet var sliderAttitude: SliderForReview!
    @IBOutlet var sliderSpeed: SliderForReview!
    @IBOutlet var viewReliabilitySlider: SliderForReview!
    @IBOutlet var btnCommentImg: UIButton!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblNAme: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        let sliders = [sliderQuality, sliderCommunication, sliderAttitude, sliderSpeed, viewReliabilitySlider]

        for slider in sliders {
            slider?.minimumValue = 0
            slider?.maximumValue = 100
            slider?.addTarget(self, action: #selector(ratingSlidervalueChanged(_:)), for: .valueChanged)
        }

    }
    
    @objc func ratingSlidervalueChanged(_ sender: SliderForReview) {
        let sliders: [(slider: SliderForReview, name: String)] = [
            (sliderQuality, "sliderQuality"),
            (sliderCommunication, "sliderCommunication"),
            (sliderAttitude, "sliderAttitude"),
            (sliderSpeed, "sliderSpeed"),
            (viewReliabilitySlider, "viewReliabilitySlider")
        ]
        
        for (index, item) in sliders.enumerated() {
            if sender == item.slider {
                let intValue = Int(sender.value)
                print("Index: \(index), Name: \(item.name), Value: \(intValue)")
                break
            }
        }
    }
    @IBAction func actionSubmit(_ sender: UIButton) {
    }
    @IBAction func actionBAck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
