//
//  AddDealVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 05/02/25.
//

import UIKit

class AddDealVC: UIViewController {

    @IBOutlet weak var vwService: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var collVwService: UICollectionView!
    @IBOutlet weak var txtFldActiveTill: UITextField!
    @IBOutlet weak var txtFldDeal: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    
//    var arrService = ["Service","Service","Service","Service"]
    var arrService = [ServiceDetail]()
    var viewModel = AddServiceVM()
    var selectServiceId = [String]()
    var selectAllServieId = [String]()
    var viewModelDeal = DealsVM()
    var callBack:((_ message:String?)->())?
    var isUpdate = false
    var dealDetail:GetDealsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getServiceApi(loader: false)
        uiData()
    }
    func uiData(){
        if isUpdate{
            
            lblHeader.text = "Update deal"
            btnSave.setTitle("Update", for: .normal)
            txtFldDeal.text = dealDetail?.title ?? ""
            for i in dealDetail?.bUserServicesIds ?? [] {
                self.selectServiceId.append(i.id ?? "")
            }
            if let formattedDate = convertToDateFormat(dealDetail?.validTo ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"yyyy-MM-dd, h:mm a") {
                txtFldActiveTill.text = formattedDate
            } else {
                print("Invalid date format")
            }
            collVwService.reloadData()
            if arrService.count > 0{
                self.vwService.isHidden = false
            }else{
                self.vwService.isHidden = true
            }
        }else{
            lblHeader.text = "Create deal"
            btnSave.setTitle("Save", for: .normal)
        }
    }
    func getServiceApi(loader:Bool){
        print(Store.authKey ?? "")
        setupDatePicker(for: txtFldActiveTill, mode: .dateAndTime, selector: #selector(dateDonePressed))
      
        selectAllServieId.removeAll()
        for i in self.arrService{
            self.selectAllServieId.append(i._id ?? "")
           }
        self.collVwService.reloadData()
           
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
    
    private func setupDatePicker(for textField: UITextField, mode: UIDatePicker.Mode, selector: Selector) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        if textField == txtFldActiveTill{
            datePicker.minimumDate = Date()
        }
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        // Add target to update the text field while scrolling
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        textField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                          UIBarButtonItem(barButtonSystemItem: .done, target: self, action: selector)], animated: true)
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        if txtFldActiveTill.isFirstResponder {
            updateTextField(txtFldActiveTill, datePicker: sender)
        }
    }
    private func updateTextField(_ textField: UITextField, datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        if textField == txtFldActiveTill {
            dateFormatter.dateFormat = "yyyy-MM-dd, h:mm a"
            textField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    @objc private func dateDonePressed() {
        if let datePicker = txtFldActiveTill.inputView as? UIDatePicker {
            updateTextField(txtFldActiveTill, datePicker: datePicker)
        }
        view.endEditing(true)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSelectAll(_ sender: UIButton) {
        self.selectServiceId.append(contentsOf: selectAllServieId)
        self.collVwService.reloadData()
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        if !setValidation() {return}
        
        let combinedDateTimeString = "\(txtFldActiveTill.text ?? "")"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd, h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let dateTime = dateFormatter.date(from: combinedDateTimeString) else {
            print("Failed to parse date & time. Input was: \(combinedDateTimeString)")
            return
        }
        
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let isoDateString = isoDateFormatter.string(from: dateTime)
        
        if isUpdate{
            viewModelDeal.updateDealsApi(dealId: dealDetail?.id ?? "", title: txtFldDeal.text ?? "", validTo: isoDateString, bUserServicesIds: selectServiceId, status: 1) { message in
                self.navigationController?.popViewController(animated: true)
                self.callBack?(message)
            }
        }else{
            viewModelDeal.createDealsApi(title: txtFldDeal.text ?? "", validTo: isoDateString, bUserServicesIds: selectServiceId) { message in
                
                self.navigationController?.popViewController(animated: true)
                self.callBack?(message)
            }
        }
       
    }
    func setValidation() -> Bool {
        var errorMessage: String?

        if txtFldDeal.text?.trimWhiteSpace.isEmpty == true {
            errorMessage = "Enter your deal."
        } else if txtFldActiveTill.text?.trimWhiteSpace.isEmpty == true {
            errorMessage = "Select deal active till."
        } else if selectServiceId.isEmpty {
            errorMessage = "Select at least one service."
            
        }

        if let errorMessage = errorMessage {
            showSwiftyAlert("", errorMessage, false)
            return false
        }
        return true
    }
}
extension AddDealVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrService.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCVC", for: indexPath) as! FeatureCVC
        cell.lblName.text = arrService[indexPath.row].serviceName ?? ""
        cell.btnTick.addTarget(self, action: #selector(tickUntick), for: .touchUpInside)
        cell.btnTick.tag = indexPath.row
        if selectServiceId.contains(arrService[indexPath.row]._id ?? ""){
            cell.btnTick.isSelected = true
        }else{
            cell.btnTick.isSelected = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collVwService.frame.width/2-0, height: 32)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func tickUntick(sender: UIButton) {
        sender.isSelected.toggle()
        print(sender.tag, sender.isSelected)
        if sender.tag < arrService.count {
            let feature = arrService[sender.tag]._id ?? ""
            if sender.isSelected {
                selectServiceId.append(feature)
            } else {
                if let index = selectServiceId.firstIndex(of: feature) {
                    selectServiceId.remove(at: index)
                }
            }
        } else {
            print("Error: sender.tag (\(sender.tag)) is out of range.")
        }
        print(selectServiceId)
    }
}
