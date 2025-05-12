//
//  ChatInfoVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 23/09/24.
//

import UIKit

class ChatInfoVC: UIViewController {
//MARK: - OUTLETS
    @IBOutlet var imgVwBtnPrivate: UIImageView!
    @IBOutlet var btnPrivate: UIButton!
    @IBOutlet var lblGroupMembers: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var viewBack: UIView!
    
    //MARK: - VARIABLES
    
    var hideProfile = 0
    var groupChatDetail:GroupChatDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        if hideProfile == 1{
            self.btnPrivate.isSelected = true
            imgVwBtnPrivate.image = UIImage(named:"privateOn")
        }else{
            self.btnPrivate.isSelected = false
            imgVwBtnPrivate.image = UIImage(named:"privateOff")
        }
        viewBack.layer.cornerRadius = 35
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.imgVwUser.imageLoad(imageUrl: groupChatDetail?.gig?.image ?? "")
        self.lblUserName.text = groupChatDetail?.gig?.title ?? ""
        self.lblGroupMembers.text = "Group: \(Store.gigDetail?["participantCount"] as? Int ?? 0) member"
        setupOverlayView()
    }
    func setupOverlayView() {
        viewBack = UIView(frame: self.view.bounds)
    
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        viewBack.addGestureRecognizer(tapGesture)
          self.view.insertSubview(viewBack, at: 0)
      }
    @objc func overlayTapped() {
          self.dismiss(animated: true)
      }
    //MARK: - IBAction
    @IBAction func actionPrivate(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            imgVwBtnPrivate.image = UIImage(named:"privateOn")
            let param:parameters = ["gigId":Store.gigDetail?["gigId"] as? String ?? "","userId":Store.userId ?? "","profileHide":1,"deviceId":Store.deviceToken ?? ""]
            print(param)
            SocketIOManager.sharedInstance.hideProfile(dict: param)
        }else{
            imgVwBtnPrivate.image = UIImage(named:"privateOff")
            let param:parameters = ["gigId":Store.gigDetail?["gigId"] as? String ?? "","userId":Store.userId ?? "","profileHide":0,"deviceId":Store.deviceToken ?? ""]
            print(param)
            SocketIOManager.sharedInstance.hideProfile(dict: param)
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
}
