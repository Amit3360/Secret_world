//
//  ChatInboxVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 28/12/23.
//

import UIKit
import IQKeyboardManagerSwift
import QBImagePickerController
import SDWebImage

class ChatInboxVC: UIViewController {

    @IBOutlet weak var btnThreeDot: UIButton!
    @IBOutlet weak var lblBlockText: UILabel!
    @IBOutlet weak var heightMessageVw: NSLayoutConstraint!
    @IBOutlet weak var txtVwMessage: IQTextView!
    @IBOutlet var lblOnline: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var imgVwProfile: UIImageView!
    @IBOutlet var tblVwInbox: UITableView!
    @IBOutlet var viewBack: UIView!
    @IBOutlet weak var bottomVw: NSLayoutConstraint!
    @IBOutlet weak var lblGroupText: UILabel!
    @IBOutlet weak var topGroupText: NSLayoutConstraint!
    
    var receiverId = ""
    var arrImage = [Any]()
    let imagePickerController = UIImagePickerController()
    var viewModel = UploadImageVM()
    var blockStatusMe = false
    var blockStatusOther = false
    var arrMessages = [Message]()
    var arrGroupMessages = [GroupChatDetail]()
    var messageDictionary = [String: [Message]]()
    var currrentDate = ""
    var yesterDayDate = ""
    var groupedMessages: [Date: [Message]] = [:]
    var dates: [Date] = []
    var callBack:(()->())?
    var userType = ""
    var userName = ""
    var otherUserName = ""
    var isGroup = false
    var gigId = ""
    var gigName = ""
    var gigImg = ""
    var participantUser = ""
    var groupMessageDictionary = [String: [GroupChatDetail]]()
    var groupedChatMessages: [Date: [GroupChatDetail]] = [:]
    var isAbout = false
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                   swipeRight.direction = .right
                   view.addGestureRecognizer(swipeRight)

