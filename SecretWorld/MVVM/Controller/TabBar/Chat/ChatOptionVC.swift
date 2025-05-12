//
//  ChatOptionVC.swift
//  SecretWorld
//
//  Created by meet sharma on 18/04/24.
//

import UIKit

class ChatOptionVC: UIViewController {

    @IBOutlet weak var tblVwOption: UITableView!
    
    var arrOption = [String]()
    var blockStatusMe = false
    var blockStatusOther = false
    var receiverId = ""
    var callBack:((_ isReport:Bool,_ index:Int)->())?
    var comingChat = false
    var myTask = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      uiSet()
     
    }
    func uiSet(){
        arrOption.removeAll()
        if receiverId == ""{
        
                arrOption.append("Archived")
                arrOption.append("Reported")
                arrOption.append("Blocked")
          
        }else{
            if blockStatusMe == true{
                if myTask{
                    arrOption.append("Set Nickname")
                    arrOption.append("Report User")
                    arrOption.append("Unblock User")
                }else{
                    arrOption.append("Set Nickname")
                    arrOption.append("View Summary")
                    arrOption.append("Report User")
                    arrOption.append("Unblock User")
                }
               
              
            }else{
                if blockStatusOther == true{
                    if myTask{
                        arrOption.append("Set Nickname")
                        arrOption.append("Report User")
                        arrOption.append("Block User")
                    }else{
                        arrOption.append("Set Nickname")
                        arrOption.append("View Summary")
                        arrOption.append("Report User")
                        arrOption.append("Block User")
                    }
                }else{
                    if myTask{
                        arrOption.append("Set Nickname")
                        arrOption.append("Report User")
                        arrOption.append("Block User")
                    }else{
                        arrOption.append("Set Nickname")
                        arrOption.append("View Summary")
                        arrOption.append("Report User")
                        arrOption.append("Block User")
                    }
                 
                }
            }
        }
        tblVwOption.reloadData()
    }



}

extension ChatOptionVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatOptionTVC", for: indexPath) as! ChatOptionTVC
        cell.lblOption.text = arrOption[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if receiverId == ""{
          
                dismiss(animated: true)
                callBack?(false, indexPath.row+1)
           
          
        }else{
//            if indexPath.row == 3{
//                let param = ["senderId":Store.userId ?? "","receiverId":self.receiverId]
//                SocketIOManager.sharedInstance.blockUnblock(dict: param)
//                dismiss(animated: true)
//                callBack?(false, indexPath.row+1)
//            }else{
            if myTask{
               
                dismiss(animated: true)
                if indexPath.row == 0{
                    callBack?(false, indexPath.row+1)
                }else{
                    callBack?(false, indexPath.row+2)
                }
            }else{
                dismiss(animated: true)
                callBack?(false, indexPath.row+1)
           
            }
//            }
        }
    }
    
}
