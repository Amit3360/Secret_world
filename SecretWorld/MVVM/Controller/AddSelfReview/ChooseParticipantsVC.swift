//
//  ChooseParticipantsVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 01/05/25.
//

import UIKit
struct participantsDetails{
    var momentId:String?
    var taskId:String?
    var appliedUserId:String?
    init(momentId: String? = nil, taskId: String? = nil, appliedUserId: String? = nil) {
        self.momentId = momentId
        self.taskId = taskId
        self.appliedUserId = appliedUserId
    }
}

class ChooseParticipantsVC: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnOk: UIButton!
    @IBOutlet var txtFldPArticipants: UITextField!
    
    var callBAck:((_ userId:String?,_ taskId:String?)->())?
    var arrParticipantsList: [AppliedUser] = []
    var momentId:String?
    var taskId:String?
    var viewModel = MomentsVM()
    var appliedUserId:String?
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldTap()
    }
    override func viewWillAppear(_ animated: Bool) {
        getParticipantsList(status: 1)
    }
    private func setupTextFieldTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapParticipantsField))
        txtFldPArticipants.addGestureRecognizer(tapGesture)
        txtFldPArticipants.isUserInteractionEnabled = true
        txtFldPArticipants.inputView = UIView() // Prevent keyboard from showing
    }
    private func getParticipantsList(status: Int) {
        arrParticipantsList.removeAll()
        viewModel.getMomentParticipantsApi(momentId: momentId ?? "", status: status, loader: false) {  data in
            for i in data ?? []{
                self.arrParticipantsList = i.appliedUsers ?? []
            }
            self.isLoading = true
        }
    }

    @objc private func didTapParticipantsField() {
        print("Participants field tapped")
        if isLoading{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
            vc.modalPresentationStyle = .popover
            vc.arrParticipantsList = arrParticipantsList
            vc.type = "participants"
            vc.matchTitle = txtFldPArticipants.text ?? ""
            vc.callBackParticipants = { [weak self] type, title, userId,selectedTaskId in
                guard let self = self else { return }
                switch type {
                case "participants":
                    appliedUserId = userId
                    taskId = selectedTaskId
                    txtFldPArticipants.text = title
                default:
                    break
                }
            }
            let popOver = vc.popoverPresentationController!
            popOver.sourceView = txtFldPArticipants
            popOver.delegate = self
            popOver.permittedArrowDirections = .up
            vc.preferredContentSize = CGSize(width: txtFldPArticipants.frame.size.width, height: CGFloat(arrParticipantsList.count*50))
            self.present(vc, animated: false)
        }
    }

    @IBAction func actionOk(_ sender: UIButton) {
        if txtFldPArticipants.text == ""{
            showSwiftyAlert("", "Please select participants first.", false)
        }else{
            self.dismiss(animated: true)
            callBAck?(appliedUserId,taskId)
        }
    }
}
// MARK: - Popup
extension ChooseParticipantsVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
