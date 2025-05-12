//
//  UserParticipantsListVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 15/03/24.
//

import UIKit

class UserParticipantsListVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var btnRejected: UIButton!
    @IBOutlet var btnAccepted: UIButton!
    @IBOutlet var btnNew: UIButton!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var tblVw: UITableView!
    var viewModel = AddGigVM()
    var arrNewParticipants = [UserDetaills]()
    var gigId = ""
    var participantsStatus:Int?
    var gigType = 0
    var isComing = 0
    var viewModelPopup = PopUpVM()
    var offSet = 1
    var limit = 10
    var totalPages = 0
    var popupId = ""
    var arrPopupRequest = [Popuprequest]()
    var isLoading = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                   swipeRight.direction = .right
                   view.addGestureRecognizer(swipeRight)

        let nibNearBy = UINib(nibName: "ParticipantTVC", bundle: nil)
        tblVw.register(nibNearBy, forCellReuseIdentifier: "ParticipantTVC")
        tblVw.estimatedRowHeight = 60
        tblVw.rowHeight = UITableView.automaticDimension
        tblVw.showsVerticalScrollIndicator = false
        if isComing == 1{
            getpopupRequests(PopupType: 0, showLoader: true)
            lblTitle.text = "Requests"
        }else{
            getUserParticipants(gigtype: gigType)
            lblTitle.text = "Participants"
        }
        
        
    }
    @objc func handleSwipe() {
            self.navigationController?.popViewController(animated: true)
        }

    func getpopupRequests(PopupType:Int,showLoader:Bool){
        viewModelPopup.getPopupRequestApi(popUpId: popupId, offset: offSet, limit: limit, type: PopupType, loader: showLoader) { data in
            self.arrPopupRequest.removeAll()
            self.totalPages = data?.totalPages ?? 0
            self.arrPopupRequest = data?.popuprequests ?? []
            
            if self.arrPopupRequest.count > 0{
                self.lblNoData.isHidden = true
            }else{
                self.lblNoData.isHidden = false
            }
            self.tblVw.reloadData()
        }
    }
    func getUserParticipants(gigtype:Int){
        viewModel.GetBusinessParticipantsListApi(gigId: gigId, type: gigtype) { data in
            self.arrNewParticipants.removeAll()
            for i in data?.user ?? [] {
                self.participantsStatus = i.status
                self.arrNewParticipants.append(i)
            }
            if self.arrNewParticipants.count > 0{
                self.lblNoData.isHidden = true
            }else{
                self.lblNoData.isHidden = false
            }
            self.tblVw.reloadData()
        }
    }
    @IBAction func actionAccepted(_ sender: UIButton) {
        
        selectedBtnAccepted()
        if isComing == 1{
            getpopupRequests(PopupType: 1, showLoader: false)
        }else{
            gigType = 1
            getUserParticipants(gigtype: gigType)
        }
        
        
    }
    func selectedBtnAccepted(){
        btnAccepted.backgroundColor = UIColor(red: 231/255, green: 243/255, blue: 230/255, alpha: 1.0)
        btnAccepted.setTitleColor(UIColor.app, for: .normal)
        btnNew.backgroundColor = .white
        btnNew.setTitleColor(UIColor.darkGray, for: .normal)
        btnRejected.backgroundColor = .white
        btnRejected.setTitleColor(UIColor.darkGray, for: .normal)
        
    }
    @IBAction func actionRejected(_ sender: UIButton) {
        selectedBtnRejected()
        getpopupRequests(PopupType: 2, showLoader: false)
        
    }
    func selectedBtnRejected(){
        btnRejected.backgroundColor = UIColor(red: 231/255, green: 243/255, blue: 230/255, alpha: 1.0)
        btnRejected.setTitleColor(UIColor.app, for: .normal)
        btnNew.backgroundColor = .white
        btnNew.setTitleColor(UIColor.darkGray, for: .normal)
        btnAccepted.backgroundColor = .white
        btnAccepted.setTitleColor(UIColor.darkGray, for: .normal)
    }
    @IBAction func actionNew(_ sender: UIButton) {
        selectedBtnNew()
        if isComing == 1{
            getpopupRequests(PopupType: 0, showLoader: false)
        }else{
            gigType = 0
            getUserParticipants(gigtype: gigType)
        }
        
    }
    func selectedBtnNew(){
        btnNew.backgroundColor = UIColor(red: 231/255, green: 243/255, blue: 230/255, alpha: 1.0)
        btnNew.setTitleColor(UIColor.app, for: .normal)
        btnAccepted.backgroundColor = .white
        btnAccepted.setTitleColor(UIColor.darkGray, for: .normal)
        btnRejected.backgroundColor = .white
        btnRejected.setTitleColor(UIColor.darkGray, for: .normal)
        
    }
    @IBAction func actionBack(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
    }
    
    
}
//MARK: -UITableViewDelegate
extension UserParticipantsListVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComing == 1{
            return arrPopupRequest.count
        }else{
            return arrNewParticipants.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantTVC", for: indexPath) as! ParticipantTVC
        if isComing == 1{
            
            cell.lblName.text = arrPopupRequest[indexPath.row].applyuserID?.name ?? ""
            cell.lblGender.text = arrPopupRequest[indexPath.row].message ?? ""
            cell.imgVwUser.imageLoad(imageUrl: arrPopupRequest[indexPath.row].applyuserID?.profilePhoto ?? "")
            cell.viewBack.layer.cornerRadius = 6
         
            if arrPopupRequest[indexPath.row].status ==  1{
                cell.widthBtnMessage.constant = 80
                cell.btnMessage.setTitle("Chat", for: .normal)
                cell.heightStackvw.constant = 0
            }else if arrPopupRequest[indexPath.row].status ==  2{
                cell.widthBtnMessage.constant = 90
                cell.btnMessage.setTitle("Accept", for: .normal)
                cell.heightStackvw.constant = 0
            }else{
                cell.widthBtnMessage.constant = 0
                cell.heightStackvw.constant = 36
                cell.btnChat.setTitle("Accept", for: .normal)
                cell.btnHere.setTitle("Reject", for: .normal)
                cell.btnHere.backgroundColor = UIColor(hex: "#FFB6B6")
                cell.btnHere.setTitleColor(UIColor(hex: "#FF3333"), for: .normal)
            }
        }else{
            if arrNewParticipants[indexPath.row].status ==  0{
                cell.widthBtnMessage.constant = 0
                cell.heightStackvw.constant = 36
                cell.btnChat.setTitle("Chat", for: .normal)
                cell.btnHere.setTitle("Hire", for: .normal)
            }else{
                cell.widthBtnMessage.constant = 100
                cell.heightStackvw.constant = 0
            }
            cell.viewBack.layer.cornerRadius = 6
            cell.btnHere.backgroundColor =  UIColor.app
            cell.btnHere.setTitleColor(UIColor.white, for: .normal)
            cell.lblName.text = arrNewParticipants[indexPath.row].title ?? ""
            cell.lblGender.text = arrNewParticipants[indexPath.row].name ?? ""
            cell.imgVwUser.imageLoad(imageUrl: arrNewParticipants[indexPath.row].image   ?? "")
            
        }
        cell.btnChat.tag = indexPath.row
        cell.btnChat.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
        cell.btnHere.tag = indexPath.row
        cell.btnHere.addTarget(self, action: #selector(actionHire), for: .touchUpInside)
        cell.btnMessage.tag = indexPath.row
        cell.btnMessage.addTarget(self, action: #selector(actionMessage), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrPopupRequest.count - 1 && !isLoading && offSet < totalPages {
            isLoading = true
            offSet += 1
            getpopupRequests(PopupType: 0, showLoader: false)
        }
    }
    
    @objc func actionMessage(sender:UIButton){
        if isComing == 1{
            //Accept
            if arrPopupRequest[sender.tag].status == 2{
                viewModelPopup.acceptRejectPopupRequestApi(requestId: arrPopupRequest[sender.tag].id ?? "", status: 1) {
                    self.getpopupRequests(PopupType: 2, showLoader: false)
                }
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                vc.receiverId = arrPopupRequest[sender.tag].applyuserID?.id ?? ""
                vc.userName = arrPopupRequest[sender.tag].applyuserID?.name ?? ""
                vc.typeId = popupId 
                vc.chatType = "popup"
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
            vc.receiverId = arrNewParticipants[sender.tag].id ?? ""
            vc.chatType = "popup"
            vc.typeId = popupId 
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    @objc func actionChat(sender:UIButton){
        if isComing == 1{
            //Accept
            viewModelPopup.acceptRejectPopupRequestApi(requestId: arrPopupRequest[sender.tag].id ?? "", status: 1) {
                self.getpopupRequests(PopupType: 0, showLoader: false)
            }
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
            vc.receiverId = arrNewParticipants[sender.tag].id ?? ""
            vc.chatType = "popup"
            vc.typeId = popupId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func actionHire(sender:UIButton){
        if isComing == 1{
            //Reject
            viewModelPopup.acceptRejectPopupRequestApi(requestId: arrPopupRequest[sender.tag].id ?? "", status: 2) {
                self.getpopupRequests(PopupType: 0, showLoader: false)
            }
            
        }else{
            print("UserId-------",Store.userId ?? "")
            viewModel.HireForGigApi(gigid: gigId, userid: arrNewParticipants[sender.tag].applyuserId ?? ""){
                let param:parameters = ["userId":self.arrNewParticipants[sender.tag].applyuserId ?? "","gigId":self.gigId,"senderId":Store.userId ?? "","gigName":self.arrNewParticipants[sender.tag].title ?? ""]
                print("Param--------",param)
//                let param:parameters = ["userId":self.arrNewParticipants[sender.tag].applyuserId ?? "","gigId":self.gigId]
                SocketIOManager.sharedInstance.joinGroup(dict: param)
                self.arrNewParticipants.remove(at: sender.tag)
                self.getUserParticipants(gigtype: self.gigType)
            }
        }
    }
}
