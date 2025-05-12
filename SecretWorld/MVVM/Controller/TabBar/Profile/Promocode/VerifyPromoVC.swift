//
//  VerifyPromoVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/01/24.
//

import UIKit

class VerifyPromoVC: UIViewController {
    
    @IBOutlet var txtFldPromo: UITextField!
    var viewModel = PromoCodeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)

    }
    override func viewWillAppear(_ animated: Bool) {
        uiSet()
    }
    @objc func handleSwipe() {
               navigationController?.popViewController(animated: true)
           }

    func uiSet(){
        txtFldPromo.text = ""
    }
    @IBAction func actionVerify(_ sender: UIButton) {
        
        if txtFldPromo.text == ""{
            showSwiftyAlert("", "Enter promo code", false)
        }else{
            verifyPromo = true
            viewModel.VerifyPromoCodeApi(promocode: txtFldPromo.text ?? "") { data in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PromoPopUpVC") as! PromoPopUpVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isComing = true
                vc.callBack = {
                    self.uiSet()
                }
                self.navigationController?.present(vc, animated: false)
                
            }
        }
        
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
