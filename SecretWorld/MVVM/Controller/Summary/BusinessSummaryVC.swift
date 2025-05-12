//
//  BusinessSummaryVC.swift
//  SecretWorld
//
//  Created by meet sharma on 10/04/25.
//

import UIKit

class BusinessSummaryVC: UIViewController {

    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var tblVwService: UITableView!
 
    @IBOutlet weak var lblServiceCount: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgVwVerify: UIImageView!
    @IBOutlet weak var imgVwBronze: UIImageView!
    @IBOutlet weak var imgVwBusiness: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var widthCategory: NSLayoutConstraint!
    @IBOutlet weak var vwCategory: UIView!
    
    var viewModelExplore = ExploreVM()
    var arrUserServiceDetail:ServiceDetailsData?
    var businessId:String = ""
    var getDay:String?
    var arrUserServices = [Allservicees]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSet()
    }
    func uiSet(){
        let nibNearBy = UINib(nibName: "ServiceTVC", bundle: nil)
        tblVwService.register(nibNearBy, forCellReuseIdentifier: "ServiceTVC")
        let currentDay = getCurrentDay()
        getDay = currentDay
        print("Current day: \(currentDay)")
        getServiceDetailApiUserSide()
    }
    
    func getServiceDetailApiUserSide(){
        
        viewModelExplore.GetUserServiceDetailApi(user_id: businessId, loader: true) { data in
            
            if let rating = data?.getBusinessDetails?.ratingCount {
                if rating >= 4 {
                    self.imgVwBronze.isHidden = false
              
                } else {
                    self.imgVwBronze.isHidden = true
                }
            }
            if data?.getBusinessDetails?.isVerified ?? false{
                self.imgVwVerify.isHidden = false
            }else{
                self.imgVwVerify.isHidden = true
            }
            if data?.getBusinessDetails?.category == 1{
                self.lblCategoryName.text = "Restaurants"
            }else if data?.getBusinessDetails?.category == 2{
                self.lblCategoryName.text = "Clothing/fashion"
            }else if data?.getBusinessDetails?.category  == 3{
                self.lblCategoryName.text = "Tech/electronics"
            }else  if data?.getBusinessDetails?.category == 4{
                self.lblCategoryName.text = "Grocery"
            }else  if data?.getBusinessDetails?.category == 5{
                self.lblCategoryName.text = "Fitness"
            }else  if data?.getBusinessDetails?.category == 6{
                self.lblCategoryName.text = "Entertainment"
            }else{
                self.lblCategoryName.text = "Other"
            }
            
       
        self.lblBusinessName.text = data?.getBusinessDetails?.businessname ?? ""
        self.lblAddress.text = data?.getBusinessDetails?.place ?? ""
            self.imgVwBusiness.imageLoad(imageUrl: data?.getBusinessDetails?.profilePhoto ?? "")
        let arrCount = data?.allservices?.count ?? 0
        let count = CGFloat(arrCount * 120)
       
            let number = data?.getBusinessDetails?.rating ?? 0
            let formattedString = String(format: "%.1f", number) // "4.3"
            let formattedNumber = Double(formattedString) ?? 4.3
            self.lblRating.text = "\(formattedNumber)"
            self.lblServiceCount.text = "(\(data?.allservices?.count ?? 0))"
            self.arrUserServices = data?.allservices ?? []
            self.tblVwService.reloadData()
            for businessTiming in data?.getBusinessDetails?.openingHours ?? [] {
                
                if businessTiming.day == self.getDay {
                    if businessTiming.starttime == ""{
                        self.lblDate.text = "Closed"
                    }else{
                        let openTime = self.convertTo12HourFormat(businessTiming.endtime ?? "")
                        self.lblDate.text = "Open till \(openTime)"
                    }
                    break
                }else{
                    self.lblDate.text = "Closed"
                }
            }
      }
     
    }
    func getCurrentDay() -> String {
       let date = Date() // Get the current date
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "EEEE" // Format to get the full day name
       return dateFormatter.string(from: date).lowercased() // Convert to lowercase
   }
    
  
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension BusinessSummaryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return min(arrUserServices.count, 10)
        
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
           cell.arrUserSubCategories = arrUserServices[indexPath.row].subcategories ?? []
        
            cell.uiSet()
            cell.lblPrice.text = "$\(arrUserServices[indexPath.row].actualPrice ?? 0)"
            cell.lblPrevPrice.text = "$\(arrUserServices[indexPath.row].price ?? 0)"
           cell.lblOff.text = "\(Int(arrUserServices[indexPath.row].discount ?? 0))% off"
           cell.lblUserName.text = arrUserServices[indexPath.row].serviceName ?? ""

            let rating = arrUserServices[indexPath.row].rating ?? 0.0
            let formattedRating = String(format: "%.1f", rating)
            cell.lblRating.text = formattedRating
            if arrUserServices[indexPath.row].serviceImages?.count ?? 0 > 0{
                cell.imgVwService.imageLoad(imageUrl: arrUserServices[indexPath.row].serviceImages?[0] ?? "")
            }
       // }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
            vc.serviceId = arrUserServices[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension BusinessSummaryVC {
    func convertTo12HourFormat(_ time24: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let date24 = dateFormatter.date(from: time24) {
            dateFormatter.dateFormat = "h:mm a"
            let time12 = dateFormatter.string(from: date24)
            return time12
        }
        
        return ""
    }
}
