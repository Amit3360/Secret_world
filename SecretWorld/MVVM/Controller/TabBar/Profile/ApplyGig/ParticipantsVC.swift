//
//  ParticipantsVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/24.
//

import UIKit


class ParticipantsVC: UIViewController {
    
    //MARK: - OUTLEST
    
    @IBOutlet var btnRejected: UIButton!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var heightStackVwBtns: NSLayoutConstraint!
    @IBOutlet var btnAccepted: UIButton!
    @IBOutlet var btnNew: UIButton!
    @IBOutlet var tblVwList: UITableView!
    
    //MARK: - VARIABLES
    
    var isComing = 0
    var viewModel = AddGigVM()
    var arrUserParticipants = [GetParticipantsData]()
    var arrGroupParticipant = [Participant]()
    var arrNewParticipants = [UserDetaills]()
    var arrCompleteParticipants = [GetRequestData]()
    var gigId = ""
    var participantsStatus:Int?
    var idForHire = ""
    var gigType = 0
    var isGroup = false
    var isCustomerAsProvider = false
    var businessGigDetail:GetGigDetailData?
    var callBack: (()->())?
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                   swipeRight.direction = .right
                   view.addGestureRecognizer(swipeRight)

    }
    @objc func handleSwipe() {
                navigationController?.popViewController(animated: true)
                callBack?()
            }

    override func viewWillAppear(_ animated: Bool) {
        uiSet()
        print(Store.authKey ?? "")
    }
    func uiSet(){
        let nibNearBy = UINib(nibName: "ParticipantsListTVC", bundle: nil)
        tblVwList.register(nibNearBy, forCellReuseIdentifier: "ParticipantsListTVC")
        
        tblVwList.estimatedRowHeight = 60
        tblVwList.rowHeight = UITableView.automaticDimension
        if isGroup == true{
            heightStackVwBtns.constant = 0
            getGroupParticipant()
            
        }else{
            if isComing == 1{
                getUserParticipants()
                heightStackVwBtns.constant = 0
            }else if isComing == 0{
                heightStackVwBtns.constant = 44
                btnRejected.isHidden = false
                getBusinessParticipants(gigtype: gigType)
            }else{
                heightStackVwBtns.constant = 0
                getCompleteParticipants(loader: true)
            }
        }
        
    }
    func getGroupParticipant(){
        viewModel.GetUserGroupParticipantsListApi(gigId: gigId) { data in
            if data?.participants?.count ?? 0 > 0{
                self.arrGroupParticipant = data?.participants ?? []
                if self.arrGroupParticipant.count > 0{
                    self.lblNoData.text = ""
                }else{
                    self.lblNoData.text = "Data Not Found!"
                }
                self.tblVwList.reloadData()
            }
        }
    }
    func getUserParticipants(){
        viewModel.GetUserParticipantsListApi(gigId: gigId) { data in
            self.arrUserParticipants = data ?? []
            
            if self.arrUserParticipants.count > 0{
                self.lblNoData.text = ""
            }else{
                self.lblNoData.text = "Data Not Found!"
            }
            self.tblVwList.reloadData()
        }
    }
    func getCompleteParticipants(loader:Bool){
        viewModel.GetCompleteGigParticipantsListApi(loader: true, gigId: gigId){ data in
            self.arrCompleteParticipants = data ?? []
            
            if self.arrCompleteParticipants.count > 0{
                self.lblNoData.text = ""
            }else{
                self.lblNoData.text = "Data Not Found!"
            }
            self.tblVwList.reloadData()
        }
    }
    func getBusinessParticipants(gigtype:Int) {
        viewModel.GetBusinessParticipantsListApi(gigId: gigId, type: gigtype) { data in
            self.arrNewParticipants.removeAll()
            for i in data?.user ?? [] {
                self.participantsStatus = i.status
                
                self.arrNewParticipants.append(i)
                
            }
            if self.arrNewParticipants.count > 0{
                self.lblNoData.text = ""
            }else{
                self.lblNoData.text = "Data Not Found!"
            }
            
            self.tblVwList.reloadData()
        }
    }
    
    //MARK: - Button actions
    
    @IBAction func actionRejected(_ sender: UIButton) {
        self.arrNewParticipants.removeAll()
        tblVwList.reloadData()
        let nibReject = UINib(nibName: "RejectedParticipantTVC", bundle: nil)
        tblVwList.register(nibReject, forCellReuseIdentifier: "RejectedParticipantTVC")
        gigType = 2
        updateSelection(selected: btnRejected)
        getBusinessParticipants(gigtype: gigType)
    }
    @IBAction func actionAccepted(_ sender: UIButton) {
        self.arrNewParticipants.removeAll()
        tblVwList.reloadData()
        let nibReject = UINib(nibName: "RejectedParticipantTVC", bundle: nil)
        tblVwList.register(nibReject, forCellReuseIdentifier: "RejectedParticipantTVC")
        updateSelection(selected: btnAccepted)
        gigType = 1
        getBusinessParticipants(gigtype: gigType)
        
    }
   
    @IBAction func actionNew(_ sender: UIButton) {
        self.arrNewParticipants.removeAll()
        tblVwList.reloadData()
        let nibNearBy = UINib(nibName: "ParticipantsListTVC", bundle: nil)
        tblVwList.register(nibNearBy, forCellReuseIdentifier: "ParticipantsListTVC")
        updateSelection(selected: btnNew)
        gigType = 0
        getBusinessParticipants(gigtype: gigType)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        callBack?()
    }
    func updateSelection(selected: UIButton) {
        let buttons = [btnAccepted, btnNew, btnRejected]
        
        for button in buttons {
            let isSelected = (button == selected)
            button?.backgroundColor = isSelected ? UIColor(red: 231/255, green: 243/255, blue: 230/255, alpha: 1.0) : .white
            button?.setTitleColor(isSelected ? UIColor.app : .darkGray, for: .normal)
        }
    }
    
    
}

