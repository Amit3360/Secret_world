import UIKit
import TOCropViewController
import SDWebImage
import IQKeyboardManagerSwift
import QBImagePickerController

protocol VoicePlayableCell: AnyObject {
    var lblRecordTime: UILabel! { get }
    var vwWave: UIView! { get }
}

class ChatDetailVC: UIViewController {
    
    @IBOutlet weak var waveRecordingVw: UIView!
    @IBOutlet weak var txtFldSearchChat: UITextField!
    
    @IBOutlet weak var vwMultipleImg: UIView!
    @IBOutlet weak var vwSearchChat: UIView!
    @IBOutlet weak var lblRecodingTime: UILabel!
    @IBOutlet weak var vwRecoding: UIView!
    @IBOutlet weak var topReactionVw: NSLayoutConstraint!
    @IBOutlet weak var vwReaction: UIView!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var vwBlock: UIView!
    @IBOutlet weak var lblBlockUser: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnFire: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblOnlineOffline: UILabel!
    @IBOutlet weak var lblReceiverName: UILabel!
    @IBOutlet weak var imgVwReceiver: UIImageView!
    @IBOutlet weak var widthCamera: NSLayoutConstraint!
    @IBOutlet weak var vwSend: UIView!
    @IBOutlet weak var vwRecord: UIView!
    @IBOutlet weak var bottomStackVw: NSLayoutConstraint!
    @IBOutlet weak var vwAttach: UIView!
    @IBOutlet weak var tblVwChat: UITableView!
    @IBOutlet weak var collVwQuestion: UICollectionView!
    @IBOutlet weak var imgVwBackground: UIImageView!
    @IBOutlet weak var txtVwMessage: IQTextView!
    @IBOutlet weak var topBackgroundImg: NSLayoutConstraint!
    @IBOutlet weak var cropContainerView: UIView!
    @IBOutlet weak var collVwMultipleImg: UICollectionView!
    @IBOutlet weak var btnChatScroll: UIButton!
    
    var arrQustion = ["Hey, what's on the menu?","What's the deal right now?","Can i send ya tasker to you"]
    var receiverId = ""
    var arrImage = [Any]()
    
