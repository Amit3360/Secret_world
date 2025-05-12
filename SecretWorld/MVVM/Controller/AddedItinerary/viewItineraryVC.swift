//
//  viewItineraryVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/01/25.
//

import UIKit

class viewItineraryVC: UIViewController {

    @IBOutlet weak var vwDescription: UIView!
    @IBOutlet weak var heightHeaderView: NSLayoutConstraint!
    @IBOutlet weak var vwUrgent: UIView!
    @IBOutlet weak var lblUrgent: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var vwPrice: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnUrgent: UIButton!
    
    var type = 0
    var itineraryDetail:Itinerary?
    var descriptionText = ""
    private var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        let deviceHasNotch = UIApplication.shared.hasNotch
        if deviceHasNotch{
            if UIDevice.current.hasDynamicIsland {
                heightHeaderView.constant = 130
            }else{
                heightHeaderView.constant = 120
            }
        }else{
            heightHeaderView.constant = 80
        }
        ItineraryDetail()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDescription))
        lblDescription.addGestureRecognizer(tapGesture)
    }
    func ItineraryDetail(){
        if itineraryDetail?.type == 1{
            btnUrgent.isHidden = true
            vwPrice.isHidden = false
            vwAddress.isHidden = false
            lblTitle.text = itineraryDetail?.title ?? ""
            lblAddress.text = itineraryDetail?.location ?? ""
          
            lblDescription.text = itineraryDetail?.notes ?? ""
            lblPrice.text = "$\(itineraryDetail?.earning ?? 0)"
            if itineraryDetail?.urgent == true{
                vwUrgent.backgroundColor = UIColor(hex: "#E63946").withAlphaComponent(0.1)
                lblUrgent.textColor = .black
            }else{
                vwUrgent.backgroundColor = UIColor(hex: "#E9E9E9")
                lblUrgent.textColor = UIColor(hex: "#989898")
            }
            if itineraryDetail?.notes == "" || itineraryDetail?.notes == nil{
                self.vwDescription.isHidden = true
            }else{
                self.vwDescription.isHidden = false
            }
            if let formattedDate = convertToDateFormat(itineraryDetail?.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"hh:mm a") {
                lblTime.text = formattedDate
            } else {
                print("Invalid date format")
            }
            if let formattedDate = convertToDateFormat(itineraryDetail?.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"MMM dd,yyyy") {
                lblDate.text = formattedDate
            } else {
                print("Invalid date format")
            }
            self.descriptionText = itineraryDetail?.notes ?? ""
            self.lblDescription.appendReadmore(after: self.descriptionText, trailingContent: .readmore)
        }else{
            btnUrgent.isHidden = false
            vwPrice.isHidden = true
            vwAddress.isHidden = true
            lblTitle.text = itineraryDetail?.title ?? ""
            if itineraryDetail?.notes == "" || itineraryDetail?.notes == nil{
                self.vwDescription.isHidden = true
            }else{
                self.vwDescription.isHidden = false
            }
            if let formattedDate = convertToDateFormat(itineraryDetail?.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"hh:mm a") {
                lblTime.text = formattedDate
            } else {
                print("Invalid date format")
            }
            if let formattedDate = convertToDateFormat(itineraryDetail?.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"MMM dd,yyyy") {
                lblDate.text = formattedDate
            } else {
                print("Invalid date format")
            }
            lblDescription.text = itineraryDetail?.notes ?? ""
            if itineraryDetail?.urgent == true{
                btnUrgent.backgroundColor = UIColor(hex: "#E63946").withAlphaComponent(0.1)
                btnUrgent.setTitleColor(.black, for: .normal)
            }else{
                btnUrgent.backgroundColor = UIColor(hex: "#E9E9E9")
                btnUrgent.setTitleColor(UIColor(hex: "#989898"), for: .normal)
            }
            self.descriptionText = itineraryDetail?.notes ?? ""
            self.lblDescription.appendReadmore(after: self.descriptionText, trailingContent: .readmore)
        }
    }
    
    @objc private func toggleDescription() {
        isExpanded.toggle()
        if lblDescription.text?.contains("Read More") ?? false || lblDescription.text?.contains("Read Less") ?? false{
            if isExpanded {
                lblDescription.appendReadLess(after: descriptionText, trailingContent: .readless)
            } else {
                lblDescription.appendReadmore(after: descriptionText, trailingContent: .readmore)
            }
          }
    }
    
    func convertToDateFormat(_ dateString: String,dateFormat:String,convertFormat:String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = dateFormat
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = convertFormat
            outputFormatter.timeZone = TimeZone.current // Adjust as needed

            return outputFormatter.string(from: date)
        }
        return nil // Return nil if parsing fails
    }
    
    @IBAction func actionUrgent(_ sender: UIButton) {
        
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
