//
//  PopupReviewVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 22/01/25.
//

import UIKit
import IQKeyboardManagerSwift
import FloatRatingView

class PopupReviewVC: UIViewController {
    
   
    @IBOutlet weak var heightParticipantVw: NSLayoutConstraint!
    @IBOutlet weak var btnParticipant: UIButton!
    @IBOutlet weak var vwParticipant: UIView!
    @IBOutlet weak var topVwParticipant: NSLayoutConstraint!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var imgVwReview: UIImageView!
    @IBOutlet weak var ratingVw: FloatRatingView!
    @IBOutlet weak var txtVwDescription: IQTextView!
    
    var reviewImgUrl:String?
    var viewModelUploadImg = UploadImageVM()
    var MomentData:MomentData?
    var viewModelMoment = MomentsVM()
    var viewModel = PopupReviewVM()
    var popupId = ""
    var isUpload = false
    var gigId = ""
    var reviewId = ""
    var callBack:((String?)->())?
    var isComing = false
    var popUpDetail:PopupDetailData?
    var isComingPopUp = false
    var businessGigDetail:GetGigDetailData?
    var userGigDetail:GetUserGigData?
    var arrCompleteParticipants = [GetRequestData]()
    var viewModelTask = ExploreVM()
    var selectUserId = ""
    var taskReviewUpdate = false
    var taskReviewId = ""
    var isMyTask = false
    override func viewDidLoad() {
        super.viewDidLoad()

        uiData()
    }
    func uiData(){
      
        if isComingPopUp{
            lblTitle.text = MomentData?.title ?? ""
            lblRating.text = "0 (0 reviews)"
            vwParticipant.isHidden = true
            heightParticipantVw.constant = 0
            topVwParticipant.constant = 0
//            if isMyTask{
//                vwParticipant.isHidden = false
//                topVwParticipant.constant = 20
//                lblTitle.text = "\(businessGigDetail?.title ?? "") \(businessGigDetail?.category?.name ?? "")"
//                heightParticipantVw.constant = 50
//                if businessGigDetail?.reviews?.count ?? 0 > 1{
//                    lblRating.text = " \(businessGigDetail?.reviews?.count ?? 0) reviews"
//                }else{
//                    lblRating.text = " \(businessGigDetail?.reviews?.count ?? 0) review"
//                }
//              
//            }else{
//                vwParticipant.isHidden = true
//                heightParticipantVw.constant = 0
//                topVwParticipant.constant = 0
//                lblTitle.text = "\(userGigDetail?.gig?.title ?? "") \(userGigDetail?.gig?.category?.name ?? "")"
//                if userGigDetail?.reviews?.count ?? 0 > 1{
//                    lblRating.text = "\(userGigDetail?.rating ?? 0) (\(userGigDetail?.reviews?.count ?? 0) reviews)"
//                }else{
//                    lblRating.text = "\(userGigDetail?.rating ?? 0) (\(userGigDetail?.reviews?.count ?? 0) review)"
//                }
//               
//                for i in userGigDetail?.reviews ?? [] {
//                    if i.user?.id == Store.userId{
//                        txtVwDescription.text = i.comment ?? ""
//                        ratingVw.rating = i.starCount ?? 0
//                        imgVwReview.imageLoad(imageUrl: i.media ?? "")
//                        btnSubmit.setTitle("Update", for: .normal)
//                        taskReviewId = i.id ?? ""
//                        taskReviewUpdate = true
//                    }else{
//                        txtVwDescription.text = ""
//                        ratingVw.rating = 0
//                        imgVwReview.image = nil
//                        btnSubmit.setTitle("Submit", for: .normal)
//                        taskReviewUpdate = true
//                    }
//                }
//            }
           
       
        }else{
            vwParticipant.isHidden = true
            topVwParticipant.constant = 0
            heightParticipantVw.constant = 0
            if isComing{
                lblTitle.text = popUpDetail?.name ?? ""
                lblRating.text = "\(popUpDetail?.rating ?? 0) (\(popUpDetail?.reviews?.count ?? 0) reviews)"
                for i in popUpDetail?.reviews ?? []{
                    imgVwReview.imageLoad(imageUrl: i.media ?? "")
                    txtVwDescription.text = i.comment ?? ""
                    ratingVw.rating = Double(i.starCount ?? 0)
                    reviewId = i.id ?? ""
                    
                }
                btnSubmit.setTitle("Update", for: .normal)
            }else{
                lblTitle.text = popUpDetail?.name ?? ""
                lblRating.text = "\(popUpDetail?.rating ?? 0) (\(popUpDetail?.reviews?.count ?? 0) reviews)"
                btnSubmit.setTitle("Submit", for: .normal)
            }
        }
        
    }
    @IBAction func actionSubmit(_ sender: UIButton) {
        let trimmedText = txtVwDescription.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !isComingPopUp{
            if ratingVw.rating == 0{
                showSwiftyAlert("", "Please select rating", false)
            }else{
                if isComing{
                    viewModel.UpdatePopupReview(reviewId: reviewId, media: imgVwReview, comment: trimmedText, starCount: Int(ratingVw.rating)) {
                        self.dismiss(animated: true)
                        self.callBack?("")
                    }
                }else{
                    viewModel.AddPopupReview(popupId: popupId, media: imgVwReview, comment: trimmedText, starCount: Int(ratingVw.rating)) {
                        self.dismiss(animated: true)
                        self.callBack?("")
                    }
                }
                
            }
        }else{
            
            viewModelMoment.addMomentReviewByUser(momentId: MomentData?._id ?? "", businessUserId: MomentData?.userId?.id ?? "", media: reviewImgUrl ?? "", comment: trimmedText, starCount: Int(ratingVw.rating)) { message in
                self.dismiss(animated: true)
                self.callBack?(message)
            }
            
//            if isMyTask{
//                if taskReviewUpdate{
//                    viewModelTask.updateReviewApi(targetType: "gig", targetId: taskReviewId, comment: trimmedText, starCount: String(ratingVw.rating), media: imgVwReview, isUploading: isUpload) { message in
//                        self.dismiss(animated: true)
//                        self.callBack?()
//                    }
//                }else{
//                    if selectUserId == "" {
//                        showSwiftyAlert("", "Select a participants", false)
//                    }else{
//                        viewModelTask.AddGigReviewApi(gigId: gigId, businessUserId: selectUserId,
//                                                      media: imgVwReview,
//                                                      comment: trimmedText,
//                                                      starCount: String(ratingVw.rating), reviewType: 1, isUploading: isUpload) {
//                            
//                            self.dismiss(animated: true)
//                            self.callBack?()
//                        }
//                    }
//                   
//                }
//            }else{
//                if taskReviewUpdate{
//                    viewModelTask.updateReviewApi(targetType: "gig", targetId: taskReviewId, comment: trimmedText, starCount: String(ratingVw.rating), media: imgVwReview, isUploading: isUpload) { message in
//                        self.dismiss(animated: true)
//                        self.callBack?()
//                    }
//                  
//                }else{
//                    viewModelTask.AddGigReviewApi(gigId: gigId, businessUserId: Store.userId ?? "",
//                                                  media: imgVwReview,
//                                                  comment: trimmedText,
//                                                  starCount: String(ratingVw.rating), reviewType: 0, isUploading: isUpload) {
//                        self.dismiss(animated: true)
//                        self.callBack?()
//                    }
//                }
//               
//            }
        }
    }
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionUploadImg(_ sender: UIButton) {
        ImagePicker().pickImage(self) { image in
            self.viewModelUploadImg.uploadProductImagesApi(Images: image) { imageData in
                if let firstImageUrl = imageData?.imageUrls?.first {
                    self.imgVwReview.imageLoad(imageUrl: firstImageUrl)
                    self.reviewImgUrl = firstImageUrl
                    self.isUpload = true
                }
            }
        }
    }
    
