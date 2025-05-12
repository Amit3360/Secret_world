//
//  ProfileViewVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/24.
//
import UIKit
import AlignedCollectionViewFlowLayout
import FXExpandableLabel
class ProfileViewVC: UIViewController,UIGestureRecognizerDelegate {
    //MARK: - OUTLEST
    @IBOutlet weak var topAboutText: NSLayoutConstraint!
    @IBOutlet weak var aboutText: UILabel!
    @IBOutlet var btnPOstedPOpup: UIButton!
    @IBOutlet var btnAppliedGig: UIButton!
    @IBOutlet var btnPOstedGig: UIButton!
    @IBOutlet var scrollVw: UIScrollView!
    @IBOutlet var lblPostedGig: UILabel!
    @IBOutlet var lblAppliedGig: UILabel!
    @IBOutlet var lblReviewTitle: UILabel!
    @IBOutlet var heightTblVwReview: NSLayoutConstraint!
    @IBOutlet var lblReviewCount: UILabel!
    @IBOutlet var lblGenderAndDOB: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVwProfile: UIImageView!
    @IBOutlet var heightCollVwSpecialize: NSLayoutConstraint!
    @IBOutlet var collVwSpecialize: UICollectionView!
    @IBOutlet var heightCollVwDietary: NSLayoutConstraint!
    @IBOutlet var collVwDitary: UICollectionView!
    @IBOutlet var collVwInterst: UICollectionView!
    @IBOutlet var heightCollVwInterst: NSLayoutConstraint!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet var tblVwReviews: UITableView!
    @IBOutlet weak var lblPopupCount: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    //MARK: - VARIBLES
    var isLabelExpanded = false
    var arrInterst = [Interest]()
    var arrDietry = [DietaryPreference]()
    var arrSpecialize = [Specialization]()
    var viewModel = UserProfileVM()
    var arrReview = [Reviewwes]()
    var getUserDetail:UserProfile?
    var heightDescription = 0
    var reviewHeight = 0
    let refreshControl = UIRefreshControl()
    var id = ""
    var isComingChat = false
    var textAbout = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    @objc func handleSwipe() {
        navigationController?.popViewController(animated: true)
    }
    func uiSet(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        addTapGestureToLabel()
        lblAbout.numberOfLines = 5
        setCollVwLayout()
        if isComingChat == true{
            getUserProfileApi(id: id)
            btnEdit.isHidden = true
        }else{
            btnEdit.isHidden = false
            getUserProfileApi(id: Store.userId ?? "")
        }
        let nibNearBy = UINib(nibName: "ReviewTVC", bundle: nil)
        tblVwReviews.register(nibNearBy, forCellReuseIdentifier: "ReviewTVC")
        tblVwReviews.estimatedRowHeight = 100
        tblVwReviews.rowHeight = UITableView.automaticDimension
    }
    override func viewWillLayoutSubviews() {
        self.heightTblVwReview.constant = self.tblVwReviews.contentSize.height+10
        print("ReviewHeight------",self.heightTblVwReview.constant)
        NotificationCenter.default.post(name: Notification.Name("AddReview"), object: nil)
    }
    func getUserProfileApi(id:String){
        viewModel.GetUserProfile(id: id) { data in
            self.arrDietry.removeAll()
            self.arrInterst.removeAll()
            self.arrSpecialize.removeAll()
            self.getUserDetail = data?.userProfile
            self.arrReview = data?.reviews ?? []
            if self.arrReview.count > 0{
                self.lblReviewTitle.isHidden = false
            }else{
                self.lblReviewTitle.isHidden = true
            }
            let rating = data?.rating ?? 0.0
            let formattedRating = String(format: "%.1f", rating)
            if self.arrReview.count > 1{
                self.lblReviewCount.text = "\(formattedRating) (\(self.arrReview.count) Reviews)"
            }else{
                self.lblReviewCount.text = "\(formattedRating) (\(self.arrReview.count) Review)"
            }
            self.lblPostedGig.text =  "\(data?.postedGig ?? 0)"
            self.lblAppliedGig.text = "\(data?.appliedGig ?? 0)"
            self.lblPopupCount.text = "\(data?.postedPopup ?? 0)"
            if data?.userProfile?.about == ""{
                self.aboutText.isHidden = true
                self.topAboutText.constant = 0
            }else{
                self.aboutText.isHidden = false
                self.topAboutText.constant = 20
                self.textAbout = data?.userProfile?.about ?? ""
                self.lblAbout.numberOfLines = 2
                self.lblAbout.appendReadmore(after: self.textAbout, trailingContent: .readmore)
                self.lblAbout.sizeToFit()
            }
            
            self.lblName.text = data?.userProfile?.name ?? ""
            let dob = data?.userProfile?.dob ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if let date = dateFormatter.date(from: dob) {
                dateFormatter.dateFormat = "MMM dd,yyyy"
                let formattedDate = dateFormatter.string(from: date)
                self.lblGenderAndDOB.text = "\(formattedDate) (\(data?.userProfile?.gender ?? ""))"
            }
            let place = "\(data?.userProfile?.place ?? ""),\(data?.userProfile?.city ?? ""),\(data?.userProfile?.country ?? ""),\(data?.userProfile?.zipCode ?? "")"
            self.lblLocation.text = place
            self.imgVwProfile.imageLoad(imageUrl: data?.userProfile?.profilePhoto ?? "")
            self.arrDietry.append(contentsOf: data?.userProfile?.Dietary ?? [])
            self.arrInterst.append(contentsOf: data?.userProfile?.Interests ?? [])
            self.arrSpecialize.append(contentsOf: data?.userProfile?.Specialization ?? [])
            if self.isComingChat == false{
                
                Store.UserDetail = ["userName":data?.userProfile?.name ?? "",
                                    "profileImage":data?.userProfile?.profilePhoto ?? "","userId":data?.userProfile?.id ?? "","mobile":data?.userProfile?.mobile ?? 0,"countryCode":Store.UserDetail?["countryCode"] as? String ?? ""]
                NotificationCenter.default.post(name: Notification.Name("UpdateUserName"), object: nil)
            }
            self.collVwDitary.reloadData()
            self.collVwInterst.reloadData()
            self.collVwSpecialize.reloadData()
            self.tblVwReviews.reloadData()
            self.tblVwReviews.invalidateIntrinsicContentSize()
            self.updateCollectionViewHeight()
            self.updateTableViewHeight()
        }
    }
    func addTapGestureToLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblAbout.isUserInteractionEnabled = true
        lblAbout.addGestureRecognizer(tapGesture)
    }
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let text = lblAbout.text else { return }
        let readmore = (text as NSString).range(of: TrailingContent.readmore.text)
        let readless = (text as NSString).range(of: TrailingContent.readless.text)
        if gesture.didTap(label: lblAbout, inRange: readmore) {
            lblAbout.appendReadLess(after: textAbout, trailingContent: .readless)
        } else if  gesture.didTap(label: lblAbout, inRange: readless) {
            lblAbout.appendReadmore(after: textAbout, trailingContent: .readmore)
        } else { return }
    }
    func setCollVwLayout(){
        let nib = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
        collVwInterst.register(nib, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        let nib2 = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
        collVwDitary.register(nib2, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        let nib3 = UINib(nibName: "BusinessCategoryCVC", bundle: nil)
        collVwSpecialize.register(nib3, forCellWithReuseIdentifier: "BusinessCategoryCVC")
        let alignedFlowLayoutCollVwInterst = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwInterst.collectionViewLayout = alignedFlowLayoutCollVwInterst
        let alignedFlowLayoutCollVwDietry = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwDitary.collectionViewLayout = alignedFlowLayoutCollVwDietry
        let alignedFlowLayoutCollVwSpecializ = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwSpecialize.collectionViewLayout = alignedFlowLayoutCollVwSpecializ
        if let flowLayout = collVwInterst.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0, height: 36)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        if let flowLayout1 = collVwDitary.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout1.estimatedItemSize = CGSize(width: 0, height: 36)
            flowLayout1.itemSize = UICollectionViewFlowLayout.automaticSize
            collVwDitary.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
        if let flowLayout2 = collVwSpecialize.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout2.estimatedItemSize = CGSize(width: 0, height: 36)
            flowLayout2.itemSize = UICollectionViewFlowLayout.automaticSize
            collVwSpecialize.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        super.viewDidLayoutSubviews()
        self.heightTblVwReview.constant = self.tblVwReviews.contentSize.height + 10
        self.view.layoutIfNeeded()
        let heightInterest = self.collVwInterst.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwInterst.constant = heightInterest
        let heightDietry = self.collVwDitary.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwDietary.constant = heightDietry
        let heightSpelize = self.collVwSpecialize.collectionViewLayout.collectionViewContentSize.height
        self.heightCollVwSpecialize.constant = heightSpelize
        self.view.layoutIfNeeded()
    }
    func updateTableViewHeight() {
        DispatchQueue.main.async {
            self.heightTblVwReview.constant = self.tblVwReviews.contentSize.height + 10
            self.view.layoutIfNeeded()
        }
    }
    func updateCollectionViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let heightInterest = self.collVwInterst.collectionViewLayout.collectionViewContentSize.height
            self.heightCollVwInterst.constant = heightInterest
            
            let heightDietry = self.collVwDitary.collectionViewLayout.collectionViewContentSize.height
            self.heightCollVwDietary.constant = heightDietry
            
            let heightSpelize = self.collVwSpecialize.collectionViewLayout.collectionViewContentSize.height
            self.heightCollVwSpecialize.constant = heightSpelize
            
            self.view.layoutIfNeeded()
        }
    }
    
    //    func updateCollectionViewHeight() {
    //        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
    //            let heightInterest = self.collVwInterst.collectionViewLayout.collectionViewContentSize.height
    //            self.heightCollVwInterst.constant = heightInterest
    //            let heightDietry = self.collVwDitary.collectionViewLayout.collectionViewContentSize.height
    //            self.heightCollVwDietary.constant = heightDietry
    //            let heightSpelize = self.collVwSpecialize.collectionViewLayout.collectionViewContentSize.height
    //            self.heightCollVwSpecialize.constant = heightSpelize
    //            self.view.layoutIfNeeded()
    //        }
    //    }
    //MARK: - BUTTONACTIONS
    @IBAction func actionPopup(_ sender: UIButton) {
        if isComingChat == false{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpListVC") as! PopUpListVC
            vc.isComing = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionAppliedGig(_ sender: UIButton) {
        if isComingChat == false{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigListVC") as! GigListVC
            vc.isComing = 1
            Store.isUserParticipantsList = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionPostedGig(_ sender: UIButton) {
        if isComingChat == false{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigListVC") as! GigListVC
            vc.isComing = 2
            Store.isUserParticipantsList = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionedit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.getUserDetail = getUserDetail
        vc.callBack = {[weak self] in
            guard let self = self else { return }
            self.arrDietry.removeAll()
            self.arrSpecialize.removeAll()
            self.arrInterst.removeAll()
            if self.isComingChat == true{
                self.getUserProfileApi(id: self.id)
            }else{
                self.getUserProfileApi(id: Store.userId ?? "")
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: -UITableViewDelegate
extension ProfileViewVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrReview.count > 0{
            return  arrReview.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTVC", for: indexPath) as! ReviewTVC
        cell.imgVwUser.imageLoad(imageUrl: arrReview[indexPath.row].userID?.profilePhoto ?? "")
        cell.lblName.text = arrReview[indexPath.row].userID?.name ?? ""
        cell.lblDescription.text = arrReview[indexPath.row].comment ?? ""
        cell.lblDescription.sizeToFit()
        let rating = arrReview[indexPath.row].starCount ?? 0.0
        
        cell.ratingView.rating = rating
        heightDescription += Int(cell.lblDescription.frame.size.height)
        cell.lblTime.text = convertToAMPMTime(arrReview[indexPath.row].createdAt ?? "")
        if arrReview[indexPath.row].media == "" || arrReview[indexPath.row].media == nil{
            cell.heightImgVw.constant = 0
            reviewHeight += Int(70 + CGFloat(self.heightDescription))
        }else{
            cell.heightImgVw.constant = 150
            reviewHeight += Int(220 + CGFloat(self.heightDescription))
            cell.imgVwReview.imageLoad(imageUrl: arrReview[indexPath.row].media ?? "")
        }
        print("reviewHeight:--\(reviewHeight)")
        let createdAt = arrReview[indexPath.row].createdAt ?? ""
        let timeAgoString = createdAt.timeAgoSinceDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let createdDate = dateFormatter.date(from: createdAt) {
            let timeDifference = Date().timeIntervalSince(createdDate)
            if timeDifference < 60 {
                cell.lblTime.text = "Just now"
            } else {
                cell.lblTime.text = "\(timeAgoString) Ago"
            }
        } else {
            cell.lblTime.text = "\(timeAgoString) Ago"
        }
        return cell
    }
    func convertToAMPMTime(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
//MARK: - UICollectionViewDelegate
extension ProfileViewVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwInterst{
            return arrInterst.count
        }else if collectionView == collVwDitary{
            return arrDietry.count
        }else{
            return arrSpecialize.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwInterst{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            cell.lblName.text = arrInterst[indexPath.row].name ?? ""
            cell.vwBg.layer.cornerRadius = 18
            cell.widthBtnCross.constant = 0
            return cell
        }else if collectionView == collVwDitary{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            cell.lblName.text = arrDietry[indexPath.row].name ?? ""
            cell.vwBg.layer.cornerRadius = 18
            cell.widthBtnCross.constant = 0
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCVC", for: indexPath) as! BusinessCategoryCVC
            cell.lblName.text = arrSpecialize[indexPath.row].name ?? ""
            cell.vwBg.layer.cornerRadius = 18
            cell.lblName.textColor = .black
            cell.vwBg.backgroundColor = UIColor(hex: "#4EB644").withAlphaComponent(0.2)
            cell.widthBtnCross.constant = 0
            return cell
        }
    }
}
