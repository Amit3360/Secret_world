//
//  LogOutVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 26/12/23.
//

import UIKit

class LogOutVC: UIViewController {

    @IBOutlet var vwShadow: UIView!
    var viewModel = UserProfileVM()
    var isLoggingOut = false
    override func viewDidLoad() {
        super.viewDidLoad()

        setupOverlayView()
    }
    func setupOverlayView() {
        vwShadow = UIView(frame: self.view.bounds)
        vwShadow.backgroundColor = UIColor.black.withAlphaComponent(0.5)
              let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        vwShadow.addGestureRecognizer(tapGesture)
              self.view.insertSubview(vwShadow, at: 0)
          }
        @objc func overlayTapped() {
              self.dismiss(animated: false)
          }
    
    @IBAction func actionLogOut(_ sender: UIButton) {
        if !isLoggingOut {
                isLoggingOut = true
            Store.isLocationSelected = false
            viewModel.logOutApi(deviceId: Store.deviceToken ?? ""){
                
                Store.autoLogin = 0
                SocketIOManager.sharedInstance.disconnect()
                Store.authKey = nil
                Store.GigType = nil
                Store.userId = ""
                isSelectAnother = false
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                    isRefresh = false
                    SceneDelegate().OnboardingThirdVCRoot()
                    self.isLoggingOut = false
                    
                }
            }
        }
        
    }
    
 
    @IBAction func actionCancel(_ sender: UIButton) {
            self.dismiss(animated: false)
    }
}
