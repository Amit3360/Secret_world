//
//  AddItineryVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/01/25.
//

import UIKit
import IQKeyboardManagerSwift

class AddItineryVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var heightHeaderVw: NSLayoutConstraint!
    @IBOutlet var vviewUrgent: UIView!
    @IBOutlet var viewLocation: UIView!
    @IBOutlet var txtFldDate: UITextField!
    @IBOutlet var txtFldLocation: UITextField!
    @IBOutlet var txtFldEarning: UITextField!
    @IBOutlet var txtFldTimeOnly: UITextField!
    @IBOutlet var viewTask: UIView!
    @IBOutlet var viewOnlyTime: UIView!
    @IBOutlet var viewEarning: UIView!
    @IBOutlet var viewRepeat: UIView!
    @IBOutlet var viewTime: UIView!
    @IBOutlet var viewTimer: UIView!
    @IBOutlet var btnUrgent: UIButton!
    @IBOutlet var viewNotes: UIView!
    @IBOutlet var txtVwNotes: IQTextView!
    @IBOutlet var txtFldRepeat: UITextField!
    @IBOutlet var txtFldTime: UITextField!
    @IBOutlet var txtFldTitle: UITextField!
    @IBOutlet var viewTitle: UIView!
    @IBOutlet var viewBackGreen: UIView!
    @IBOutlet weak var txtFldChooseTask: UITextField!
    
    //MARK: - variables
    var isPersonal = false
    var selectedIndex:IndexPath?
    var lat,long:Double?
    var currentDate,currentTime:String?
    var viewModelGig = AddGigVM()
    var arrAppliedGigs = [GetAppliedData]()
    var gigId = ""
    var type = 2
    var repeatType = ""
    var isUrgent = false
    var viewModel = ItineraryVM()
    var itineraryId = ""
    var isComing = false
    var itineraryDetail:Itinerary?
    var callBack:((_ type:Int?,_ message:String?)->())?
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    
    private func uiSet() {
        let deviceHasNotch = UIApplication.shared.hasNotch
        if deviceHasNotch{
            if UIDevice.current.hasDynamicIsland {
                heightHeaderVw.constant = 130
            }else{
                heightHeaderVw.constant = 120
            }
        }else{
            heightHeaderVw.constant = 80
        }
        
        getCurrentDateAndTime()
        txtFldRepeat.delegate = self
        viewBackGreen.layer.cornerRadius = 30
        viewBackGreen.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        setupDatePicker(for: txtFldTime, mode: .time, selector: #selector(timeDonePressed))
        setupDatePicker(for: txtFldDate, mode: .date, selector: #selector(dateDonePressed))
        handlePerosnal()
        getAppliedGigApi()
        print("Auth---",Store.authKey ?? "")
        
    }
    
    private func getAppliedGigApi(){
        viewModelGig.GetUserAppliedGigApi(offset: 1, limit: 10, type: 1) { data in
            self.arrAppliedGigs.removeAll()
            self.arrAppliedGigs = data?.gigs ?? []
            
            for i in data?.gigs ?? []{
                if i.gig?.id?.contains(self.itineraryDetail?.gigID ?? "") ?? false{
                    print("Contain-----")
                    self.txtFldChooseTask.text = "\(i.gig?.title ?? "") \(i.gig?.category?.name ?? "")"
                    self.gigId = i.gig?.id ?? ""
                }
            }
        }
    }
    
    private func handlePerosnal(){
        if !isPersonal{
            viewOnlyTime.isHidden  = true
            viewRepeat.isHidden  = true
            type = 1
            if isComing{
                self.btnSave.setTitle("Update", for: .normal)
                self.txtFldTitle.text = itineraryDetail?.title ?? ""
                self.txtVwNotes.text = itineraryDetail?.notes ?? ""
                self.txtFldLocation.text = itineraryDetail?.location ?? ""
                self.lat = itineraryDetail?.lat ?? 0
                self.long = itineraryDetail?.long ?? 0
                self.txtFldEarning.text = "\(itineraryDetail?.earning ?? 0)"
                
                if itineraryDetail?.urgent ?? false{
                    self.btnUrgent.isSelected = true
                    btnUrgent.backgroundColor = .app
                    isUrgent = true
                }else{
                    self.btnUrgent.isSelected = false
                    isUrgent = false
                    btnUrgent.backgroundColor = .white
                    btnUrgent.borderWid = 1
                    btnUrgent.borderCol = .app
                }
                if let formattedDate = convertToDateFormat(itineraryDetail?.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"h:mm a") {
                    txtFldTime.text = formattedDate
                } else {
                    print("Invalid date format")
                }
                if let formattedDate = convertToDateFormat(itineraryDetail?.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"MMM d, yyyy") {
                    txtFldDate.text = formattedDate
                } else {
                    print("Invalid date format")
                }
            }else{
                self.btnSave.setTitle("Save", for: .normal)
                
            }
        }else{
            type = 2
            viewTask.isHidden  = true
            viewLocation.isHidden  = true
            viewEarning.isHidden  = true
            viewOnlyTime.isHidden  = true
            viewRepeat.isHidden  = false
            if isComing{
                self.btnSave.setTitle("Update", for: .normal)
                self.txtFldTitle.text = itineraryDetail?.title ?? ""
                self.txtVwNotes.text = itineraryDetail?.notes ?? ""
                self.repeatType = itineraryDetail?.itineraryRepeat ?? ""
                
                if itineraryDetail?.urgent ?? false{
                    self.btnUrgent.isSelected = true
                    btnUrgent.backgroundColor = .app
                    isUrgent = true
                }else{
                    self.btnUrgent.isSelected = false
                    isUrgent = false
                    btnUrgent.backgroundColor = .white
                    btnUrgent.borderWid = 1
                    btnUrgent.borderCol = .app
                }
                switch itineraryDetail?.itineraryRepeat{
                case "none":
                    txtFldRepeat.text = "Does not repeat"
                    selectedIndex = IndexPath(row: 0, section: 0)
                case "daily":
                    txtFldRepeat.text = "Everyday"
                    selectedIndex = IndexPath(row: 1, section: 0)
                case "weekly":
                    txtFldRepeat.text = "Every week"
                    selectedIndex = IndexPath(row: 2, section: 0)
                case "monthly":
                    txtFldRepeat.text = "Every month"
                    selectedIndex = IndexPath(row: 3, section: 0)
                case "yearly":
                    txtFldRepeat.text = "Every Year"
                    selectedIndex = IndexPath(row: 4, section: 0)
                default:
                    break
                }
                if let formattedDate = convertToDateFormat(itineraryDetail?.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"h:mm a") {
                    txtFldTime.text = formattedDate
                } else {
                    print("Invalid date format")
                }
                if let formattedDate = convertToDateFormat(itineraryDetail?.reminderTime ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"MMM d, yyyy") {
                    txtFldDate.text = formattedDate
                } else {
                    print("Invalid date format")
                }
            }else{
                self.btnSave.setTitle("Save", for: .normal)
            }
        }
        
    }
    private func getCurrentDateAndTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let formattedDate = dateFormatter.string(from: Date())
        currentDate = formattedDate
        dateFormatter.dateFormat = "h:mm a"
        currentTime = dateFormatter.string(from: Date())
        
    }
    
    private func convertToDateFormat(_ dateString: String,dateFormat:String,convertFormat:String) -> String? {
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
        if textField == txtFldDate{
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
        if txtFldDate.isFirstResponder {
            updateTextField(txtFldDate, datePicker: sender)
        } else if txtFldTimeOnly.isFirstResponder {
            updateTextField(txtFldTimeOnly, datePicker: sender)
        } else if txtFldTime.isFirstResponder {
            updateTextField(txtFldTime, datePicker: sender)
        }
    }
    private func updateTextField(_ textField: UITextField, datePicker: UIDatePicker) {
        getCurrentDateAndTime()
        
        let dateFormatter = DateFormatter()
        if textField == txtFldDate {
            dateFormatter.dateFormat = "MMM d, yyyy"
            textField.text = dateFormatter.string(from: datePicker.date)
        } else {
            dateFormatter.dateFormat = "h:mm a"
            if currentDate == txtFldDate.text{
                datePicker.minimumDate = Date()
            }else{
                datePicker.minimumDate = nil
            }
            textField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    @objc private func dateDonePressed() {
        if let datePicker = txtFldDate.inputView as? UIDatePicker {
            updateTextField(txtFldDate, datePicker: datePicker)
        }
        view.endEditing(true)
    }
    
    @objc private func timeDonePressed() {
        if let datePicker = txtFldTime.inputView as? UIDatePicker {
            updateTextField(txtFldTime, datePicker: datePicker)
        }
        view.endEditing(true)
    }
    
    //MARK: - button actions
    @IBAction func actionChooseTask(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "calender"
        vc.arrAppliedGig = self.arrAppliedGigs
        vc.callBackItinerary = { [self] type,title,id,price in
            self.txtFldChooseTask.text = title
            self.gigId = id
            self.txtFldEarning.text = "\(price)"
        }
        vc.modalPresentationStyle = .popover
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender as? UIView
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(
            width: txtFldChooseTask.frame.size.width+40,
            height: CGFloat(arrAppliedGigs.count * 50)
        )
        self.present(vc, animated: false)
    }
    
    @IBAction func actionUrgent(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            btnUrgent.backgroundColor = .app
            isUrgent = true
        }else{
            isUrgent = false
            btnUrgent.backgroundColor = .white
            btnUrgent.borderWid = 1
            btnUrgent.borderCol = .app
        }
    }
    @IBAction func actionLocation(_ sender: UIButton) {
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentLocationVC") as! CurrentLocationVC
        vc.isSignUp = true
        vc.callBack = { [weak self] aboutLocation in
            guard let self = self else { return }
            self.txtFldLocation.text = aboutLocation.placeName ?? ""
            self.lat = aboutLocation.lat ?? 0.0
            self.long = aboutLocation.long ?? 0.0
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func actionRepeat(_ sender: UIButton) {
        pushToRepeatVc()
    }
    private func pushToRepeatVc(){
        view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepeatVC") as! RepeatVC
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = self
        vc.selectedIndex = selectedIndex
        self.navigationController?.present(vc, animated: true)
        
    }
    @IBAction func actionBAck(_ sender: UIButton) {
//        if isPersonal{
//      
//        NotificationCenter.default.post(name: Notification.Name("personal"), object: nil)
//        
//        }else{
//            NotificationCenter.default.post(name: Notification.Name("professional"), object: nil)
//        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSave(_ sender: UIButton) {
      
        
        if !validation() { return }

          let combinedDateTimeString = "\(txtFldDate.text ?? "") \(txtFldTime.text ?? "")"
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
          dateFormatter.locale = Locale(identifier: "en_US_POSIX")

          guard let dateTime = dateFormatter.date(from: combinedDateTimeString) else {
              print("Failed to parse date & time. Input was: \(combinedDateTimeString)")
              return
          }
          
          let isoDateFormatter = ISO8601DateFormatter()
          isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
          isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

          let isoDateString = isoDateFormatter.string(from: dateTime)
          print("Formatted ISO8601 Date String: \(isoDateString)")
        if isComing{
            viewModel.UpdateItitneraryApi(itineraryId: itineraryDetail?.id ?? "", gigId: self.gigId,type: self.type, title: txtFldTitle.text ?? "", endTime: "", description: txtVwNotes.text ?? "", location: txtFldLocation.text ?? "", repeatType: repeatType, notes: txtVwNotes.text ?? "", urgent: isUrgent,lat:self.lat ?? 0,long: self.long ?? 0,earning:txtFldEarning.text ?? "", reminderTime:isoDateString) { message in
                self.navigationController?.popViewController(animated: true)
                self.callBack?(self.type, message)
            }
        }else{
            viewModel.AddItitneraryApi(gigId: self.gigId,type: self.type, title: txtFldTitle.text ?? "", endTime: "", description: txtVwNotes.text ?? "", location: txtFldLocation.text ?? "", repeatType: repeatType, notes: txtVwNotes.text ?? "", urgent: isUrgent,lat:self.lat ?? 0,long: self.long ?? 0,earning:txtFldEarning.text ?? "", reminderTime:isoDateString) { message in
                self.navigationController?.popViewController(animated: true)
                self.callBack?(self.type, message)
                
            }
        }
           }
    private func validation() -> Bool {
        var errorMessage: String?

        if type == 2 {
            if txtFldTitle.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Title cannot be empty."
            } else if txtFldTime.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Start time cannot be empty."
            } else if txtFldDate.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Date cannot be empty."
            } else if txtFldRepeat.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Select a repeat option."
            } else if txtVwNotes.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Notes cannot be empty."
            }
        } else {
            if txtFldTitle.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Title cannot be empty."
            } else if txtFldChooseTask.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Task cannot be empty."
            } else if txtFldLocation.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Location cannot be empty."
            } else if txtFldEarning.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Earning cannot be empty."
            } else if txtFldTime.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Start Time cannot be empty."
            } else if txtFldDate.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Date cannot be empty."
            } else if txtVwNotes.text?.trimWhiteSpace.isEmpty == true {
                errorMessage = "Notes cannot be empty."
            }
        }

        if let errorMessage = errorMessage {
            showSwiftyAlert("", errorMessage, false)
            return false
        }
        return true
    }
}
//MARK: - getSelectedData by protocol
extension AddItineryVC:backData{
    func passIndex(index: IndexPath, title: String) {
        selectedIndex = index
        
        switch title{
        case "Does not repeat":
            repeatType = "none"
        case "Every day":
            repeatType = "daily"
        case "Every week":
            repeatType = "weekly"
        case "Every month":
            repeatType = "monthly"
        case "Every Year":
            repeatType = "yearly"
        default:
            break
        }
        txtFldRepeat.text = title
    }
    
}
//MARK: - UITextFieldDelegate
extension AddItineryVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFldRepeat{
            pushToRepeatVc()
        }
    }
}

// MARK: - Popup
extension AddItineryVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
