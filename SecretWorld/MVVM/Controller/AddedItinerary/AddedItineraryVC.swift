//
//  AddedItineraryVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 31/01/25.
//

import UIKit

class AddedItineraryVC: UIViewController {
    
    @IBOutlet weak var lblDataFound: UILabel!
    @IBOutlet weak var earningVw: UIView!
    @IBOutlet weak var heightEarningVw: NSLayoutConstraint!
    @IBOutlet weak var topEarningVw: NSLayoutConstraint!
    @IBOutlet weak var lblEarning: UILabel!
    @IBOutlet weak var tblVwItinerary: UITableView!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var heightBackgroundImg: NSLayoutConstraint!
    
    let deviceHasNotch = UIApplication.shared.hasNotch
    var date = ""
    var type = 0
    var viewModel = ItineraryVM()
    var arrItineries = [Itinerary]()
    var price = 0
    var callBack:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
    }
    
    func uiSet(){
        let nibReiew = UINib(nibName: "AddedItineraryTVC", bundle: nil)
        tblVwItinerary.register(nibReiew, forCellReuseIdentifier: "AddedItineraryTVC")
        let reminderTime = self.date
        tblVwItinerary.showsVerticalScrollIndicator = false
        tblVwItinerary.separatorStyle = .none
        if let formattedDate = convertToDateFormat(reminderTime, dateFormat: "yyyy-MM-dd", convertFormat: "MMM dd, yyyy") {
            lblDate.text = formattedDate
        } else {
            print("Invalid date format")
        }
        if deviceHasNotch{
            if UIDevice.current.hasDynamicIsland {
              
                heightBackgroundImg.constant = 212
            }else{
                
                heightBackgroundImg.constant = 212
            }
        }else{
           
            heightBackgroundImg.constant = 162
        }
        if type == 1{
            self.earningVw.isHidden = false
            self.topEarningVw.constant = 20
            self.heightEarningVw.constant = 50
        }else{
            self.earningVw.isHidden = true
            self.topEarningVw.constant = 0
            self.heightEarningVw.constant = 0
        }
        getItieriesApi(type: type)
    }
    
    private func getItieriesApi(type:Int){
      print("AuthKEy--",Store.authKey ?? "")
        self.price = 0
        viewModel.GetItineraryApi(type: type,date: date) { data in
            self.lblItemCount.text = "\(data?.items ?? 0) item"
            if data?.itineraries?.count ?? 0 > 0{
                self.lblDataFound.isHidden = true
            }else{
                self.lblDataFound.isHidden = false
            }
            self.arrItineries = data?.itineraries ?? []
            for i in data?.itineraries ?? []{
                self.price += Int(i.earning ?? 0.0)
            }
        self.lblEarning.text = "$\(self.price)"
            
        self.tblVwItinerary.reloadData()
    }
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
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.callBack?()
    }
    
}

