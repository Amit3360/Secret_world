//
//  MessagePopupVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 25/01/24.
//

import UIKit
import IQKeyboardManagerSwift

class MessagePopupVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet var lbltextCount: UILabel!
    @IBOutlet var txtvwMsg: IQTextView!
    @IBOutlet var viewBack: UIView!
    
    //MARK: - VARIABELS
    var viewModel = PopUpVM()
    var popupId = ""
    var popupName = ""
    var callBack:((_ message:String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(popupId)
        
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
    @IBAction func actionSent(_ sender: UIButton) {
        if txtvwMsg.text == ""{
            showSwiftyAlert("", "Enter message", false)
        }else{
            viewModel.applyPopupApi(popupId: popupId, message: txtvwMsg.text ?? "", typeName: popupName) { message in
                self.dismiss(animated: true)
                self.callBack?(message ?? "")
            }
        }
        
    }
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
}
//MARK: - UITextViewDelegate
extension MessagePopupVC: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        
        let characterCount = textView.text.count
        lbltextCount.text = "\(characterCount)/250"
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 250
        
    }
}