        uiSet()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
                       tapGesture.cancelsTouchesInView = false
                       view.addGestureRecognizer(tapGesture)
            }
            @objc func dismissKeyboardWhileClick() {
                   view.endEditing(true)
               }
    @objc func handleSwipe() {
        self.navigationController?.popViewController(animated: true)
        receiveChat(isOpen: true)
        callBack?()
            }

    func uiSet(){
       
        tblVwInbox.showsVerticalScrollIndicator = false
        txtVwMessage.placeholder = "Type a message here..."
        if isGroup == true{
            btnThreeDot.isHidden = true
        }else{
            btnThreeDot.isHidden = false
        }
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy"
        currrentDate = dateformatter.string(from: date)
        let calendar = Calendar.current
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let yesterdayString = dateFormatter.string(from: yesterday)
            yesterDayDate = yesterdayString
        } else {
            print("Error: Could not calculate yesterday's date.")
        }
        
        keyboardHandling()
        txtVwMessage.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: 5, right: 10)
        viewBack.layer.cornerRadius = 15
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let readParam = ["senderId":Store.userId ?? ""]
        SocketIOManager.sharedInstance.readMessage(dict: readParam)
        if isGroup == true{
            self.lblGroupText.text = "\(gigName) Group has been created"
            self.topGroupText.constant = 20
        }else{
            self.lblGroupText.text = ""
            self.topGroupText.constant = 0
         
        }
        
            receiveChat(isOpen: true)
            getSendMessageData(isOpen: false)
            SocketIOManager.sharedInstance.getGroupMessageData = {
                DispatchQueue.global(qos: .background).async {
                    self.receiveChat(isOpen: false)
                }
               
                
            }
        if isAbout == true{
            getUserDetailApi()
        }
        
    }
    func receiveChat(isOpen:Bool){
        
        if SocketIOManager.sharedInstance.socket?.status == .connected{
            if isGroup == true{
                self.getGroupChat(open: isOpen)
            }else{
              
                self.getChat(open: isOpen)
            }
         
        }else{
            SocketIOManager.sharedInstance.reConnectSocket(userId: Store.userId ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now()+4.0){
                if self.isGroup == true{
                    self.getGroupChat(open: isOpen)
                    
                }else{
                    self.getChat(open: isOpen)
                   
                }
            }
        }
    }
  
    func getChat(open: Bool) {
        self.getUserDetailApi()
        let param = ["senderId": Store.userId ?? "", "receiverId": self.receiverId, "isOpen": open] as [String: Any]
        print("Param----------", param)
        
        SocketIOManager.sharedInstance.getMessageList(dict: param)
        SocketIOManager.sharedInstance.chatData = { data in
            DispatchQueue.main.asyncAfter(deadline: .now()){
                self.lblBlockText.text = ""
                
                guard let messages = data?.first?.messages, !messages.isEmpty else {
                    // Handle case where there are no messages
                    return
                }
                
                if self.receiverId == data?[0].messages?[0].recipient?.id ?? "" || self.receiverId == data?[0].messages?[0].sender?.id ?? "" {
                    if data?[0].userOnline == true {
                        self.lblOnline.text = "Online"
                    } else {
                        self.lblOnline.text = "Offline"
                    }
                    
                    self.blockStatusMe = data?[0].userBlocked ?? false
                    self.blockStatusOther = data?[0].blockedByUser ?? false
                    
                    if self.blockStatusMe == true {
                        self.heightMessageVw.constant = 0
                        self.lblBlockText.text = "You have blocked \(self.userName)"
                        self.lblBlockText.isHidden = false
                    } else if self.blockStatusOther == true {
                        self.heightMessageVw.constant = 0
                        self.lblBlockText.text = "You have been blocked by \(self.userName)"
                        self.lblBlockText.isHidden = false
                    } else {
                        self.lblBlockText.text = ""
                        self.lblBlockText.isHidden = true
                        self.heightMessageVw.constant = 50
                    }
                    
                    self.arrMessages.removeAll()
                    self.dates.removeAll()
                    self.groupedMessages.removeAll()
                    self.arrMessages.append(contentsOf: data?[0].messages ?? [])
                    
                    for index in 0..<self.arrMessages.count {
                        if let createdAt = self.arrMessages[index].createdAt {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            if let date = dateFormatter.date(from: createdAt) {
                                self.arrMessages[index].messageDate = date
                            } else {
                                print("Failed to convert the string to a Date.")
                            }
                            self.arrMessages[index].createdAt = self.convertTimestampToDateString(timestamp: createdAt)
                        }
                    }
                    
                    self.arrMessages.sort { $0.messageDate ?? Date() < $1.messageDate ?? Date() }
                    
                    // Group messages by date
                    for message in self.arrMessages {
                        let date = message.messageDate?.dateWithoutTime()
                        
                        if self.groupedMessages[date ?? Date()] == nil {
                            self.groupedMessages[date ?? Date()] = []
                            self.dates.append(date ?? Date())
                        }
                        self.groupedMessages[date ?? Date()]?.append(message)
                    }
                    
                    self.tblVwInbox.scrollToBottom(animated: true)
                    self.tblVwInbox.estimatedRowHeight = 50
                    self.tblVwInbox.rowHeight = UITableView.automaticDimension
                    self.tblVwInbox.reloadData()
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.getUserDetailApi()
//                    }
                }
            }
        }
    }

    func getGroupChat(open:Bool){
        let param = ["groupId":self.gigId,"senderId":Store.userId ?? "","isOpen":open] as [String : Any]
        print("Param----------",param)
        lblUserName.text = gigName
        imgVwProfile.imageLoad(imageUrl: gigImg)
        lblOnline.text = participantUser
        SocketIOManager.sharedInstance.getGroupChat(dict: param)
        SocketIOManager.sharedInstance.groupData = { data in
            if data?[0].groupChatDetails?.count ?? 0 > 0{
                if data?[0].groupChatDetails?[0].group?.id == self.gigId{
                    self.lblBlockText.text = ""
                    self.lblBlockText.isHidden = true
                    self.heightMessageVw.constant = 50
                    
                    self.arrGroupMessages.removeAll()
                    self.dates.removeAll()
                    self.groupedChatMessages.removeAll()
                    self.arrGroupMessages.append(contentsOf: data?[0].groupChatDetails ?? [])
                    if self.arrGroupMessages.count > 0 {
                        
                        self.arrGroupMessages.remove(at: self.arrGroupMessages.count-1)
                        
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
                    
                    self.arrGroupMessages.sort { $0.messageDate ?? Date() < $1.messageDate  ?? Date()}
                    
                    // Group messages by date
                    for message in self.arrGroupMessages {
                        let date = message.messageDate?.dateWithoutTime()
                        
                        if self.groupedChatMessages[date ?? Date()] == nil {
                            self.groupedChatMessages[date ?? Date()] = []
                            self.dates.append(date ?? Date())
                        }
                        self.groupedChatMessages[date ?? Date()]?.append(message)
                    }
                    
                    self.tblVwInbox.scrollToBottom(animated: true)
                    self.tblVwInbox.estimatedRowHeight = 50
                    self.tblVwInbox.rowHeight = UITableView.automaticDimension
                    self.tblVwInbox.reloadData()
                }
            }
        }
        }
    
    
    func getUserDetailApi(){
        viewModel.getUserDetail(receiverId: receiverId) { data in
            self.userType = data?.userProfile?.usertype ?? ""
            self.lblUserName.text = data?.userProfile?.name ?? ""
            self.imgVwProfile.imageLoad(imageUrl: data?.userProfile?.profilePhoto ?? "")
            if self.isAbout == true{
                if data?.userProfile?.isOnline == true{
                    self.lblOnline.text = "Online"
                }else{
                    self.lblOnline.text = "Offline"
                }
                
            }
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
  
    func getSendMessageData(isOpen:Bool){
       
            SocketIOManager.sharedInstance.sendMessageData = {
                if self.isGroup == true{
                    self.getGroupChat(open: isOpen)
                    
                }else{
                    self.getChat(open: isOpen)
                    
                }
            }
        
    }
    
  
    @IBAction func actionUserDetail(_ sender: UIButton) {
        
        if isGroup == true{
            if Store.role == "b_user"{
                
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantsVC") as! ParticipantsVC
                    vc.isComing = 1
                    vc.gigId = gigId
                   vc.gigType = 1
                vc.isGroup = true
                    self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantsVC") as! ParticipantsVC
                vc.isComing = 1
                vc.gigId = gigId
                vc.gigType = 1
                vc.isGroup = true

                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else{
            if userType == "user"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewVC") as! ProfileViewVC
                vc.isComingChat = true
                vc.id = self.receiverId
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileVC") as! BusinessProfileVC
                vc.isComing = false
                vc.businessId = self.receiverId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
      
       
    }
    
    @IBAction func actionThreeDot(_ sender: UIButton) {
        self.txtVwMessage.resignFirstResponder()
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatOptionVC") as! ChatOptionVC
        vc.modalPresentationStyle = .popover
        vc.blockStatusMe = self.blockStatusMe
        vc.blockStatusOther = self.blockStatusOther
        vc.receiverId = self.receiverId
        
        vc.callBack = { (isReport,inbox) in
          
            if isReport == true{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
                vc.receiverId = self.receiverId
                vc.callBack = { message in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.message = message
                    vc.isSelect = 10
                    self.navigationController?.present(vc, animated: true)
                    self.getChat(open: true)
                }
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: true)
            }else{
                
                self.getChat(open: true)
            }
           
        }
        if blockStatusMe == true{
        vc.preferredContentSize = CGSize(width: 150, height: 100)
        }else{
            if blockStatusOther == true{
        vc.preferredContentSize = CGSize(width: 150, height: 100)
            }else{
        vc.preferredContentSize = CGSize(width: 150, height: 100)
            }
        }
        
      
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        self.present(vc, animated: false)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        receiveChat(isOpen: true)
        callBack?()
    }
    
    
    @IBAction func actionSendMessage(_ sender: UIButton) {
        if txtVwMessage.text != ""{
            if isGroup == true{
                let param = ["senderId":Store.userId ?? "","groupId":self.gigId,"message":txtVwMessage.text ?? ""]
                SocketIOManager.sharedInstance.sendMessage(dict: param)
                self.txtVwMessage.text = ""
                self.txtVwMessage.resignFirstResponder()
               
            }else{
                let param = ["senderId":Store.userId ?? "","receiverId":self.receiverId,"message":txtVwMessage.text ?? ""]
                SocketIOManager.sharedInstance.sendMessage(dict: param)
                self.txtVwMessage.text = ""
                self.txtVwMessage.resignFirstResponder()
               
            }
        }else{
            print("Empty message")
        }
    }
    
    @IBAction func actionUploadImage(_ sender: UIButton) {

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
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Camera not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery() {
        let imagePickerController = QBImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsMultipleSelection = true
        imagePickerController.mediaType = .any
        present(imagePickerController, animated: true, completion: nil)
    }
  
   
}
//MARK: -UITableViewDelegate
extension ChatInboxVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if isGroup == true{
            if arrGroupMessages.count > 0 {
                return  dates.count
                
            }else{
                return 1
            }
        }else{
            if arrMessages.count > 0 {
                return  dates.count
                
            }else{
                return 1
            }
        }
       
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isGroup == true{
            if arrGroupMessages.count > 0{
                let date = dates[section]
                return groupedChatMessages[date]?.count ?? 0
            }else{
                return 0
            }
        }else{
            if arrMessages.count > 0{
                let date = dates[section]
                return groupedMessages[date]?.count ?? 0
            }else{
                return 0
            }
        }
       
    }
    
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTimingTVC") as! ChatTimingTVC
        if isGroup == true{
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

        }else{
            if arrMessages.count > 0 {
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

        }
            return cell
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isGroup == true{
            let date = dates[indexPath.section]
            let messagesForDate = groupedChatMessages[date]
            let message = messagesForDate?[indexPath.row]
            if message?.media?.count ?? 0 == 0{
                    
                if message?.sender?.id == Store.userId {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTVC", for: indexPath) as! SenderTVC
                       
                    cell.lblMessage.text = message?.message ?? ""
                    cell.lblName.text = message?.sender?.name ?? ""
                   
//                        cell.imgVwProfile.imageLoad(imageUrl: message?.sender?.profilePhoto ?? "")
                    cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray

                    cell.imgVwProfile.sd_setImage(
                        with: URL(string: message?.sender?.profilePhoto ?? ""),
                        placeholderImage: UIImage(named: "Profile-Pic-Icon (1)"),
                        options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                    )
                    
                        let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                        cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                    cell.vwMessage.layer.cornerRadius = 10
                    cell.vwMessage.clipsToBounds = true
                    cell.vwMessage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
                    cell.vwMessage.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 5, offset:CGSize(width: 2, height: 5))
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverTVC", for: indexPath) as! RecieverTVC
                        
                        cell.lblMessage.text = message?.message ?? ""
                        cell.lblName.text = message?.sender?.name ?? ""
                       
//                        cell.imgVwProfile.imageLoad(imageUrl: message?.sender?.profilePhoto ?? "")
                        cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgVwProfile.sd_setImage(
                            with: URL(string: message?.sender?.profilePhoto ?? ""),
                            placeholderImage: UIImage(named: "Profile-Pic-Icon (1)"),
                            options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                        )
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                        cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                      
                        cell.vwMessage.layer.cornerRadius = 10
                        cell.vwMessage.clipsToBounds = true
                        cell.vwMessage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                        cell.vwMessage.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 5, offset:CGSize(width: 2, height: 5))
                        return cell
                    }
                }else{
                    
                    if message?.sender?.id == Store.userId {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SendImageTVC", for: indexPath) as! SendImageTVC
                       
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
                        cell.callBack = { index in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
                            vc.arrImage = message?.media ?? []
                            vc.index = index
//                            self.navigationController?.pushViewController(vc, animated: true)
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false)
                        }
                      
//                        cell.imgVwProfile.imageLoad(imageUrl: message?.sender?.profilePhoto ?? "")
                        cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgVwProfile.sd_setImage(
                            with: URL(string: message?.sender?.profilePhoto ?? ""),
                            placeholderImage: UIImage(named: "Profile-Pic-Icon (1)"),
                            options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                        )
                       
                        cell.lblName.text = message?.sender?.name ?? ""
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                        cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                        cell.vwImg.layer.cornerRadius = 10
                        cell.vwImg.clipsToBounds = true
                        cell.vwImg.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
                        cell.vwImg.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 5, offset:CGSize(width: 2, height: 5))
                       
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveImageTVC", for: indexPath) as! ReceiveImageTVC
                      
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
                        cell.callBack = { index in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
                            vc.arrImage = message?.media ?? []
                            vc.index = index
//                            self.navigationController?.pushViewController(vc, animated: true)
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false)
                        }
                       
//                            cell.imgVwProfile.imageLoad(imageUrl: message?.sender?.profilePhoto ?? "")
                        cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgVwProfile.sd_setImage(
                            with: URL(string: message?.sender?.profilePhoto ?? ""),
                            placeholderImage: UIImage(named: "Profile-Pic-Icon (1)"),
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
                        cell.vwImage.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 5, offset:CGSize(width: 2, height: 5))
                       

                        return cell
                    }
                }

        }else{
            let date = dates[indexPath.section]
            let messagesForDate = groupedMessages[date]
            let message = messagesForDate?[indexPath.row]
            if message?.media?.count == 0{
                    
                if message?.sender?.id == Store.userId {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTVC", for: indexPath) as! SenderTVC
                       
                        cell.lblMessage.text = message?.message ?? ""
                        cell.lblName.text = message?.sender?.name ?? ""
              
//                        cell.imgVwProfile.imageLoad(imageUrl: message?.sender?.profilePhoto ?? "")
                    cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgVwProfile.sd_setImage(
                        with: URL(string: message?.sender?.profilePhoto ?? ""),
                        placeholderImage: UIImage(named: "Profile-Pic-Icon (1)"),
                        options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                    )
                    
                        let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                        cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                    cell.vwMessage.layer.cornerRadius = 10
                    cell.vwMessage.clipsToBounds = true
                    cell.vwMessage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
                    cell.vwMessage.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 5, offset:CGSize(width: 2, height: 5))
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverTVC", for: indexPath) as! RecieverTVC
                        cell.lblMessage.text = message?.message ?? ""
                        cell.lblName.text = message?.sender?.name ?? ""
                     
//                        cell.imgVwProfile.imageLoad(imageUrl: message?.sender?.profilePhoto ?? "")
                        cell.imgVwProfile.sd_setImage(
                            with: URL(string: message?.sender?.profilePhoto ?? ""),
                            placeholderImage: UIImage(named: "Profile-Pic-Icon (1)"),
                            options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                        )
                      
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                       let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                        cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                      
                        cell.vwMessage.layer.cornerRadius = 10
                        cell.vwMessage.clipsToBounds = true
                        cell.vwMessage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                        cell.vwMessage.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 5, offset:CGSize(width: 2, height: 5))
                        return cell
                    }
                }else{
                    
                    if message?.sender?.id == Store.userId {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SendImageTVC", for: indexPath) as! SendImageTVC
                       
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
                        cell.callBack = { index in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
                            vc.arrImage = message?.media ?? []
                            vc.index = index
//                            self.navigationController?.pushViewController(vc, animated: true)
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false)
                        }
                     
//                            cell.imgVwProfile.imageLoad(imageUrl: message?.sender?.profilePhoto ?? "")
                        cell.imgVwProfile.sd_setImage(
                            with: URL(string: message?.sender?.profilePhoto ?? ""),
                            placeholderImage: UIImage(named: "Profile-Pic-Icon (1)"),
                            options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                        )
                      
                        cell.lblName.text = message?.sender?.name ?? ""
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                        cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                        cell.vwImg.layer.cornerRadius = 10
                        cell.vwImg.clipsToBounds = true
                        cell.vwImg.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
                        cell.vwImg.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 5, offset:CGSize(width: 2, height: 5))
                       
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveImageTVC", for: indexPath) as! ReceiveImageTVC
                      
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
                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()

                        cell.callBack = { index in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
                            vc.arrImage = message?.media ?? []
                            vc.index = index
//                            self.navigationController?.pushViewController(vc, animated: true)
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false)
                        }
                       
