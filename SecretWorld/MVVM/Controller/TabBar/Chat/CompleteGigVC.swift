//
//  CompleteGigVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 23/09/24.
//

import UIKit

class CompleteGigVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet var viewBack: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var btnMArkAsComplete: UIButton!
    
    //MARK: - VARIABLS
    
    var groupId = ""
    var callBack:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        viewBack.layer.cornerRadius = 35
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupOverlayView()
    }
    func setupOverlayView() {
        viewBack = UIView(frame: self.view.bounds)
    
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        viewBack.addGestureRecognizer(tapGesture)
          self.view.insertSubview(viewBack, at: 0)
      }
    @objc func overlayTapped() {
          self.dismiss(animated: true)
      }

    //MARK: - IBAction
    @IBAction func actionMArkAsComplete(_ sender: UIButton) {
        let param:parameters = ["gigId":Store.gigDetail?["gigId"] as? String ?? "","userId":Store.userId ?? "","deviceId":Store.deviceToken ?? "","groupId":self.groupId]
        SocketIOManager.sharedInstance.completedBy(dict: param)
        self.dismiss(animated: true)
        self.callBack?()
      
       
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
