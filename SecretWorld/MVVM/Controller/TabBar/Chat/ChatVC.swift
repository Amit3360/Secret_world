//
//  ChatVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//
import UIKit

class ChatVC: UIViewController {
    
    //MARK: - OUTLETS
    //leftSidebtn
    @IBOutlet weak var bottomTblVw: NSLayoutConstraint!
    @IBOutlet var leftSideViewDot: UIView!
    @IBOutlet var btnLeftSideNotification: UIButton!
    //rightSidebtn
    @IBOutlet var btnRightSideNotification: UIButton!
    @IBOutlet var viewDot: UIView!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var imgVwBackDesign: UIImageView!
    @IBOutlet var viewBack: UIView!
    @IBOutlet var tblVwChatList: UITableView!
    
    //MARK: - VARIABLES
    
    var arrChatList = [MessageListModel]()
    var isGroup = false
    let deviceHasNotch = UIApplication.shared.hasNotch
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
//        configureSocket()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        if SocketIOManager.sharedInstance.socket?.status == .connected{
            self.getMessage()
        }else{
            SocketIOManager.sharedInstance.reConnectSocket(userId: Store.userId ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now()+4.0){
                self.getMessage()
            }
        }
    }
    //MARK: - FUNCTIONS
    
    func uiSet(){
        
        tblVwChatList.showsVerticalScrollIndicator = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedGetChat(notification:)), name: Notification.Name("GetGroupMessage"), object: nil)
     