//                            cell.imgVwProfile.imageLoad(imageUrl: message?.sender?.profilePhoto ?? "")
                        cell.imgVwProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgVwProfile.sd_setImage(
                            with: URL(string: message?.sender?.profilePhoto ?? ""),
                            placeholderImage: UIImage(named: "Profile-Pic-Icon (1)"),
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
                        cell.vwImage.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 5, offset:CGSize(width: 2, height: 5))
                       

                        return cell
                    }
                }

        }
        
        }
       

}



//MARK: - KEYBOARD HANDLING
extension ChatInboxVC {
    
    private func keyboardHandling(){
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatInboxVC.self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomVw.constant = 10
   
    }
    @objc func keyboardWillShow(notification: NSNotification){
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136,1334,1920, 2208:
                    print("1")
                    self.bottomVw.constant = (keyboardSize.height - self.view.safeAreaInsets.bottom+3)
                    self.tableViewScrollToBottom()
                case 2436,2688,1792:
                    print("2")
                    self.bottomVw.constant = (keyboardSize.height - self.view.safeAreaInsets.bottom+10)
                    self.tableViewScrollToBottom()
                default:
                    print("3")
                    self.bottomVw.constant = (keyboardSize.height - self.view.safeAreaInsets.bottom+10)
                    self.tableViewScrollToBottom()
                }
            }
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    //MARK: - TABLE VIEW SCROLL TO BOTTOM
    func tableViewScrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0)) {
            let numberOfSections = self.tblVwInbox.numberOfSections
            if numberOfSections > 0 {
                let numberOfRows = self.tblVwInbox.numberOfRows(inSection: numberOfSections - 1)
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                    self.tblVwInbox.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }
}

