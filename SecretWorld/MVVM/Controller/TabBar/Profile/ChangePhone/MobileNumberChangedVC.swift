//
//  MobileNumberChangedVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 02/01/24.
//

import UIKit

class MobileNumberChangedVC: UIViewController {

    @IBOutlet var lblMobileNumber: UILabel!
    var phoneNumber:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        if let phoneNumber = phoneNumber {
          let secureeNumber = securePhoneNumber(phoneNumber)
          let fullText = "Your new phone number is \n\(secureeNumber)"
          let attributedText = NSMutableAttributedString(string: fullText)
          let range = (fullText as NSString).range(of: secureeNumber)
          attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: lblMobileNumber.font.pointSize), range: range)
          attributedText.addAttribute(.foregroundColor, value: UIColor.app, range: range)
          lblMobileNumber.attributedText = attributedText
        }
      }
    func securePhoneNumber(_ phoneNumber: String) -> String {
          let visibleDigitsCount = 4
          let maskedCount = phoneNumber.count - visibleDigitsCount
          let maskedPart = String(repeating: "*", count: maskedCount)
          let visiblePart = phoneNumber.suffix(visibleDigitsCount)
          return "\(maskedPart)\(visiblePart)"
        }
    @IBAction func actionOk(_ sender: UIButton) {
        SceneDelegate().OnboardingThirdVCRoot()
    }
 

}
