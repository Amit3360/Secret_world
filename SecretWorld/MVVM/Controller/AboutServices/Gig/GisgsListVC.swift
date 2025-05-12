//
//  GisgsListVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/12/23.
//
import UIKit
class GisgsListVC: UIViewController {
  
    @IBOutlet weak var lblTaskCount: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var heightTblVwTask: NSLayoutConstraint!
    @IBOutlet weak var tblVwTask: UITableView!
    @IBOutlet var lblNoData: UILabel!
   
    var arrGigList = [GigList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
    }
    func registerCell(){
        let nibNearBy = UINib(nibName: "GigNearByTVC", bundle: nil)
        tblVwTask.register(nibNearBy, forCellReuseIdentifier: "GigNearByTVC")
        tblVwTask.showsVerticalScrollIndicator = false
        tblVwTask.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("GetStoreServiceData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationUserSide(notification:)), name: Notification.Name("GetStoreUserServices"), object: nil)
        btnViewAll.underline()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateHeight()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       updateHeight()
      }
      func updateHeight(){
          let heightInterest = self.arrGigList.count*144
          
          if arrGigList.count > 0 {
              heightTblVwTask.constant = CGFloat(heightInterest)
              lblTaskCount.text = "(\(arrGigList.count))"
//              btnViewAll.isHidden = false
          }else{
              heightTblVwTask.constant = 257
              lblTaskCount.text = "(0)"
//              btnViewAll.isHidden = true
          }
   
        self.view.layoutIfNeeded()
      }
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        uiSet()
    }
    @objc func methodOfReceivedNotificationUserSide(notification: Notification) {
        
        uiSet()
    }
    func uiSet(){
            arrGigList = Store.UserServiceDetailData?.gigs ?? []
        
            if arrGigList.count > 0 {
                lblNoData.isHidden = true
            }else{
                lblNoData.isHidden = false
            }
        tblVwTask.reloadData()
            self.updateHeight()
    }
    @IBAction func actionviewAll(_ sender: UIButton) {
    }
}


//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension GisgsListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return arrGigList.count
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigNearByTVC", for: indexPath) as! GigNearByTVC
     
            if arrGigList.count > 0 {
                cell.lblName.text = arrGigList[indexPath.row].name
                cell.lblTitle.text = arrGigList[indexPath.row].title
                let value: Double = arrGigList[indexPath.row].price ?? 0
                let formattedValue = String(format: "%.2f", value)
                cell.lblPrice.text = "$\(formattedValue)"
                cell.lblAddress.text = arrGigList[indexPath.row].place ?? ""
                if arrGigList[indexPath.row].skills?.count ?? 0 > 1{
                    cell.leadingCategory.constant = 5
                }else{
                    cell.leadingCategory.constant = 10
                }
                let skills = arrGigList[indexPath.row].skills ?? []
                cell.arrCategory = skills
                cell.uiSet(load: true)
                
                if let formattedDate = convertToDateFormat(arrGigList[indexPath.row].startDate ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"dd MMM yyyy") {
                    cell.lblDate.text = formattedDate
                } else {
                    print("Invalid date format")
                }
                
                if let formattedTime = convertToDateFormat(arrGigList[indexPath.row].startDate ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"h a") {
                    cell.lblTime.text = formattedTime
                } else {
                    print("Invalid date format")
                }
                
                let rating = arrGigList[indexPath.row].UserRating ?? 0.0
                let formattedRating = String(format: "%.1f", rating)
                cell.lblRatingReview.text = formattedRating
                
                if let imageURL = arrGigList[indexPath.row].image, !imageURL.isEmpty {
                    cell.imgVwGig.imageLoad(imageUrl: imageURL)
                } else {
                    cell.imgVwGig.image = UIImage(named: "dummy")
                }
                
                cell.viewShadow.applyShadow()
            }
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
        Store.isUserParticipantsList = false
        vc.gigId = arrGigList[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func convertToDateFormat(_ dateString: String,dateFormat:String,convertFormat:String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = dateFormat
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = convertFormat
            outputFormatter.timeZone = TimeZone.current // Adjust as needed
            
            return outputFormatter.string(from: date)
        }
        return nil // Return nil if parsing fails
    }
}



