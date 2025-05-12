//
//  MomentParticipantsVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 10/04/25.
//

import UIKit

class MomentParticipantsVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var heightStackVwBtns: NSLayoutConstraint!
    @IBOutlet var lblNodata: UILabel!
    @IBOutlet var btnNew: UIButton!
    @IBOutlet var btnAccepted: UIButton!
    @IBOutlet var btnRejected: UIButton!
    @IBOutlet var tblVwParticipants: UITableView!
    
    //MARK: - variables
    var momentName:String?
    var callBack:(()->())?
    var selectedType:Int? //0 accept  1 new  2 reject
    var viewModel = MomentsVM()
    var momentId:String?
    var taskUserDataList: [TaskUserData] = []
    var filteredTasksWithOriginalIndex: [(index: Int, data: TaskUserData)] {
        return taskUserDataList.enumerated().compactMap { index, task in
            guard let appliedUsers = task.appliedUsers, !appliedUsers.isEmpty else { return nil }
            return (index: index, data: task)
        }
    }
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    
    private func uiSet(){
        let nibTaskCount = UINib(nibName: "TaskCountSectionTVC", bundle: nil)
        tblVwParticipants.register(nibTaskCount, forCellReuseIdentifier: "TaskCountSectionTVC")
        let nibAcceptReject = UINib(nibName: "AcceptRejectTVC", bundle: nil)
        tblVwParticipants.register(nibAcceptReject, forCellReuseIdentifier: "AcceptRejectTVC")
        let nib = UINib(nibName: "ParticipantsListTVC", bundle: nil)
        tblVwParticipants.register(nib, forCellReuseIdentifier: "ParticipantsListTVC")
        
        updateButtonSelection(selectedButton: btnNew)
        heightStackVwBtns.constant = 36
        selectedType = 0
        getParticipantsList(status: 0)
        
    }
    
    private func getParticipantsList(status: Int) {
        lblNodata.isHidden = true
        viewModel.getMomentParticipantsApi(momentId: momentId ?? "", status: status,loader: true) { [self] data in
            self.taskUserDataList = data ?? []
            let filteredData = self.taskUserDataList.filter { $0.appliedUsers?.isEmpty == false }
            lblNodata.isHidden = !filteredData.isEmpty
            self.tblVwParticipants.reloadData()
        }
    }
    //MARK: - IBAction
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        callBack?()
    }
    @IBAction func actionNewRequest(_ sender: UIButton) {
        updateButtonSelection(selectedButton: btnNew)
        selectedType = 0
        getParticipantsList(status: 0)
        
    }
    @IBAction func actionAcceptedRequest(_ sender: UIButton) {
        updateButtonSelection(selectedButton: btnAccepted)
        selectedType = 1
        getParticipantsList(status: 1)
    }
    @IBAction func actionRejectedRequest(_ sender: UIButton) {
        updateButtonSelection(selectedButton: btnRejected)
        selectedType = 2
        getParticipantsList(status: 2)
        
    }
    private func updateButtonSelection(selectedButton: UIButton) {
        let allButtons = [btnNew, btnAccepted, btnRejected]
        
        for button in allButtons {
            if button == selectedButton {
                button?.backgroundColor = UIColor(red: 231/255, green: 243/255, blue: 230/255, alpha: 1.0)
                button?.setTitleColor(.app, for: .normal)
            } else {
                button?.backgroundColor = .white
                button?.setTitleColor(.darkGray, for: .normal)
            }
        }
    }
    
}

