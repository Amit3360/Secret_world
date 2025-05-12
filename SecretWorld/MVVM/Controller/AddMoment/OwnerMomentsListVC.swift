//
//  OwnerMomentsListVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 10/04/25.
//

import UIKit

class OwnerMomentsListVC: UIViewController {
    
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var lblNodata: UILabel!
    @IBOutlet var btnCompleted: UIButton!
    @IBOutlet var btnOngoing: UIButton!
    @IBOutlet var btnUpcoming: UIButton!
    @IBOutlet var tblVwList: UITableView!
    
    var viewModel = MomentsVM()
    var arrMomentsList = [MomentsList]()
    var arrAppliedMomentsList = [MomentElement]()
    var offset = 1
    var limit = 10
    var totalNumberOfPages:Int?
    var isComing = false
    var isApplied = false
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    private func uiSet(){
        let nib = UINib(nibName: "MomentsListTVC", bundle: nil)
        tblVwList.register(nib, forCellReuseIdentifier: "MomentsListTVC")
        tblVwList.showsVerticalScrollIndicator = false
        updateButtonSelection(selectedButton: btnUpcoming)
        if isApplied{
            lblScreenTitle.text = "Applied Moments List"
            getAppliedMomentsListApi(type: 0, offset: 1, limit: 10)
        }else{
            lblScreenTitle.text = "Moments List"
            getMomentsListApi(type: 0, offset: 1, limit: 10)
        }
        
        

    }
    private func getAppliedMomentsListApi(type:Int,offset:Int,limit:Int){
        lblNodata.isHidden = true
        arrMomentsList.removeAll()
        viewModel.getAppliedMomentsList(type: type,offset: offset,limit: limit) { data in
            self.arrAppliedMomentsList = data?.moments ?? []
            if data?.moments?.count ?? 0 > 0{
                self.lblNodata.isHidden = true
            }else{
                self.lblNodata.isHidden = false
            }
            self.tblVwList.reloadData()
        }
    }

    private func getMomentsListApi(type:Int,offset:Int,limit:Int){
        lblNodata.isHidden = true
        arrMomentsList.removeAll()
        viewModel.getMomentsList(type: type,offset: offset,limit: limit) { data in
            self.arrMomentsList = data?.moments ?? []
            if data?.moments?.count ?? 0 > 0{
                self.lblNodata.isHidden = true
            }else{
                self.lblNodata.isHidden = false
            }
            self.tblVwList.reloadData()
        }
    }
    @IBAction func actionUpcoming(_ sender: UIButton) {
        updateButtonSelection(selectedButton: btnUpcoming)
        if isApplied{
            getAppliedMomentsListApi(type: 0, offset: 1, limit: 10)
        }else{
            getMomentsListApi(type: 0, offset: 1, limit: 10)
        }
        
    }
    @IBAction func actionOngoing(_ sender: UIButton) {
        updateButtonSelection(selectedButton: btnOngoing)
        if isApplied{
            getAppliedMomentsListApi(type: 1, offset: 1, limit: 10)
        }else{
            getMomentsListApi(type: 1, offset: 1, limit: 10)
        }
    }
    @IBAction func actionCompleted(_ sender: UIButton) {
        updateButtonSelection(selectedButton: btnCompleted)
        if isApplied{
            getAppliedMomentsListApi(type: 2, offset: 1, limit: 10)
        }else{
            getMomentsListApi(type: 2, offset: 1, limit: 10)
        }
    }
    func updateButtonSelection(selectedButton: UIButton) {
        let allButtons = [btnUpcoming, btnOngoing, btnCompleted]
        
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

    @IBAction func actionBack(_ sender: UIButton) {
        if isComing{
            SceneDelegate().tabBarProfileRoot()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
//MARK: -UITableViewDelegate
extension OwnerMomentsListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isApplied ? arrAppliedMomentsList.count : arrMomentsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsListTVC", for: indexPath) as! MomentsListTVC
        setupShadow(for: cell.viewShadow)
        
        if isApplied{
            let moments = arrAppliedMomentsList[indexPath.row]
            cell.lblTitle.text = moments.title ?? ""
            let isoDate = moments.startDate ?? ""
            cell.lblDate.text = formatDateString(isoDate)
            cell.lblTime.text = formatTimeString(isoDate)
            cell.lblLocation.text = moments.place
            if moments.tasks?.count ?? 0 == 1 {
                cell.lblTaskCount.text = "\( moments.tasks?.count ?? 0) Task"
            }else{
                cell.lblTaskCount.text = "\( moments.tasks?.count ?? 0) Tasks"
            }
        }else{
            let moments = arrMomentsList[indexPath.row]
            cell.lblTitle.text = moments.title ?? ""
            let isoDate = moments.startDate ?? ""
            cell.lblDate.text = formatDateString(isoDate)
            cell.lblTime.text = formatTimeString(isoDate)
            cell.lblLocation.text = moments.place
            if moments.tasks?.count ?? 0 == 1 {
                cell.lblTaskCount.text = "\(moments.tasks?.count ?? 0) Task"
            }else{
                cell.lblTaskCount.text = "\(moments.tasks?.count ?? 0) Tasks"
            }
        }
        
        return cell
    }

    private func setupShadow(for view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
        view.layer.shadowOpacity = 0.44
        view.layer.shadowOffset = .zero
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.layer.cornerRadius = 10
    }

    func formatDateString(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dMMMMYYYY" // e.g., 4July2025
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
    func formatTimeString(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Input is in UTC
        formatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a" // e.g., 8:20 AM
            outputFormatter.timeZone = TimeZone.current // Convert to local time
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputFormatter.string(from: date)
        }

        return ""
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isApplied{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSideMomentDetailVC") as! UserSideMomentDetailVC
                vc.momentId = arrAppliedMomentsList[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OwnerMomentDetailVC") as! OwnerMomentDetailVC
                vc.momentId = arrMomentsList[indexPath.row]._id ?? ""
            vc.callBack = {[weak self] in
                guard let self = self else { return }
                self.uiSet()
            }
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    
}
