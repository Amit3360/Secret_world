//
//  OnboardingThirdVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit
import AuthenticationServices
import GoogleSignInSwift

class OnboardingThirdVC: UIViewController {
    //MARK: - Outlets
    
    @IBOutlet var imgVwBack: UIImageView!
    
    var viewModel = AuthVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GoogleSignIn.shared.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        Store.autoLogin = 0
    }
    func actionHandleAppleSignin() {

            let appleIDProvider = ASAuthorizationAppleIDProvider()

            let request = appleIDProvider.createRequest()

        request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])

            authorizationController.delegate = self

            authorizationController.presentationContextProvider = self

            authorizationController.performRequests()

        }
    
    //MARK: - Button Actions
    
    
    @IBAction func actionSignInWithGoogle(_ sender: UIButton) {
        GoogleSignIn.shared.email = true
        GoogleSignIn.shared.presentingWindow = view.window
        GoogleSignIn.shared.signIn()
    }
    
    @IBAction func actionSignInWithApple(_ sender: UIButton) {
        actionHandleAppleSignin()
    }
    
    @IBAction func actionSignInWithPhoneNumber(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterPhoneNumberVC") as! EnterPhoneNumberVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension OnboardingThirdVC: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    
    // ASAuthorizationControllerDelegate function for authorization failed
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print(error.localizedDescription)
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account as per your requirement
            
            let appleId = appleIDCredential.user
            
            let appleUserFullName = appleIDCredential.fullName?.namePrefix ?? ""
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            
            let appleUserLastName = appleIDCredential.fullName?.familyName
            
            let appleUserEmail = appleIDCredential.email
            print(appleIDCredential)
            print("Name-----",appleIDCredential.fullName?.namePrefix ?? "",appleIDCredential.fullName?.nameSuffix ?? "",appleIDCredential.fullName?.middleName ?? "",appleIDCredential.fullName?.givenName ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now()){
             
                self.viewModel.socialLoginApi(socialId: appleId, name: appleUserFullName, profile_photo: "", socialType: "apple", usertype: "", latitude: "", longitude: "", mobile: "", fcmToken: Store.deviceToken ?? "") { data in
                    socialDetail = ["name":data?.user?.name ?? "","profile":data?.user?.profilePhoto ?? ""]
                    Store.authKey = data?.token ?? ""
                    if data?.user?.profileStatus == 1 || data?.user?.profileStatus == 0{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountTypeVC") as! AccountTypeVC
                        isComingSocial = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }else if data?.user?.profileStatus == 2{
                    
                        if data?.user?.role == "b_user"{
                            
                            SceneDelegate().completeSignupBusinessUserVCRoot()
                            
                        }else{
                            
                            SceneDelegate().completeSignupUserVCRoot()
                            
                        }
                        
                        
                    }else{
                        
                        SceneDelegate().userRoot()
                        
                    }
                }
            }

            
        }
        
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return self.view.window!

    }
}

extension OnboardingThirdVC: GoogleSignInDelegate {
    func googleSignIn(didSignIn auth: GoogleSignIn.Auth?, user: GoogleSignIn.User?, error: Error?) {
           print(user ?? "")
            
            if let email = user?.email {
                DispatchQueue.main.asyncAfter(deadline: .now()){
                 
                    self.viewModel.socialLoginApi(socialId: user?.id ?? "", name: user?.name ?? "", profile_photo: user?.picture?.absoluteString ?? "", socialType: "google", usertype: "", latitude: "", longitude: "", mobile: "", fcmToken: "") { data in
                        socialDetail = ["name":data?.user?.name ?? "","profile":data?.user?.profilePhoto ?? ""]
                        Store.authKey = data?.token ?? ""
                        if data?.user?.profileStatus == 1 || data?.user?.profileStatus == 0{
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountTypeVC") as! AccountTypeVC
                            isComingSocial = true
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            
                        }else if data?.user?.profileStatus == 2{
                        
                            if data?.user?.role == "b_user"{
                                
                                SceneDelegate().completeSignupBusinessUserVCRoot()
                                
                            }else{
                                
                                SceneDelegate().completeSignupUserVCRoot()
                                
                            }
                            
                            
                        }else{
                            
                            SceneDelegate().userRoot()
                            
                        }
                    }
                }
       
            } else {
                print("Google User Email not available")
            }
        
    }
}
