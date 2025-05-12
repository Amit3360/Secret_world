//
//  AboutVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 23/12/23.
//

import UIKit
import FXExpandableLabel

class AboutVC: UIViewController, UIGestureRecognizerDelegate {
    //MARK: - OUTLETS
    @IBOutlet var lblOpeningTime: UILabel!
    @IBOutlet var viewServiceProvider: UIView!
    @IBOutlet var lblProviderName: UILabel!
    @IBOutlet var imgVwProvider: UIImageView!
    @IBOutlet var tblVwBusinessHour: UITableView!
    @IBOutlet weak var lblAbout: UILabel!
    
    //MARK: - VARIABLES
    var arrdays = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday","sunday"]
    var obj = [BusinessTimingModel]()
    var receiverId = ""
    var phoneNumber: Int?
    var textAbout = ""
    var isSeeMore = false
    var getDay:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
       
       
    }
    private func getCurrentDay() -> String {
        let date = Date() // Get the current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Format to get the full day name
        return dateFormatter.string(from: date).lowercased() // Convert to lowercase
    }

    private func uiSet(){
        let currentDay = getCurrentDay()
        getDay = currentDay
        print("Current day: \(currentDay)")
        
        let nib2 = UINib(nibName: "BusinessHourTVC", bundle: nil)
        tblVwBusinessHour.register(nib2, forCellReuseIdentifier: "BusinessHourTVC")

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("GetStoreServiceData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationUser(notification:)), name: Notification.Name("GetUserAbout"), object: nil)
        addTapGestureToLabel()
        obj = arrdays.map { day in
            BusinessTimingModel(day: day, starttime: "", endtime: "", status: "0")
        }
        
        if Store.role == "b_user"{
            viewServiceProvider.isHidden = true
        }else{
            viewServiceProvider.isHidden = false
            }
        
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
       
        lblAbout.numberOfLines = 5
        lblProviderName.text = Store.ServiceDetailData?.user?.name ?? ""
        
        imgVwProvider.imageLoad(imageUrl: Store.ServiceDetailData?.user?.profile_photo ?? "")
        self.receiverId = Store.ServiceDetailData?.user?.id ?? ""
//        lblAbout.text = Store.UserServiceDetailData?.getBusinessDetails?.about ?? ""
        for i in Store.ServiceDetailData?.service ?? []{
            self.textAbout = i.description ?? ""
            
            self.lblAbout.appendReadmore(after: self.textAbout, trailingContent: .readmore)
        }
        lblAbout.sizeToFit()
        print("Dataaaaaa-----",lblAbout.frame.size.height)
        
        Store.aboutHeight = lblAbout.frame.size.height
        openingHoursSetupBusiness()
        
    }
    private func openingHoursSetupBusiness() {

        for openingHour in Store.ServiceDetailData?.user?.openingHours ?? [] {
            let lowercaseDay = (openingHour.day ?? "").lowercased()
            if let index = arrdays.firstIndex(of: lowercaseDay) {
                obj[index] = BusinessTimingModel(day: lowercaseDay, starttime: openingHour.starttime ?? "", endtime: openingHour.endtime ?? "", status: "1")
            }
        }

        tblVwBusinessHour.reloadData()
    }
    
    @objc func methodOfReceivedNotificationUser(notification: Notification) {
        guard let businessDetail = Store.getBusinessDetail else { return }
        
        lblAbout.numberOfLines = 5
        self.receiverId = businessDetail.userID ?? ""
        phoneNumber = businessDetail.mobile ?? 0
        lblProviderName.text = businessDetail.name ?? ""
        imgVwProvider.imageLoad(imageUrl: businessDetail.profilePhoto ?? "")
        self.textAbout = businessDetail.about ?? ""
//        if isSeeMore == true{
//          
//            self.lblAbout.appendReadLess(after: self.textAbout, trailingContent: .readless)
//        }else{
            self.lblAbout.appendReadmore(after: self.textAbout, trailingContent: .readmore)
//        }
       
        self.lblAbout.sizeToFit()

        
        for openingHour in Store.getBusinessDetail?.openingHours ?? [] {
            if let index = arrdays.firstIndex(of: openingHour.day ?? "") {
                obj[index] = BusinessTimingModel(day: openingHour.day ?? "", starttime: openingHour.starttime ?? "", endtime: openingHour.endtime ?? "", status: "1")
                
            }
        }
//        for businessTiming in obj {
//            if businessTiming.day == getDay {
//                if businessTiming.starttime == ""{
//                    lblOpeningTime.text = "Closed today"
//                }else{
//                    let openTime = convertTo12HourFormat(businessTiming.endtime)
//                    lblOpeningTime.text = "Open till \(openTime)"
//                }
//                break
//            }
//        }
        tblVwBusinessHour.reloadData()

        
    }
    
    private func addTapGestureToLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblAbout.isUserInteractionEnabled = true
        lblAbout.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let text = lblAbout.text else { return }

              let readmore = (text as NSString).range(of: TrailingContent.readmore.text)
              let readless = (text as NSString).range(of: TrailingContent.readless.text)
              if gesture.didTap(label: lblAbout, inRange: readmore) {
                  lblAbout.appendReadLess(after: textAbout, trailingContent: .readless)
              } else if  gesture.didTap(label: lblAbout, inRange: readless) {
                  lblAbout.appendReadmore(after: textAbout, trailingContent: .readmore)
              } else { return }
        NotificationCenter.default.post(name: Notification.Name("UpdateAboutText"), object: nil)
    }
    
    @IBAction func actionServiceProviderProfile(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileVC") as! BusinessProfileVC
        vc.businessId = Store.getBusinessDetail?.id ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionMessage(_ sender: UIButton) {
        guard let businessDetail = Store.getBusinessDetail else { return }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
        vc.receiverId = Store.recevrID ?? ""
        vc.isAbout = true
        vc.typeId = businessDetail.id ?? ""
        vc.typeName = businessDetail.businessname ?? ""
        vc.chatType = "business"
        vc.callBack = {[weak self] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: Notification.Name("UpdateAboutText"), object: nil)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionCall(_ sender: UIButton) {
          isCall = true
          guard let number = phoneNumber else { return }
          let numberUrl = URL(string: "tel://\(number)")!
          if UIApplication.shared.canOpenURL(numberUrl) {
              UIApplication.shared.open(numberUrl)
          }
    }
}
//MARK: -UITableViewDelegate
extension AboutVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessHourTVC", for: indexPath) as! BusinessHourTVC
        let item = obj[indexPath.row]
        let isToday = getDay == item.day

        cell.lblday.text = isToday ? "Today" : item.day.capitalized
        let textColor = isToday ? UIColor.black : UIColor(hex: "#797979")
        cell.lblday.textColor = textColor
        cell.lblTime.textColor = textColor

        if item.status == "1" {
            cell.lblTime.text = "\(convertTo12HourFormat(item.starttime)) - \(convertTo12HourFormat(item.endtime))"
        } else {
            cell.lblTime.text = "Closed"
            cell.lblTime.textColor = UIColor(red: 1.0, green: 59.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0)
        }
        return cell
    }

   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
          return  35
        
    }
    
}
extension AboutVC {
    func convertTo12HourFormat(_ time24: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Optional: if your input is in UTC
        
        if let date24 = dateFormatter.date(from: time24) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a"
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            outputFormatter.timeZone = TimeZone.current // Convert to local time
            
            return outputFormatter.string(from: date24)
        }
        
        return ""
    }
}
