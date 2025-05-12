//
//  GigChatVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 20/09/24.
//

import UIKit
import IQKeyboardManagerSwift
import QBImagePickerController
import SDWebImage

class GigChatVC: UIViewController {

    //MARK: - OUTLETS
    
    @IBOutlet var btnTaskComplete: UIButton!
    @IBOutlet var viewPrivateProfile: UIView!
    @IBOutlet var heightViewPrivateComplete: NSLayoutConstraint!
    @IBOutlet var btnPrivate: UIButton!
    @IBOutlet var imgVwPrivateBtn: UIImageView!
    @IBOutlet weak var vwSendMessage: UIView!
    @IBOutlet weak var lblGrouptitle: UILabel!
    @IBOutlet weak var topGroupTitle: NSLayoutConstraint!
    @IBOutlet weak var btmStackVw: NSLayoutConstraint!
    @IBOutlet weak var tblVwMessage: UITableView!
    @IBOutlet weak var txtVwMessage: IQTextView!
    @IBOutlet weak var btnReady: UIButton!
//    @IBOutlet weak var lblGigTitle: UILabel!
//    @IBOutlet weak var lblGigName: UILabel!
//    @IBOutlet weak var btnMore: UIButton!
//    @IBOutlet weak var topGigName: NSLayoutConstraint!
//    @IBOutlet weak var heightGigDetailVw: NSLayoutConstraint!
    @IBOutlet weak var chatVw: UIView!
    //@IBOutlet weak var imgVwGig: UIImageView!
    @IBOutlet weak var lblGigComplete: UILabel!
    
    //MARK: - VARIABLES
    var gigDetaill:FilteredItem?
    var arrGroupMessages = [GroupChatDetail]()
    var dates: [Date] = []
    var groupedChatMessages: [Date: [GroupChatDetail]] = [:]
    var currrentDate = ""
    var yesterDayDate = ""
    var arrImage = [Any]()
    let imagePickerController = UIImagePickerController()
    var viewModel = UploadImageVM()
    var groupId = ""
    var hideProfile = 0
    var groupChatDetail:GroupChatDetail?
    var callBack: ((_ isBack:Bool)->())?
    var callBackViewImg:((_ arrImg:[String],_ index:Int)->())?
    var gigUserId = ""
    var gigId = ""
    
    //MARK: - LIFECYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
   
    override func viewWillAppear(_ animated: Bool) {
        uiSet()
        getGigChat()
        gigDetail()
    }
    
    //MARK: - FUNCTIONS
    
    func uiSet() {
        
        if hideProfile == 1{
            self.btnPrivate.isSelected = true
            imgVwPrivateBtn.image = UIImage(named:"privateOn")
        }else{
            self.btnPrivate.isSelected = false
            imgVwPrivateBtn.image = UIImage(named:"privateOff")
        }

        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy"
        currrentDate = dateformatter.string(from: date)
        
        imagePickerController.delegate = self
        
        let calendar = Calendar.current
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let yesterdayString = dateFormatter.string(from: yesterday)
            yesterDayDate = yesterdayString
        } else {
            print("Error: Could not calculate yesterday's date.")
        }
        // Create a CATransition animation for the slide effect
        keyboardHandling()
   
        let deviceHasNotch = UIApplication.shared.hasNotch
        if deviceHasNotch {
            print("This device has a notch.")
           // topGigName.constant = 50
           // heightGigDetailVw.constant = 110
            btmStackVw.constant = 30
        } else {
            //topGigName.constant = 30
           // heightGigDetailVw.constant = 90
            btmStackVw.constant = 10
         
            print("This device does not have a notch.")
            
        }
        // Set shadow properties