extension AddedItineraryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type != 0{
            return arrItineries.count+1
        }else{
            return arrItineries.count
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddedItineraryTVC", for: indexPath) as! AddedItineraryTVC
        
        if type != 0 {
            if indexPath.row == 0 {
                if type == 1 {
                    cell.vwFirst.isHidden = true
                    cell.vwSecond.isHidden = false
                    cell.vwSecond.applyShadow()
                    cell.btnAddSecond.setImage(UIImage(named: "addItinerary"), for: .normal)
                    cell.imgVwMap.image = UIImage(named: "")
                } else {
                    cell.vwFirst.isHidden = false
                    cell.vwSecond.isHidden = true
                    cell.vwFirst.applyShadow()
                    cell.btnAddFirst.setImage(UIImage(named: "addItinerary"), for: .normal)
                }
                cell.lblAddNewFirst.textColor = UIColor(hex: "#A4A4A4")
                cell.lblTitle.textColor = UIColor(hex: "#A4A4A4")
                cell.lblLocation.textColor = UIColor(hex: "#A4A4A4")
                cell.lblEarning.textColor = UIColor(hex: "#A4A4A4")
                cell.lblAddNewSecond.textColor = UIColor(hex: "#A4A4A4")
                cell.lblRepeatFirst.textColor = UIColor(hex: "#A4A4A4")
                cell.lblTime.textColor = UIColor(hex: "#A4A4A4")
                cell.lblAddNewSecond.text = "Add New"
                cell.lblTitle.text = "Title"
                cell.lblLocation.text = "Location"
                cell.lblEarning.text = "Earning"
                cell.lblAddNewFirst.text = "Add New"
                cell.lblRepeatFirst.text = "Repeat"
                cell.lblTime.text = "Time"
            } else if indexPath.row - 1 < arrItineries.count {
                cell.imgVwMap.image = UIImage(named: "map2")
                cell.btnAddFirst.setImage(UIImage(named: "greenUntick"), for: .normal)
                cell.btnAddSecond.setImage(UIImage(named: "greenUntick"), for: .normal)
                cell.lblAddNewFirst.textColor = UIColor(hex: "#000000")
                cell.lblTitle.textColor = UIColor(hex: "#363636")
                cell.lblLocation.textColor = UIColor(hex: "#5A5A5A")
                cell.lblEarning.textColor = UIColor(hex: "#3E9C35")
                cell.lblAddNewSecond.textColor = UIColor(hex: "#363636")
                cell.lblRepeatFirst.textColor = UIColor(hex: "#5A5A5A")
                cell.lblTime.textColor = UIColor(hex: "#000000")
                let itinerary = arrItineries[indexPath.row - 1]
                
                if itinerary.type == 1 {
                    cell.vwFirst.isHidden = true
                    cell.vwSecond.isHidden = false
                    
                    if let formattedDate = convertToDateFormat(itinerary.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"hh:mm a") {
                        cell.lblAddNewSecond.text = formattedDate
                    } else {
                        print("Invalid date format")
                    }
                    cell.lblTitle.text = itinerary.title ?? ""
                    cell.lblLocation.text = itinerary.location ?? ""
                    cell.lblEarning.text = "$\(itinerary.earning ?? 0)"
                    cell.vwSecond.applyShadow()
                    if (itinerary.urgent ?? false){
                        cell.vwSecond.backgroundColor = UIColor(hex: "#FF5247").withAlphaComponent(0.1)
                    }else{
                        cell.vwSecond.backgroundColor = UIColor(hex: "#FFFFFF")
                    }
                } else {
                    cell.lblAddNewFirst.text = itinerary.title ?? ""
                    if let formattedDate = convertToDateFormat(itinerary.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",convertFormat:"hh:mm a") {
                        cell.lblTime.text = formattedDate
                    } else {
                        print("Invalid date format")
                    }
                    switch itinerary.itineraryRepeat ?? "" {
                    case "none":
                        cell.lblRepeatFirst.text = "Does not repeat"
                    case "daily":
                        cell.lblRepeatFirst.text = "Every day"
                    case "weekly":
                        cell.lblRepeatFirst.text = "Every week"
                    case "monthly":
                        cell.lblRepeatFirst.text = "Every month"
                    case "yearly":
                        cell.lblRepeatFirst.text = "Every Year"
                    default:
                        break
                    }
                    
                    cell.vwFirst.isHidden = false
                    cell.vwSecond.isHidden = true
                    if (itinerary.urgent ?? false){
                        cell.vwFirst.backgroundColor = UIColor(hex: "#FF5247").withAlphaComponent(0.1)
                    }else{
                        cell.vwFirst.backgroundColor = UIColor(hex: "#FFFFFF")
                    }
                    cell.vwFirst.applyShadow()
                }
            }
        } else {
            if indexPath.row < arrItineries.count {
                let itinerary = arrItineries[indexPath.row]
                cell.imgVwMap.image = UIImage(named: "map2")
                cell.btnAddFirst.setImage(UIImage(named: "greenUntick"), for: .normal)
                cell.btnAddSecond.setImage(UIImage(named: "greenUntick"), for: .normal)
                cell.lblAddNewFirst.textColor = UIColor(hex: "#000000")
                cell.lblTitle.textColor = UIColor(hex: "#363636")
                cell.lblLocation.textColor = UIColor(hex: "#5A5A5A")
                cell.lblEarning.textColor = UIColor(hex: "#3E9C35")
                cell.lblAddNewSecond.textColor = UIColor(hex: "#363636")
                cell.lblRepeatFirst.textColor = UIColor(hex: "#5A5A5A")
                cell.lblTime.textColor = UIColor(hex: "#000000")
                if itinerary.type == 1 {
                    cell.vwFirst.isHidden = true
                    cell.vwSecond.isHidden = false
                    
                    if let formattedDate = convertToDateFormat(itinerary.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",convertFormat:"hh:mm a") {
                        cell.lblAddNewSecond.text = formattedDate
                    } else {
                        print("Invalid date format")
                    }
                    cell.lblTitle.text = itinerary.title ?? ""
                    cell.lblLocation.text = itinerary.location ?? ""
                    cell.lblEarning.text = "$\(itinerary.earning ?? 0)"
                    cell.vwSecond.applyShadow()
                    if (itinerary.urgent ?? false){
                        cell.vwSecond.backgroundColor = UIColor(hex: "#FF5247").withAlphaComponent(0.1)
                    }else{
                        cell.vwSecond.backgroundColor = UIColor(hex: "#FFFFFF")
                    }
                } else {
                    cell.lblAddNewFirst.text = itinerary.title ?? ""
                  
                    if let formattedDate = convertToDateFormat(itinerary.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",convertFormat:"hh:mm a") {
                        cell.lblTime.text = formattedDate
                    } else {
                        print("Invalid date format")
                    }
                    switch itinerary.itineraryRepeat ?? "" {
                    case "none":
                        cell.lblRepeatFirst.text = "Does not repeat"
                    case "daily":
                        cell.lblRepeatFirst.text = "Every day"
                    case "weekly":
                        cell.lblRepeatFirst.text = "Every week"
                    case "monthly":
                        cell.lblRepeatFirst.text = "Every month"
                    case "yearly":
                        cell.lblRepeatFirst.text = "Every Year"
                    default:
                        break
                    }

                    cell.vwFirst.isHidden = false
                    cell.vwSecond.isHidden = true
                    if (itinerary.urgent ?? false){
                        cell.vwFirst.backgroundColor = UIColor(hex: "#FF5247").withAlphaComponent(0.1)
                    }else{
                        cell.vwFirst.backgroundColor = UIColor(hex: "#FFFFFF")
                    }
                    cell.vwFirst.applyShadow()
                }
            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type != 0 {
            if indexPath.row != 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "viewItineraryVC") as! viewItineraryVC
                vc.itineraryDetail = arrItineries[indexPath.row-1]

                // Check if indexPath.row + 1 is within bounds
                if indexPath.row - 1 < arrItineries.count {
                    vc.type = arrItineries[indexPath.row - 1].type ?? 0
                } else {
                    vc.type = arrItineries[indexPath.row - 1].type ?? 0 // Use current row instead
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddItineryVC") as! AddItineryVC
                if self.type == 1{
                    vc.isPersonal = false
                }else{
                    vc.isPersonal = true
                }
                vc.isComing = false
                vc.callBack = { (type,message) in
//                    self.type = type
                    showSwiftyAlert("", message ?? "", true)
                    self.arrItineries.removeAll()
                    self.getItieriesApi(type: self.type)
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "viewItineraryVC") as! viewItineraryVC
            vc.itineraryDetail = arrItineries[indexPath.row]
            vc.type = arrItineries[indexPath.row].type ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if type != 0 {
            if indexPath.row == 0 {
                return nil
            }

            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
                print("delete", indexPath.row-1)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelGigVC") as! CancelGigVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 5
                vc.callBack = { (message) in
                    showSwiftyAlert("", message ?? "", true)
                    self.getItieriesApi(type: self.type)
                }
                vc.itineraryId = self.arrItineries[indexPath.row-1].id ?? ""
//                vc.date = self.date
                self.navigationController?.present(vc, animated: false)
                guard indexPath.row < self.arrItineries.count else {
                    completionHandler(false)
                    return
                }
                completionHandler(true)
            }
            
            deleteAction.image = UIImage(named: "whiteDelete")
            deleteAction.backgroundColor = UIColor(hex: "#FF0408")
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }else{
          
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelGigVC") as! CancelGigVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 5
                vc.callBack = { (message) in
                    showSwiftyAlert("", message ?? "", true)
                    self.getItieriesApi(type: self.type)
                }
                vc.itineraryId = self.arrItineries[indexPath.row].id ?? ""
//                vc.date = self.date
                self.navigationController?.present(vc, animated: false)
                guard indexPath.row < self.arrItineries.count else {
                    completionHandler(false)
                    return
                }
                completionHandler(true)
            }
            
            deleteAction.image = UIImage(named: "whiteDelete")
            deleteAction.backgroundColor = UIColor(hex: "#FF0408")
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
       
    }

    // Leading Swipe Actions (Left side)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
        if type != 0 {
            if indexPath.row == 0 {
                return nil
            }

            let pinAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddItineryVC") as! AddItineryVC
                if self.arrItineries[indexPath.row-1].type == 1{
                    vc.isPersonal = false
                }else{
                    vc.isPersonal = true
                }
                vc.itineraryDetail = self.arrItineries[indexPath.row-1]
                vc.isComing = true
                vc.callBack = { (type,message) in
//                    self.type = type
                    showSwiftyAlert("", message ?? "", true)
                    self.arrItineries.removeAll()
                    self.getItieriesApi(type: self.type)
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
                guard indexPath.row < self.arrItineries.count else {
                    completionHandler(false)
                    return
                }
                completionHandler(true)
            }
            pinAction.image = UIImage(named: "whiteEdit")
            pinAction.backgroundColor = UIColor(hex: "#00FF3A")

            return UISwipeActionsConfiguration(actions: [pinAction])
        }else{
          
            let pinAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddItineryVC") as! AddItineryVC
                if self.arrItineries[indexPath.row].type == 1{
                    vc.isPersonal = false
                }else{
                    vc.isPersonal = true
                }
                vc.isComing = true
                vc.itineraryDetail = self.arrItineries[indexPath.row]
                vc.callBack = { (type,message) in
//                    self.type = type
                    showSwiftyAlert("", message ?? "", true)
                    self.arrItineries.removeAll()
                    self.getItieriesApi(type: self.type)
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
                guard indexPath.row < self.arrItineries.count else {
                    completionHandler(false)
                    return
                }
                completionHandler(true)
            }
            pinAction.image = UIImage(named: "whiteEdit")
            pinAction.backgroundColor = UIColor(hex: "#00FF3A")

            return UISwipeActionsConfiguration(actions: [pinAction])
        }
    }
}
