//
//  AddMomentPlatformFeeVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 07/05/25.
//

import UIKit

class AddMomentPlatformFeeVC: UIViewController {
    @IBOutlet var imgVwTitle: UIImageView!
    @IBOutlet var btnContinue: UIButton!
    @IBOutlet var lblPlatformFee: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblFeesDetail: UILabel!
    
    var callBack:(()->())?
    var isComing = false
    var feesDetailMessage:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        if isComing{
            btnContinue.setTitle("Pay", for: .normal)
            imgVwTitle.image = UIImage(named: "alert2")
            lblPlatformFee.text = "Platform fee Summary"
            lblTitle.text = ""
            lblSubTitle.text = "You’ll handle your moment’s price directly. This fee supports platform maintenance and secure hosting."
            let message = feesDetailMessage ?? ""
            let attributedText = NSMutableAttributedString(string: message)

            let lines = message.components(separatedBy: "\n") // now it's guaranteed to be non-optional

            // Define fonts and colors
            let regularFont = UIFont(name: "Nunito-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
            let redColor = UIColor.app
            let blackColor = UIColor(hex: "#363636")

            var location = 0
            for line in lines {
                let range = NSRange(location: location, length: line.count)

                attributedText.addAttribute(.font, value: regularFont, range: range)
                attributedText.addAttribute(.foregroundColor, value: line.contains("Amount to Pay Now") ? redColor : blackColor, range: range)

                // Move to next line (+1 for newline character)
                location += line.count + 1
            }

            lblFeesDetail.attributedText = attributedText
            lblFeesDetail.numberOfLines = 0
            lblFeesDetail.textAlignment = .center


        }else{
            btnContinue.setTitle("Continue", for: .normal)
            imgVwTitle.image = UIImage(named: "alert")
            lblPlatformFee.text = "Platform fees"
            lblTitle.text = "This fee helps cover payment processing, support, and platform maintenance."
            lblSubTitle.text = "By continuing, you agree to these charges."
            let fullText = """
            • $3 flat fee if your moment is under $30
            • $1 + 15% of the moment price if it’s $30 or more
            """

            let attributedString = NSMutableAttributedString(string: fullText)

            // Load custom fonts
            let regularFont = UIFont(name: "Nunito-Regular", size: lblFeesDetail.font.pointSize) ?? UIFont.systemFont(ofSize: lblFeesDetail.font.pointSize)
            let boldFont = UIFont(name: "Nunito-Bold", size: lblFeesDetail.font.pointSize) ?? UIFont.boldSystemFont(ofSize: lblFeesDetail.font.pointSize)

            // Set entire string to regular Nunito
            attributedString.addAttributes([.font: regularFont], range: NSRange(location: 0, length: attributedString.length))

            // Apply bold to keywords
            let boldPhrases = ["$3", "$30", "$1 + 15%", "$30"]
            for phrase in boldPhrases {
                let range = (attributedString.string as NSString).range(of: phrase)
                if range.location != NSNotFound {
                    attributedString.addAttribute(.font, value: boldFont, range: range)
                }
            }

            lblFeesDetail.attributedText = attributedString
            lblFeesDetail.numberOfLines = 0
            lblFeesDetail.lineBreakMode = .byWordWrapping
        }
    }
    @IBAction func actionContinue(_ sender: UIButton) {
        
        if isComing{
            self.dismiss(animated: true)
            callBack?()
        }else{
            self.dismiss(animated: true)
        }
        
    }
    @IBAction func actionCross(_ sender: UIButton) {
        
        if isComing{
            self.dismiss(animated: true)
        }else{
            self.dismiss(animated: true)
            callBack?()
        }
    }
}
