//
//  GigReadyVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 16/10/24.
//

import UIKit

class GigReadyVC: UIViewController {

    @IBOutlet var viewBack: GradientBorderView!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblGigName: UILabel!
    var callBack:(()->())?
    var gigDetail: FilteredItem?
    var isComing = 0
    var gigDetail2:GetUserGigData?
    var groupId = ""
    var userOwnerGigDetail:GetGigDetailData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let myView = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
//        myView.backgroundColor = .white
//        self.view.addGlowBorder(borderWidth: 3.0, borderColor: .white, glowColor: .cyan, glowRadius: 15.0)
      //  view.addSubview(myView)

        uiSet()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewBack.animateGradient()
        }

    }
    func uiSet(){

        if isComing == 1{
            lblLocation.text = userOwnerGigDetail?.address ?? ""
            lblGigName.text = "\(userOwnerGigDetail?.title ?? "") \(userOwnerGigDetail?.category?.name ?? "")"
            lblDescription.text = userOwnerGigDetail?.about ?? ""

        }else if isComing == 2{
            lblLocation.text = gigDetail2?.gig?.address ?? ""
            lblGigName.text = "\(gigDetail2?.gig?.title ?? "") \(gigDetail2?.gig?.category?.name ?? "")"
            lblDescription.text = gigDetail2?.gig?.about ?? ""

        }else{
            lblLocation.text = gigDetail?.place ?? ""
            lblGigName.text = gigDetail?.title ?? ""
            lblDescription.text = gigDetail?.about ?? ""
        }
    }

    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func actionReady(_ sender: UIButton) {
        self.dismiss(animated: true)
        callBack?()
    }
}

extension UIView {
    func addGlowBorder(borderWidth: CGFloat = 2.0, borderColor: UIColor = .white, glowColor: UIColor = .yellow, glowRadius: CGFloat = 10.0) {
        // Create a sublayer to add the glow effect inside the view
        let glowLayer = CAShapeLayer()
        
        // Define the path for the border (just inside the view's bounds)
        glowLayer.path = UIBezierPath(rect: self.bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)).cgPath
        glowLayer.fillColor = UIColor.clear.cgColor
        glowLayer.strokeColor = borderColor.cgColor
        glowLayer.lineWidth = borderWidth
        
        // Add a shadow to this layer to simulate the glow effect
        glowLayer.shadowColor = glowColor.cgColor
        glowLayer.shadowRadius = glowRadius
        glowLayer.shadowOpacity = 1.0
        glowLayer.shadowOffset = CGSize.zero
        
        // Add the glowLayer to the view
        self.layer.addSublayer(glowLayer)
        
        // Ensure the glow layer resizes with the view
        glowLayer.frame = self.bounds
    }
}