//MARK: -UITableViewDelegate

extension ParticipantsVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isGroup == true{
            return arrGroupParticipant.count
        }else{
            if isComing == 1{
                return arrUserParticipants.count
            }else if isComing == 0{
                
                return arrNewParticipants.count
                
            }else{
                return arrCompleteParticipants.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if gigType == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantsListTVC", for: indexPath) as! ParticipantsListTVC
            if isGroup == true {
                cell.lblUserNAme.text = arrGroupParticipant[indexPath.row].name ?? ""
                //            cell.lbl.text = arrGroupParticipant[indexPath.row].gender ?? ""
                //            cell.widthBtnMessage.constant = 0
                //            cell.heightStackvw.constant = 0
                cell.imgVwUser.imageLoad(imageUrl: arrGroupParticipant[indexPath.row].profilePhoto ?? "")
                //            cell.viewBack.layer.cornerRadius = 15
            }else{
                if isComing == 1{
                    
                    cell.lblUserNAme.text = arrUserParticipants[indexPath.row].applyuserID?.name ?? ""
                    cell.imgVwUser.imageLoad(imageUrl: arrUserParticipants[indexPath.row].applyuserID?.profilePhoto ?? "")
                    
                }else if isComing == 0{
                    
                    
                    cell.lblUserNAme.text = arrNewParticipants[indexPath.row].name ?? ""
                    cell.lblTitle.text = "\(arrNewParticipants[indexPath.row].gigTitle ?? "") \(arrNewParticipants[indexPath.row].categoryName ?? "")"
                    cell.imgVwUser.imageLoad(imageUrl: arrNewParticipants[indexPath.row].profile_photo  ?? "")
                    cell.lblTime.text = formattedDateString(from: arrNewParticipants[indexPath.row].createdAt ?? "")
                    cell.lblDesciption.text = arrNewParticipants[indexPath.row].message ?? ""
                    let formattedLocation = String(format: "%.1f", Double(arrNewParticipants[indexPath.row].distance ?? 0))
                    cell.lblLocation.text = "• Location: \(formattedLocation) miles"
                    cell.lblTaskCompleted.text = "• Task completed: \(arrNewParticipants[indexPath.row].taskCompleted ?? 0)"
                    cell.lblRatingReview.text = "0.0"
                    cell.btnAccept.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
                    cell.btnAccept.tag = indexPath.row
                    
                    cell.btnChat.tag = indexPath.row
                    cell.btnChat.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
                    
                    cell.btnReject.tag = indexPath.row
                    cell.btnReject.addTarget(self, action: #selector(actionReject), for: .touchUpInside)
                    
                }else{
                    
                    
                    cell.lblUserNAme.text = arrCompleteParticipants[indexPath.row].name ?? ""
                    
                    cell.imgVwUser.imageLoad(imageUrl: arrCompleteParticipants[indexPath.row].profilePhoto ?? "")
                    cell.btnChat.tag = indexPath.row
                    cell.btnChat.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RejectedParticipantTVC", for: indexPath) as! RejectedParticipantTVC
            cell.lblName.text = arrNewParticipants[indexPath.row].name ?? ""
            cell.lblGender.text = arrNewParticipants[indexPath.row].gender ?? ""
            cell.imgVwProfile.imageLoad(imageUrl: arrNewParticipants[indexPath.row].profile_photo ?? "")
            
            cell.btnMessage.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
            cell.btnMessage.tag = indexPath.row
            if gigType == 2{
                cell.btnMessage.isHidden = true
            }else{
                cell.btnMessage.isHidden = false
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if gigType != 0{
            return 66
        }else {
            return UITableView.automaticDimension
        }
    }
    func formattedDateString(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        
         dateFormatter.dateFormat = "h:mm a"
        
        
        return dateFormatter.string(from: date)
    }
    @objc func acceptRequest(sender:UIButton){
        guard sender.tag >= 0 && sender.tag < arrNewParticipants.count else {
                   return
               }
               
               sender.isEnabled = false
               print("UserId-------",Store.userId ?? "")
               viewModel.HireForGigApi(gigid: gigId, userid: arrNewParticipants[sender.tag].applyuserId ?? "") {
                   [weak self] in
                   guard let self = self else { return }
                   guard sender.tag >= 0 && sender.tag < self.arrNewParticipants.count else {
                       return
                   }
                   let param:parameters = ["userId":arrNewParticipants[sender.tag].applyuserId ?? "","gigId":gigId,"senderId":Store.userId ?? "","gigName":arrNewParticipants[sender.tag].title ?? ""]
                   print("Param--------",param)
       //            let param:parameters = ["userId":arrNewParticipants[sender.tag].applyuserId ?? "","gigId":gigId]
                   SocketIOManager.sharedInstance.joinGroup(dict: param)
                   self.arrNewParticipants.remove(at: sender.tag)
                   self.getBusinessParticipants(gigtype: self.gigType)
                   sender.isEnabled = true
               }
    }
    
   
       @objc func actionChat(sender:UIButton){
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
           if Store.role == "b_user"{
               vc.receiverId = arrNewParticipants[sender.tag].applyuserId ?? ""
           }else{
               vc.receiverId = arrNewParticipants[sender.tag].applyuserId ?? ""
           }
           vc.typeId = gigId
           vc.chatType = "task"
           self.navigationController?.pushViewController(vc, animated: true)
       }
    
    @objc func actionReject(sender:UIButton){
        guard sender.tag >= 0 && sender.tag < arrNewParticipants.count else {
                   return
               }
               
        sender.isEnabled = false
        viewModel.rejectedTask(gigid: arrNewParticipants[sender.tag].requestId ?? "", userid: arrNewParticipants[sender.tag].applyuserId ?? "") {
                   [weak self] in
                   guard let self = self else { return }
                   guard sender.tag >= 0 && sender.tag < self.arrNewParticipants.count else {
                       return
                   }
                  
                   self.arrNewParticipants.remove(at: sender.tag)
                   self.getBusinessParticipants(gigtype: self.gigType)
                   sender.isEnabled = true
               }
    }
    
}
