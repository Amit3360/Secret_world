//
//  ServicesMoreOptionsVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/01/24.
//

import UIKit

class ServicesMoreOptionsVC: UIViewController {

    @IBOutlet var viewBack: UIView!
    var callBack:((_ isSelect:Bool)->())?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = 35
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
    @IBAction func actionDelete(_ sender: UIButton) {
            self.dismiss(animated: true)
            self.callBack?(false)
        
        
    }
    @IBAction func actionEdit(_ sender: UIButton) {
        self.dismiss(animated: true)
        callBack?(true)
    }
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    

}
