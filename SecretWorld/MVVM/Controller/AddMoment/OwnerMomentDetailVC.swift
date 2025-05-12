//
//  OwnerMomentDetailVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 09/04/25.
//

import UIKit

class OwnerMomentDetailVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var viewShadow: UIView!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblReviewTitle: UILabel!
    @IBOutlet var heightTblVwReview: NSLayoutConstraint!
    @IBOutlet var tblVwReview: UITableView!
    @IBOutlet var btnReview: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet var heightTblVwTaskList: NSLayoutConstraint!
    @IBOutlet var tblVwTaskList: UITableView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewParticipants: UIView!
    @IBOutlet var lblUserCount: UILabel!
    @IBOutlet var viewUserCount: UIView!
    
    //MARK: - variables
    var hasAcceptedPerson = false
    var viewModel = MomentsVM()
    var arrMoments = [MomentTask]()
    var momentId:String?
    var MomentData:MomentData?
    var callBack:(()->())?
    var paymentMethod: String?
    var arrReviews = [ReviewDataa]()
    var isComingHome = false
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.tblVwTaskList.reloadData()
            self.tblVwTaskList.layoutIfNeeded()
            self.heightTblVwTaskList.constant = self.tblVwTaskList.contentSize.height
            
            self.tblVwReview.reloadData()
            self.tblVwReview.layoutIfNeeded()
            self.heightTblVwReview.constant = self.tblVwReview.contentSize.height
            
        }
    }
    
    private func uiSet(){
        tblVwReview.delegate = self
        tblVwReview.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleParticipantTap))
        viewParticipants.isUserInteractionEnabled = true
        viewParticipants.addGestureRecognizer(tapGesture)
        let nib = UINib(nibName: "OwnerMomentTaskListTVC", bundle: nil)
        tblVwTaskList.register(nib, forCellReuseIdentifier: "OwnerMomentTaskListTVC")
        tblVwTaskList.isScrollEnabled = false
        tblVwTaskList.estimatedRowHeight = 200
        tblVwTaskList.rowHeight = UITableView.automaticDimension
        
        let nibReview = UINib(nibName: "SelfReviewTVC", bundle: nil)
        tblVwReview.register(nibReview, forCellReuseIdentifier: "SelfReviewTVC")
        tblVwReview.isScrollEnabled = false
        tblVwReview.estimatedRowHeight = 300
        tblVwReview.rowHeight = UITableView.automaticDimension
        setupShadow(for: viewShadow)
        
        getMomentApi()
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
    
    @objc func handleParticipantTap() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MomentParticipantsVC") as! MomentParticipantsVC
        vc.momentName = MomentData?.title ?? ""
        vc.momentId = MomentData?._id ?? ""
        vc.callBack = {
            self.uiSet()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK: - API Call
    func getMomentApi() {
        viewModel.getMomentDetails(id: momentId ?? "") { data in
            self.lblLocation.text = data?.place ?? ""
            self.btnDelete.isHidden = false
            self.MomentData = data
            if data?.status == 2{
                self.btnReview.isHidden = false
            }else{
                self.btnReview.isHidden = true
            }
            //            if self.MomentData?.paymentMethod == 0 {
            //                self.paymentMethod = "Online"
            //            } else {
            //                self.paymentMethod = "Cash"
            //            }
            
            self.lblUserCount.text =  "\(data?.participants ?? 0)"
            self.lblTitle.text = data?.title?.capitalized ?? ""
            self.lblDate.text = self.formatDateString(data?.startDate ?? "")
            self.lblTime.text = self.formatTimeString(data?.startDate ?? "")
            self.arrMoments = data?.tasks ?? []
            
            if let tasks = data?.tasks {
                for task in tasks {
                    if let reviews = task.reviews {
                        self.arrReviews.append(contentsOf: reviews)
                    }
                    
                    if let accepted = task.personAccepted, accepted > 0 {
                        self.hasAcceptedPerson = true
                        break
                    }
                }
            }
            
            if self.hasAcceptedPerson {
                self.btnEdit.isHidden = true
            } else {
                self.btnEdit.isHidden = false
                
            }
            
            if !self.isWithinOneHourBeforeStart(startDate: data?.startDate ?? ""){
                
                self.btnDelete.alpha = 0.5
                self.btnDelete.isUserInteractionEnabled = false
                
            }else{
                self.btnDelete.alpha = 1.0
                self.btnDelete.isUserInteractionEnabled = true
                
            }
            if self.arrReviews.count > 0{
                self.lblReviewTitle.text = "Reviews"
            }else{
                self.lblReviewTitle.text = ""
            }
            DispatchQueue.main.async {
                self.tblVwTaskList.reloadData()
                self.tblVwTaskList.layoutIfNeeded()
                self.heightTblVwTaskList.constant = self.tblVwTaskList.contentSize.height
                self.tblVwReview.reloadData()
                self.tblVwReview.layoutIfNeeded()
                self.heightTblVwReview.constant = self.tblVwReview.contentSize.height
                self.view.layoutIfNeeded()
            }
            
        }
    }
    func isWithinOneHourBeforeStart(startDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let startDateTime = dateFormatter.date(from: startDate) else {
            return false
        }
        
        let oneHourBeforeStart = startDateTime.addingTimeInterval(-3600)
        return Date() <= oneHourBeforeStart
    }
    
    //MARK: - IBAction
    @IBAction func actionReview(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseParticipantsVC") as! ChooseParticipantsVC
        vc.modalPresentationStyle = .overFullScreen
        vc.momentId = MomentData?._id ?? ""
        vc.callBAck = {[weak self] userId,taskId in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewReviewVC") as! NewReviewVC
                vc.appliedUserId = userId
                vc.taskId = taskId
                vc.momentId = self.MomentData?._id ?? ""
                vc.callBack = {[weak self]  in
                    guard let self = self else { return }
                    self.arrReviews.removeAll()
                    DispatchQueue.main.async {
                        self.uiSet()
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        if isComingHome{
            callBack?()
        }
    }
    @IBAction func actionDelete(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteMomentPopUpVC") as! DeleteMomentPopUpVC
        vc.isSelect = 0
        vc.callBack = {[weak self] in
            guard let self = self else { return }
            viewModel.deleteMomentApi(id: momentId ?? "") { message in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.callBack?()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
        
    }
    @IBAction func actionEdit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMomentVC") as! AddMomentVC
        vc.MomentData = MomentData
        vc.isEdit = true
        vc.callBack = {
            DispatchQueue.main.async {
                self.uiSet()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func actionChat(_ sender: UIButton) {
        
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
    
}
//MARK: -UITableViewDelegate
extension OwnerMomentDetailVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwReview{
            return arrReviews.count
            
        }else{
            return arrMoments.count
        }
    }
    func applyBoxShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25 // 40 in hex = 25% opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwReview{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelfReviewTVC", for: indexPath) as! SelfReviewTVC
            
            let review = arrReviews[indexPath.row]
            cell.lblRatingType.textColor = getRatingColor(score: review.overallAverage ?? 0)
            cell.lblRatingType.font = UIFont(name: "DancingScript-Bold", size: 13)
            cell.lblRatingType.text = getRatingLabel(score: review.overallAverage ?? 0)  // Convert Float to Double
            if let ratingImageName = getRatingImageName(score: review.overallAverage ?? 0) {
                cell.imgVwRate.image = UIImage(named: ratingImageName)
            } else {
                cell.imgVwRate.image = UIImage(named: "meh") // Replace with your default image
            }
            
            applyBoxShadow(to: cell.viewShadow)
            cell.lblUserName.text = review.businessUser?.name ?? ""
            cell.imgVwUser.imageLoad(imageUrl: review.businessUser?.profilePhoto ?? "")
            cell.lblComment.text = review.comment ?? ""
            cell.lblReliability.attributedText = styledRatingText(title: "Reliability", value: review.rating?.reliability ?? 0)
            cell.lblSpeed.attributedText = styledRatingText(title: "Speed", value: review.rating?.speed ?? 0)
            cell.lblAttitude.attributedText = styledRatingText(title: "Attitude", value: review.rating?.attitude ?? 0)
            cell.lblQuality.attributedText = styledRatingText(title: "Quality", value: review.rating?.quality ?? 0)
            cell.lblCommunincation.attributedText = styledRatingText(title: "Communication", value: review.rating?.communication ?? 0)
            let timeString = timeAgoString(from: review.createdAt ?? "")
            cell.lblTime.text = timeString
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerMomentTaskListTVC", for: indexPath) as! OwnerMomentTaskListTVC
            
            cell.momentTask = arrMoments[indexPath.row]
            cell.uiSet()
            let task = arrMoments[indexPath.row]
            cell.lblTitle.text = task.role?.capitalized ?? ""
            cell.lblRoleInstruction.text = task.roleInstruction?.capitalized ?? ""
            cell.lblBarter.text = task.barterProposal?.capitalized ?? ""
            cell.lblTime.text = task.taskDuration ?? ""
            let accepted = task.personAccepted ?? 0
            let needed = task.personNeeded ?? 0
            cell.lblSpot.text = "Spots (\(accepted)/\(task.personNeeded ?? 0))"
            
            let amount = task.perPersonAmount ?? 0
            let paymentTermsText = (task.paymentTerms == 0) ? "Fixed" : "Hourly"
            let fullText = "Payout: $\(amount) per person (\(paymentTermsText))"
            let boldText = "$\(amount) per person (\(paymentTermsText))"
            let attributedString = NSMutableAttributedString(string: fullText)
            let regularFont = UIFont(name: "Nunito-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
            let boldFont = UIFont(name: "Nunito-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
            attributedString.addAttribute(.font, value: regularFont, range: NSRange(location: 0, length: fullText.count))
            if let boldRange = fullText.range(of: boldText) {
                let nsRange = NSRange(boldRange, in: fullText)
                attributedString.addAttribute(.font, value: boldFont, range: nsRange)
            }
            cell.lblAmount.attributedText = attributedString
            
            cell.lblTaskCount.text = "Task \(indexPath.row + 1)"
            cell.lblCalculation.text = "Total Payout: \(task.personNeeded ?? 0)×\(task.perPersonAmount ?? 0) = \(task.amount ?? 0) (\(paymentTermsText))"
            
            if needed > 0 {
                cell.progressView.progress = Float(accepted) / Float(needed)
            } else {
                cell.progressView.progress = 0.0
            }
            if task.taskPaymentMethod == 1{
                //barter
                cell.viewBarter.isHidden = false
                cell.viewPayout.isHidden = true
                cell.heightViewCalculation.constant = 0
            }else  if task.taskPaymentMethod == 2{
                //barter+money
                cell.viewBarter.isHidden = false
                cell.viewPayout.isHidden = false
                cell.heightViewCalculation.constant = 37
            }else{
                //0 for money
                cell.viewBarter.isHidden = true
                cell.viewPayout.isHidden = false
                cell.heightViewCalculation.constant = 37
            }
            
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVwReview{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewReviewVC") as! NewReviewVC
            vc.appliedUserId = arrReviews[indexPath.row].businessUser?._id ?? ""
            vc.isEdit = true
            vc.arrReviews = arrReviews
            vc.indexx = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    private func getRatingLabel(score: Double) -> String {
        switch score {
        case 0...20:
            return "Meh"
        case 20...40:
            return "Okayish"
        case 40...60:
            return "Good"
        case 60...80:
            return "Fire"
        case 80...100:
            return "Awesome"
        default:
            return "Unknown"
        }
    }
    
    private func getRatingImageName(score: Double) -> String? {
        switch score {
        case 0...20:
            return "meh"          // Replace with actual asset name
        case 21...40:
            return "okayish"
        case 41...60:
            return "good"
        case 61...80:
            return "ic_fire"
        case 81...100:
            return "awesome"
        default:
            return nil
        }
    }
    
    private func getRatingColor(score: Double) -> UIColor {
        switch score {
        case 0...20:
            return UIColor(hex: "#A0A0A0")     // Gray
        case 20...40:
            return UIColor(hex: "#4CAF50")     // Green
        case 40...60:
            return UIColor(hex: "#FFD700")     // Gold
        case 60...80:
            return UIColor(hex: "#FF4210")     // Deep Orange
        case 80...100:
            return UIColor(hex: "#3F51B5")     // Indigo
        default:
            return UIColor.black
        }
    }
    
    func styledRatingText(title: String, value: Int) -> NSAttributedString {
        let titleFont = UIFont(name: "Nunito-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12)
        let valueFont = UIFont(name: "Nunito-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: valueFont,
            .foregroundColor: UIColor(hex: "#828282")
        ]
        
        let attributedString = NSMutableAttributedString(string: "\(title): ", attributes: titleAttributes)
        let valueString = NSAttributedString(string: "\(value)", attributes: valueAttributes)
        
        attributedString.append(valueString)
        
        return attributedString
    }
    
    
    
    func timeAgoString(from dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: dateString) else {
            return ""
        }
        
        let now = Date()
        let secondsAgo = Int(now.timeIntervalSince(date))
        
        if secondsAgo < 60 {
            return "now"
        }
        
        let minutesAgo = secondsAgo / 60
        if minutesAgo < 60 {
            return "\(minutesAgo) minute\(minutesAgo == 1 ? "" : "s") ago"
        }
        
        let hoursAgo = minutesAgo / 60
        if hoursAgo < 24 {
            return "\(hoursAgo) hour\(hoursAgo == 1 ? "" : "s") ago"
        }
        
        let daysAgo = hoursAgo / 24
        if daysAgo < 7 {
            return "\(daysAgo) day\(daysAgo == 1 ? "" : "s") ago"
        }
        
        let weeksAgo = daysAgo / 7
        if weeksAgo < 4 {
            return "\(weeksAgo) week\(weeksAgo == 1 ? "" : "s") ago"
        }
        
        let monthsAgo = daysAgo / 30
        if monthsAgo < 12 {
            return "\(monthsAgo) month\(monthsAgo == 1 ? "" : "s") ago"
        }
        
        let yearsAgo = monthsAgo / 12
        return "\(yearsAgo) year\(yearsAgo == 1 ? "" : "s") ago"
    }
    
    
    
}
