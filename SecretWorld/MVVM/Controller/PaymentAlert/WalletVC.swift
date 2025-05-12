//
//  WalletVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/08/24.
//
import UIKit
class WalletVC: UIViewController {
//MARK: - outlets
    @IBOutlet var viewBack: UIView!
    @IBOutlet weak var btnWallet: UIButton!
    @IBOutlet var lblBalance: UILabel!
    //MARK: - variables
    var viewModel = PaymentVM()
    var isComing = false
    var callBack:(()->())?
    var isBank = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                   swipeRight.direction = .right
                   view.addGestureRecognizer(swipeRight)
        viewBack.applyShadow()
    }
    @objc func handleSwipe() {
        if isComing == true{
            if isAddFunds{
                self.dismiss(animated: false)
            }else{
                if let nav = self.navigationController, nav.viewControllers.count > 1 {
                        // It's pushed
                        nav.popViewController(animated: true)
                    } 
            }
        }else{
            if isBank == true{
                self.navigationController?.popViewController(animated: true)
//                SceneDelegate().tabBarProfileRoot()
            }else{
                self.navigationController?.popViewController(animated: true)
//                SceneDelegate().addGigRoot()
                callBack?()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getWallet()
    }
    func getWallet() {
        viewModel.getWalletAmount(loader: true) { data in
            let amount = data?.checkWallet?.amount ?? 0
            Store.WalletAmount = amount
            let formattedAmount = String(format: "%.2f", amount)
            if amount > 0 {
                self.lblBalance.text = "$\(formattedAmount)"
                if isAddFunds{
                    self.btnWallet.isHidden = true
                }else{
                    self.btnWallet.isHidden = false
                }
            } else {
                self.lblBalance.text = "$0"
                self.btnWallet.isHidden = true
            }
        }
    }
    //MARK: - @IBAction
    @IBAction func actionBack(_ sender: UIButton) {
        if isComing == true{
            if isAddFunds{
                self.dismiss(animated: false)
            }else{
                if let nav = self.navigationController, nav.viewControllers.count > 1 {
                        nav.popViewController(animated: true)
                    }
            }
            
        }else{
            if isBank == true{
                self.navigationController?.popViewController(animated: true)
//                SceneDelegate().tabBarProfileRoot()
            }else{
                self.navigationController?.popViewController(animated: true)
//                SceneDelegate().addGigRoot()
                callBack?()
            }
        }
    }
    @IBAction func actionAddPayment(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WithdrawAmountVC") as! WithdrawAmountVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = false

        vc.callBack = { [weak self] amount, message, isBalance in
            guard let self = self else { return }

            // Step 2: Call API and present WalletWebViewVC
            self.viewModel.AddWalletApi(amount: amount, type: sender.tag) { url in
                guard let url = url else { return }

                DispatchQueue.main.async {
                    let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WalletWebViewVC") as! WalletWebViewVC
                    webVC.modalPresentationStyle = .overFullScreen
                    webVC.paymentLink = url

                    webVC.callback = { [weak self] payment in
                        guard let self = self else { return }

                        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                        popupVC.modalPresentationStyle = .overFullScreen
                        popupVC.isSelect = payment ? 21 : 20
                        popupVC.callBack = {
                            DispatchQueue.main.async {
                            if self.isComing {
                                if isAddFunds{
                                    
                                    self.dismiss(animated: false)
                                }else{
                                    
                                    self.getWallet()
                                }
                            } else {
                                SceneDelegate().addGigRoot()
                            }
                            
                        }
                        }
                        self.present(popupVC, animated: true)
                    }

                    // Present WalletWebViewVC
                    self.present(webVC, animated: true)
                }
            }
        }

        // Step 1: Present WithdrawAmountVC
        self.present(vc, animated: true)
    }
    @IBAction func actionWithdraw(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WithdrawAmountVC") as! WithdrawAmountVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isComing = true
        vc.callBack = { [weak self] amount,message,isBalance in
            guard let self = self else { return }
            if isBalance == true{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 10
                vc.message = message
                vc.callBack = {[weak self] in
                    guard let self = self else { return }
                    self.getWallet()
                }
                self.present(vc, animated: true)
            }else{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 10
                vc.message = "Your wallet balance is lower than the withdrawal amount"
                self.present(vc, animated: true)
            }
        }
        self.present(vc, animated: true)
    }
}
//MARK: - applyShadow
extension UIView {
    func applyShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4 / 2.0
        self.layer.masksToBounds = false
    }
}
