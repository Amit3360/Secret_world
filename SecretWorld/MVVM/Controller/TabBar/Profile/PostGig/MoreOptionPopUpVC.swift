//
//  MoreOptionPopUpVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/01/24.
//

import UIKit

class MoreOptionPopUpVC: UIViewController {

    @IBOutlet var viewBack: UIView!
    
    var callBack: ((_ isComing: Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewBack.layer.cornerRadius = 30
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupOverlayView()
    }
    func setupOverlayView() {
        viewBack = UIView(frame: self.view.bounds)
        viewBack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        viewBack.addGestureRecognizer(tapGesture)
        self.view.insertSubview(viewBack, at: 0)
    }
    @objc func overlayTapped() {
          self.dismiss(animated: true)
      }

    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionGig(_ sender: UIButton) {
        self.dismiss(animated: true)
        callBack?(true)
    }
    

    @IBAction func actionEdit(_ sender: UIButton) {
        self.dismiss(animated: true)
        callBack?(false)
       
    }
}