//
        imgVwBackDesign.layer.cornerRadius = 15
        imgVwBackDesign.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        viewBack.layer.cornerRadius = 15
        viewBack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.getMessage()
      
      
    }
    
    func getMessage(){
        if Store.userNotificationCount ?? 0 > 0{
            btnRightSideNotification.isHidden = false
            leftSideViewDot.isHidden = true
            viewDot.isHidden = false
        }else{
            btnRightSideNotification.isHidden = false
            leftSideViewDot.isHidden = true
            viewDot.isHidden = true
        }
        let param = ["senderId": Store.userId ?? ""]
        SocketIOManager.sharedInstance.getUserMessage(dict: param)
     
        SocketIOManager.sharedInstance.messageData = {  data in
            
            self.arrChatList.removeAll()
            self.arrChatList = data ?? []
            if data?[0].messages?.count ?? 0 > 0 {
                self.lblNoData.isHidden = true
                self.lblNoData.text = ""
            } else {
                self.lblNoData.isHidden = false
                self.lblNoData.text = "Data Not Found!"
            }
            self.tblVwChatList.reloadData()
            
        }
        
    }

    @objc func methodOfReceivedGetChat(notification: Notification) {
        
        if SocketIOManager.sharedInstance.socket?.status == .connected{
            self.getMessage()
        }else{
            SocketIOManager.sharedInstance.reConnectSocket(userId: Store.userId ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now()+4.0){
                self.getMessage()
            }
        }
    }
    //leftSidebtn
    @IBAction func actionLeftSideNotification(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        vc.callBack = {[weak self] in
            guard let self = self else { return }
            self.btnRightSideNotification.isHidden = true
            self.viewDot.isHidden = true
            self.leftSideViewDot.isHidden = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //rightSidebtn
    @IBAction func actionNotification(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        vc.callBack = {[weak self] in
            guard let self = self else { return }
            self.btnRightSideNotification.isHidden = true
            self.viewDot.isHidden = true
            self.leftSideViewDot.isHidden = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UITABLEVIEWDELEGATE AND DATA SOURCE

extension ChatVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrChatList.count > 0{
            return  arrChatList[0].messages?.count ?? 0
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTVC", for: indexPath) as! ChatListTVC
        
        let data = arrChatList[0].messages?[indexPath.row]
        if data?.groupID != nil{
            if data?.media?.count ?? 0 > 0 {
                cell.lblMsg.text = "Media"
            }else{
                cell.lblMsg.text = data?.message ?? ""
            }
            if data?.unreadCount == 0{
                cell.lblMsgCount.text = ""
                cell.viewMsgCount.backgroundColor = .clear
            }else{
                if data?.unreadCount ?? 0 > 9{
                    
                    cell.lblMsgCount.text = "9+"
                    cell.viewMsgCount.backgroundColor = UIColor(hex: "#3E9C35")
                }else{
                    
                    cell.lblMsgCount.text = "\(data?.unreadCount ?? 0)"
                    cell.viewMsgCount.backgroundColor = UIColor(hex: "#3E9C35")
                }
            }
            cell.lblName.text = data?.name ?? ""
       
//            cell.imgVwUser.imageLoad(imageUrl: data?.image ?? "")
            cell.imgVwUser.sd_setImage(
                with: URL(string: data?.image ?? ""),
                placeholderImage: UIImage(named: "profile"),
                options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
            )
            cell.lblTime.text = formattedDateString(from: data?.createdAt ?? "")
        }else{
            if data?.media?.count ?? 0 > 0 {
                cell.lblMsg.text = "Media"
            }else{
                cell.lblMsg.text = data?.message ?? ""
            }
            
            if data?.sender?.id ?? "" == Store.userId ?? ""{
                cell.lblName.text = data?.recipient?.name ?? ""
//                cell.imgVwUser.imageLoad(imageUrl: data?.recipient?.profilePhoto ?? "")
                cell.imgVwUser.sd_setImage(
                    with: URL(string: data?.recipient?.profilePhoto ?? ""),
                    placeholderImage: UIImage(named: "profile"),
                    options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                )
            }else{
                cell.lblName.text = data?.sender?.name ?? ""
//                cell.imgVwUser.imageLoad(imageUrl: data?.sender?.profilePhoto ?? "")
                cell.imgVwUser.sd_setImage(
                    with: URL(string: data?.sender?.profilePhoto ?? ""),
                    placeholderImage: UIImage(named: "profile"),
                    options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                )
            }
            
            cell.lblTime.text = formattedDateString(from: data?.createdAt ?? "")
            if data?.unreadCount == 0{
                cell.lblMsgCount.text = ""
                cell.viewMsgCount.backgroundColor = .clear
            }else{
                if data?.unreadCount ?? 0 > 9{
                    
                    cell.lblMsgCount.text = "9+"
                    cell.viewMsgCount.backgroundColor = UIColor(hex: "#3E9C35")
                }else{
                    cell.lblMsgCount.text = "\(data?.unreadCount ?? 0)"
                    cell.viewMsgCount.backgroundColor = UIColor(hex: "#3E9C35")
                }
            }
        }
        cell.contentView.layer.masksToBounds = false
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOpacity = 0.1
        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.contentView.layer.shouldRasterize = true
        cell.contentView.layer.rasterizationScale = UIScreen.main.scale
        cell.contentView.layer.cornerRadius = 10
        
        return cell
    }
    func formattedDateString(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Check if the date is today
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "h:mm a" // Time format for today
        }
        // Check if the date is yesterday
        else if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "Yesterday" // Special format for yesterday
        }
        // Otherwise, use the full date format
        else {
            dateFormatter.dateFormat = "dd/MM/yyyy" // Date format for past days
        }
        
        return dateFormatter.string(from: date)
    }

    @objc func actionBookMark(sender:UIButton){
        
        sender.isSelected = !sender.isSelected
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = arrChatList[0].messages?[indexPath.row]
        if data?.groupID != nil{
            isGroup = true
        }else{
            isGroup = false
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatInboxVC") as! ChatInboxVC
        vc.isGroup = self.isGroup
        if isGroup == true{
            vc.gigId = data?.groupID ?? ""
            vc.gigName = data?.name ?? ""
            vc.gigImg = data?.image ?? ""
           let arrName = data?.group?.participantsNames ?? []
            let resultString = arrName.joined(separator: ", ")
            vc.participantUser = resultString
            vc.callBack = {[weak self] in
                guard let self = self else { return }
                self.getMessage()
            }
        }else{
            if arrChatList[0].messages?[indexPath.row].sender?.id == Store.userId {
                vc.receiverId = arrChatList[0].messages?[indexPath.row].recipient?.id ?? ""
                vc.userName = arrChatList[0].messages?[indexPath.row].recipient?.name ?? ""
                vc.otherUserName = arrChatList[0].messages?[indexPath.row].sender?.name ?? ""
            }else{
                vc.receiverId = arrChatList[0].messages?[indexPath.row].sender?.id ?? ""
                vc.userName = arrChatList[0].messages?[indexPath.row].sender?.name ?? ""
                vc.otherUserName = arrChatList[0].messages?[indexPath.row].recipient?.name ?? ""
            }
            vc.callBack = {[weak self] in
                guard let self = self else { return }
                self.getMessage()
            }
        
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
