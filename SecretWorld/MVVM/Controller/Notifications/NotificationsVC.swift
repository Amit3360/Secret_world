//
//  NotificationsVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 26/12/23.
//

import UIKit

class NotificationsVC: UIViewController {

    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var tblVw: UITableView!

    var viewModel = NotificationVM()
    var arrNotification = [Notifications]()
    var notifications: [Date: [Notifications]] = [:]
    var dates: [Date] = []
    var currrentDate = ""
    var yesterDayDate = ""
    var isComingNotification = false
    var popUpId = ""
    var callBack:(()->())?
    var isCalling = false
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        tblVw.showsVerticalScrollIndicator = false
         //uiSet()
    }

    @objc func handleSwipe() {
        if isCalling{
            self.navigationController?.popViewController(animated: true)
            self.callBack?()
        }
    }
    func uiSet(){
        if isComingNotification == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
            vc.modalPresentationStyle = .overFullScreen
            vc.popupId = self.popUpId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
            let date = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MMM dd, yyyy"
            currrentDate = dateformatter.string(from: date)
            let calendar = Calendar.current
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: date) {
                let yesterdayString = dateformatter.string(from: yesterday)
                yesterDayDate = yesterdayString
            } else {
                print("Error: Could not calculate yesterday's date.")
            }
           
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblVw.addSubview(refreshControl)
        notificationsApi()
        }
    
    @objc func refresh(_ sender: AnyObject) {
        
        WebService.hideLoader()
        notificationsApi()
        refreshControl.endRefreshing()
    }

    func notificationsApi(){
    viewModel.getNotification { data in
        
        if data?.notifications?.count ?? 0 > 0 {
            self.lblNoData.isHidden = true
        } else {
            self.lblNoData.isHidden = false
        }
        
        self.arrNotification.removeAll()
        self.dates.removeAll()
        self.notifications.removeAll()
        self.arrNotification.append(contentsOf: data?.notifications ?? [])
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        for index in 0..<self.arrNotification.count {
            if let createdAt = self.arrNotification[index].createdAt,
               let date = dateFormatter.date(from: createdAt) {
                self.arrNotification[index].messageDate = date
            } else {
                print("Failed to convert the string to a Date.")
            }
            self.arrNotification[index].createdAt = self.convertTimestampToDateString(timestamp: self.arrNotification[index].createdAt ?? "")
        }
        
        self.arrNotification.sort { $0.messageDate ?? Date() > $1.messageDate ?? Date() }
        
        for message in self.arrNotification {
            let date = message.messageDate?.dateWithoutTime() ?? Date()
            if self.notifications[date] == nil {
                self.notifications[date] = []
                self.dates.append(date)
            }
            self.notifications[date]?.append(message)
        }
        self.dates.sort(by: { $0 > $1 })
        self.tblVw.estimatedRowHeight = 50
        self.tblVw.rowHeight = UITableView.automaticDimension
        self.tblVw.reloadData()
        self.isCalling = true
    }
}
        func convertTimestampToDateString(timestamp: String) -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            guard let date = dateFormatter.date(from: timestamp) else {
                return nil
            }
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
    
    @IBAction func actionBack(_ sender: UIButton) {
        if isCalling{
            //SceneDelegate().tabbarRoots(SelectedIndex: 3)
            self.navigationController?.popViewController(animated: true)
            self.callBack?()
        }
    }
    
    @IBAction func actionNotification(_ sender: UIButton) {
    }
    
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE

extension NotificationsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrNotification.count > 0 {
            return  dates.count
        }else{
            return 1
        }
        
    }
    
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrNotification.count > 0{
            let date = dates[section]
            return notifications[date]?.count ?? 0
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderNotificationsTVC") as! HeaderNotificationsTVC
        
        if arrNotification.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
     
            if dateFormatter.string(from: dates[section]) == currrentDate {
                headerCell.lblTime.text = "Today"
            } else if dateFormatter.string(from: dates[section]) == yesterDayDate {
                headerCell.lblTime.text = "Yesterday"
            } else {
               
               headerCell.lblTime.text = dateFormatter.string(from: dates[section])
            }
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath) as! NotificationsTVC
        let date = dates[indexPath.section]
        let notificationForDate = notifications[date]
        let notification = notificationForDate?[indexPath.row]
        let hightlight = notification?.highlights
        let message = notification?.message ?? ""
        
         cell.lblTitle.text = notification?.title ?? ""
    
        let wordsToHighlight = notification?.highlights?.compactMap { $0 } ?? []
        let fontSize: CGFloat = 14.0
        let fontColor = UIColor.black
        let highlightedMessage = highlightWords(in: message, wordsToHighlight: wordsToHighlight, fontSize: fontSize, fontColor: fontColor)
        cell.lblDescription.attributedText = highlightedMessage
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = dates[indexPath.section]
        let notificationForDate = notifications[date]
        let notification = notificationForDate?[indexPath.row]
        if notification?.status == "1"{
            if Store.userId == notification?.gigUser{
                
                if Store.role == "b_user"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailOwnerVC") as! TaskDetailOwnerVC
                    vc.gigId = notification?.gigId ?? ""
                    vc.isComing = 1
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailOwnerVC") as! TaskDetailOwnerVC
                    vc.gigId = notification?.gigId ?? ""
                    vc.isComing = 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                vc.gigId = notification?.gigId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if notification?.status == "2"{
            if Store.userId == notification?.popUpUser{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
                vc.popupId = notification?.popUpId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
                vc.popupId = notification?.popUpId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if notification?.status == "3"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
            vc.serviceId = notification?.serviceId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else if notification?.status == "4"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistoryVC") as! TransactionHistoryVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if notification?.status == "5"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if notification?.status == "6"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
            vc.businessId = notification?.businessId ?? ""
            Store.BusinessUserIdForReview = notification?.businessId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else if notification?.status == "7"{
            isAddFunds = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
            vc.isComing = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if notification?.status == "8"{
            if Store.UserDetail?["userId"] as? String ?? "" == notification?.momentUser ?? ""{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OwnerMomentDetailVC") as! OwnerMomentDetailVC
                vc.momentId = notification?.momentId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)

            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSideMomentDetailVC") as! UserSideMomentDetailVC
                vc.momentId = notification?.momentId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func highlightWords(in message: String, wordsToHighlight: [String], fontSize: CGFloat, fontColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: message)
        let boldFont = UIFont.boldSystemFont(ofSize: fontSize)
        
        for word in wordsToHighlight {
            let range = (message as NSString).range(of: word)
            if range.location != NSNotFound {
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: boldFont,
                    .foregroundColor: fontColor
                ]
                attributedString.addAttributes(attributes, range: range)
            }
        }
        
        return attributedString
    }
}
