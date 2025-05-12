import UIKit

class NicknamePopupVC: UIViewController {

    @IBOutlet weak var txtFldName: UITextField!
     
    var receiverId = ""
    var nickName = ""
    var orignalName = ""
    var callBack:((_ name:String?)->())?
    var chatType = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSet()
    }
    func uiSet(){
        txtFldName.text = nickName
    }
    @IBAction func actionCancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func actionSave(_ sender: UIButton) {
        if txtFldName.text?.trimWhiteSpace.isEmpty == true{
            let param:parameters = ["userId":Store.userId ?? "","otherUserId":receiverId,"nickname":orignalName,"type":chatType]
            print(param)
            SocketIOManager.sharedInstance.setNickname(dict: param)
            dismiss(animated: true)
            self.callBack?(orignalName)
        }else{
            let param:parameters = ["userId":Store.userId ?? "","otherUserId":receiverId,"nickname":txtFldName.text ?? "","type":chatType]
            print(param)
            SocketIOManager.sharedInstance.setNickname(dict: param)
            dismiss(animated: true)
            self.callBack?(txtFldName.text ?? "")
        }
       
    }
    
}