    var viewModel = UploadImageVM()
    var blockStatusMe = false
    var blockStatusOther = false
    var arrMessages = [Message]()
    var arrGroupMessages = [GroupChatDetail]()
    var messageDictionary = [String: [Message]]()
    var currrentDate = ""
    var yesterDayDate = ""
    //var groupedMessages: [Date: [String: [Message]]] = [:]
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
    var chatType = ""
    var typeId = ""
    var typeName = ""
    var selectMessageId = ""
    private let waveformView = BarWaveformView()
    private var audioRecorder = AudioRecorder()
    var audioPlayer: AVAudioPlayer?
    var recordingTimer: Timer?
    var recordingDuration: Int = 0
    var isRecording = false
    var isEmit = true
    var recordUlr:URL?
    var viewModelMessage = MessageVM()
    var socketId = ""
    var seenStatus = true
    var player: AVAudioPlayer?
    var currentPlayingButton: IndexPathButton?
    var playbackTimer: Timer?
    var playbackProgressTimer: Timer?
    var waveformUpdateTimer: Timer?
    var playbackProgress: [IndexPath: CGFloat] = [:]
    var isSearchChat = false
    var viewModelTask = AddGigVM()
    var myTask = false
    var getData = false
    var viewModelPopup = PopUpVM()
    var viewModelMoment = MomentsVM()
    var viewModelBusiness = ExploreVM()
    var matchingIndexes: [IndexPath] = []
    var currentMatchIndex: Int = 0
    var nickName = ""
    var orignalName = ""
    var imagesToCrop: [UIImage] = []
    var currentCroppingIndex: Int = 0
    var selectImgCount = 0
    var croppedImages: [UIImage?] = []
    var lastContentOffset: CGFloat = 0
    var isMoment = false
    var typeNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
    }
    
    func uiSet(){
        [lblOnlineOffline, lblReceiverName, imgVwReceiver].forEach {
            $0?.isUserInteractionEnabled = true
        }
        
        lblOnlineOffline.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
        lblReceiverName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
        imgVwReceiver.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        let nib = UINib(nibName: "TypeNameTVC", bundle: nil)
        tblVwChat.register(nib, forCellReuseIdentifier: "TypeNameTVC")

        let nibImages = UINib(nibName: "MultipleImagesCVC", bundle: nil)
        collVwMultipleImg.register(nibImages, forCellWithReuseIdentifier: "MultipleImagesCVC")
        SocketIOManager.sharedInstance.seenMessageData = {
            self.getChat(open: true)
        }
        
        cropContainerView.isHidden = true
        vwMultipleImg.isHidden = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let waveformWidth = view.frame.width - 40
        let waveformHeight: CGFloat = 50
        waveformView.frame = CGRect(x: 0, y: 0, width: waveformWidth-150, height: waveformHeight)
        waveformView.waveColor = .app
        waveformView.backgroundColor = .clear
        waveRecordingVw.addSubview(waveformView)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tblVwChat.addGestureRecognizer(longPressGesture)
        self.vwSend.isHidden = true
        if chatType == "task"{
            btnFire.isHidden = true
            if !isMoment{
                
                viewModelTask.GetBuisnessGigDetailApi(gigId: typeId) { data in
                    
                    if data?.status == 1{
                        self.btnFire.isHidden = false
                        self.btnFire.setImage(UIImage(named: "chatFire"), for: .normal)
                        self.btnFire.isUserInteractionEnabled = true
                        self.imgVwBackground.image = UIImage(named: "chatBackground")
                    }else if data?.status == 2{
                        self.btnFire.isHidden = false
                        self.btnFire.isUserInteractionEnabled = false
                        self.btnFire.setImage(UIImage(named: "completeChat"), for: .normal)
                        self.imgVwBackground.image = UIImage(named: "backgroundBorder")
                    }else{
                        self.btnFire.isHidden = true
                        self.btnFire.isUserInteractionEnabled = true
                        self.btnFire.setImage(UIImage(named: "chatFire"), for: .normal)
                        self.imgVwBackground.image = UIImage(named: "chatBackground")
                    }
                    
                    
                    self.typeName = "\(data?.title ?? "") \(data?.category?.name ?? "")"
                    self.typeId = data?.id ?? ""
                    self.getData = true
                    if data?.user?.id == Store.userId {
                        self.myTask = true
                    }else{
                        self.myTask = false
                    }
                }
            }else{
                
                viewModelMoment.getMomentDetails(id: typeId) { data in
                   // self.typeName = data?.title ?? ""
                   // self.typeId = data?.userId?.id ?? ""
                    self.typeId = data?._id ?? ""
                    self.getData = true
                    if data?.userId?.id == Store.userId {
                        self.myTask = true
                    }else{
                        self.myTask = false
                    }
                }
            }
        }else if chatType == "popup"{
            self.viewModelPopup.getPopupDetailApi(loader: true, popupId: typeId) { data in
                self.typeName = data?.name ?? ""
                self.typeId = data?.id ?? ""
                if data?.user?.id == Store.userId {
                    self.myTask = true
                }else{
                    self.myTask = false
                }
            }
            getData = true
            btnFire.isHidden = true
        }else{
            viewModelBusiness.GetUserServiceDetailApi(user_id: typeId, loader: true) { data in
                self.typeName = data?.getBusinessDetails?.businessname ?? ""
                self.typeId = data?.getBusinessDetails?.id ?? ""
                if data?.getBusinessDetails?.userID == Store.userId {
                    self.myTask = true
                }else{
                    self.myTask = false
                }
            }
            getData = true
            btnFire.isHidden = true
        }
        setupKeyboardObservers()
        let deviceHasNotch = UIApplication.shared.hasNotch
        if deviceHasNotch{
            topBackgroundImg.constant = 0
            imgVwBackground.contentMode = .scaleAspectFill
        }else{
            topBackgroundImg.constant = 5
            imgVwBackground.contentMode = .scaleToFill
            
        }
        tblVwChat.showsVerticalScrollIndicator = false
        
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
        
        let readParam = ["senderId":Store.userId ?? ""]
        SocketIOManager.sharedInstance.readMessage(dict: readParam)
        
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
    @objc func profileTapped(_ sender: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewVC") as! ProfileViewVC
        vc.id = receiverId
        vc.isComingChat = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissKeyboardWhileClick() {
        view.endEditing(true)
    }
    
    @objc func handleSwipe() {
        self.navigationController?.popViewController(animated: true)
        
        receiveChat(isOpen: true)
        callBack?()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    func emitSeenMsg(){
        let param = ["userId": Store.userId ?? "", "otherUserId": self.receiverId,"status":seenStatus] as [String: Any]
        print("Param----------", param)
        SocketIOManager.sharedInstance.seenMsg(dict: param)
        //        DispatchQueue.main.asyncAfter(deadline: .now()+2.0){
        //            self.getChat(open: true)
        //        }
        
    }
    func getChat(open: Bool) {
        self.emitSeenMsg()
        self.getUserDetailApi()
        let param = ["senderId": Store.userId ?? "", "receiverId": self.receiverId, "isOpen": open,"type": chatType] as [String: Any]
        print("Param----------", param)
        
        SocketIOManager.sharedInstance.getMessageList(dict: param)
        SocketIOManager.sharedInstance.chatData = { data in
            
            //            let messageId = data?[0].messages?[(data?[0].messages?.count ?? 0)-1]
            
            //            self.emitSeenMsg(messageId: "")
            DispatchQueue.main.asyncAfter(deadline: .now()){
                self.lblBlockUser.text = ""
                
                guard let messages = data?.first?.messages, !messages.isEmpty else {
                    // Handle case where there are no messages
                    return
                }
                
                if self.receiverId == data?[0].messages?[0].recipient?.id ?? "" || self.receiverId == data?[0].messages?[0].sender?.id ?? "" {
                    if data?[0].userOnline == true {
                        self.lblOnlineOffline.text = "Online"
                    } else {
                        self.lblOnlineOffline.text = "Offline"
                    }
                    
                    self.blockStatusMe = data?[0].userBlocked ?? false
                    self.blockStatusOther = data?[0].blockedByUser ?? false
                    
                    if self.blockStatusMe == true {
                        self.vwMessage.isHidden = true
                        self.vwBlock.isHidden = false
                        self.lblBlockUser.text = "You have blocked \(self.userName) Unblock them to continue chatting."
                        
                    } else if self.blockStatusOther == true {
                        self.vwMessage.isHidden = true
                        self.vwBlock.isHidden = false
                        self.lblBlockUser.text =  "You have been blocked by \(self.userName)"
                    } else {
                        
                        self.vwMessage.isHidden = false
                        self.vwBlock.isHidden = true
                        self.lblBlockUser.text =  ""
                    }
                    
                    self.arrMessages.removeAll()
                    self.dates.removeAll()
                    self.groupedMessages.removeAll()
                    self.typeNames.removeAll()
                    self.arrMessages.append(contentsOf: data?[0].messages ?? [])
                    
                    for index in 0..<self.arrMessages.count {
                        print("typeName:",self.arrMessages[index].typeName ?? "")
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
                    
                    self.tblVwChat.scrollToBottom(animated: true)
                    self.tblVwChat.estimatedRowHeight = 50
                    self.tblVwChat.rowHeight = UITableView.automaticDimension
                    self.tblVwChat.reloadData()
                    
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
        //        lblUserName.text = gigName
        //        imgVwProfile.imageLoad(imageUrl: gigImg)
        //        lblOnline.text = participantUser
        SocketIOManager.sharedInstance.getGroupChat(dict: param)
        SocketIOManager.sharedInstance.groupData = { data in
            if data?[0].groupChatDetails?.count ?? 0 > 0{
                if data?[0].groupChatDetails?[0].group?.id == self.gigId{
                    //                    self.lblBlockText.text = ""
                    //                    self.lblBlockText.isHidden = true
                    //                    self.heightMessageVw.constant = 50
                    
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
                    
                    self.tblVwChat.scrollToBottom(animated: true)
                    self.tblVwChat.estimatedRowHeight = 50
                    self.tblVwChat.rowHeight = UITableView.automaticDimension
                    self.tblVwChat.reloadData()
                }
            }
        }
    }
    
    
    func getUserDetailApi(){
        viewModel.getUserDetail(receiverId: receiverId) { data in
            self.userType = data?.userProfile?.usertype ?? ""
            if data?.userProfile?.nickName == "" || data?.userProfile?.nickName == nil{
                self.lblReceiverName.text = data?.userProfile?.name ?? ""
                self.nickName = data?.userProfile?.name ?? ""
            }else{
                self.nickName = data?.userProfile?.nickName ?? ""
                self.lblReceiverName.text = data?.userProfile?.nickName ?? ""
            }
            self.orignalName = data?.userProfile?.name ?? ""
            self.imgVwReceiver.imageLoad(imageUrl: data?.userProfile?.profilePhoto ?? "")
            
            if data?.userProfile?.isOnline == true{
                self.lblOnlineOffline.text = "Online"
            }else{
                self.lblOnlineOffline.text = "Offline"
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
                //                    self.emitSeenMsg(messageId: "")
                
                self.getChat(open: isOpen)
                
            }
        }
        
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let touchPoint = gesture.location(in: tblVwChat)
        
        if let indexPath = tblVwChat.indexPathForRow(at: touchPoint),
           let cell = tblVwChat.cellForRow(at: indexPath),
           gesture.state == .began {
            
            
            let date = dates[indexPath.section]
            let messagesForDate = groupedMessages[date]
            let message = messagesForDate?[indexPath.row]
            self.selectMessageId = message?.id ?? ""
            if message?.media?.count == 0{
                
                if message?.sender?.id != Store.userId {
                    vwReaction.isHidden = false
                    
                    let cellFrameInView = tblVwChat.convert(cell.frame, to: self.view)
                    
                    topReactionVw.constant = cellFrameInView.maxY - 150
                    self.view.layoutIfNeeded()
                }
                
            }else{
                
                if message?.sender?.id != Store.userId {
                    vwReaction.isHidden = false
                    
                    let cellFrameInView = tblVwChat.convert(cell.frame, to: self.view)
                    
                    topReactionVw.constant = cellFrameInView.maxY - 160
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    @IBAction func actionReaction(_ sender: UIButton) {
        print(sender.tag)
        let param = ["userId": Store.userId ?? "","messageId":selectMessageId,"reaction":sender.tag,"otherUserId":self.receiverId] as [String : Any]
        SocketIOManager.sharedInstance.messageReact(dict: param)
        self.vwReaction.isHidden = true
        //        self.getChat(open: true)
    }
    
    @IBAction func actionSendMessage(_ sender: Any) {
        if self.arrImage.count > 0 {
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                self.viewModel.uploadImageApi(image: self.arrImage) { data in
                    self.arrImage.removeAll()
                    self.arrImage.append(contentsOf: data?.imageUrls ?? [String]())
                    if self.arrImage.count >= 4{
                        if self.isGroup == true{
                            let param = ["senderId":Store.userId ?? "","groupId":self.gigId,"media":self.arrImage,"type":self.chatType,"typeName":self.typeName,"typeId":self.typeId,"message":self.txtVwMessage.text ?? ""] as [String : Any]
                            SocketIOManager.sharedInstance.sendMessage(dict: param)
                            print("Param------",param)
                            self.txtVwMessage.text = ""
                            self.txtVwMessage.resignFirstResponder()
                            
                        }else{
                            
                            let param = ["senderId":Store.userId ?? "","receiverId":self.receiverId,"media":self.arrImage,"type":self.chatType,"typeName":self.typeName,"typeId":self.typeId,"message":self.txtVwMessage.text ?? "","isMoment":self.isMoment] as [String : Any]
                            print("Param------",param)
                            self.txtVwMessage.text = ""
                            self.txtVwMessage.resignFirstResponder()
                            SocketIOManager.sharedInstance.sendMessage(dict: param)
                            
                        }
                        
                    }else{
                        for imageUrl in self.arrImage {
                            if self.isGroup == true{
                                let param = ["senderId": Store.userId ?? "", "groupId": self.gigId, "media": [imageUrl],"type":self.chatType,"typeName":self.typeName,"typeId":self.typeId,"message":self.txtVwMessage.text ?? ""] as [String : Any]
                                print("Param------",param)
                                SocketIOManager.sharedInstance.sendMessage(dict: param)
                                
                            }else{
                                let param = ["senderId": Store.userId ?? "", "receiverId": self.receiverId, "media": [imageUrl],"type":self.chatType,"typeName":self.typeName,"typeId":self.typeId,"message":self.txtVwMessage.text ?? "","isMoment":self.isMoment] as [String : Any]
                                print("Param------",param)
                                SocketIOManager.sharedInstance.sendMessage(dict: param)
                                
                            }
                            
                        }
                    }
                    self.arrImage.removeAll()
                    self.vwMultipleImg.isHidden = true
                    self.vwRecord.isHidden = false
                    self.vwSend.isHidden = true
                    self.widthCamera.constant = self.txtVwMessage.text.isEmpty ? 44 : 0
                    
                    
                }
            }
        }else{
            
            if txtVwMessage.text != ""{
                if isGroup == true{
                    
                    let param = ["senderId":Store.userId ?? "","groupId":self.gigId,"message":txtVwMessage.text ?? "","type":chatType,"typeName":self.typeName,"typeId":self.typeId]
                    SocketIOManager.sharedInstance.sendMessage(dict: param)
                    
                    self.txtVwMessage.text = ""
                    self.txtVwMessage.resignFirstResponder()
                    
                }else{
                    
                    let param = ["senderId":Store.userId ?? "","receiverId":self.receiverId,"message":txtVwMessage.text ?? "","type":chatType,"typeName":self.typeName,"typeId":self.typeId,"isMoment":self.isMoment] as [String : Any]
                    SocketIOManager.sharedInstance.sendMessage(dict: param)
                    self.txtVwMessage.text = ""
                    self.txtVwMessage.resignFirstResponder()
                    
                }
            }else{
                print("Empty message")
            }
        }
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        seenStatus = false
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            self.emitSeenMsg()
            self.navigationController?.popViewController(animated: true)
            
        }
        
        
    }
    @IBAction func actionAttach(_ sender: UIButton) {
        self.vwAttach.isHidden = false
    }
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.async {
                
                let picker: UIImagePickerController = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                self.addChild(picker)
                picker.didMove(toParent: self)
                self.view!.addSubview(picker.view!)
            }
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
        imagePickerController.maximumNumberOfSelection = UInt(10 - arrImage.count)
        selectImgCount = Int(UInt(10 - arrImage.count))
        imagePickerController.mediaType = .image
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func openGallaryVideo() {
        let imagePickerController = QBImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.allowsMultipleSelection = true
        imagePickerController.maximumNumberOfSelection = UInt(10 - arrImage.count)
        selectImgCount = Int(UInt(10 - arrImage.count))
        imagePickerController.mediaType = .video
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func actionSendRecording(_ sender: UIButton) {
        isEmit = false
        vwMessage.isHidden = false
        vwRecoding.isHidden = true
        audioRecorder.stopRecording()
        
        audioRecorder.audioUrl = { [weak self] url in
            guard let self = self else { return }
            self.recordUlr = url
            print("Url-----", url)
            
            self.viewModelMessage.fileUploadAudio(audio: url) { data in
                print("Data--",data?.imageUrls)
                let uploadedUrls = data?.imageUrls ?? []
                print("Uploaded URLs:", uploadedUrls)
                
                guard !uploadedUrls.isEmpty else {
                    print("❌ No uploaded URLs found, not emitting.")
                    return
                }
                
                self.txtVwMessage.text = ""
                
                let jsonObject: [String: Any] = [
                    "senderId": Store.userId ?? "",
                    "receiverId": self.receiverId,
                    "media": uploadedUrls,
                    "type": self.chatType,"typeName":self.typeName,"typeId":self.typeId
                ]
                
                print("✅ Emitting JSON:", jsonObject)
                print("Socket connected: \(SocketIOManager.sharedInstance.socket?.status == .connected)")
                
                SocketIOManager.sharedInstance.sendMessage(dict: jsonObject)
            }
            self.waveformView.reset()
        }
    }
    
    @IBAction func actionDeleteRecording(_ sender: UIButton) {
        self.vwMessage.isHidden = false
        self.vwRecoding.isHidden = true
        
        
        isRecording = false
        recordingDuration = 0
        lblRecodingTime.text = "0:00"
        
        audioRecorder.stopRecording()
        
        audioRecorder.audioUrl = { [weak self] url in
            guard let self = self else { return }
            
            audioRecorder.deleteFile(at: url)
            self.waveformView.reset()
        }
    }
    
    @IBAction func actionVoiceRecord(_ sender: UIButton) {
        self.vwMessage.isHidden = true
        self.vwRecoding.isHidden = false
        
        
        isRecording = true
        recordingDuration = 0
        lblRecodingTime.text = "0:00"
        audioRecorder.onAudioLevelUpdate = { [weak self] level in
            self?.waveformView.updateWave(with: level)
        }
        
        requestMicrophonePermission { granted in
            if granted {
                self.audioRecorder.startRecording()
            } else {
                print("Microphone access denied")
                // Optionally, show an alert to the user here
            }
        }
        startRecordingTimer()
    }
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    func startRecordingTimer() {
        recordingTimer?.invalidate() // Invalidate any existing timer
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordingDuration += 1
            self.lblRecodingTime.text = self.formatTime(self.recordingDuration)
        }
    }
    
    // Function to format time in mm:ss format
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func actionCamera(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose an option", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Upload Image From Gallery", style: .default) { _ in
            self.openGallery()
        }
        let galleryVideoAction = UIAlertAction(title: "Upload Video From Gallery", style: .default) { _ in
            self.openGallaryVideo()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(galleryVideoAction)
        alertController.addAction(cancelAction)
        
        // For iPad support
        alertController.popoverPresentationController?.sourceView = sender
        alertController.popoverPresentationController?.sourceRect = sender.bounds
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionSearch(_ sender: UIButton) {
        if !isSearchChat{
            vwSearchChat.isHidden = false
            isSearchChat = true
            btnSearch.isHidden = true
        }else{
            txtFldSearchChat.text = ""
            scrollToFirstMatchingMessageSafely(searchText: "")
            scrollToBottom()
            vwSearchChat.isHidden = true
            isSearchChat = false
            btnSearch.isHidden = false
        }
    }
    @IBAction func actionFire(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteChatPopupVC") as! DeleteChatPopupVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.isComing = "Complete"
        vc.callBack = { (status) in
            if status{
                self.viewModelTask.CompleteGigApi(gigid: self.typeId) { message in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                    vc.isSelect = 10
                    vc.message = message
                    vc.callBack = {[weak self] in
                        guard let self = self else { return }
                        self.uiSet()
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    self.navigationController?.present(vc, animated: true)
                    
                }
            }
        }
        self.navigationController?.present(vc, animated: true)
        
        
        
        
    }
    @IBAction func actionMore(_ sender: UIButton) {
        self.txtVwMessage.resignFirstResponder()
        if getData{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ChatOptionVC") as! ChatOptionVC
            vc.modalPresentationStyle = .popover
            vc.blockStatusMe = self.blockStatusMe
            vc.blockStatusOther = self.blockStatusOther
            vc.receiverId = self.receiverId
            vc.myTask = self.myTask
            vc.callBack = { (isReport,inbox) in
                if inbox == 1{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NicknamePopupVC") as! NicknamePopupVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.receiverId = self.receiverId
                    vc.nickName = self.nickName
                    vc.orignalName = self.orignalName
                    vc.chatType = self.chatType
                    vc.callBack = { (name) in
                        self.lblReceiverName.text = name
                        
                    }
                    self.navigationController?.present(vc, animated: true)
                }else if inbox == 2{
                    if self.chatType == "task"{
                        // also for moment
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSideMomentDetailVC") as! UserSideMomentDetailVC
                        vc.momentId = self.typeId
                        self.navigationController?.pushViewController(vc, animated: true)

//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskSummaryVC") as! TaskSummaryVC
//                        vc.taskId = self.typeId
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if self.chatType == "moment"{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSideMomentDetailVC") as! UserSideMomentDetailVC
                        vc.momentId = self.typeId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if self.chatType == "popup"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupSummaryVC") as! PopupSummaryVC
                        vc.popupId = self.typeId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessSummaryVC") as! BusinessSummaryVC
                        vc.businessId = self.receiverId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }else if inbox == 3{
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
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteChatPopupVC") as! DeleteChatPopupVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.receiverId = self.receiverId
                    vc.blockStatusMe = self.blockStatusMe
                    vc.blockStatusOther = self.blockStatusOther
                    vc.chatType = self.chatType
                    vc.isComing = "block"
                    vc.callBack = { (status) in
                        self.getChat(open: true)
                    }
                    self.navigationController?.present(vc, animated: true)
                }
                //            if isReport == true{
                //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
                //                vc.receiverId = self.receiverId
                //                vc.callBack = { message in
                //                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                //                    vc.modalPresentationStyle = .overFullScreen
                //                    vc.message = message
                //                    vc.isSelect = 10
                //                    self.navigationController?.present(vc, animated: true)
                //                    self.getChat(open: true)
                //                }
                //                vc.modalPresentationStyle = .overFullScreen
                //                self.navigationController?.present(vc, animated: true)
                //            }else{
                //
                //                self.getChat(open: true)
                //            }
                
            }
            if myTask{
                vc.preferredContentSize = CGSize(width: 165, height: 150)
            }else{
                vc.preferredContentSize = CGSize(width: 165, height: 200)
            }
            
            
            let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
            popOver.sourceView = sender
            popOver.delegate = self
            popOver.permittedArrowDirections = .up
            self.present(vc, animated: false)
        }
    }
    
    @IBAction func actionChatScroll(_ sender: UIButton) {
        scrollToBottom()
    }
    func scrollToBottom() {
        let numberOfSections = tblVwChat.numberOfSections
        if numberOfSections > 0 {
            let numberOfRows = tblVwChat.numberOfRows(inSection: numberOfSections - 1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                tblVwChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

// MARK: - Popup

extension ChatDetailVC : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
        
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}

extension ChatDetailVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwQuestion{
            return 3
        }else{
            return arrImage.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwQuestion{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggetionQuestionCVC", for: indexPath) as! SuggetionQuestionCVC
            cell.lblQuestion.text = arrQustion[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultipleImagesCVC", for: indexPath) as! MultipleImagesCVC
            print(print("data",arrImage))
            let item = arrImage[indexPath.row]
            
            if let image = item as? UIImage {
                // Set image directly
                cell.imgVwSelected.image = image
                cell.imgVwPlay.isHidden = true
            } else if let videoURL = item as? URL {
                // Show video thumbnail
                let asset = AVAsset(url: videoURL)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                imageGenerator.appliesPreferredTrackTransform = true
                
                do {
                    let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
                    let thumbnail = UIImage(cgImage: cgImage)
                    cell.imgVwSelected.image = thumbnail
                    cell.imgVwPlay.isHidden = false
                } catch {
                    print("Failed to generate thumbnail for video:", error)
                }
            }
            cell.btnCross.addTarget(self, action: #selector(deleteMultiImg), for: .touchUpInside)
            cell.btnCross.tag = indexPath.row
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwQuestion{
            let text = arrQustion[indexPath.row]
            let font = UIFont.systemFont(ofSize: 10)
            let padding: CGFloat = 26
            
            let textWidth = text.size(withAttributes: [NSAttributedString.Key.font: font]).width
            let width = textWidth + padding
            let height: CGFloat = 22
            
            return CGSize(width: width, height: height)
        }else{
            return CGSize(width: 80, height: 80)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
        vc.arrData = self.arrImage
        vc.index = indexPath.row
        vc.isComing = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    @objc func deleteMultiImg(sender:UIButton){
        arrImage.remove(at: sender.tag)
        collVwMultipleImg.reloadData()
        if arrImage.count > 0{
            self.vwMultipleImg.isHidden = false
        }else{
            self.vwMultipleImg.isHidden = true
            self.vwRecord.isHidden = false
            self.vwSend.isHidden = true
        }
    }
}

//MARK: -UITableViewDelegate
extension ChatDetailVC: UITableViewDelegate,UITableViewDataSource{
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
                //                cell.gradiantVw.startColor = UIColor(hex: "#EFF7EE").withAlphaComponent(0.7)
                //                cell.gradiantVw.endColor = UIColor(hex: "#8C918C").withAlphaComponent(0.7)
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
        45
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
                    
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                    cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                    cell.vwMessage.layer.cornerRadius = 10
                    cell.vwMessage.clipsToBounds = true
                    cell.vwMessage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
                    
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverTVC", for: indexPath) as! RecieverTVC
                    
                    cell.lblMessage.text = message?.message ?? ""
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                    cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                    
                    cell.vwMessage.layer.cornerRadius = 10
                    cell.vwMessage.clipsToBounds = true
                    cell.vwMessage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                    
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
                        //                               self.navigationController?.pushViewController(vc, animated: true)
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false)
                    }
                    
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                    cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                    cell.vwImg.layer.cornerRadius = 10
                    cell.vwImg.clipsToBounds = true
                    cell.vwImg.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
                    
                    
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
                        //                               self.navigationController?.pushViewController(vc, animated: true)
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false)
                    }
                    
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                    cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                    cell.vwImage.layer.cornerRadius = 10
                    cell.vwImage.clipsToBounds = true
                    cell.vwImage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
                    
                    return cell
                }
            }
            
        }else{
            let date = dates[indexPath.section]
            let messagesForDate = groupedMessages[date]
            let message = messagesForDate?[indexPath.row]
            if message?.media?.count == 0{
                print(message?.typeName ?? "")
                if message?.sender?.id == Store.userId {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTVC", for: indexPath) as! SenderTVC
                    
                    //                        cell.lblMessage.text = message?.message ?? ""
                    if let messageText = message?.message,
                       let searchText = txtFldSearchChat.text,
                       !searchText.isEmpty {
                        
                        let attributedString = NSMutableAttributedString(string: messageText)
                        let range = (messageText as NSString).range(of: searchText, options: .caseInsensitive)
                        
                        if range.location != NSNotFound {
                            attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
                            cell.lblMessage.attributedText = attributedString
                        } else {
                            // If not found, show normal text
                            cell.lblMessage.attributedText = NSAttributedString(string: messageText)
                        }
                        
                    } else {
                        // In case text field is empty
                        cell.lblMessage.text = message?.message
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                    cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                    
                    if message?.msgStatus == "seen"{
                        cell.imgVwTick.image = UIImage(named: "seenMessage")
                    }else if message?.msgStatus == "delivered"{
                        cell.imgVwTick.image = UIImage(named: "doubleTick")
                    }else{
                        cell.imgVwTick.image = UIImage(named: "singleTick")
                    }
                    
                    let customPathView = BrezerPath()
                    customPathView.translatesAutoresizingMaskIntoConstraints = false
                    customPathView.backgroundColor = .clear
                    cell.vwNotch.subviews.forEach { view in
                        if view is BrezerPath {
                            view.removeFromSuperview()
                        }
                    }
                    cell.vwNotch.addSubview(customPathView)
                    
                    
                    NSLayoutConstraint.activate([
                        customPathView.topAnchor.constraint(equalTo: cell.vwNotch.topAnchor),
                        customPathView.leadingAnchor.constraint(equalTo: cell.vwNotch.leadingAnchor),
                        customPathView.trailingAnchor.constraint(equalTo: cell.vwNotch.trailingAnchor),
                        customPathView.bottomAnchor.constraint(equalTo: cell.vwNotch.bottomAnchor)
                    ])
                    cell.vwNotch.layoutIfNeeded()
                    customPathView.frame = cell.vwNotch.bounds
                    cell.vwReactionFirst.isHidden = true
                    cell.vwReactionSecond.isHidden = true
                    cell.vwReactionThird.isHidden = true
                    if message?.reactionList?.count ?? 0 > 0{
                        cell.bottomReactionVw.constant = -5
                    }else{
                        cell.bottomReactionVw.constant = -15
                    }
                    if let emojiTypes = message?.reactionList?.first?.emojiTypes {
                        print("Emojitypes---", emojiTypes)
                        
                        if emojiTypes.contains(0) {
                            cell.vwReactionFirst.isHidden = false
                        }
                        if emojiTypes.contains(1) {
                            cell.vwReactionSecond.isHidden = false
                        }
                        if emojiTypes.contains(2) {
                            cell.vwReactionThird.isHidden = false
                        }
                    }
                    
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverTVC", for: indexPath) as! RecieverTVC
                    //                           cell.lblMessage.text = message?.message ?? ""
                    if let messageText = message?.message,
                       let searchText = txtFldSearchChat.text,
                       !searchText.isEmpty {
                        
                        let attributedString = NSMutableAttributedString(string: messageText)
                        let range = (messageText as NSString).range(of: searchText, options: .caseInsensitive)
                        
                        if range.location != NSNotFound {
                            attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
                            cell.lblMessage.attributedText = attributedString
                        } else {
                            // If not found, show normal text
                            cell.lblMessage.attributedText = NSAttributedString(string: messageText)
                        }
                        
                    } else {
                        // In case text field is empty
                        cell.lblMessage.text = message?.message
                    }
                    
                    // Hide all first
                    cell.vwReactionFirst.isHidden = true
                    cell.vwReactionSecond.isHidden = true
                    cell.vwReactionThird.isHidden = true
                    if message?.reactionList?.count ?? 0 > 0{
                        cell.bottomReactionVw.constant = 0
                    }else{
                        cell.bottomReactionVw.constant = -10
                    }
                    if let emojiTypes = message?.reactionList?.first?.emojiTypes {
                        print("Emojitypes---", emojiTypes)
                        
                        if emojiTypes.contains(0) {
                            cell.vwReactionFirst.isHidden = false
                        }
                        if emojiTypes.contains(1) {
                            cell.vwReactionSecond.isHidden = false
                        }
                        if emojiTypes.contains(2) {
                            cell.vwReactionThird.isHidden = false
                        }
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                    cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                    
                    
                    let customPathView = BrezerPathRight()
                    customPathView.translatesAutoresizingMaskIntoConstraints = false
                    customPathView.backgroundColor = .clear
                    cell.vwNotch.subviews.forEach { view in
                        if view is BrezerPathRight {
                            view.removeFromSuperview()
                        }
                    }
                    cell.vwNotch.addSubview(customPathView)
                    
                    
                    NSLayoutConstraint.activate([
                        customPathView.topAnchor.constraint(equalTo: cell.vwNotch.topAnchor),
                        customPathView.leadingAnchor.constraint(equalTo: cell.vwNotch.leadingAnchor),
                        customPathView.trailingAnchor.constraint(equalTo: cell.vwNotch.trailingAnchor),
                        customPathView.bottomAnchor.constraint(equalTo: cell.vwNotch.bottomAnchor)
                    ])
                    cell.vwNotch.layoutIfNeeded()
                    customPathView.frame = cell.vwNotch.bounds
                    return cell
                }
            }else{
                
                if message?.sender?.id == Store.userId {
                    print("Media----",message?.media?[0] ?? "")
                    if let mediaArray = message?.media as? [String],
                       let mediaURL = mediaArray.first,
                       mediaURL.contains("m4a") || mediaURL.contains("aac") || mediaURL.contains("mp3"){
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "VoiceRecordTVC", for: indexPath) as! VoiceRecordTVC
                        let audioURL = URL(string: message?.media?[0] ?? "")
                        
                        downloadAudio(from: audioURL ?? URL(fileURLWithPath: "")) { localURL in
                            guard let localURL = localURL else { return }
                            
                            // Check if file is MP3
                            if localURL.pathExtension.lowercased() == "mp3" {
                                self.convertToPCM(mp3URL: localURL) { pcmURL in
                                    guard let pcmURL = pcmURL else { return }
                                    self.extractWaveformSamples(from: pcmURL) { samples in
                                        DispatchQueue.main.async {
                                            // Remove old waveform views to avoid stacking
                                            cell.vwWave.subviews.forEach { $0.removeFromSuperview() }
                                            
                                            let waveformWidth = cell.vwWave.frame.width
                                            let waveformHeight: CGFloat = 30
                                            let waveformView = WaveformView(frame: CGRect(x: 0, y: 0, width: waveformWidth, height: waveformHeight))
                                            waveformView.samples = samples
                                            waveformView.progress = 0 // reset progress
                                            waveformView.backgroundColor = .clear
                                            
                                            cell.vwWave.addSubview(waveformView)
                                            cell.vwWave.setNeedsDisplay()
                                        }
                                    }
                                }
                            } else {
                                self.extractWaveformSamples(from: localURL) { samples in
                                    DispatchQueue.main.async {
                                        // Remove old waveform views to avoid stacking
                                        cell.vwWave.subviews.forEach { $0.removeFromSuperview() }
                                        
                                        let waveformWidth = cell.vwWave.frame.width
                                        let waveformHeight: CGFloat = 30
                                        let waveformView = WaveformView(frame: CGRect(x: 0, y: 0, width: waveformWidth, height: waveformHeight))
                                        waveformView.samples = samples
                                        waveformView.progress = 0 // reset progress
                                        waveformView.backgroundColor = .clear
                                        
                                        cell.vwWave.addSubview(waveformView)
                                        cell.vwWave.setNeedsDisplay()
                                    }
                                }
                            }
                        }
                        if message?.msgStatus == "seen"{
                            cell.imgVwTick.image = UIImage(named: "seenMessage")
                        }else if message?.msgStatus == "delivered"{
                            cell.imgVwTick.image = UIImage(named: "doubleTick")
                        }else{
                            cell.imgVwTick.image = UIImage(named: "singleTick")
                        }
                        cell.btnPlay.addTarget(self, action: #selector(playAudio(sender:)), for: .touchUpInside)
                        cell.btnPlay.tag = indexPath.row
                        cell.btnPlay.indexPath = indexPath.section
                        
                        let customPathView = BrezerPath()
                        customPathView.translatesAutoresizingMaskIntoConstraints = false
                        customPathView.backgroundColor = .clear
                        cell.vwNotch.subviews.forEach { view in
                            if view is BrezerPath {
                                view.removeFromSuperview()
                            }
                        }
                        cell.vwNotch.addSubview(customPathView)
                        
                        
                        NSLayoutConstraint.activate([
                            customPathView.topAnchor.constraint(equalTo: cell.vwNotch.topAnchor),
                            customPathView.leadingAnchor.constraint(equalTo: cell.vwNotch.leadingAnchor),
                            customPathView.trailingAnchor.constraint(equalTo: cell.vwNotch.trailingAnchor),
                            customPathView.bottomAnchor.constraint(equalTo: cell.vwNotch.bottomAnchor)
                        ])
                        cell.vwNotch.layoutIfNeeded()
                        customPathView.frame = cell.vwNotch.bounds
                        
                        cell.vwReactionFirst.isHidden = true
                        cell.vwReactionSecond.isHidden = true
                        cell.vwReactionThird.isHidden = true
                        if message?.reactionList?.count ?? 0 > 0{
                            cell.bottomReactionVw.constant = -5
                        }else{
                            cell.bottomReactionVw.constant = -15
                        }
                        if let emojiTypes = message?.reactionList?.first?.emojiTypes {
                            print("Emojitypes---", emojiTypes)
                            
                            if emojiTypes.contains(0) {
                                cell.vwReactionFirst.isHidden = false
                            }
                            if emojiTypes.contains(1) {
                                cell.vwReactionSecond.isHidden = false
                            }
                            if emojiTypes.contains(2) {
                                cell.vwReactionThird.isHidden = false
                            }
                        }
                        return cell
                    }else{
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SendImageTVC", for: indexPath) as! SendImageTVC
                        
                        cell.arrImage = message?.media ?? []
                        if message?.msgStatus == "seen"{
                            cell.imgVwTick.image = UIImage(named: "seenMessage")
                        }else if message?.msgStatus == "delivered"{
                            cell.imgVwTick.image = UIImage(named: "doubleTick")
                        }else{
                            cell.imgVwTick.image = UIImage(named: "singleTick")
                        }
                        
                        if message?.message == nil{
                            cell.lblMessage.text = ""
                            //                            cell.topMessage.constant = 0
                        }else{
                            //                                       cell.lblMessage.text = message?.message ?? ""
                            if let messageText = message?.message,
                               let searchText = txtFldSearchChat.text,
                               !searchText.isEmpty {
                                
                                let attributedString = NSMutableAttributedString(string: messageText)
                                let range = (messageText as NSString).range(of: searchText, options: .caseInsensitive)
                                
                                if range.location != NSNotFound {
                                    attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
                                    cell.lblMessage.attributedText = attributedString
                                } else {
                                    // If not found, show normal text
                                    cell.lblMessage.attributedText = NSAttributedString(string: messageText)
                                }
                                
                            } else {
                                // In case text field is empty
                                cell.lblMessage.text = message?.message
                            }
                            //                            cell.topMessage.constant = 5
                        }
                        cell.lblMessage.sizeToFit()
                        cell.uiSet()
                        cell.callBack = { index in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
                            vc.arrImage = message?.media ?? []
                            vc.index = index
                            //                                       self.navigationController?.pushViewController(vc, animated: true)
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false)
                        }
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                        cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                        
                        let customPathView = BrezerPath()
                        customPathView.translatesAutoresizingMaskIntoConstraints = false
                        customPathView.backgroundColor = .clear
                        cell.vwNotch.subviews.forEach { view in
                            if view is BrezerPath {
                                view.removeFromSuperview()
                            }
                        }
                        cell.vwNotch.addSubview(customPathView)
                        
                        
                        NSLayoutConstraint.activate([
                            customPathView.topAnchor.constraint(equalTo: cell.vwNotch.topAnchor),
                            customPathView.leadingAnchor.constraint(equalTo: cell.vwNotch.leadingAnchor),
                            customPathView.trailingAnchor.constraint(equalTo: cell.vwNotch.trailingAnchor),
                            customPathView.bottomAnchor.constraint(equalTo: cell.vwNotch.bottomAnchor)
                        ])
                        cell.vwNotch.layoutIfNeeded()
                        customPathView.frame = cell.vwNotch.bounds
                        
                        cell.vwReactionFirst.isHidden = true
                        cell.vwReactionSecond.isHidden = true
                        cell.vwReactionThird.isHidden = true
                        if message?.reactionList?.count ?? 0 > 0{
                            cell.bottomReactionVw.constant = -5
                        }else{
                            cell.bottomReactionVw.constant = -15
                        }
                        if let emojiTypes = message?.reactionList?.first?.emojiTypes {
                            print("Emojitypes---", emojiTypes)
                            
                            if emojiTypes.contains(0) {
                                cell.vwReactionFirst.isHidden = false
                            }
                            if emojiTypes.contains(1) {
                                cell.vwReactionSecond.isHidden = false
                            }
                            if emojiTypes.contains(2) {
                                cell.vwReactionThird.isHidden = false
                            }
                        }
                        
                        return cell
                    }
                    
                    
                    
                }else{
                    print("Media----",message?.media?[0] ?? "")
                    if let mediaArray = message?.media as? [String],
                       let mediaURL = mediaArray.first,
                       mediaURL.contains("m4a") || mediaURL.contains("aac") || mediaURL.contains("mp3"){
                        let cell = tableView.dequeueReusableCell(withIdentifier: "RecieveVoiceRecodingTVC", for: indexPath) as! RecieveVoiceRecodingTVC
                        let audioURL = URL(string: message?.media?[0] ?? "")
                        
                        downloadAudio(from: audioURL ?? URL(fileURLWithPath: "")) { localURL in
                            guard let localURL = localURL else { return }
                            
                            // Check if file is MP3
                            if localURL.pathExtension.lowercased() == "mp3" {
                                self.convertToPCM(mp3URL: localURL) { pcmURL in
                                    guard let pcmURL = pcmURL else { return }
                                    self.extractWaveformSamples(from: pcmURL) { samples in
                                        DispatchQueue.main.async {
                                            // Remove old waveform views to avoid stacking
                                            cell.vwWave.subviews.forEach { $0.removeFromSuperview() }
                                            
                                            let waveformWidth = cell.vwWave.frame.width
                                            let waveformHeight: CGFloat = 30
                                            let waveformView = WaveformView(frame: CGRect(x: 0, y: 0, width: waveformWidth, height: waveformHeight))
                                            waveformView.samples = samples
                                            waveformView.progress = 0 // reset progress
                                            waveformView.backgroundColor = .clear
                                            
                                            cell.vwWave.addSubview(waveformView)
                                            cell.vwWave.setNeedsDisplay()
                                        }
                                    }
                                }
                            } else {
                                self.extractWaveformSamples(from: localURL) { samples in
                                    DispatchQueue.main.async {
                                        // Remove old waveform views to avoid stacking
                                        cell.vwWave.subviews.forEach { $0.removeFromSuperview() }
                                        
                                        let waveformWidth = cell.vwWave.frame.width
                                        let waveformHeight: CGFloat = 30
                                        let waveformView = WaveformView(frame: CGRect(x: 0, y: 0, width: waveformWidth, height: waveformHeight))
                                        waveformView.samples = samples
                                        waveformView.progress = 0 // reset progress
                                        waveformView.backgroundColor = .clear
                                        
                                        cell.vwWave.addSubview(waveformView)
                                        cell.vwWave.setNeedsDisplay()
                                    }
                                }
                            }
                        }
                        cell.vwReactionFirst.isHidden = true
                        cell.vwReactionSecond.isHidden = true
                        cell.vwReactionThird.isHidden = true
                        if message?.reactionList?.count ?? 0 > 0{
                            cell.bottomReactionVw.constant = -5
                        }else{
                            cell.bottomReactionVw.constant = -15
                        }
                        if let emojiTypes = message?.reactionList?.first?.emojiTypes {
                            print("Emojitypes---", emojiTypes)
                            
                            if emojiTypes.contains(0) {
                                cell.vwReactionFirst.isHidden = false
                            }
                            if emojiTypes.contains(1) {
                                cell.vwReactionSecond.isHidden = false
                            }
                            if emojiTypes.contains(2) {
                                cell.vwReactionThird.isHidden = false
                            }
                        }
                        let customPathView = BrezerPathRight()
                        customPathView.translatesAutoresizingMaskIntoConstraints = false
                        customPathView.backgroundColor = .clear
                        cell.vwNotch.subviews.forEach { view in
                            if view is BrezerPathRight {
                                view.removeFromSuperview()
                            }
                        }
                        cell.vwNotch.addSubview(customPathView)
                        
                        
                        NSLayoutConstraint.activate([
                            customPathView.topAnchor.constraint(equalTo: cell.vwNotch.topAnchor),
                            customPathView.leadingAnchor.constraint(equalTo: cell.vwNotch.leadingAnchor),
                            customPathView.trailingAnchor.constraint(equalTo: cell.vwNotch.trailingAnchor),
                            customPathView.bottomAnchor.constraint(equalTo: cell.vwNotch.bottomAnchor)
                        ])
                        cell.vwNotch.layoutIfNeeded()
                        customPathView.frame = cell.vwNotch.bounds
                        cell.btnPlay.addTarget(self, action: #selector(playAudio(sender:)), for: .touchUpInside)
                        cell.btnPlay.tag = indexPath.row
                        cell.btnPlay.indexPath = indexPath.section
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveImageTVC", for: indexPath) as! ReceiveImageTVC
                        
                        cell.arrImage = message?.media ?? []
                        
                        // Hide all first
                        cell.vwReactionFirst.isHidden = true
                        cell.vwReactionSecond.isHidden = true
                        cell.vwReactionThird.isHidden = true
                        if message?.reactionList?.count ?? 0 > 0{
                            cell.bottomReactionVw.constant = 0
                        }else{
                            cell.bottomReactionVw.constant = -10
                        }
                        if let emojiTypes = message?.reactionList?.first?.emojiTypes {
                            print("Emojitypes---", emojiTypes)
                            
                            if emojiTypes.contains(0) {
                                cell.vwReactionFirst.isHidden = false
                            }
                            if emojiTypes.contains(1) {
                                cell.vwReactionSecond.isHidden = false
                            }
                            if emojiTypes.contains(2) {
                                cell.vwReactionThird.isHidden = false
                            }
                        }
                        
                        if message?.message == nil{
                            cell.lblMessage.text = ""
                            cell.topMessage.constant = 0
                        }else{
                            if let messageText = message?.message,
                               let searchText = txtFldSearchChat.text,
                               !searchText.isEmpty {
                                
                                let attributedString = NSMutableAttributedString(string: messageText)
                                let range = (messageText as NSString).range(of: searchText, options: .caseInsensitive)
                                
                                if range.location != NSNotFound {
                                    attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
                                    cell.lblMessage.attributedText = attributedString
                                } else {
                                    // If not found, show normal text
                                    cell.lblMessage.attributedText = NSAttributedString(string: messageText)
                                }
                                
                            } else {
                                // In case text field is empty
                                cell.lblMessage.text = message?.message
                            }
                            //                                   cell.lblMessage.text = message?.message ?? ""
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
                            //                                   self.navigationController?.pushViewController(vc, animated: true)
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: false)
                        }
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let formattedDate = dateFormatter.string(from: message?.messageDate ?? Date())
                        cell.lblTime.text = string_date_ToDate((formattedDate), currentFormat: .BackEndFormat, requiredFormat: .dateTime)
                        cell.vwImage.layer.cornerRadius = 10
                        
                        let customPathView = BrezerPathRight()
                        customPathView.translatesAutoresizingMaskIntoConstraints = false
                        customPathView.backgroundColor = .clear
                        cell.vwNotch.subviews.forEach { view in
                            if view is BrezerPathRight {
                                view.removeFromSuperview()
                            }
                        }
                        cell.vwNotch.addSubview(customPathView)
                        
                        
                        NSLayoutConstraint.activate([
                            customPathView.topAnchor.constraint(equalTo: cell.vwNotch.topAnchor),
                            customPathView.leadingAnchor.constraint(equalTo: cell.vwNotch.leadingAnchor),
                            customPathView.trailingAnchor.constraint(equalTo: cell.vwNotch.trailingAnchor),
                            customPathView.bottomAnchor.constraint(equalTo: cell.vwNotch.bottomAnchor)
                        ])
                        cell.vwNotch.layoutIfNeeded()
                        customPathView.frame = cell.vwNotch.bounds
                        
                        return cell
                    }
                }
            }
            
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Hide the reaction view
        vwReaction.isHidden = true
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        // Check if scrolled more than screen height from bottom
        if offsetY + screenHeight < contentHeight - screenHeight {
            print("true")
            self.btnChatScroll.isHidden = false
        } else {
            print("false") // Close to bottom
            self.btnChatScroll.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.vwReaction.isHidden = true
    }
    @objc func playAudio(sender: IndexPathButton) {
        guard let section = sender.indexPath,
              dates.indices.contains(section),
              let messagesForDate = groupedMessages[dates[section]],
              messagesForDate.indices.contains(sender.tag)
        else { return }
        
        let data = messagesForDate[sender.tag]
        guard let audioURLString = data.media?.first else { return }
        
        // Toggle playback
        // Toggle playback
        if sender == currentPlayingButton {
            stopPlayback()
            return
        }
        
        // 🔁 Reset previous waveform before switching
        if let previousButton = currentPlayingButton,
           let previousSection = previousButton.indexPath {
            let previousIndexPath = IndexPath(row: previousButton.tag, section: previousSection)
            if let previousCell = tblVwChat.cellForRow(at: previousIndexPath) as? VoiceRecordTVC {
                previousCell.lblRecordTime.text = "0:00"
                if let waveformView = previousCell.vwWave.subviews.compactMap({ $0 as? WaveformView }).first {
                    waveformView.progress = 0
                }
            } else if let previousCell = tblVwChat.cellForRow(at: previousIndexPath) as? RecieveVoiceRecodingTVC {
                previousCell.lblRecordTime.text = "0:00"
                if let waveformView = previousCell.vwWave.subviews.compactMap({ $0 as? WaveformView }).first {
                    waveformView.progress = 0
                }
            }
        }
        
        // Update button state
        currentPlayingButton?.isSelected = false
        sender.isSelected = true
        currentPlayingButton = sender
        if let btn = currentPlayingButton,
           let section = btn.indexPath {
            resetCellUI(at: IndexPath(row: btn.tag, section: section))
        }
        // Identify the correct cell type
        let indexPath = IndexPath(row: sender.tag, section: section)
        guard let cell = tblVwChat.cellForRow(at: indexPath) else { return }
        
        if let voiceCell = cell as? VoiceRecordTVC {
            handleAudioPlay(sender: sender, cell: voiceCell, audioURLString: audioURLString)
        } else if let receiveCell = cell as? RecieveVoiceRecodingTVC {
            handleAudioPlay(sender: sender, cell: receiveCell, audioURLString: audioURLString)
        }
    }
    
    private func resetCellUI(at indexPath: IndexPath) {
        if let cell = tblVwChat.cellForRow(at: indexPath) as? VoicePlayableCell {
            cell.lblRecordTime.text = "0:00"
            if let waveformView = cell.vwWave.subviews.compactMap({ $0 as? WaveformView }).first {
                waveformView.progress = 0
            }
        }
    }
    private func handleAudioPlay<T: UITableViewCell & VoicePlayableCell>(sender: IndexPathButton, cell: T, audioURLString: String) {
        guard let url = URL(string: audioURLString) else {
            print("Invalid audio URL")
            return
        }
        
        let fileManager = FileManager.default
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let localURL = cacheDir.appendingPathComponent(url.lastPathComponent)
        
        let play: (_ url: URL) -> Void = { convertedURL in
            DispatchQueue.main.async {
                self.playAudio(from: convertedURL, for: cell)
            }
        }
        
        let playAfterConversion: () -> Void = {
            self.convertToPCM(mp3URL: localURL) { convertedURL in
                guard let convertedURL = convertedURL else {
                    print("Conversion failed")
                    return
                }
                play(convertedURL)
            }
        }
        
        if fileManager.fileExists(atPath: localURL.path) {
            playAfterConversion()
        } else {
            URLSession.shared.downloadTask(with: url) { location, _, error in
                guard let location = location else {
                    print("Download failed: \(error?.localizedDescription ?? "unknown")")
                    return
                }
                
                print("Downloaded to: \(location)")
                
                DispatchQueue.main.async {
                    self.extractWaveformSamples(from: location) { samples in
                        print("Waveform sample count: \(samples.count)")
                    }
                    self.playAudio(from: location, for: cell)
                }
            }.resume()
        }
    }
    
    private func playAudio(from url: URL, for cell: VoicePlayableCell) {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.delegate = self
            self.player?.isMeteringEnabled = true
            self.player?.prepareToPlay()
            self.player?.play()
            
            DispatchQueue.main.async {
                self.startPlaybackTimers(for: cell)
            }
        } catch {
            print("Audio player error: \(error)")
        }
    }
    
    private func stopPlayback() {
        player?.stop()
        playbackTimer?.invalidate()
        playbackProgressTimer?.invalidate()
        playbackTimer = nil
        playbackProgressTimer = nil
        
        if let btn = currentPlayingButton,
           let section = btn.indexPath {
            let indexPath = IndexPath(row: btn.tag, section: section)
            if let cell = tblVwChat.cellForRow(at: indexPath) as? VoiceRecordTVC {
                cell.lblRecordTime.text = "0:00"
                if let waveformView = cell.vwWave.subviews.compactMap({ $0 as? WaveformView }).first {
                    waveformView.progress = 0
                }
            } else if let cell = tblVwChat.cellForRow(at: indexPath) as? RecieveVoiceRecodingTVC {
                cell.lblRecordTime.text = "0:00"
                if let waveformView = cell.vwWave.subviews.compactMap({ $0 as? WaveformView }).first {
                    waveformView.progress = 0
                }
            }
        }
        
        currentPlayingButton?.isSelected = false
        currentPlayingButton = nil
    }
    
    private func startPlaybackTimers(for cell: VoicePlayableCell) {
        guard let duration = player?.duration else { return }
        
        playbackTimer?.invalidate()
        playbackProgressTimer?.invalidate()
        
        playbackTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.stopPlayback()
            cell.lblRecordTime.text = "0:00"
        }
        
        playbackProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self,
                  let currentTime = self.player?.currentTime,
                  let duration = self.player?.duration else { return }
            
            let progress = Float(currentTime / duration)
            let minutes = Int(currentTime) / 60
            let seconds = Int(currentTime) % 60
            cell.lblRecordTime.text = String(format: "%d:%02d", minutes, seconds)
            
            if let waveformView = cell.vwWave.subviews.compactMap({ $0 as? WaveformView }).first {
                waveformView.progress = progress
            }
        }
    }
    
    // MARK: - Utility Functions
    
    func extractWaveformSamples(from audioURL: URL, samplesCount: Int = 100, completion: @escaping ([Float]) -> Void) {
        let asset = AVAsset(url: audioURL)
        guard let track = asset.tracks(withMediaType: .audio).first else {
            completion([])
            return
        }
        
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsNonInterleaved: false
        ]
        
        do {
            let reader = try AVAssetReader(asset: asset)
            let output = AVAssetReaderTrackOutput(track: track, outputSettings: settings)
            reader.add(output)
            reader.startReading()
            
            var samples = [Int16]()
            while let buffer = output.copyNextSampleBuffer(),
                  let blockBuffer = CMSampleBufferGetDataBuffer(buffer) {
                let length = CMBlockBufferGetDataLength(blockBuffer)
                var data = Data(count: length)
                _ = data.withUnsafeMutableBytes {
                    CMBlockBufferCopyDataBytes(blockBuffer, atOffset: 0, dataLength: length, destination: $0.baseAddress!)
                }
                samples += data.withUnsafeBytes { Array($0.bindMemory(to: Int16.self)) }
            }
            
            let chunkSize = max(1, samples.count / samplesCount)
            let waveform = stride(from: 0, to: samples.count, by: chunkSize).map {
                let chunk = samples[$0..<min($0 + chunkSize, samples.count)]
                return (chunk.map { abs(Float($0)) }.max() ?? 0) / Float(Int16.max)
            }
            completion(waveform)
        } catch {
            print("Failed to read audio: \(error)")
            completion([])
        }
    }
    
    func convertToPCM(mp3URL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: mp3URL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            print("Failed to create export session")
            completion(nil)
            return
        }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".m4a")
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .m4a
        exportSession.audioTimePitchAlgorithm = .spectral
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("Export completed: \(outputURL)")
                completion(outputURL)
            case .failed, .cancelled:
                print("Export failed: \(exportSession.error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            default:
                break
            }
        }
    }
    
    func downloadAudio(from url: URL, completion: @escaping (URL?) -> Void) {
        URLSession.shared.downloadTask(with: url) { tempURL, _, error in
            guard let tempURL = tempURL, error == nil else {
                completion(nil)
                return
            }
            
            let fileManager = FileManager.default
            let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let localURL = cacheDir.appendingPathComponent(url.lastPathComponent)
            
            do {
                if fileManager.fileExists(atPath: localURL.path) {
                    try fileManager.removeItem(at: localURL)
                }
                try fileManager.copyItem(at: tempURL, to: localURL)
                completion(localURL)
            } catch {
                print("File copy error: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

//MARK: - AVAudioPlayerDelegate
extension ChatDetailVC:AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("stop (from delegate)")
        playbackTimer?.invalidate()
        playbackProgressTimer?.invalidate()
        playbackTimer = nil
        playbackProgressTimer = nil
        
        if let btn = currentPlayingButton,
           let section = btn.indexPath {
            let indexPath = IndexPath(row: btn.tag, section: section)
            if let cell = tblVwChat.cellForRow(at: indexPath) as? VoiceRecordTVC {
                cell.lblRecordTime.text = "0:00"
                if let waveformView = cell.vwWave.subviews.compactMap({ $0 as? WaveformView }).first {
                    waveformView.progress = 0
                }
            } else if let cell = tblVwChat.cellForRow(at: indexPath) as? RecieveVoiceRecodingTVC {
                cell.lblRecordTime.text = "0:00"
                if let waveformView = cell.vwWave.subviews.compactMap({ $0 as? WaveformView }).first {
                    waveformView.progress = 0
                }
            }
        }
        
        currentPlayingButton?.isSelected = false
        currentPlayingButton = nil
    }
}
//MARK: - KEYBOARD HANDLING
extension ChatDetailVC {
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    @objc func keyboardWillChangeFrame(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        // Convert keyboard frame to local view coordinates
        let keyboardFrameInView = self.view.convert(keyboardFrame, from: nil)
        let keyboardHeight = max(0, self.view.bounds.height - keyboardFrameInView.origin.y)
        self.bottomStackVw.constant = keyboardHeight
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        tableViewScrollToBottom()
    }
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        self.bottomStackVw.constant = 10
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    private func tableViewScrollToBottom() {
        DispatchQueue.main.async {
            let sections = self.tblVwChat.numberOfSections
            if sections > 0 {
                let rows = self.tblVwChat.numberOfRows(inSection: sections - 1)
                if rows > 0 {
                    let indexPath = IndexPath(row: rows - 1, section: sections - 1)
                    self.tblVwChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
}

//MARK: - UITextViewDelegate
extension ChatDetailVC:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedText = (textView.text as NSString).replacingCharacters(in: range, with: text).trimmingCharacters(in: .whitespacesAndNewlines)
        let isTextEmpty = updatedText.isEmpty
        //        vwAttach.isHidden = !isTextEmpty
        vwRecord.isHidden = !isTextEmpty
        widthCamera.constant = isTextEmpty ? 44 : 0
        vwSend.isHidden = isTextEmpty
        print(updatedText)
        
        return true
    }
    
}

//MARK: - UIImagePickerControllerDelegate
extension ChatDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            if arrImage.count < 10{
                self.arrImage.insert(image, at: 0)
            }
            self.vwMultipleImg.isHidden = false
            self.collVwMultipleImg.reloadData()
            self.vwSend.isHidden = false
            self.vwRecord.isHidden = true
            
        } else if let videoURL = info[.mediaURL] as? URL {
            if arrImage.count < 10{
                self.arrImage.insert(videoURL, at: 0)
            }
            self.vwMultipleImg.isHidden = false
            self.collVwMultipleImg.reloadData()
            self.vwSend.isHidden = false
            self.vwRecord.isHidden = true
            
        }
        
        //        picker.dismiss(animated: true, completion: nil)
        picker.view!.removeFromSuperview()
        picker.removeFromParent()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //        picker.dismiss(animated: true, completion: nil)
        picker.view!.removeFromSuperview()
        picker.removeFromParent()
        
    }
    
}
//MARK: - QBImagePickerControllerDelegate
extension ChatDetailVC: QBImagePickerControllerDelegate {
    @objc func qb_imagePickerController(_ imagePickerController: QBImagePickerController, didSelect asset: PHAsset) {
        selectImgCount -= 1
        
        if selectImgCount == 0 {
            print("Selected maximum image")
            // Optional: show alert
            let alert = UIAlertController(title: "Limit Reached", message: "You can select up to 10 images.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            imagePickerController.present(alert, animated: true)
        } else {
            print("Selected asset: \(asset)")
        }
    }
    
    @objc func qb_imagePickerController(_ imagePickerController: QBImagePickerController, didDeselect asset: PHAsset) {
        selectImgCount += 1
        print("Deselected asset: \(asset)")
    }
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        
        guard let selectedAssets = assets as? [PHAsset], !selectedAssets.isEmpty else {
            return
        }
        
        self.imagesToCrop.removeAll()           // 🔁 Reset images to crop
        self.currentCroppingIndex = 0           // 🔁 Reset cropping index
        
        
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false  // Allow async processing
        requestOptions.deliveryMode = .highQualityFormat // High-quality image
        requestOptions.resizeMode = .none // Keep original size
        
        for asset in selectedAssets {
            if asset.mediaType == .image {
                
                let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                imageManager.requestImage(
                    for: asset,
                    targetSize: targetSize,
                    contentMode: .aspectFill,
                    options: requestOptions
                ) { [weak self] (image, _) in
                    guard let self = self else { return }
                    if let image = image {
                        
                        self.imagesToCrop.append(image)
                    }
                    
                    // After last image has been fetched, start cropping
                    if self.imagesToCrop.count == selectedAssets.count {
                        self.presentCropperForNextImage()
                    }
                }
                
            } else if asset.mediaType == .video {
                imageManager.requestAVAsset(forVideo: asset, options: nil) { [weak self] (avAsset, _, _) in
                    guard let self = self else { return }
                    
                    if let urlAsset = avAsset as? AVURLAsset {
                        let videoURL = urlAsset.url
                        print("Video URL:", videoURL)
                        
                        DispatchQueue.main.async {
                            self.arrImage.append(videoURL)
                            self.vwMultipleImg.isHidden = false
                            self.collVwMultipleImg.reloadData()
                            self.vwSend.isHidden = false
                            self.vwRecord.isHidden = true
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
    
    func cropVideoToSquare(videoURL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: videoURL)
        let composition = AVMutableComposition()
        
        guard let videoTrack = asset.tracks(withMediaType: .video).first else {
            completion(nil)
            return
        }
        
        let duration = asset.duration
        let videoSize = videoTrack.naturalSize
        let squareLength = min(videoSize.width, videoSize.height)
        
        let compositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        do {
            try compositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: duration), of: videoTrack, at: .zero)
        } catch {
            print("Error inserting video track:", error)
            completion(nil)
            return
        }
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: squareLength, height: squareLength)
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: duration)
        
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionTrack!)
        
        let tx = (videoSize.width > videoSize.height)
        ? CGAffineTransform(translationX: -(videoSize.width - videoSize.height) / 2, y: 0)
        : CGAffineTransform(translationX: 0, y: -(videoSize.height - videoSize.width) / 2)
        
        transformer.setTransform(tx, at: .zero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        let exportPath = NSTemporaryDirectory() + UUID().uuidString + ".mp4"
        let exportURL = URL(fileURLWithPath: exportPath)
        
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            completion(nil)
            return
        }
        
        exportSession.outputURL = exportURL
        exportSession.outputFileType = .mp4
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                DispatchQueue.main.async {
                    completion(exportURL)
                }
            case .failed, .cancelled:
                print("Export failed:", exportSession.error ?? "Unknown error")
                DispatchQueue.main.async {
                    completion(nil)
                }
            default:
                break
            }
        }
    }
    
    func presentCropperForNextImage() {
        guard currentCroppingIndex < imagesToCrop.count else {
            print("All images cropped")
            return
        }
        
        let image = imagesToCrop[currentCroppingIndex]
        
        let cropVC = TOCropViewController(image: image)
        cropVC.delegate = self
        
        addChild(cropVC)
        cropVC.view.frame = cropContainerView.bounds
        cropContainerView.addSubview(cropVC.view)
        cropVC.didMove(toParent: self)
        
        // Create left button
        let leftButton = UIButton(type: .system)
        leftButton.setTitle("◀︎", for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        leftButton.tintColor = .white
        leftButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        leftButton.layer.cornerRadius = 25
        leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        
        // Create right button
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("▶︎", for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        rightButton.tintColor = .white
        rightButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        rightButton.layer.cornerRadius = 25
        rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        
        // Set frames or use Auto Layout
        let buttonSize: CGFloat = 50
        leftButton.frame = CGRect(x: 20, y: cropContainerView.bounds.midY - buttonSize/2, width: buttonSize, height: buttonSize)
        rightButton.frame = CGRect(x: cropContainerView.bounds.width - buttonSize - 20, y: cropContainerView.bounds.midY - buttonSize/2, width: buttonSize, height: buttonSize)
        
        cropContainerView.addSubview(leftButton)
        cropContainerView.addSubview(rightButton)
        
        cropContainerView.isHidden = false
    }
    @objc func didTapLeftButton() {
        // Handle previous image / cancel / go back
        if currentCroppingIndex > 0 {
            currentCroppingIndex -= 1
            if arrImage.count < 10{
                self.arrImage.remove(at: currentCroppingIndex)
            }
            presentCropperForNextImage()
        }
        print("Left button tapped")
    }
    
    @objc func didTapRightButton() {
        // Handle next image / save / go forward
        if currentCroppingIndex < imagesToCrop.count - 1 {
            
            if arrImage.count < 10{
                self.arrImage.insert(imagesToCrop[currentCroppingIndex], at: 0)
            }
            self.currentCroppingIndex += 1
            self.cropContainerView.isHidden = true
            
            vwMultipleImg.isHidden = false
            self.collVwMultipleImg.reloadData()
            self.vwSend.isHidden = false
            self.vwRecord.isHidden = true
            presentCropperForNextImage()
        }
        print("Right button tapped")
    }
}

//MARK: - TOCropViewControllerDelegate
extension ChatDetailVC: TOCropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.willMove(toParent: nil)
        cropViewController.view.removeFromSuperview()
        cropViewController.removeFromParent()
        if arrImage.count < 10{
            self.arrImage.insert(image, at: 0)
        }
        self.currentCroppingIndex += 1
        self.cropContainerView.isHidden = true
        
        vwMultipleImg.isHidden = false
        self.collVwMultipleImg.reloadData()
        self.vwSend.isHidden = false
        self.vwRecord.isHidden = true
        print("images-----",arrImage)
        self.presentCropperForNextImage()
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.willMove(toParent: nil)
        cropViewController.view.removeFromSuperview()
        cropViewController.removeFromParent()
        
        self.currentCroppingIndex += 1
        self.cropContainerView.isHidden = true
        
        self.presentCropperForNextImage()
    }
}


//MARK: - UITextFieldDelegate
extension ChatDetailVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            //            self.tblVwChat.reloadData()
            
            if !updatedText.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                    guard let self = self else { return }
                    //                    self.scrollToFirstMatchingMessage(searchText: updatedText)
                    DispatchQueue.main.async {
                        self.tblVwChat.reloadData()
                        self.tblVwChat.layoutIfNeeded()
                        
                        CATransaction.begin()
                        CATransaction.setCompletionBlock {
                            self.scrollToFirstMatchingMessageSafely(searchText: updatedText)
                        }
                        self.tblVwChat.reloadSections(IndexSet(integer: 0), with: .none)
                        CATransaction.commit()
                    }
                }
            }
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !matchingIndexes.isEmpty else { return true }
        
        currentMatchIndex += 1
        if currentMatchIndex >= matchingIndexes.count {
            currentMatchIndex = 0 // Loop back to start
        }
        
        let indexPath = matchingIndexes[currentMatchIndex]
        let section = indexPath.section
        let row = indexPath.row
        
        // ✅ Final check before scrolling
        if section < tblVwChat.numberOfSections {
            let totalRows = tblVwChat.numberOfRows(inSection: section)
            if row < totalRows {
                tblVwChat.scrollToRow(at: indexPath, at: .middle, animated: true)
            } else {
                print("❗️Skipping scroll. Row \(row) is out of bounds. Total rows: \(totalRows)")
            }
        } else {
            print("❗️Skipping scroll. Section \(section) is out of bounds.")
        }
        
        return true
    }
    
    func scrollToFirstMatchingMessageSafely(searchText: String) {
        matchingIndexes.removeAll()
        currentMatchIndex = 0
        
        for (index, message) in arrMessages.enumerated() {
            if let msg = message.message,
               msg.range(of: searchText, options: .caseInsensitive) != nil {
                let indexPath = IndexPath(row: index, section: 0)
                matchingIndexes.append(indexPath)
            }
        }
        
        guard !matchingIndexes.isEmpty else { return }
        
        let indexPath = matchingIndexes[currentMatchIndex]
        
        // ✅ Final safe check before scrolling
        let totalSections = tblVwChat.numberOfSections
        if indexPath.section < totalSections {
            let rows = tblVwChat.numberOfRows(inSection: indexPath.section)
            if indexPath.row < rows {
                tblVwChat.scrollToRow(at: indexPath, at: .middle, animated: true)
            } else {
                print("❗️Row \(indexPath.row) does not exist yet, rows: \(rows)")
            }
        } else {
            print("❗️Section \(indexPath.section) does not exist")
        }
    }
}
