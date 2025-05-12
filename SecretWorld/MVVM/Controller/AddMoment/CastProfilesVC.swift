//
//  CastProfilesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/04/25.
//

import UIKit

class CastProfilesVC: UIViewController {
//MARK: - IBOutlet
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var tblVwList: UITableView!
    
    //MARK: - variables
    var callBack:(()->())?
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
        let nib = UINib(nibName: "ParticipantsListTVC", bundle: nil)
        tblVwList.register(nib, forCellReuseIdentifier: "ParticipantsListTVC")
        let nibTaskCount = UINib(nibName: "TaskCountSectionTVC", bundle: nil)
        tblVwList.register(nibTaskCount, forCellReuseIdentifier: "TaskCountSectionTVC")
        tblVwList.estimatedRowHeight = 300
        tblVwList.rowHeight = UITableView.automaticDimension

        getParticipantsList()

    }
    private func getParticipantsList() {
        lblNoData.isHidden = true
        viewModel.getMomentParticipantsApi(momentId: momentId ?? "", status: 1,loader: true) { [self] data in
            self.taskUserDataList = data ?? []
            let filteredData = self.taskUserDataList.filter { $0.appliedUsers?.isEmpty == false }
            lblNoData.isHidden = !filteredData.isEmpty
            self.tblVwList.reloadData()
        }
    }

    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: -UITableViewDelegate
extension CastProfilesVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return filteredTasksWithOriginalIndex.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasksWithOriginalIndex[section].data.appliedUsers?.count ?? 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let filteredData = taskUserDataList.filter { $0.appliedUsers?.isEmpty == false }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantsListTVC", for: indexPath) as! ParticipantsListTVC
        cell.btnChat.isHidden = true
        cell.btnAccept.isHidden = true
        cell.btnReject.isHidden = true
        cell.hieghtStackVwBTns.constant = 0
            let appliedUser = filteredTasksWithOriginalIndex[indexPath.section].data.appliedUsers?[indexPath.row]
        if Store.UserDetail?["userId"] as? String ?? "" == appliedUser?.id ?? ""{
            
            cell.widthBtnCastProfileChat.constant = 0
            cell.heightBtnChatCastProfile.constant = 0
        }else{
            cell.heightBtnChatCastProfile.constant = 36
            cell.widthBtnCastProfileChat.constant = 36
        }
            

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
        return UITableView.automaticDimension
    }

    
}
