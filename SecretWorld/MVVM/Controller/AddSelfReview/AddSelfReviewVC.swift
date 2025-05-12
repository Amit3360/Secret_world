//
//  AddSelfReviewVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/04/25.
//

import UIKit
import IQKeyboardManagerSwift

class AddSelfReviewVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var viewBack: UIView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var txtVwAbout: IQTextView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    
    //MARK: - variables
    var viewModel = SelfReviewVM()
    var isEdit = false
    var isComing = false
    var callBack:(()->())?
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    private func uiSet(){
        getSelfReviewApi()
        txtVwAbout.delegate = self
        lblName.text =  "@\(Store.UserDetail?["userName"] as? String ?? "")"
        imgVwUser.imageLoad(imageUrl: Store.UserDetail?["profileImage"] as? String ?? "")
        viewBack.layer.shadowColor = UIColor.black.cgColor
        viewBack.layer.shadowOpacity = 0.1  // Reduced from 0.25 to 0.1
        viewBack.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewBack.layer.shadowRadius = 3     // Slightly less blur
        viewBack.layer.masksToBounds = false
        
    }
    private func getSelfReviewApi(){
        viewModel.getSelfReviewApi(userId: Store.UserDetail?["userId"] as? String ?? "") { data in
            self.txtVwAbout.text = data?.review?.selfReview ?? ""
            DispatchQueue.main.async {
                if data?.review?.selfReview == "" || data?.review?.selfReview == nil{
                    self.txtVwAbout.isScrollEnabled = false
                    self.btnSave.setTitle("Save", for: .normal)
                    self.lblScreenTitle.text = "Add self review"
                    self.isEdit = false
                }else{
                    self.txtVwAbout.isScrollEnabled = true
                    self.btnSave.setTitle("Save changes", for: .normal)
                    self.lblScreenTitle.text = "Update self review"
                    self.isEdit = true
                }
            }
            
        }
    }
    //MARK: - IBAction
    @IBAction func actionSave(_ sender: UIButton) {
        if txtVwAbout.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            showSwiftyAlert("", "Please enter self review.", false)
        }else if !(txtVwAbout.text ?? "").isValidInput{
            showSwiftyAlert("", "Invalid Input: your self review should contain meaningful text", false)
        }else{
            viewModel.AddSelfReviewApi(review: txtVwAbout.text ?? "") { message in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.isSelect = 10
                if self.isEdit{
                    vc.message = "Review updated successfully"
                }else{
                    vc.message = message
                }
                
                vc.callBack = { [weak self] in
                    guard let self = self else { return }
                    if isComing{
                        self.navigationController?.popViewController(animated: true)
                        self.callBack?()
                    }else{
                        self.uiSet()
                        self.dismiss(animated: true)
                    }
                   
                }
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }
    }
    @IBAction func actionBAck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension AddSelfReviewVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if txtVwAbout.text == ""{
            txtVwAbout.isScrollEnabled = false
        }else{
            txtVwAbout.isScrollEnabled = true
        }
    }
}
