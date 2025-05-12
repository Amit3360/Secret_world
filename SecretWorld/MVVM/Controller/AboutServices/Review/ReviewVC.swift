//
//  ReviewVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 23/12/23.
//

import UIKit
class ReviewVC: UIViewController {
  @IBOutlet var heightTblVw: NSLayoutConstraint!
  @IBOutlet var heightBtnAddReview: NSLayoutConstraint!
  @IBOutlet var widthBtnAddReview: NSLayoutConstraint!
  @IBOutlet var btnAddReview: UIButton!
  @IBOutlet var lblReview: UILabel!
  @IBOutlet var lblNoData: UILabel!
  @IBOutlet var tblVwReview: UITableView!
  var arrReviewUser = [Review]()
  var viewModel = ExploreVM()
  var heightDescription = 0
  var reviewHeight = 0
  var idMatch = false
  var updateReview = false
  override func viewDidLoad() {
    super.viewDidLoad()
   
  }
  override func viewWillAppear(_ animated: Bool) {
      let nibNearBy = UINib(nibName: "ReviewTVC", bundle: nil)
      tblVwReview.register(nibNearBy, forCellReuseIdentifier: "ReviewTVC")
      tblVwReview.estimatedRowHeight = 100
      tblVwReview.rowHeight = UITableView.automaticDimension
      btnAddReview.isHidden = false
      lblReview.isHidden = false
      NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("GetStoreServiceData"), object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationUser(notification:)), name: Notification.Name("GetStoreUserServices"), object: nil)
    uiSet()
  }
  @objc func methodOfReceivedNotification(notification: Notification) {
    uiSet()
  }
  @objc func methodOfReceivedReview(notification: Notification) {
    uiSet()
  }
  @objc func methodOfReceivedNotificationUser(notification: Notification) {
    uiSet()
  }
  func uiSet(){
    getReviewsApi()
  }
  func getReviewsApi(){
    viewModel.GetReviewsApi(businessUserId: Store.BusinessUserIdForReview ?? "") { data in
      self.arrReviewUser = data?.reviews ?? []
        for i in data?.reviews ?? []{
            if Store.userId == i.userId ?? ""{
                self.btnAddReview.setTitle("update review", for: .normal)
                self.widthBtnAddReview.constant = 120
            }else{
                self.widthBtnAddReview.constant = 100
                self.btnAddReview.setTitle("add review", for: .normal)
            }
        }
        
      if self.arrReviewUser.count > 0 {
        self.lblNoData.isHidden = true
      }else{
        self.lblNoData.isHidden = false
      }
      self.tblVwReview.reloadData()
      self.updateTableViewHeight()
    }
  }
  func updateTableViewHeight() {
    DispatchQueue.main.async {
      self.tblVwReview.layoutIfNeeded()
      self.heightTblVw.constant = self.tblVwReview.contentSize.height + 100
      self.view.layoutIfNeeded()
      print("ReviewHeight------", self.heightTblVw.constant)
      NotificationCenter.default.post(name: Notification.Name("AddReview"), object: nil)
      
        if self.updateReview == true{
            NotificationCenter.default.post(name: Notification.Name("UpdateReview"), object: nil)
        }
       
    }
  }
  @IBAction func actionAddReview(_ sender: UIButton) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewVC") as! AddReviewVC
    vc.modalPresentationStyle = .overFullScreen
    for (index, review) in arrReviewUser.enumerated() {
      if Store.userId == review.userId ?? ""{
        vc.isUpdateReview = true
        vc.reviewDetail = review
        break
      }
    }
    vc.isComing = 3
    vc.callBack = {[weak self] in
        guard let self = self else { return }
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterFeedbackPopUpVC") as! AfterFeedbackPopUpVC
      vc.modalPresentationStyle = .overFullScreen
      vc.callBack = {[weak self] in
          guard let self = self else { return }
          self.updateReview = true
        self.getReviewsApi()
          NotificationCenter.default.post(name: Notification.Name("UpdateReviewValue"), object: nil)
      }
      self.navigationController?.present(vc, animated: false)
    }
    self.navigationController?.present(vc, animated: true)
  }
}
//MARK: -UITableViewDelegate
extension ReviewVC: UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if arrReviewUser.count > 0{
          return arrReviewUser.count
      }else{
          return 0
      }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTVC", for: indexPath) as! ReviewTVC
    cell.lblName.text = arrReviewUser[indexPath.row].name ?? ""
    cell.lblDescription.text = arrReviewUser[indexPath.row].comment ?? ""
    let createdAt = arrReviewUser[indexPath.row].createdAt ?? ""
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
    cell.lblDescription.sizeToFit()
  
    heightDescription += Int(cell.lblDescription.frame.size.height)
    cell.ratingView.rating = Double(arrReviewUser[indexPath.row].starCount ?? 0)
    cell.imgVwUser.imageLoad(imageUrl: arrReviewUser[indexPath.row].profilePhoto ?? "")
    if arrReviewUser[indexPath.row].media == "" || arrReviewUser[indexPath.row].media == nil{
      cell.heightImgVw.constant = 0
      reviewHeight += Int(70 + CGFloat(self.heightDescription))
    }else{
      cell.heightImgVw.constant = 150
      reviewHeight += Int(220 + CGFloat(self.heightDescription))
      cell.imgVwReview.imageLoad(imageUrl: arrReviewUser[indexPath.row].media ?? "")
    }
    return cell
  }
}
