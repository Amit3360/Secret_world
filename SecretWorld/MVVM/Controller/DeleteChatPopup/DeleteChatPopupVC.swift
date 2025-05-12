//
//  DeleteChatPopupVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 03/04/25.
//

import UIKit

class DeleteChatPopupVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    
    var isComing = ""
    var callBack:((_ status:Bool)->())?
    var receiverId = ""
    var blockStatusMe = false
    var blockStatusOther = false
    var chatType = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSet()
    }
    func uiSet(){
        if isComing == "Archive"{
            lblTitle.text = "Are you sure, you want to archive  this chat?"
        }else if isComing == "Unarchive"{
                lblTitle.text = "Are you sure, you want to unarchive  this chat?"
        }else if isComing == "Delete"{
            lblTitle.text = "Are you sure, you want to delete this chat?"
        }else{
            
            if blockStatusMe == true{
                lblTitle.text = "Are you sure, you want to unblock this person?"
            }else{
                if blockStatusOther == true{
                    lblTitle.text = "Are you sure, you want to block this person?"
                   
                }else{
                    lblTitle.text = "Are you sure, you want to block this person?"
                }
            }
        }
    }
    @IBAction func actionYes(_ sender: UIButton) {
        if isComing == "block"{
            let param = ["senderId":Store.userId ?? "","receiverId":self.receiverId,"type":chatType]
                SocketIOManager.sharedInstance.blockUnblock(dict: param)
            dismiss(animated: true)
            callBack?(true)
        }else{
            dismiss(animated: true)
            callBack?(true)
        }
     
    }
    
    @IBAction func actionNo(_ sender: UIButton) {
        dismiss(animated: true)
        callBack?(false)
    }
    
}

