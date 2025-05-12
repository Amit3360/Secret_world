//
//  GigPopupViewVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/11/24.
//

import UIKit
import Hero

class GigPopupViewVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var collVwHeight: NSLayoutConstraint!
    @IBOutlet var collVwGigList: UICollectionView!
    //MARK: - Variables
    var isSelectBtn = 0
    var callBack:((_ isSelect:Int?,_ isChat:Bool,_ gigData:GetUserGigData?,_ userGig:Bool)->())?
    var arrData = [FilteredItem]()
    var currentIndex = 0
    var selectedId = ""
    var viewModel = AddGigVM()
    var data:GetUserGigData?
    var callBackCancel:(()->())?
    var callBackMoment:((_ popupId:String,_ userId:String)->())?
    var arrParticipanstList = [Participantzz]()
    var isUserGig = false
    
    var viewModelMoment = MomentsVM()
    var MomentData:MomentData?
    var isComingMoment = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
        if !isComingMoment{
            getGigDetailApi(selectId: selectedId)
        }else{
            getMomentDetailApi()
        }
    }
    
    private func getGigDetailApi(selectId: String) {
        viewModel.GetPopUpGigDetailApi(gigId: selectId) { data in
            DispatchQueue.main.async {
                guard let data = data else { return }
                self.data = data
                self.arrParticipanstList = data.participantsList ?? []
                self.updateCellData()
            }
        }
    }

    private func getMomentDetailApi() {
        viewModelMoment.getMomentDetails(id: selectedId) { data in
            DispatchQueue.main.async {
                guard let data = data else { return }
                self.MomentData = data
            
                self.updateCellData()
            }
        }
    }
    private func updateCellData() {
        // Reload the collection view to display updated data
        self.collVwGigList.reloadData()
    }
    private func uiSet() {
       // setupTapGesture()
        if let index = arrData.firstIndex(where: { $0.id == selectedId }) {
            currentIndex = index
        }
        if isComingMoment{
            let nibCollvw = UINib(nibName: "MomentViewCVC", bundle: nil)
            collVwGigList.register(nibCollvw, forCellWithReuseIdentifier: "MomentViewCVC")
            collVwHeight.constant = 350
        }else{
            let nibCollvw = UINib(nibName: "GigViewCVC", bundle: nil)
            collVwGigList.register(nibCollvw, forCellWithReuseIdentifier: "GigViewCVC")
            collVwHeight.constant = 500
        }
        collVwGigList.delegate = self // Set delegate
        collVwGigList.reloadData()
        DispatchQueue.main.async {
            self.scrollToCurrentIndex()
        }
    }
    private func scrollToCurrentIndex() {
        collVwGigList.layoutIfNeeded()
        if arrData.indices.contains(currentIndex) {
            let indexPath = IndexPath(item: currentIndex, section: 0)
            collVwGigList.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            Store.CurrentUserId = arrData[indexPath.row].userID ?? ""
            if !isComingMoment{
                getGigDetailApi(selectId: arrData[indexPath.row].id ?? "")
            }else{
                selectedId = arrData[indexPath.row].id ?? ""
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                    self.getMomentDetailApi()
                }
            }
        }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        // Ignore touches on collection view
        tapGesture.delegate = self
    }
       @objc private func dismissView() {
           dismiss(animated: true, completion: nil)
           callBackCancel?()
       }
    @IBAction func actionLeftClick(_ sender: UIButton) {
        if currentIndex > 0 {
                    currentIndex -= 1
                    scrollToCurrentIndex()
           
                }
    }
    @IBAction func actionRightClick(_ sender: UIButton) {
        if currentIndex < arrData.count - 1 {
                    currentIndex += 1
                    scrollToCurrentIndex()
          
        }
    }
}

//MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension GigPopupViewVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrData.count > 0{
            return arrData.count
        }else{
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isComingMoment{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MomentViewCVC", for: indexPath) as! MomentViewCVC
            if let momentData = MomentData {
                cell.lblMomentName.text = momentData.title ?? ""
                cell.lblUserName.text = momentData.userId?.name ?? ""
                let startDate = momentData.startDate ?? ""
                // Create a DateFormatter to parse the ISO 8601 string
                let isoDateFormatter = ISO8601DateFormatter()
                isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                if let date = isoDateFormatter.date(from: startDate) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MMM-yyyy"
                    let formattedDate = dateFormatter.string(from: date)
                    dateFormatter.dateFormat = "hh:mm a"
                    let formattedTime = dateFormatter.string(from: date)
                    let timeText = "Time: \(formattedTime)"
                    let dateText = "Date: \(formattedDate)"
                    
                    // Create an NSMutableAttributedString for the "Time" label
                    let timeAttributedString = NSMutableAttributedString(string: timeText)
                    let boldAttributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.boldSystemFont(ofSize:11) // Adjust the font size as needed
                    ]
                    // Apply bold to "Time:"
                    timeAttributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 5))
                    
                    // Set the attributed string to the label
                    cell.lblTime.attributedText = timeAttributedString
                    
                    // Create an NSMutableAttributedString for the "Date" label
                    let dateAttributedString = NSMutableAttributedString(string: dateText)
                    // Apply bold to "Date:"
                    dateAttributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 5))
                    
                    // Set the attributed string to the label
                    cell.lblDate.attributedText = dateAttributedString
                } else {
                    print("Invalid date format")
                }
                let locationText = "Location: \(momentData.place ?? "")"
                let locationBoldText = "Location: "
                let locationNormalText = (momentData.place ?? "")
                
                let locationAttributedString = NSMutableAttributedString()
                
                // Bold part for "Location:"
                let boldAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 11) // Adjust font size as needed
                ]
                let boldLocation = NSAttributedString(string: locationBoldText, attributes: boldAttributes)
                locationAttributedString.append(boldLocation)
                
                // Normal part (place name)
                let normalAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 11) // Adjust font size as needed
                ]
        
                    let normalLocation = NSAttributedString(string: locationNormalText, attributes: normalAttributes)
                    locationAttributedString.append(normalLocation)
                    
                    cell.lblLocation.attributedText = locationAttributedString
               
            }
            cell.btnDelete.addTarget(self, action: #selector(dismissMoment), for: .touchUpInside)
            cell.btnViewMore.tag = indexPath.row
            cell.btnViewMore.addTarget(self, action: #selector(viewMoreMoment), for: .touchUpInside)
            cell.btnShare.tag = indexPath.row
            cell.btnShare.addTarget(self, action: #selector(shareMoment), for: .touchUpInside)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GigViewCVC", for: indexPath) as! GigViewCVC
            if let gigData = data {
                cell.arrParticipanstList = arrParticipanstList
                cell.uiSet()
                if gigData.participantsList?.count == 0{
                    cell.lblParticipants.text = "No Participants"
                }else if  gigData.participantsList?.count == 1{
                    cell.lblParticipants.text = "Participant: \(gigData.gig?.totalParticipants ?? 0)"
                }else{
                    cell.lblParticipants.text = "Participants: \(gigData.gig?.totalParticipants ?? 0)"
                }
                
                cell.lblParticipantsCount.text = "Spots: (\(gigData.appliedParticipants ?? 0)/\(gigData.gig?.totalParticipants ?? 0))"
                // Bind gig data to cell
                let value: Double = gigData.gig?.price ?? 0
                let formattedValue = String(format: "%.2f", value)
                let priceText = "Payout: $\(formattedValue)"
                let attributedString = NSMutableAttributedString(string: priceText)
                if let priceRange = priceText.range(of: "$\(gigData.gig?.price ?? 0)") {
                    let nsRange = NSRange(priceRange, in: priceText)
                    attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 14)], range: nsRange)
                }
                cell.lblPayout.attributedText = attributedString
                
                
                // Assuming `gigData.gig?.place`, `gigData.gig?.serviceDuration`, and `gigData.gig?.serviceName` have values
                
                // For lblLocation
                let locationText = "Location: \(gigData.gig?.place ?? "")"
                let locationBoldText = "Location: "
                let locationNormalText = gigData.gig?.address ?? ""
                
                let locationAttributedString = NSMutableAttributedString()
                
                // Bold part for "Location:"
                let boldAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 11) // Adjust font size as needed
                ]
                let boldLocation = NSAttributedString(string: locationBoldText, attributes: boldAttributes)
                locationAttributedString.append(boldLocation)
                
                // Normal part (place name)
                let normalAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 11) // Adjust font size as needed
                ]
                if gigData.gig?.type == "inMyLocation"{
                    let normalLocation = NSAttributedString(string: locationNormalText, attributes: normalAttributes)
                    locationAttributedString.append(normalLocation)
                    
                    cell.lblLocation.attributedText = locationAttributedString
                    
                }else{
                    let normalLocation = NSAttributedString(string: "Remote", attributes: normalAttributes)
                    locationAttributedString.append(normalLocation)
                    
                    cell.lblLocation.attributedText = locationAttributedString
                    
                    
                }
                
                // For lblTaskDuration
                let taskDurationText = "Task Duration: \(gigData.gig?.serviceDuration ?? "")"
                let taskDurationBoldText = "Task Duration: "
                let taskDurationNormalText = gigData.gig?.serviceDuration ?? ""
                
                let taskDurationAttributedString = NSMutableAttributedString()
                
                // Bold part for "Task Duration:"
                let boldTaskDuration = NSAttributedString(string: taskDurationBoldText, attributes: boldAttributes)
                taskDurationAttributedString.append(boldTaskDuration)
                
                // Normal part (service duration)
                let normalTaskDuration = NSAttributedString(string: taskDurationNormalText, attributes: normalAttributes)
                taskDurationAttributedString.append(normalTaskDuration)
                
                // Set the attributed text to the label
                cell.lblTaskDuration.attributedText = taskDurationAttributedString
                
                cell.lblServiceName.font = .boldSystemFont(ofSize: 11)
                cell.lblServiceName.text = "Rating: \(gigData.gig?.rating ?? 0).0"
                if gigData.gig?.rating ?? 0 > 4{
                    cell.imgVwMedal.isHidden = false
                }else{
                    cell.imgVwMedal.isHidden = true
                }
                let startDate = gigData.gig?.startDate ?? ""
                // Create a DateFormatter to parse the ISO 8601 string
                let isoDateFormatter = ISO8601DateFormatter()
                isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                if let date = isoDateFormatter.date(from: startDate) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MMM-yyyy"
                    let formattedDate = dateFormatter.string(from: date)
                    dateFormatter.dateFormat = "hh:mm a"
                    let formattedTime = dateFormatter.string(from: date)
                    let timeText = "Time: \(formattedTime)"
                    let dateText = "Date: \(formattedDate)"
                    
                    // Create an NSMutableAttributedString for the "Time" label
                    let timeAttributedString = NSMutableAttributedString(string: timeText)
                    let boldAttributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.boldSystemFont(ofSize:11) // Adjust the font size as needed
                    ]
                    // Apply bold to "Time:"
                    timeAttributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 5))
                    
                    // Set the attributed string to the label
                    cell.lblTime.attributedText = timeAttributedString
                    
                    // Create an NSMutableAttributedString for the "Date" label
                    let dateAttributedString = NSMutableAttributedString(string: dateText)
                    // Apply bold to "Date:"
                    dateAttributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 5))
                    
                    // Set the attributed string to the label
                    cell.lblDate.attributedText = dateAttributedString
                } else {
                    print("Invalid date format")
                }
                self.changeTimeStatus(gigData.gig?.timeStatus ?? "",lable: cell.lblImmediate,image: cell.imgVwFire)
                cell.lblGigName.text = "\(gigData.gig?.title ?? "") \(gigData.gig?.category?.name ?? "")"
                cell.lblNameProvider.text = "\(gigData.gig?.name ?? "")"
                if gigData.gig?.user?.profilePhoto == "" || gigData.gig?.user?.profilePhoto == nil{
                    cell.imgVwServiceProvider.image = UIImage(named: "dummy")
                }else{
                    cell.imgVwServiceProvider.imageLoad(imageUrl: gigData.gig?.user?.profilePhoto ?? "")
                }
                cell.btnApply.tag = indexPath.row
                cell.btnApply.addTarget(self, action: #selector(actionApply), for: .touchUpInside)
                if gigData.gig?.user?.id == Store.userId{
                    cell.btnApply.setTitle("View More", for: .normal)
                    isUserGig = true
                }else{
                    cell.btnApply.setTitle("View More", for: .normal)
                    isUserGig = false
                }
                
                cell.btnDismiss.tag = indexPath.row
                cell.btnDismiss.addTarget(self, action: #selector(actionDismiss), for: .touchUpInside)
                cell.btnViewMore.tag = indexPath.row
                cell.btnViewMore.addTarget(self, action: #selector(actionViewMore), for: .touchUpInside)
                cell.btnShare.tag = indexPath.row
                cell.btnShare.addTarget(self, action: #selector(actionShare), for: .touchUpInside)
                //cell.btnChat.isHidden = gigData.status != 1
            }
            return cell
        }
    }
 
    @objc func actionShare(sender:UIButton){
        let deepLinkURL = URL(string: "https://api.secretworld.ai/taskId/\(selectedId)")!
        print(deepLinkURL)
               // Initialize UIActivityViewController
               let activityViewController = UIActivityViewController(activityItems: [deepLinkURL], applicationActivities: nil)
               
               // Exclude certain activities if needed
               activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList]
               
               // Present the activity view controller
               present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func shareMoment(sender:UIButton){
        let deepLinkURL = URL(string: "https://api.secretworld.ai/momentId/\(selectedId)")!
        print(deepLinkURL)
               // Initialize UIActivityViewController
               let activityViewController = UIActivityViewController(activityItems: [deepLinkURL], applicationActivities: nil)
               
               // Exclude certain activities if needed
               activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList]
               
               // Present the activity view controller
               present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func dismissMoment(sender:UIButton){
        self.dismiss(animated: true)
        callBackCancel?()
    }
    @objc func viewMoreMoment(sender:UIButton){
        self.dismiss(animated: true)
        callBackMoment?(MomentData?._id ?? "",MomentData?.userId?.id ?? "")
    }
    @objc func actionDismiss(sender:UIButton){
        self.dismiss(animated: true)
        callBackCancel?() 
        
    }
    @objc func actionChat(sender:UIButton){
        self.dismiss(animated: true)
        callBack?(0,true,data, isUserGig)
    }
    @objc func actionViewMore(sender:UIButton){
        self.dismiss(animated: true)
        callBack?(1,false, data, isUserGig)

    }
    @objc func actionApply(sender:UIButton){
        
        self.dismiss(animated: true)
        callBack?(0,false,data, isUserGig)
  
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collVwGigList else { return }
        
        let visibleCells = collVwGigList.visibleCells
        if let firstCell = visibleCells.first,
           let indexPath = collVwGigList.indexPath(for: firstCell) {
            
            // Access the gig ID of the currently visible item
            let gigId = arrData[indexPath.item].id ?? ""
            print("Current Gig ID: \(gigId)")
            Store.CurrentUserId = arrData[indexPath.item].userID ?? ""
            // Avoid redundant API calls for the same gig ID 
            if selectedId != gigId {
                selectedId = gigId
                if isComingMoment{
                    getMomentDetailApi()
                }else{
                    getGigDetailApi(selectId: gigId)
                }
              
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isComingMoment{
            return CGSize(width: collVwGigList.frame.size.width, height: 280)
        }else{
            return CGSize(width: collVwGigList.frame.size.width, height: 430)
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    private func changeTimeStatus(_ timeStatus: String,lable:UILabel,image:UIImageView) {
        lable.text = timeStatus
        switch timeStatus {
           
        case "Immediate!":
            lable.textColor = UIColor(hex: "#D8553A")
            image.image = UIImage(named: "fire")
        case "Same Day!":
            lable.textColor = UIColor(hex: "#FF9100")
            image.image = UIImage(named: "sameDay")
        case "Scheduled task!":
            lable.textColor =  UIColor(hex: "#17A3CE")
            image.image = UIImage(named: "sheduleTask")
        default:
            lable.textColor = UIColor(hex: "#D8553A")
            image.image = UIImage(named: "fire")
        }
    }
    private func formatDateString(_ isoDate: String) -> String {
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
    private func formatTimeString(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX") // Recommended for fixed formats

        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a" // e.g., 4:30 PM
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            outputFormatter.timeZone = TimeZone.current // or set explicitly if needed
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
}

extension GigPopupViewVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Prevent gesture recognizer from triggering when touching buttons
        if let view = touch.view, view is UIButton {
            return false
        }
        return true
    }
}
