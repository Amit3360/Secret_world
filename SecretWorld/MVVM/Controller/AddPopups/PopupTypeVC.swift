//
//  PopupTypeVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 12/12/24.
//

import UIKit

class PopupTypeVC: UIViewController {

    @IBOutlet weak var tblVwCategory: UITableView!
  
    @IBOutlet weak var heightTableVw: NSLayoutConstraint!
    @IBOutlet var viewBack: UIView!
    
    var callBack:((_ type:Int?,_ category:String?)->())?
    var popUptype = 0
    var arrCategory = ["Food & Drinks","Services","Clothes / Fashion","Beauty / Self-Care","Low Key"]
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        viewBack.layer.cornerRadius = 35
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        heightTableVw.constant = 62 * 4
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
  
}

extension PopupTypeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupCategoryTVC", for: indexPath) as! PopupCategoryTVC
        cell.lblTitle.text = arrCategory[indexPath.row]
        if popUptype == indexPath.row+1{
            cell.imgVwSelect.image = UIImage(named: "selectedGender")
        }else{
            cell.imgVwSelect.image = UIImage(named: "unSelect")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popUptype = indexPath.row+1
        self.dismiss(animated: true)
        callBack?(indexPath.row+1,arrCategory[indexPath.row])
    }
}
