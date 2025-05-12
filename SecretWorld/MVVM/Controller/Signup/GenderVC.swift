//
//  GenderVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit

class GenderVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet var imgVwFemale: UIImageView!
    @IBOutlet var imgVwMale: UIImageView!
    @IBOutlet var imgVwOther: UIImageView!
    @IBOutlet var lblOthers: UILabel!
    @IBOutlet var lblMale: UILabel!
    @IBOutlet var lblFemale: UILabel!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnOthers: UIButton!
   
    var callBack:((_ gender:String?)->())?
    var selectedGender: String?
    var genderTxt: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        viewBackground.layer.cornerRadius = 35
        viewBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if genderTxt == lblFemale.text{
            btnFemale.isSelected = true
            imgVwFemale.image = UIImage(named: "selectedGender")
            imgVwMale.image = UIImage(named: "unSelect")
            imgVwOther.image = UIImage(named: "unSelect")
        }else if genderTxt == lblMale.text{
            btnMale.isSelected = true
            imgVwFemale.image = UIImage(named: "unSelect")
            imgVwMale.image = UIImage(named: "selectedGender")
            imgVwOther.image = UIImage(named: "unSelect")
        }else if genderTxt == lblOthers.text{
            btnOthers.isSelected = true
            imgVwFemale.image = UIImage(named: "unSelect")
            imgVwMale.image = UIImage(named: "unSelect")
            imgVwOther.image = UIImage(named: "selectedGender")
        }else{
            btnFemale.isSelected = false
            btnMale.isSelected = false
            btnOthers.isSelected = false
            imgVwFemale.image = UIImage(named: "unSelect")
            imgVwMale.image = UIImage(named: "unSelect")
            imgVwOther.image = UIImage(named: "unSelect")
        }
        if let selectedGender = selectedGender {
                    selectButtonForGender(selectedGender)
                }
        setupOverlayView()
    }
    func setupOverlayView() {
            viewBackground = UIView(frame: self.view.bounds)
        viewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
              let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        viewBackground.addGestureRecognizer(tapGesture)
              self.view.insertSubview(viewBackground, at: 0)
          }
        @objc func overlayTapped() {
              self.dismiss(animated: true)
          }
    //MARK: - Button Actions
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
   
    @IBAction func actionFemale(_ sender: UIButton) {
        selectButtonForGender(lblFemale.text ?? "")
    }
    @IBAction func actionMale(_ sender: UIButton) {
        selectButtonForGender(lblMale.text ?? "")
    }
    @IBAction func actionOthers(_ sender: UIButton) {
        selectButtonForGender(lblOthers.text ?? "")
    }
    func selectButtonForGender(_ gender: String?) {
            btnFemale.isSelected = (gender == lblFemale.text ?? "")
            btnMale.isSelected = (gender == lblMale.text ?? "")
            btnOthers.isSelected = (gender == lblOthers.text ?? "")
             
            selectedGender = gender
            self.dismiss(animated: true)
            self.callBack?(gender)
        }
}
