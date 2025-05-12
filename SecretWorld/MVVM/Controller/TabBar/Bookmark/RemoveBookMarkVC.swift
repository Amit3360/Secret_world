//
//  RemoveBookMarkVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 02/01/24.
//

import UIKit

class RemoveBookMarkVC: UIViewController {

    @IBOutlet var viewBack: UIView!
    @IBOutlet var tblVw: UITableView!
    var callBack:((_ favourite:Bool)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = 20
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let nibNearBy = UINib(nibName: "ServicesNearByTVC", bundle: nil)
        tblVw.register(nibNearBy, forCellReuseIdentifier: "ServicesNearByTVC")
    }
    
    @IBAction func actionRemove(_ sender: UIButton) {
        self.dismiss(animated: true)
        callBack?(true)
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
        callBack?(false)
    }
    
}
//MARK: -UITableViewDelegate
extension RemoveBookMarkVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesNearByTVC", for: indexPath) as! ServicesNearByTVC
        cell.btnBookMark.isSelected = true
        cell.btnBookMark.isUserInteractionEnabled = true
          cell.viewShadow.layer.masksToBounds = false
          cell.viewShadow.layer.shadowColor = UIColor.black.cgColor
          cell.viewShadow.layer.shadowOpacity = 0.1
          cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
          cell.viewShadow.layer.shouldRasterize = true
          cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
           cell.viewShadow.layer.cornerRadius = 10
        cell.heighViewServiceNames.constant = 0
        cell.lblPrice.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
          return  120
        
    }
   
}
