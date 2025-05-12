//
//  PromoCodePopUpVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 09/04/24.
//

import UIKit
//After gig complete and give review
class PromoCodePopUpVC: UIViewController {
    
    @IBOutlet var lblExpiryDate: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblPromoCode: UILabel!
    var promoCodeDetail:PromoCodes?
    var callBack:(()->())?
    var viewModel = AddGigVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        lblDiscount.text = "\(promoCodeDetail?.discount ?? 0)%"
        if let formattedDate = formatDate(dateString: promoCodeDetail?.expiryTime ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: "dd MMM yyyy") {
            lblExpiryDate.text = "Expire on \(formattedDate)"
        }
        lblPromoCode.text = promoCodeDetail?.promoCode ?? ""
        
    }
   
    @IBAction func actionCopy(_ sender: UIButton) {
        UIPasteboard.general.string =  lblPromoCode.text
        showSwiftyAlert("", "Copied promo code", true)
    }
    @IBAction func actionThanks(_ sender: UIButton) {
        viewModel.UpdatePromoStatusApi(gigid: promoCodeDetail?.gigID ?? "", userid: promoCodeDetail?.applyuserID ?? "") {
            self.dismiss(animated: false)
            self.callBack?()
        }
        
    }
    
    @IBAction func actionDismis(_ sender: UIButton) {
        viewModel.UpdatePromoStatusApi(gigid: promoCodeDetail?.gigID ?? "", userid: promoCodeDetail?.applyuserID ?? "") {
            self.dismiss(animated: false)
            self.callBack?()
        }
    }
    func formatDate(dateString: String, inputFormat: String, outputFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