        gigChatDetail()
        getSendMessageData()
    }
    
    func gigDetail() {
        
        if Store.GigChatDetail?.count ?? 0 > 0 {
            
            self.groupChatDetail = Store.GigChatDetail?[0].groupChatDetails?[0]
            self.hideProfile = Store.GigChatDetail?[0].profileHide ?? 0
            self.groupId = Store.GigChatDetail?[0].groupChatDetails?[0].group?.id ?? ""
            
            // Toggle ready button visibility
            if Store.GigChatDetail?[0].isReady == 1 {
                
                if Store.GigChatDetail?[0].completeGig == 1{
                    self.heightViewPrivateComplete.constant = 60
                    self.btnTaskComplete.isHidden = true
                    self.viewPrivateProfile.isHidden = true
                   // self.btnMore.isHidden = true
                   // self.btnReady.isHidden = true
                    self.vwSendMessage.isHidden = true
                    self.lblGigComplete.isHidden = false
                }else{
                    self.heightViewPrivateComplete.constant = 100
                    self.btnTaskComplete.isHidden = false
                    self.viewPrivateProfile.isHidden = false

                    self.lblGigComplete.isHidden = true
                    //self.btnReady.isHidden = true
                    self.vwSendMessage.isHidden = false
                    if Store.role == "user"{
                        
                        if Store.UserDetail?["userId"] as? String ?? "" == gigUserId{
                            self.heightViewPrivateComplete.constant = 60
                            self.btnTaskComplete.isHidden = true
                            self.viewPrivateProfile.isHidden = true

                            //self.btnMore.isHidden = true
                        }else{
                            self.heightViewPrivateComplete.constant = 100
                            self.btnTaskComplete.isHidden = false
                            self.viewPrivateProfile.isHidden = false

                            //self.btnMore.isHidden = false
                        }
                    }else{
                        if Store.BusinessUserDetail?["userId"] as? String ?? "" == gigUserId{
                           // self.btnMore.isHidden = true
                            self.heightViewPrivateComplete.constant = 60
                            self.btnTaskComplete.isHidden = true
                            self.viewPrivateProfile.isHidden = true

                        }else{
                            self.heightViewPrivateComplete.constant = 60
                            self.btnTaskComplete.isHidden = true
                            self.viewPrivateProfile.isHidden = true

                            //self.btnMore.isHidden = false
                        }
                    }
                }
            } else {
                
                if Store.GigChatDetail?[0].completeGig == 1{
                    self.btnTaskComplete.isHidden = true
                    self.viewPrivateProfile.isHidden = true
                    self.heightViewPrivateComplete.constant = 60
                //self.btnMore.isHidden = true
               // self.btnReady.isHidden = true
                    self.vwSendMessage.isHidden = true
                    
                self.lblGigComplete.isHidden = false
                }else{
                    
                    self.lblGigComplete.isHidden = true
                    if Store.role == "user"{
                        
                        if Store.UserDetail?["userId"] as? String ?? "" == gigUserId{
                            self.btnTaskComplete.isHidden = true
                            self.viewPrivateProfile.isHidden = true
                            self.heightViewPrivateComplete.constant = 60

                            //self.btnMore.isHidden = true
                            //self.btnReady.isHidden = true
                            self.vwSendMessage.isHidden = false
                        }else{
                            self.btnTaskComplete.isHidden = false
                            self.viewPrivateProfile.isHidden = false
                            self.heightViewPrivateComplete.constant = 100

                            //self.btnMore.isHidden = true
                           // self.btnReady.isHidden = false
                            self.vwSendMessage.isHidden = false
                        }
                    }else{
                        if Store.BusinessUserDetail?["userId"] as? String ?? "" == gigUserId{
                            self.btnTaskComplete.isHidden = true
                            self.viewPrivateProfile.isHidden = true
                            self.heightViewPrivateComplete.constant = 60

                            //self.btnMore.isHidden = true
                            //self.btnReady.isHidden = true
                            self.vwSendMessage.isHidden = false
                        }else{
                            self.btnTaskComplete.isHidden = true
                            self.viewPrivateProfile.isHidden = true
                            self.heightViewPrivateComplete.constant = 60

                           // self.btnMore.isHidden = true
                            //self.btnReady.isHidden = false
                            self.vwSendMessage.isHidden = false
                        }
                    }
                }
            }
            
            // Set labels and image
           // self.lblGigName.text = Store.GigChatDetail?[0].groupChatDetails?[0].group?.name ?? ""
           // self.lblGigTitle.text = "Group Chat"
           // self.imgVwGig.imageLoad(imageUrl: Store.GigChatDetail?[0].groupChatDetails?[0].gig?.image ?? "")
            
            // Adjust group title visibility
            if Store.GigChatDetail?.count == 1 {
                self.lblGrouptitle.text = "\(Store.GigChatDetail?[0].groupChatDetails?[0].gig?.title ?? "") Group has been created"
                self.topGroupTitle.constant = 20
            } else {
                self.lblGrouptitle.text = ""
                self.topGroupTitle.constant = 0
            }
            
            // Clear existing messages to avoid duplicates
            self.arrGroupMessages.removeAll()
            
            // Append new messages
            if let groupChatDetails = Store.GigChatDetail?[0].groupChatDetails {
                self.arrGroupMessages.append(contentsOf: groupChatDetails)
            }
            
            if self.arrGroupMessages.count > 0 {
                self.arrGroupMessages.remove(at: self.arrGroupMessages.count - 1) // If needed, otherwise remove this
            }
            
            for index in 0..<self.arrGroupMessages.count {
                if let createdAt = self.arrGroupMessages[index].createdAt {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    if let date = dateFormatter.date(from: createdAt) {
                        self.arrGroupMessages[index].messageDate = date
                    } else {
                        print("Failed to convert the string to a Date.")
                    }
                    self.arrGroupMessages[index].createdAt = self.convertTimestampToDateString(timestamp: createdAt)
                }
            }
            
            self.arrGroupMessages.sort { $0.messageDate ?? Date() < $1.messageDate ?? Date() }
            
            // Group messages by date
            self.dates.removeAll() // Clear the dates to avoid duplication
            self.groupedChatMessages.removeAll() // Clear grouped messages
            
            for message in self.arrGroupMessages {
                let date = message.messageDate?.dateWithoutTime()
                if self.groupedChatMessages[date ?? Date()] == nil {
                    self.groupedChatMessages[date ?? Date()] = []
                    self.dates.append(date ?? Date())
                }
                self.groupedChatMessages[date ?? Date()]?.append(message)
            }
            
            self.tblVwMessage.reloadData()
            
            self.tblVwMessage.estimatedRowHeight = 50
            self.tblVwMessage.rowHeight = UITableView.automaticDimension
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                self.tblVwMessage.scrollToBottom(animated: true)
            }
        }
    }
    
    func getGigChat(){
        let param:parameters = ["gigId":self.gigId,"senderId":Store.userId ?? "","isOpen":true,"deviceId":Store.deviceToken ?? ""]
        SocketIOManager.sharedInstance.getGroupChat(dict: param)
     
    }
    func gigChatDetail() {
        
        SocketIOManager.sharedInstance.groupData = { data in
            // Ensure GigChatDetail is initialized properly
            Store.GigChatDetail?.removeAll()
            Store.GigChatDetail = data ?? []
            
            let id = data?[0].groupChatDetails?[0].gig?._id ?? ""
            print("Id---------",id,self.gigId)
            if self.gigId == id {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    self.gigDetail()
                    
                }
            }
        }
    }
    func getSendMessageData(){
       
            SocketIOManager.sharedInstance.sendMessageData = {
                self.getGigChat()
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
    
    //MARK: - ACTIONS
    @IBAction func actionPrivateProfile(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            
            imgVwPrivateBtn.image = UIImage(named:"privateOn")
            let param:parameters = ["gigId":self.gigId,"userId":Store.userId ?? "","profileHide":1,"deviceId":Store.deviceToken ?? ""]
            print(param)
            
            SocketIOManager.sharedInstance.hideProfile(dict: param)
            
        }else{
            
            imgVwPrivateBtn.image = UIImage(named:"privateOff")
            let param:parameters = ["gigId":self.gigId,"userId":Store.userId ?? "","profileHide":0,"deviceId":Store.deviceToken ?? ""]
            print(param)
            
            SocketIOManager.sharedInstance.hideProfile(dict: param)
            
        }

    }
    @IBAction func actionComplete(_ sender: UIButton) {
        let param:parameters = ["gigId":gigId,"userId":Store.userId ?? "","deviceId":Store.deviceToken ?? "","groupId":self.groupId]
        SocketIOManager.sharedInstance.completedBy(dict: param)

        self.dismiss(animated: true)
        callBack?(false)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
//        vc.modalPresentationStyle = .overFullScreen
//        vc.isSelect = 17
//        vc.callBack = {
////            self.getGigChat()
////           // self.btnMore.isHidden = true
////            self.vwSendMessage.isHidden = true
////           // self.btnReady.isHidden = true
////            self.lblGigComplete.isHidden = false
//        }
//        self.navigationController?.present(vc, animated: true)

//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteGigVC") as! CompleteGigVC
//        vc.modalPresentationStyle = .overFullScreen
//        vc.groupId = self.groupId
//        vc.callBack = {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
//            vc.modalPresentationStyle = .overFullScreen
//            vc.isSelect = 17
//            vc.callBack = {
//                self.getGigChat()
//               // self.btnMore.isHidden = true
//                self.vwSendMessage.isHidden = true
//               // self.btnReady.isHidden = true
//                self.lblGigComplete.isHidden = false
//            }
//            self.navigationController?.present(vc, animated: true)
//            
//        }
//        self.navigationController?.present(vc, animated: false)

       
    }

    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        callBack?(true)
    }
    @IBAction func actionCrossBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionMore(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigSettingVC") as! GigSettingVC
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = { [weak self] index in
            guard let self = self else { return }
            if index == 0{
               
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteGigVC") as! CompleteGigVC
                vc.modalPresentationStyle = .overFullScreen
                vc.groupId = self.groupId
                vc.callBack = {[weak self] in
                    guard let self = self else { return }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.isSelect = 17
                    vc.callBack = {[weak self] in
                        guard let self = self else { return }
                        self.getGigChat()
                        //self.btnMore.isHidden = true
                        self.vwSendMessage.isHidden = true
                        //self.btnReady.isHidden = true
                        self.lblGigComplete.isHidden = false
                    }
                    self.navigationController?.present(vc, animated: true)
                    
                }
                self.navigationController?.present(vc, animated: false)
            }else{
               
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatInfoVC") as! ChatInfoVC
                vc.groupChatDetail = self.groupChatDetail
                vc.hideProfile = self.hideProfile
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: false)
            }
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func actionReady(_ sender: UIButton) {
        let param:parameters = ["userId":Store.userId ?? "","deviceId":Store.deviceToken ?? "","gigId":self.gigId]
        print("param--",param)
        SocketIOManager.sharedInstance.readyUser(dict: param)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            if Store.role == "user"{
                let param2 = ["senderId":Store.userId ?? "","groupId":self.groupId,"message":"\(Store.UserDetail?["userName"] as? String ?? "") is ready","deviceId":Store.deviceToken ?? "","gigId":self.gigId]
                SocketIOManager.sharedInstance.sendMessage(dict: param2)
            }else{
                let param2 = ["senderId":Store.userId ?? "","groupId":self.groupId,"message":"\(Store.BusinessUserDetail?["userName"] as? String ?? "") is ready","deviceId":Store.deviceToken ?? "","gigId":self.gigId]
                SocketIOManager.sharedInstance.sendMessage(dict: param2)
            }
            
        }
        
    }
    @IBAction func actionSend(_ sender: UIButton) {
        let trimmedText = txtVwMessage.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText == ""{
            self.txtVwMessage.resignFirstResponder()

        }else{
            let param = ["senderId":Store.userId ?? "","groupId":self.groupId,"message":txtVwMessage.text ?? "","deviceId":Store.deviceToken ?? "","gigId":self.gigId]
            SocketIOManager.sharedInstance.sendMessage(dict: param)
            self.txtVwMessage.text = ""
            self.txtVwMessage.resignFirstResponder()
            
        }
       
    }
    
    @IBAction func actionSeeAllParticipant(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigUsersVC") as! GigUsersVC
        vc.gigId = self.gigId
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func actionUpload(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose an option", message: "", preferredStyle: .actionSheet)
           
           let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
               self.openCamera()
           }
           
           let galleryAction = UIAlertAction(title: "Upload From Gallary", style: .default) { _ in
               self.openGallery()
           }
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           
           alertController.addAction(cameraAction)
           alertController.addAction(galleryAction)
           alertController.addAction(cancelAction)
           
           // For iPad support
           alertController.popoverPresentationController?.sourceView = sender
           alertController.popoverPresentationController?.sourceRect = sender.bounds
           
           self.present(alertController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.modalPresentationStyle = .overFullScreen 
            present(imagePickerController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Camera not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // Updated gallery handling
       func openGallery() {
           let imagePickerController = QBImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.allowsMultipleSelection = true
           imagePickerController.mediaType = .any
           present(imagePickerController, animated: true, completion: nil)
       }
    
}

//MARK: - UITABLEVIEW DELEGATE AND DATESOURCE

extension GigChatVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
    
            if arrGroupMessages.count > 0 {
                return  dates.count
                
            }else{
                return 1
            }
       
       
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            if arrGroupMessages.count > 0{
                let date = dates[section]
                return groupedChatMessages[date]?.count ?? 0
            }else{
                return 0
            }
       
    }
    
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTimingTVC") as! ChatTimingTVC
   
            if arrGroupMessages.count > 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
         
                if dateFormatter.string(from: dates[section]) == currrentDate {
                    cell.lblTiming.text = "Today"
                } else if dateFormatter.string(from: dates[section]) == yesterDayDate {
                    cell.lblTiming.text = "Yesterday"
                } else {
                   
                   cell.lblTiming.text = dateFormatter.string(from: dates[section])
                }
            }

            return cell
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let date = dates[indexPath.section]
        let messagesForDate = groupedChatMessages[date]
        let message = messagesForDate?[indexPath.row]
        if message?.media?.count ?? 0 == 0{
            
            if message?.sender?.id == Store.userId {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTVC", for: indexPath) as! SenderTVC
                
                cell.lblMessage.text = message?.message ?? ""
                cell.lblName.text = "You"
                if  message?.sender?.name ?? "" == "Private User"{
                    if Store.role == "user"{
//                        cell.lblName.text = Store.UserDetail?["userName"] as? String ?? ""
                        cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgVwProfile.sd_setImage(
                            with: URL(string: Store.UserDetail?["profileImage"] as? String ?? ""),
                            placeholderImage: UIImage(named: "profile"),
                            options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                            
                        )
                    }else{
//                        cell.lblName.text = Store.BusinessUserDetail?["userName"] as? String ?? ""
                        cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgVwProfile.sd_setImage(
                            with: URL(string: Store.BusinessUserDetail?["profileImage"] as? String ?? ""),
                            placeholderImage: UIImage(named: "profile"),
                            options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                        )
                    }
                }else{
//                    cell.lblName.text = message?.sender?.name ?? ""
                    cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgVwProfile.sd_setImage(
                        with: URL(string: message?.sender?.profilePhoto ?? ""),
                        placeholderImage: UIImage(named: "profile"),
                        options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                    )
                }
                    
            
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                cell.vwMessage.layer.cornerRadius = 10
                cell.vwMessage.clipsToBounds = true
                cell.vwMessage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
                cell.vwMessage.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 3, offset:CGSize(width: 2, height: 2))
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverTVC", for: indexPath) as! RecieverTVC
                
                cell.lblMessage.text = message?.message ?? ""
                cell.lblName.text = message?.sender?.name ?? ""
        
                cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgVwProfile.sd_setImage(
                    with: URL(string: message?.sender?.profilePhoto ?? ""),
                    placeholderImage: UIImage(named: "profile"),
                    options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                )
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                
                cell.vwMessage.layer.cornerRadius = 10
                cell.vwMessage.clipsToBounds = true
                cell.vwMessage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                cell.vwMessage.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 3, offset:CGSize(width: 2, height: 2))
                return cell
            }
        }else{
            
            if message?.sender?.id == Store.userId {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendImageTVC", for: indexPath) as! SendImageTVC
                cell.lblName.text = "You"
                cell.arrImage = message?.media ?? []
                if message?.message == nil{
                    cell.lblMessage.text = ""
                    cell.topMessage.constant = 0
                }else{
                    cell.lblMessage.text = message?.message ?? ""
                    cell.topMessage.constant = 5
                }
                cell.lblMessage.sizeToFit()
                cell.uiSet()
                cell.callBack = { [weak self] index in
                    guard let self = self else { return }
                  
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
                    vc.arrImage = message?.media ?? []
                    vc.index = index
//                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false)
                }
                
                if  message?.sender?.name ?? "" == "Private User"{
                    if Store.role == "user"{
//                        cell.lblName.text = Store.UserDetail?["userName"] as? String ?? ""
                        cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgVwProfile.sd_setImage(
                            with: URL(string: Store.UserDetail?["profileImage"] as? String ?? ""),
                            placeholderImage: UIImage(named: "profile"),
                            options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                            
                        )
                    }else{
//                        cell.lblName.text = Store.BusinessUserDetail?["userName"] as? String ?? ""
                        cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgVwProfile.sd_setImage(
                            with: URL(string: Store.BusinessUserDetail?["profileImage"] as? String ?? ""),
                            placeholderImage: UIImage(named: "profile"),
                            options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                        )
                    }
                }else{
//                    cell.lblName.text = message?.sender?.name ?? ""
                    cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgVwProfile.sd_setImage(
                        with: URL(string: message?.sender?.profilePhoto ?? ""),
                        placeholderImage: UIImage(named: "profile"),
                        options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                    )
                }
              
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                cell.vwImg.layer.cornerRadius = 10
                cell.vwImg.clipsToBounds = true
                cell.vwImg.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
                cell.vwImg.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 3, offset:CGSize(width: 2, height: 2))
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveImageTVC", for: indexPath) as! ReceiveImageTVC
                
                cell.arrImage = message?.media ?? []
              
                cell.lblMessage.sizeToFit()
                cell.uiSet()
                cell.callBack = { [weak self] index in
                    guard let self = self else { return }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
                    vc.arrImage = message?.media ?? []
                    vc.index = index
//                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false)
                }
                
                cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                
                cell.imgVwProfile.sd_setImage(
                    with: URL(string: message?.sender?.profilePhoto ?? ""),
                    placeholderImage: UIImage(named: "profile"),
                    options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                )
                
                cell.lblName.text = message?.sender?.name ?? ""
              
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                cell.vwImage.layer.cornerRadius = 10
                cell.vwImage.clipsToBounds = true
                cell.vwImage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                cell.vwImage.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 3, offset:CGSize(width: 2, height: 2))
                
                
                return cell
            }
        }
        
    }
}

