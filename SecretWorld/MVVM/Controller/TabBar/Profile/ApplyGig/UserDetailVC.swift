//
//  UserDetailVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/24.
//

import UIKit

class UserDetailVC: UIViewController {
    //MARK: - OUTLEST
    @IBOutlet var lblTxtCount: UILabel!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var viewBack: UIView!
    @IBOutlet var txtVwMs: UITextView!
    
    //MARK: - VARIABLES
    var callBack: ((_ messsage:String)->())?
    var viewModel = AddGigVM()
    var gigId = ""
    var userDetail:UserDetailses?
    var isComing = 0
    var name:String?
    var data:GetUserGigData?
    var taskName:String?
    var MomentData:MomentData?
    var viewModelMOment = MomentsVM()
    var momentTaskId:String?
    var timezone:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        if isComing == 0{
            let timezoneIdentifier = TimeZone.current.identifier
            print("Current timezone identifier: \(timezoneIdentifier)")
            timezone = timezoneIdentifier
            lblName.text = MomentData?.userId?.name ?? ""
            lblGender.text = MomentData?.userId?.gender ?? ""
            imgVwUser.imageLoad(imageUrl: MomentData?.userId?.profilePhoto ?? "")

        }else  if isComing == 1{
            lblName.text = userDetail?.name ?? ""
            lblGender.text = userDetail?.gender ?? ""
            imgVwUser.imageLoad(imageUrl: userDetail?.profilePhoto ?? "")
        }else{
            lblName.text = data?.gig?.user?.name ?? ""
            lblGender.text = data?.gig?.user?.gender ?? ""
            imgVwUser.imageLoad(imageUrl: data?.gig?.user?.profilePhoto ?? "")

        }
            
       
        
        viewBack.layer.cornerRadius = 35
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupOverlayView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboardWhileClick() {
        view.endEditing(true)
    }
    func setupOverlayView() {
        viewBack = UIView(frame: self.view.bounds)
        viewBack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        viewBack.addGestureRecognizer(tapGesture)
        self.view.insertSubview(viewBack, at: 0)
        
    }
    @objc func overlayTapped() {
        self.dismiss(animated: true)
        
    }
    //MARK: - BUTTON ACTIONS
    @IBAction func acionDismiss(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    
    @IBAction func actionApply(_ sender: Any) {
         
        let trimmedText = txtVwMs.text.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedText.isEmpty {
            showSwiftyAlert("", "Enter your message", false)
        }else if !(txtVwMs.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your message should contain meaningful text", false)
        } else {
            if isComing == 0{
                
                viewModelMOment.applyMomentApi(momentId: MomentData?._id ?? "", taskId: momentTaskId ?? "", message: txtVwMs.text ?? "", type: "task", typeName: MomentData?.title ?? "", typeId: MomentData?._id ?? "", userid: Store.UserDetail?["userId"] as? String ?? "", timezone: timezone ?? "") { message  in
                    self.dismiss(animated: true)
                    self.callBack?(message ?? "")

                }
            }else{
                viewModel.ApplyGigApi(gigId: gigId, message: trimmedText, typeName: taskName ?? "") { message in
                    self.dismiss(animated: true)
                    self.callBack?(message ?? "")
                }

            }
        }
    }
}
//MARK: - UITextViewDelegate
extension UserDetailVC: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        
        let characterCount = textView.text.count
        lblTxtCount.text = "\(characterCount)/250"
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 250
        
    }
}

