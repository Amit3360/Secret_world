//
//  ServicesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 23/12/23.
//

import UIKit

class ServicesVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var btnViewAll: UIButton!
    @IBOutlet var tblVwList: UITableView!
    @IBOutlet var lblServicesCount: UILabel!
       
    var arrServices = [Servicess]()
    var arrUserServices:ServiceDetailsData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibNearBy = UINib(nibName: "ServiceTVC", bundle: nil)
        tblVwList.register(nibNearBy, forCellReuseIdentifier: "ServiceTVC")
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("GetStoreServiceData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationUser(notification:)), name: Notification.Name("GetStoreUserServices"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tblVwList.reloadData()
    }
    @objc func methodOfReceivedNotificationUser(notification: Notification) {
        
        arrUserServices = Store.UserServiceDetailData
        getServiceDetail()
        tblVwList.reloadData()
        
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        userUISet()
    }
    func userUISet(){
        
        arrServices = Store.ServiceDetailData?.service ?? []
        
        getServiceDetail()
        
        tblVwList.reloadData()
    }
    func getServiceDetail(){
            
        if Store.role == "b_user"{
            btnViewAll.isHidden = true
            let serviceAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black
            ]
            let serviceText = NSAttributedString(string: "Service ", attributes: serviceAttributes)
            let countAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.app
            ]
        
            let countString = "(\(Store.ServiceDetailData?.service?.count ?? 0))"
            let countText = NSAttributedString(string: countString, attributes: countAttributes)
            let combinedString = NSMutableAttributedString()
            combinedString.append(serviceText)
            combinedString.append(countText)
            self.lblServicesCount.attributedText = combinedString
            
        }else{
            
            if arrUserServices?.allservices?.count ?? 0 > 0 {
                lblNoData.isHidden = true
                
                
                lblServicesCount.isHidden = false
                
             
                self.lblServicesCount.text = "(\(Store.UserServiceDetailData?.allservices?.count ?? 0))"
            }else{
                lblNoData.isHidden = false
                lblServicesCount.text = "(0)"
                lblServicesCount.isHidden = false
            }
            if arrUserServices?.allservices?.count ?? 0 > 10{
                btnViewAll.isHidden = false
            }else{
                btnViewAll.isHidden = true
            }
            
        }
        
    }
    //MARK: - BUTTON ACTIONS
    @IBAction func actionViewAll(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllServicesVC") as! AllServicesVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.callBack = {[weak self] type,serviceIddd in
                        guard let self = self else { return }
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
                vc.serviceId = serviceIddd
                self.navigationController?.pushViewController(vc, animated: true)
            
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func actnShare(_ sender: UIButton) {
        
    }
   

}
//MARK: - UITableViewDelegate
extension ServicesVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Store.role == "b_user"{
            return min(arrServices.count, 10)
        }else{
            return min(arrUserServices?.allservices?.count ?? 0, 10)
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTVC", for: indexPath) as! ServiceTVC
        
          cell.contentView.layer.masksToBounds = false
          cell.contentView.layer.shadowColor = UIColor.black.cgColor
          cell.contentView.layer.shadowOpacity = 0.1
          cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
          cell.contentView.layer.shouldRasterize = true
          cell.contentView.layer.rasterizationScale = UIScreen.main.scale

            cell.indexpath = indexPath.row
           cell.arrUserSubCategories = arrUserServices?.allservices?[indexPath.row].subcategories ?? []
        
            cell.uiSet()
            cell.lblPrice.text = "$\(arrUserServices?.allservices?[indexPath.row].actualPrice ?? 0)"
            cell.lblPrevPrice.text = "$\(arrUserServices?.allservices?[indexPath.row].price ?? 0)"
           cell.lblOff.text = "\(Int(arrUserServices?.allservices?[indexPath.row].discount ?? 0))% off"
           cell.lblUserName.text = arrUserServices?.allservices?[indexPath.row].serviceName ?? ""

            let rating = arrUserServices?.allservices?[indexPath.row].rating ?? 0.0
            let formattedRating = String(format: "%.1f", rating)
            cell.lblRating.text = formattedRating
            if arrUserServices?.allservices?[indexPath.row].serviceImages?.count ?? 0 > 0{
                cell.imgVwService.imageLoad(imageUrl: arrUserServices?.allservices?[indexPath.row].serviceImages?[0] ?? "")
            }
       // }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
            vc.serviceId = arrUserServices?.allservices?[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
