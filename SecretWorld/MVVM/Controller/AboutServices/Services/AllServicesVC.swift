//
//  AllServicesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 25/12/23.
//

import UIKit

class AllServicesVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet var vwBack: UIView!
    @IBOutlet var tblVwServices: UITableView!
    
    //MARK: - VARIABLES
    var callBack:((_ type:Int,_ serviceId:String)->())?
    var arrUserServices = [Allservicees]()
    var serviceId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        vwBack.layer.cornerRadius = 50
        vwBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let nibNearBy = UINib(nibName: "ServiceTVC", bundle: nil)
        tblVwServices.register(nibNearBy, forCellReuseIdentifier: "ServiceTVC")
        tblVwServices.showsVerticalScrollIndicator = false
        arrUserServices = Store.UserServiceDetailData?.allservices ?? []
        
        tblVwServices.reloadData()
        

    }
    //MARK: - BUTTON ACTIONS
    @IBAction func actionCross(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
   

}
//MARK: -UITableViewDelegate
extension AllServicesVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrUserServices.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTVC", for: indexPath) as! ServiceTVC
        
          cell.viewShadow.layer.masksToBounds = false
          cell.viewShadow.layer.shadowColor = UIColor.black.cgColor
          cell.viewShadow.layer.shadowOpacity = 0.1
          cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
          cell.viewShadow.layer.shouldRasterize = true
          cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
        cell.lblPrice.text = "$\(arrUserServices[indexPath.row].price ?? 0)"
        cell.lblUserName.text = Store.UserServiceDetailData?.getBusinessDetails?.name ?? ""
        cell.lblRating.text = "\(arrUserServices[indexPath.row].rating ?? 0)"
        cell.lblServiceName.text = arrUserServices[indexPath.row].serviceName
        cell.indexpath = indexPath.row
        cell.uiSet()
        if arrUserServices[indexPath.row].serviceImages?.count ?? 0 > 0{
            cell.imgVwService.imageLoad(imageUrl: arrUserServices[indexPath.row].serviceImages?[0] ?? "")
        }
        return cell
    }
    @objc func actionFavourite(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected != true{
            callBack?(1, arrUserServices[sender.tag].id ?? "")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
          return  120
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false)
        callBack?(2, arrUserServices[indexPath.row].id ?? "")
        
    }
    
}
