//
//  GigUsersVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 27/09/24.
//

import UIKit

class GigUsersVC: UIViewController {
  @IBOutlet var viewBack: UIView!
  @IBOutlet var tblVwUserList: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
  var arrUserParticipants = [GetParticipantsData]()
  var viewModel = AddGigVM()
  var gigId = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    viewBack.layer.cornerRadius = 35
    viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  override func viewWillAppear(_ animated: Bool) {
    getUserParticipantsApi()
  }
    // Dismiss screen on touch outside the table view
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self.view), !tblVwUserList.frame.contains(location) {
          self.dismiss(animated: true, completion: nil)
        }
      }
    
  func getUserParticipantsApi(){
    viewModel.GetUserParticipantsListApi(gigId: gigId) { data in
      self.arrUserParticipants = data ?? []
        self.heightTableView.constant = CGFloat((data?.count ?? 0) * 90)
      self.tblVwUserList.reloadData()
    }
  }
}
//MARK: -UITableViewDelegate
extension GigUsersVC: UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrUserParticipants.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GigUsersTVC", for: indexPath) as! GigUsersTVC
    cell.imgVwUser.imageLoad(imageUrl: arrUserParticipants[indexPath.row].applyuserID?.profilePhoto ?? "")
    cell.lblUserName.text = arrUserParticipants[indexPath.row].applyuserID?.name ?? ""
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
}





