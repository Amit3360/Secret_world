//
//  PrivacyPolicyVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 26/12/23.
//

import UIKit

class PrivacyPolicyVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtVwPolicy: UITextView!
    
    //MARK: - VARIABLES
    var isComing = 0
    var viewModel = UserProfileVM()
    var content = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
    }
    @objc func handleSwipe() {
                navigationController?.popViewController(animated: true)
            }
    override func viewWillAppear(_ animated: Bool) {
        uiSet()
    }
    
    private func uiSet() {
        if isComing == 0{
            lblTitle.text = "About us"
            viewModel.getUserPolicyTermApi(type: "about") { data in
                if let aboutContent = data?.data?.content {
                    self.txtVwPolicy.attributedText = aboutContent.convertHtmlToAttributedString()
                }
            }
        }else if isComing == 1{
            lblTitle.text = "Privacy Policy"
            viewModel.getUserPolicyTermApi(type: "k") { data in
                if let policyContent = data?.data?.content {
                    self.txtVwPolicy.attributedText = policyContent.convertHtmlToAttributedString()
                }
            }
        } else {
            lblTitle.text = "Apply cancellation policy "
            viewModel.getUserPolicyTermApi(type: "p") { data in
                if let aboutContent = data?.data?.content {
                    let fullText = """
                    Cancellation Policy
                    • Customers can cancel their booking/order within 24 hours of purchase for a full refund.

                    • Cancellations after 24 hours may be subject to a cancellation fee of 20%.

                    Refund Policy
                    • If canceled before the cancellation window closes, a full refund will be processed within 5-7 business days.

                    • Partial refunds (if applicable) will be credited after deducting the cancellation fee.

                    No-Show & Late Cancellation
                    • If the customer does not show up or cancels after the service/product has been processed, no refund will be issued.

                    Special Cases
                    • Emergency situations (e.g., medical emergencies) may be considered for a full or partial refund upon proper documentation.
                    """

                    let attributedString = NSMutableAttributedString(string: fullText)

                    let regularFont = UIFont(name: "Nunito-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
                    let boldFont = UIFont(name: "Nunito-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15)

                    // Apply default font first
                    attributedString.addAttribute(.font, value: regularFont, range: NSRange(location: 0, length: attributedString.length))

                    // Apply bold to specific headings
                    let boldHeadings = ["Cancellation Policy", "Refund Policy", "No-Show & Late Cancellation", "Special Cases"]
                    for heading in boldHeadings {
                        if let range = fullText.range(of: heading) {
                            let nsRange = NSRange(range, in: fullText)
                            attributedString.addAttribute(.font, value: boldFont, range: nsRange)
                        }
                    }

                    self.txtVwPolicy.attributedText = attributedString
                }
            }
        }
    }

    //MARK: - BUTTON ACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - convertHtmlToAttributedString
extension String {
    func convertHtmlToAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let attributedString = try NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )

            // Apply Poppins font
            applyCustomFont(to: attributedString)
            return attributedString
        } catch {
            print("Error converting HTML: \(error)")
            return nil
        }
    }
    
    private func applyCustomFont(to attributedString: NSMutableAttributedString) {
        let fullRange = NSRange(location: 0, length: attributedString.length)
        attributedString.enumerateAttributes(in: fullRange, options: []) { attributes, range, _ in
            if let font = attributes[.font] as? UIFont {
                let newFont: UIFont
                if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    newFont = UIFont(name: "Poppins-Bold", size: font.pointSize) ?? font
                } else {
                    newFont = UIFont(name: "Poppins-Regular", size: font.pointSize) ?? font
                }
                attributedString.addAttribute(.font, value: newFont, range: range)
            }
        }
    }
}
