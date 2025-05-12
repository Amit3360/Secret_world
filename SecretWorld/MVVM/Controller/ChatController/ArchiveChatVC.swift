import UIKit

class ArchiveChatVC: UIViewController {

    @IBOutlet weak var imgVwDataFound: UIImageView!
    @IBOutlet weak var vwDataFound: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblVwChat: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var searchText = ""
    var arrChatList = [MessageListModel]()
    var type = ""
    var longSelectIndex = -1
    var isComing = ""
    var status = 0
    var isGroup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSet()
    }
    func uiSet(){
        if isComing == "archive"{
            lblTitle.text = "Archived"
            lblNoData.text = "You don't have archived chats yet"
        }else if isComing == "blocked"{
            lblTitle.text = "Blocked"
            lblNoData.text = "You don't have anyone blocked yet"
        }else{
            lblTitle.text = "Reported"
            lblNoData.text = "You don't have anyone reported yet"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tblVwChat.addGestureRecognizer(longPressGesture)
        
        if SocketIOManager.sharedInstance.socket?.status == .connected{
            self.getMessage(searchText: searchText)
        }else{
            SocketIOManager.sharedInstance.reConnectSocket(userId: Store.userId ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now()+4.0){
                self.getMessage(searchText: self.searchText)
            }
        }
    }
    func getMessage(searchText:String){
       
        let param = ["senderId": Store.userId ?? "","type":type,"search":searchText,"status":status] as [String : Any]
        SocketIOManager.sharedInstance.getUserMessage(dict: param)
     
        SocketIOManager.sharedInstance.messageData = {  data in
            
            self.arrChatList.removeAll()
            self.arrChatList = data ?? []
            if data?[0].messages?.count ?? 0 > 0 {
                self.vwDataFound.isHidden = true
                self.lblNoData.isHidden = true
                self.imgVwDataFound.isHidden = true
            } else {
                self.vwDataFound.isHidden = false
                self.lblNoData.isHidden = false
                self.imgVwDataFound.isHidden = false
            }
            self.tblVwChat.reloadData()
            
        }
        
    }

    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
//MARK: - UITABLEVIEWDELEGATE AND DATA SOURCE

extension ArchiveChatVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrChatList.count > 0{
            return arrChatList.first?.messages?.count ?? 0
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTVC", for: indexPath) as! ChatListTVC
        cell.btnPin.isHidden = true
        cell.btnFire.isHidden = true
        cell.btnMute.isHidden = true
        if longSelectIndex == indexPath.row{
            cell.vwChat.layer.masksToBounds = false
            cell.vwChat.layer.shadowColor = UIColor(hex: "#3E9C35").cgColor
            cell.vwChat.layer.shadowOpacity = 1.0
            cell.vwChat.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.vwChat.layer.shouldRasterize = true
            cell.vwChat.layer.rasterizationScale = UIScreen.main.scale
            cell.vwChat.layer.cornerRadius = 10
        }else{
            cell.vwChat.layer.masksToBounds = true
            cell.vwChat.layer.shadowColor = UIColor.clear.cgColor
            cell.vwChat.layer.shadowOpacity = 1.0
            cell.vwChat.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.vwChat.layer.shouldRasterize = true
            cell.vwChat.layer.rasterizationScale = UIScreen.main.scale
            cell.vwChat.layer.cornerRadius = 0
        }
        guard let messages = arrChatList.first?.messages, indexPath.row < messages.count else {
            return UITableViewCell() // or handle gracefully
        }
        let data = messages[indexPath.row]
        if data.groupID != nil{
            if data.media?.count ?? 0 > 0 {
                cell.lblMsg.text = "Media"
            }else{
                cell.lblMsg.text = data.message ?? ""
            }
            if data.unreadCount == 0{
                cell.lblMsgCount.text = ""
                cell.viewMsgCount.backgroundColor = .clear
            }else{
                if data.unreadCount ?? 0 > 9{
                    
                    cell.lblMsgCount.text = "9+"
                    cell.viewMsgCount.backgroundColor = UIColor(hex: "#3E9C35")
                }else{
                    
                    cell.lblMsgCount.text = "\(data.unreadCount ?? 0)"
                    cell.viewMsgCount.backgroundColor = UIColor(hex: "#3E9C35")
                }
            }
            cell.lblName.text = data.name ?? ""
            cell.lblTypeName.text = data.typeName ?? ""
//            cell.imgVwUser.imageLoad(imageUrl: data?.image ?? "")
            cell.imgVwUser.sd_setImage(
                with: URL(string: data.image ?? ""),
                placeholderImage: UIImage(named: "profile"),
                options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
            )
            cell.lblTime.text = formattedDateString(from: data.createdAt ?? "")
        }else{
            if data.media?.count ?? 0 > 0 {
                cell.lblMsg.text = "Media"
            }else{
                cell.lblMsg.text = data.message ?? ""
            }
            if (data.isUserPinned ?? false){
                cell.btnPin.isHidden = false
            }else{
                cell.btnPin.isHidden = true
            }
            if (data.isUserMuted ?? false){
                cell.btnMute.isHidden = false
            }else{
                cell.btnMute.isHidden = true
            }
            if data.sender?.id ?? "" == Store.userId ?? ""{
                cell.lblName.text = data.recipient?.name ?? ""
//                cell.imgVwUser.imageLoad(imageUrl: data?.recipient?.profilePhoto ?? "")
                cell.imgVwUser.sd_setImage(
                    with: URL(string: data.recipient?.profilePhoto ?? ""),
                    placeholderImage: UIImage(named: "profile"),
                    options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                )
                if data.recipient?.isOnline == true{
                    cell.imgVwOnline.image = UIImage(named: "chatOnline")
                }else{
                    cell.imgVwOnline.image = UIImage(named: "chatOffline")
                }
            }else{
                cell.lblName.text = data.sender?.name ?? ""
//                cell.imgVwUser.imageLoad(imageUrl: data?.sender?.profilePhoto ?? "")
                cell.imgVwUser.sd_setImage(
                    with: URL(string: data.sender?.profilePhoto ?? ""),
                    placeholderImage: UIImage(named: "profile"),
                    options: [.continueInBackground, .retryFailed, .scaleDownLargeImages]
                )
                if data.sender?.isOnline == true{
                    cell.imgVwOnline.image = UIImage(named: "chatOnline")
                }else{
                    cell.imgVwOnline.image = UIImage(named: "chatOffline")
                }
            }
            cell.lblTypeName.text = data.typeName ?? ""
            cell.lblTime.text = formattedDateString(from: data.createdAt ?? "")
            if data.unreadCount == 0{
                cell.lblMsgCount.text = ""
                cell.viewMsgCount.backgroundColor = .clear
                cell.widthMsgCount.constant = 0
                cell.leadingMsgCount.constant = -5
            }else{
                if data.unreadCount ?? 0 > 9{
                    cell.widthMsgCount.constant = 18
                    cell.lblMsgCount.text = "9+"
                    cell.viewMsgCount.backgroundColor = UIColor(hex: "#3E9C35")
                    cell.leadingMsgCount.constant = 5
                }else{
                    cell.widthMsgCount.constant = 18
                    cell.lblMsgCount.text = "\(data.unreadCount ?? 0)"
                    cell.viewMsgCount.backgroundColor = UIColor(hex: "#3E9C35")
                    cell.leadingMsgCount.constant = 5
                }
            }
        }
       
        
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
        
        return  90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
//        self.navigationController?.pushViewController(vc, animated: true)
        let data = arrChatList[0].messages?[indexPath.row]
        if data?.groupID != nil{
            isGroup = true
        }else{
            isGroup = false
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
        vc.isGroup = self.isGroup
        vc.chatType = arrChatList[0].messages?[indexPath.row].type ?? ""
        vc.isMoment = arrChatList[0].messages?[indexPath.row].isMoment ?? false
        vc.typeName = arrChatList[0].messages?[indexPath.row].typeName ?? ""
        vc.typeId = arrChatList[0].messages?[indexPath.row].typeId ?? ""
        if isGroup == true{
            vc.gigId = data?.groupID ?? ""
            vc.gigName = data?.name ?? ""
            vc.gigImg = data?.image ?? ""
           let arrName = data?.group?.participantsNames ?? []
            let resultString = arrName.joined(separator: ", ")
            vc.participantUser = resultString
            vc.callBack = {[weak self] in
                guard let self = self else { return }
                self.getMessage(searchText: self.searchText)
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
                self.getMessage(searchText: self.searchText)
            }

        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let touchPoint = gesture.location(in: tblVwChat)
        
        if let indexPath = tblVwChat.indexPathForRow(at: touchPoint), gesture.state == .began {
            self.longSelectIndex = indexPath.row
            self.tblVwChat.reloadData()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatUserOptionVC") as! ChatUserOptionVC
            vc.modalPresentationStyle = .overFullScreen
            vc.messageId = arrChatList[0].messages?[indexPath.row].id ?? ""
            vc.isPin = arrChatList[0].messages?[indexPath.row].isUserPinned ?? false
            vc.isMute = arrChatList[0].messages?[indexPath.row].isUserMuted ?? false
            vc.isArchive = arrChatList[0].messages?[indexPath.row].isUserArchived ?? false
            if arrChatList[0].messages?[indexPath.row].sender?.id ?? "" == Store.userId ?? ""{
                vc.userName = arrChatList[0].messages?[indexPath.row].recipient?.name ?? ""
                vc.receiverId = arrChatList[0].messages?[indexPath.row].recipient?.id ?? ""
            }else{
                vc.receiverId = arrChatList[0].messages?[indexPath.row].sender?.id ?? ""
                vc.userName = arrChatList[0].messages?[indexPath.row].sender?.name ?? ""
            }
            vc.callBack = { (index) in
                if index == 0{
                    self.longSelectIndex = -1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                        self.tblVwChat.reloadData()
                    }
                    
                   
             
                    if self.arrChatList[0].messages?[indexPath.row].sender?.role ?? "" == "user"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewVC") as! ProfileViewVC
                        vc.isComingChat = true
                        if self.arrChatList[0].messages?[indexPath.row].sender?.id ?? "" == Store.userId ?? ""{
                            
                            vc.id = self.arrChatList[0].messages?[indexPath.row].recipient?.id ?? ""
                        }else{
                            vc.id = self.arrChatList[0].messages?[indexPath.row].sender?.id ?? ""
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileVC") as! BusinessProfileVC
                        vc.isComing = false
                        if self.arrChatList[0].messages?[indexPath.row].sender?.id ?? "" == Store.userId ?? ""{
                            
                            vc.businessId = self.arrChatList[0].messages?[indexPath.row].recipient?.id ?? ""
                        }else{
                            vc.businessId = self.arrChatList[0].messages?[indexPath.row].sender?.id ?? ""
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    }else if index == 3{

                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteChatPopupVC") as! DeleteChatPopupVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.isComing = "Archive"
                        vc.callBack = { [self] (status) in
                            if status == true{
                                
                                let param:parameters = ["messageId":self.arrChatList[0].messages?[indexPath.row].id ?? "","userId":Store.userId ?? "","type":type]
                                SocketIOManager.sharedInstance.archiveChat(dict: param)
                            }
                        self.longSelectIndex = -1
                            self.tblVwChat.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                              
                                self.getMessage(searchText: "")
                            }
                        }
                        self.navigationController?.present(vc, animated: true)
                    }else if index == 4{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteChatPopupVC") as! DeleteChatPopupVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.isComing = "Delete"
                        vc.callBack = { (status) in
                            if status == true{
                                if self.arrChatList[0].messages?[indexPath.row].sender?.id ?? "" == Store.userId ?? ""{
                                    let param:parameters = ["otherUserId":self.arrChatList[0].messages?[indexPath.row].recipient?.id ?? "","userId":Store.userId ?? "","type":self.type]
                                    SocketIOManager.sharedInstance.deleteChat(dict: param)
                                   
                                }else{
                                    let param:parameters = ["otherUserId":self.arrChatList[0].messages?[indexPath.row].sender?.id ?? "","userId":Store.userId ?? "","type":self.type]
                                    SocketIOManager.sharedInstance.deleteChat(dict: param)
                                    
                                }
                               
                            }
                            
                            self.longSelectIndex = -1
                            self.tblVwChat.reloadData()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                               
                                self.getMessage(searchText: "")
                            }
                        }
                        self.navigationController?.present(vc, animated: true)

                    
                }else{
                    self.longSelectIndex = -1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                        self.tblVwChat.reloadData()
                        self.getMessage(searchText: "")
                    }
                }
              
               
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
}