extension ChatInboxVC: QBImagePickerControllerDelegate {
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
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            self.viewModel.uploadImageApi(image: self.arrImage) { data in
                self.arrImage.removeAll()
                self.arrImage.append(contentsOf: data?.imageUrls ?? [String]())
                if self.arrImage.count >= 4{
                    if self.isGroup == true{
                        let param = ["senderId":Store.userId ?? "","groupId":self.gigId,"media":self.arrImage] as [String : Any]
                        SocketIOManager.sharedInstance.sendMessage(dict: param)
                        print("Param------",param)
                        self.txtVwMessage.text = ""
                        self.txtVwMessage.resignFirstResponder()
                        
                    }else{
                        let param = ["senderId":Store.userId ?? "","receiverId":self.receiverId,"media":self.arrImage] as [String : Any]
                        print("Param------",param)
                        self.txtVwMessage.text = ""
                        self.txtVwMessage.resignFirstResponder()
                        SocketIOManager.sharedInstance.sendMessage(dict: param)
                    
                    }
           
                }else{
                    for imageUrl in self.arrImage {
                        if self.isGroup == true{
                            let param = ["senderId": Store.userId ?? "", "groupId": self.gigId, "media": [imageUrl]] as [String : Any]
                            print("Param------",param)
                            SocketIOManager.sharedInstance.sendMessage(dict: param)
                           
                        }else{
                            let param = ["senderId": Store.userId ?? "", "receiverId": self.receiverId, "media": [imageUrl]] as [String : Any]
                            print("Param------",param)
                            SocketIOManager.sharedInstance.sendMessage(dict: param)
                           
                        }
                               
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

extension ChatInboxVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
                if self.isGroup == true{
                    let param = ["senderId": Store.userId ?? "", "groupId": self.gigId, "media": self.arrImage]
                    print("Param------",param)
                    SocketIOManager.sharedInstance.sendMessage(dict: param)
                    
                }else{
                    let param = ["senderId": Store.userId ?? "", "receiverId": self.receiverId, "media": self.arrImage]
                    SocketIOManager.sharedInstance.sendMessage(dict: param)
                    
                }
                
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Popup

extension ChatInboxVC : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
        
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}

extension Date {
    
    func dateWithoutTime() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
}