//MARK: - QBImagePickerControllerDelegate

extension GigChatVC: QBImagePickerControllerDelegate {
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        guard let selectedAssets = assets as? [PHAsset] else {
            return
        }
        guard !selectedAssets.isEmpty else {
            return
        }

        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false  // Allow async processing
        requestOptions.deliveryMode = .highQualityFormat // High-quality image
        requestOptions.resizeMode = .none // Keep original size

        for asset in selectedAssets {
            if asset.mediaType == .image {
                // Request original/full resolution image
                let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)

                imageManager.requestImage(
                    for: asset,
                    targetSize: targetSize, // Request full resolution
                    contentMode: .aspectFill,
                    options: requestOptions
                ) { (image, _) in
                    if let image = image {
                        print("High-Quality Image:", image)
                        self.arrImage.append(image)
                    }
                }
            } else if asset.mediaType == .video {
                imageManager.requestAVAsset(forVideo: asset, options: nil) { (avAsset, _, _) in
                    if let urlAsset = avAsset as? AVURLAsset {
                        let videoURL = urlAsset.url
                        print("Video URL:", videoURL)
                        self.arrImage.append(videoURL)
                    }
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.uploadImageApi(image: self.arrImage) { data in
                self.arrImage.removeAll()
                self.arrImage.append(contentsOf: data?.imageUrls ?? [String]())

                if self.arrImage.count >= 4 {
                    let param = ["senderId": Store.userId ?? "", "groupId": self.groupId, "media": self.arrImage, "deviceId": Store.deviceToken ?? "", "gigId": self.gigId] as [String: Any]
                    SocketIOManager.sharedInstance.sendMessage(dict: param)
                    print("Param------", param)
                    self.txtVwMessage.text = ""
                    self.txtVwMessage.resignFirstResponder()
                } else {
                    for imageUrl in self.arrImage {
                        let param = ["senderId": Store.userId ?? "", "groupId": self.groupId, "media": [imageUrl], "deviceId": Store.deviceToken ?? "", "gigId": self.gigId] as [String: Any]
                        print("Param------", param)
                        SocketIOManager.sharedInstance.sendMessage(dict: param)
                    }
                }
            }
        }

        dismiss(animated: true, completion: nil)
    }
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension GigChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.arrImage.append(image)
            
        } else if let videoURL = info[.mediaURL] as? URL {
            self.arrImage.append(videoURL)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.uploadImageApi(image: self.arrImage) { data in
                self.arrImage.removeAll()
                self.arrImage.append(contentsOf: data?.imageUrls ?? [String]())
               
                let param = ["senderId": Store.userId ?? "", "groupId": self.groupId, "media": self.arrImage,"deviceId":Store.deviceToken ?? "","gigId":self.gigId]
                    print("Param------",param)
                    SocketIOManager.sharedInstance.sendMessage(dict: param)
                    
               
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - KEYBOARD HANDLING
extension GigChatVC {
    
    private func keyboardHandling() {
        // Ensure IQKeyboardManager does not interfere
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(GigChatVC.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    @objc func keyboardWillHide(notification: NSNotification) {
        let deviceHasNotch = UIApplication.shared.hasNotch
        UIView.animate(withDuration: 0.3) {
            self.btmStackVw.constant = deviceHasNotch ? 10 : 10
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let bottomInset = self.view.safeAreaInsets.bottom
        let keyboardHeight = keyboardSize.height - (bottomInset > 0 ? bottomInset : 0)  // Adjust safe area handling
        
        let deviceHasNotch = UIApplication.shared.hasNotch

        UIView.animate(withDuration: 0.3) {
            self.btmStackVw.constant = deviceHasNotch ? keyboardHeight + 5 : keyboardHeight + 5
            self.view.layoutIfNeeded()
        }
        
        // Ensure smooth scrolling after keyboard is fully shown
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableViewScrollToBottom()
        }
    }
    
    // MARK: - TABLE VIEW SCROLL TO BOTTOM
    func tableViewScrollToBottom() {
        DispatchQueue.main.async {
            let numberOfSections = self.tblVwMessage.numberOfSections
            if numberOfSections > 0 {
                let numberOfRows = self.tblVwMessage.numberOfRows(inSection: numberOfSections - 1)
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                    self.tblVwMessage.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
}