    @IBAction func actionChooseParticipant(_ sender: UIButton) {
        if businessGigDetail?.participantsList?.count ?? 0 > 0{
            let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
            vc.type = "review"
            vc.modalPresentationStyle = .popover
            vc.businessGigDetail = self.businessGigDetail
            vc.callBack = { (type,name,id) in
                self.btnParticipant.setTitle(name, for: .normal)
                self.selectUserId = id
                
                for i in self.arrCompleteParticipants {
                    if i.review != nil{
                        if  i.applyuserID == self.selectUserId{
                            self.btnSubmit.setTitle("Update", for: .normal)
                            self.ratingVw.rating = i.review?.starCount ?? 0
                            self.txtVwDescription.text = i.review?.comment ?? ""
                            self.imgVwReview.imageLoad(imageUrl: i.review?.media ?? "")
                            self.taskReviewUpdate = true
                            self.taskReviewId = i.review?.id ?? ""
                            if i.review?.media != ""{
                                self.isUpload = true
                            }else{
                                self.isUpload = false
                            }
                        }else{
                            self.btnSubmit.setTitle("Submit", for: .normal)
                            self.ratingVw.rating = 0
                            self.txtVwDescription.text = ""
                            self.imgVwReview.image = nil
                            self.taskReviewUpdate = false
                            self.taskReviewId = ""
                            self.isUpload = false
                        }
                    }
                }
            }
            let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
            popOver.sourceView = sender
            popOver.delegate = self
            popOver.permittedArrowDirections = .up
            vc.preferredContentSize = CGSize(width: btnParticipant.frame.size.width, height: CGFloat((businessGigDetail?.participantsList?.count ?? 0)*50))
            self.present(vc, animated: false)
        }
    }
}

// MARK: - Popup
extension PopupReviewVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
