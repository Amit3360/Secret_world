//
//  ChatUserOptionVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 28/03/25.
//

import UIKit

class ChatUserOptionVC: UIViewController {

    @IBOutlet weak var tblVwOption: UITableView!
    @IBOutlet weak var lblName: UILabel!
    
    var arrOption = ["View profile","Pin Conversation","Mute","Archieve","Delete"]
    var callBack:((_ index:Int?)->())?
    var messageId = ""
    var isPin = false
    var isMute = false
    var userName = ""
    var isArchive = false
    var receiverId = ""
    var chatType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        lblName.text = userName
        if isPin{
            arrOption.remove(at: 1)
            arrOption.insert("Unpin Conversation", at: 1)
        }else{
            arrOption.remove(at: 1)
            arrOption.insert("Pin Conversation", at: 1)
        }
        if isMute{
            arrOption.remove(at: 2)
            arrOption.insert("Unmute", at: 2)
        }else{
            arrOption.remove(at: 2)
            arrOption.insert("Mute", at: 2)
        }
        if isArchive{
            arrOption.remove(at: 3)
            arrOption.insert("Unarchieve", at: 3)
        }else{
            arrOption.remove(at: 3)
            arrOption.insert("Archieve", at: 3)
        }
        tblVwOption.reloadData()
    }
  
}

extension ChatUserOptionVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserOptionTVC", for: indexPath) as! ChatUserOptionTVC
        cell.lblOption.text = arrOption[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1{
            let param:parameters = ["messageId":messageId,"userId":Store.userId ?? "","type":chatType]
            SocketIOManager.sharedInstance.pinChat(dict: param)
            
        }else if indexPath.row == 2{
            let param:parameters = ["messageId":messageId,"userId":Store.userId ?? "","type":chatType]
            SocketIOManager.sharedInstance.muteChat(dict: param)
            
        }
        
        dismiss(animated: true)
        callBack?(indexPath.row)
    }
}
