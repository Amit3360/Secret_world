//
//  SelectServiceTypeVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 02/01/24.
//

import UIKit
import SwiftMessages

class SelectServiceTypeVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet var imgVwMomentSelect: UIImageView!
    @IBOutlet var btnAddMomemnt: UIButton!
    @IBOutlet var viewAddMoment: UIView!
    @IBOutlet var viewAddgig: UIView!
    @IBOutlet var viewAddPopup: UIView!
    @IBOutlet var btnAddpopup: UIButton!
    @IBOutlet var viewBack: UIView!
    @IBOutlet var btnAddgig: UIButton!
    @IBOutlet var imgVwGig: UIImageView!
    @IBOutlet var imgVwPopup: UIImageView!

    //MARK: - VARIABLES
    var callBack: ((_ isComing:Int)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
        
    }
    //MARK: - FUNCTIONS
    func uiSet(){
        if Store.role == "user"{
            viewAddPopup.isHidden = false
            viewAddMoment.isHidden = false
            btnAddpopup.isSelected = true
        }else{
            viewAddPopup.isHidden = true
            viewAddMoment.isHidden = true
        }
        viewBack.layer.cornerRadius = 20
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imgVwMomentSelect.image = UIImage(named: "unSelect")
        imgVwGig.image = UIImage(named: "unSelect")
        imgVwPopup.image = UIImage(named: "selectedGender")
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
    //MARK: - BUTTON ACTIONS
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionAddMoment(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if btnAddMomemnt.isSelected == true{
            btnAddgig.isSelected = false
            btnAddpopup.isSelected = false
            imgVwGig.image = UIImage(named: "unSelect")
            imgVwPopup.image = UIImage(named: "unSelect")
            imgVwMomentSelect.image = UIImage(named: "selectedGender")
        }else{
            imgVwMomentSelect.image = UIImage(named: "unSelect")
        }
    }
    @IBAction func actionAddService(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if btnAddpopup.isSelected == true{
            btnAddgig.isSelected = false
            btnAddMomemnt.isSelected = false
            imgVwGig.image = UIImage(named: "unSelect")
            imgVwMomentSelect.image = UIImage(named: "unSelect")
            imgVwPopup.image = UIImage(named: "selectedGender")
        }else{
            imgVwPopup.image = UIImage(named: "unSelect")
        }
    }
    @IBAction func actionAddGig(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if btnAddgig.isSelected == true{
            btnAddpopup.isSelected = false
            btnAddMomemnt.isSelected = false
            imgVwMomentSelect.image = UIImage(named: "unSelect")
            imgVwGig.image = UIImage(named: "selectedGender")
            imgVwPopup.image = UIImage(named: "unSelect")
        }else{
            imgVwGig.image = UIImage(named: "unSelect")
        }
    }
    
    @IBAction func actionAdd(_ sender: UIButton) {
        Store.AddGigImage = nil
        Store.AddGigDetail = nil
        
        if btnAddpopup.isSelected {
            self.dismiss(animated: true) {
                self.callBack?(1) // popup
            }
        } else if btnAddgig.isSelected {
            self.dismiss(animated: true) {
                self.callBack?(2) // Gig
            }
        } else if btnAddMomemnt.isSelected {
            self.dismiss(animated: true) {
                self.callBack?(3) // Moment
            }
        } else {
            showSwiftyAlert("", "Select type", false)
        }
    }

}