//MARK: -UITableViewDelegate
extension MomentParticipantsVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return filteredTasksWithOriginalIndex.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasksWithOriginalIndex[section].data.appliedUsers?.count ?? 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filteredData = taskUserDataList.filter { $0.appliedUsers?.isEmpty == false }
        
        if selectedType == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantsListTVC", for: indexPath) as! ParticipantsListTVC
            let tapGestureImg = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            cell.imgVwUser.isUserInteractionEnabled = true
            cell.imgVwUser.tag = indexPath.row // store row; optionally combine with section
            cell.imgVwUser.addGestureRecognizer(tapGestureImg)
            cell.imgVwUser.accessibilityHint = "\(indexPath.section)" // store section

            cell.widthBtnCastProfileChat.constant = 0
            cell.btnAccept.tag = indexPath.row
            cell.btnAccept.accessibilityHint = "\(indexPath.section)"
            cell.btnAccept.addTarget(self, action: #selector(actionAccept(_:)), for: .touchUpInside)
            
            cell.btnReject.tag = indexPath.row
            cell.btnReject.accessibilityHint = "\(indexPath.section)"
            cell.btnReject.addTarget(self, action: #selector(actionReject(_:)), for: .touchUpInside)
            
            cell.btnChat.tag = indexPath.row
            cell.btnChat.accessibilityHint = "\(indexPath.section)"
            cell.btnChat.addTarget(self, action: #selector(actionChatNewRequest(_:)), for: .touchUpInside)
            
            let appliedUser = filteredTasksWithOriginalIndex[indexPath.section].data.appliedUsers?[indexPath.row]
            
            cell.lblUserNAme.text = appliedUser?.name ?? ""
            cell.lblTitle.text = appliedUser?.role ?? ""
            cell.lblTaskCompleted.text = "• Task completed: \(appliedUser?.taskCompleted ?? 0)"
            cell.lblRatingReview.text = "0.0 (0 Reviews)"
            cell.lblDesciption.text = appliedUser?.message ?? ""
            if let distance = appliedUser?.distance {
                if distance > 0{
                    cell.lblLocation.text = String(format: "• Location: %.1f miles", distance)
                }else{
                    cell.lblLocation.text = "• Location: 0 miles"
                }
            }
            cell.imgVwUser.imageLoad(imageUrl: appliedUser?.profilePhoto ?? "")
            let createdAt = appliedUser?.createdAt ?? ""
            let formattedTime = convertToAMPM(from: createdAt)
            cell.lblTime.text = formattedTime
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptRejectTVC", for: indexPath) as! AcceptRejectTVC
            let appliedUser = filteredData[indexPath.section].appliedUsers?[indexPath.row]
            cell.lblName.text = appliedUser?.name ?? ""
            cell.lblGender.text = appliedUser?.gender ?? ""
            cell.imgVwUser.imageLoad(imageUrl: appliedUser?.profilePhoto ?? "")
            if selectedType == 1{
                cell.btnChat.isHidden = false
                cell.btnChat.tag = indexPath.row
                
            }else{
                cell.btnChat.isHidden = true
            }
            cell.btnChat.tag = indexPath.row
            cell.btnChat.accessibilityHint = "\(indexPath.section)"
            cell.btnChat.addTarget(self, action: #selector(actionChatAcceptedRequest(_:)), for: .touchUpInside)
            
            return cell
        }
        
    }
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        let row = tappedImageView.tag
        guard let sectionStr = tappedImageView.accessibilityHint,
              let section = Int(sectionStr) else { return }

        let appliedUser = filteredTasksWithOriginalIndex[section].data.appliedUsers?[row]
        let userId = appliedUser?.id ?? ""

        print("👤 Image tapped for user: \(appliedUser?.name ?? "") | ID: \(userId)")

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewVC") as! ProfileViewVC
        vc.id = userId
        vc.isComingChat = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func actionAccept(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteMomentPopUpVC") as! DeleteMomentPopUpVC
        vc.isSelect = 1
        vc.callBack = {[weak self] in
            guard let self = self else { return }
            guard let sectionStr = sender.accessibilityHint,
                  let section = Int(sectionStr) else { return }
            let row = sender.tag
            
            let filteredData = taskUserDataList.filter { $0.appliedUsers?.isEmpty == false }
            let appliedUser = filteredData[section].appliedUsers?[row]
            
            print("✅ Accept: \(appliedUser?.name ?? "") | ID: \(appliedUser?.requestId ?? "")")
            
            viewModel.acceptRequestApi(momentid: momentId ?? "", userid: appliedUser?.id ?? "") {
                self.uiSet()
            }
            
        }
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
        
    }
    
    @objc func actionReject(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteMomentPopUpVC") as! DeleteMomentPopUpVC
        vc.isSelect = 2
        vc.callBack = {[weak self] in
            guard let self = self else { return }
            guard let sectionStr = sender.accessibilityHint,
                  let section = Int(sectionStr) else { return }
            let row = sender.tag
            
            let filteredData = taskUserDataList.filter { $0.appliedUsers?.isEmpty == false }
            let appliedUser = filteredData[section].appliedUsers?[row]
            
            print("✅ Reject: \(appliedUser?.name ?? "") | ID: \(appliedUser?.requestId ?? "")")
            
            viewModel.rejectRequestApi(requestId: appliedUser?.requestId ?? "", userId: appliedUser?.id ?? "") {
                self.uiSet()
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
        
    }
    @objc func actionChatAcceptedRequest(_ sender: UIButton) {
        print("✅ actionChatAcceptedRequest clicked: ")
        guard let sectionStr = sender.accessibilityHint,
              let section = Int(sectionStr) else { return }
        let row = sender.tag
        
        let filteredData = taskUserDataList.filter { $0.appliedUsers?.isEmpty == false }
        let appliedUser = filteredData[section].appliedUsers?[row]
        
        print("✅ actionChatAcceptedRequest: \(appliedUser?.name ?? "") | ID: \(appliedUser?.requestId ?? "")")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
        vc.typeName = momentName ?? ""
        vc.receiverId = appliedUser?.id ?? ""
        vc.typeId = momentId ?? ""
        vc.chatType = "task"
        vc.isMoment = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func actionChatNewRequest(_ sender: UIButton) {
        print("✅ actionChatNewRequest clicked: ")
        guard let sectionStr = sender.accessibilityHint,
              let section = Int(sectionStr) else { return }
        let row = sender.tag
        
        let filteredData = taskUserDataList.filter { $0.appliedUsers?.isEmpty == false }
        let appliedUser = filteredData[section].appliedUsers?[row]
        
        print("✅ actionChatNewRequest: \(appliedUser?.name ?? "") | ID: \(appliedUser?.requestId ?? "")")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
        vc.typeName = momentName ?? ""
        vc.receiverId = appliedUser?.id ?? ""
        vc.typeId = momentId ?? ""
        vc.chatType = "task"
        vc.isMoment = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func convertToAMPM(from isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: isoString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "hh:mm a"
            displayFormatter.amSymbol = "AM"
            displayFormatter.pmSymbol = "PM"
            displayFormatter.locale = Locale(identifier: "en_US_POSIX")
            return displayFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCountSectionTVC") as! TaskCountSectionTVC
        let originalIndex = filteredTasksWithOriginalIndex[section].index
        cell.lblTaskCount.text = "Task \(originalIndex + 1)"
        
        return cell.contentView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedType == 0{
            return 210
        }else{
            return 100
        }
    }
    
    
}
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
