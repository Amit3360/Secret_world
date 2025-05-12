//
//  CreateItineraryVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 02/01/25.
//

import UIKit
import IQKeyboardManagerSwift

struct ItineraryData{
    let title:String?
    let description:String?
    let date:String?
    let startTime:String?
    let endTime:String?
    init(title: String?, description: String?, date: String?, startTime: String,endTime:String) {
        self.title = title
        self.description = description
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
    }
}
class CreateItineraryVC: UIViewController {
//MARK: - IBOutlet
    @IBOutlet weak var txtFldEndTime: UITextField!
    @IBOutlet var txtFldDate: UITextField!
    @IBOutlet var txtfldTime: UITextField!
    @IBOutlet var txtVwDescription: IQTextView!
    @IBOutlet var txtFldTask: UITextField!
    @IBOutlet var txtFldTItle: UITextField!
    
    //MARK: - variables
    var callBack: (( String, String, String, String, String, String) -> ())?
    var isComing = false
    var getTitle = ""
    var gigId = ""
    var timing = ""
    var location = ""
    var endTime = ""
    var viewModel = ItineraryVM()
    var arrAppliedGigs = [GetAppliedData]()
    var itineraryData:ItineraryData?
    //MARK: - viewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        txtFldDate.tag = 1
        txtfldTime.tag = 2
        setupDatePickers()
         GetEventdata()
        
    }
    func GetEventdata(){
        txtFldTItle.text = itineraryData?.title
        txtFldDate.text = itineraryData?.date
        txtVwDescription.text = itineraryData?.description
        txtfldTime.text = itineraryData?.startTime
        txtFldEndTime.text = itineraryData?.endTime
    }
    //MARK: - IBAction
    @IBAction func actionsave(_ sender: UIButton) {
        
//        viewModel.AddItitneraryApi(gigId: gigId, title: txtFldTItle.text ?? "", description: txtVwDescription.text ?? "", location: location, reminderTime: timing) { [self] in
          
            self.dismiss(animated: true)
        callBack?(self.gigId,txtFldTItle.text ?? "", txtFldDate.text ?? "", txtfldTime.text ?? "", txtVwDescription.text ?? "", txtFldEndTime.text ?? "")
      //  }
        
        
    }
    
    @IBAction func actionSelectTask(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
                 vc.type = "calender"
                  vc.arrAppliedGig = self.arrAppliedGigs
        vc.callBack = { [self] type,title,id in
            self.txtFldTask.text = title
            self.gigId = id
        }
                 vc.modalPresentationStyle = .popover
                 let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
                 popOver.sourceView = sender as? UIView
                 popOver.delegate = self
                 popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(
            width: txtFldTask.frame.size.width+40,
            height: CGFloat(arrAppliedGigs.count * 50)
        )
                 self.present(vc, animated: false)
    }
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
// MARK: - Handle TextFields DatePicker
extension CreateItineraryVC {
    private func setupDatePickers() {
        setupDatePicker(for: txtFldDate, mode: .date, selector: #selector(dateDonePressed))
        setupDatePicker(for: txtfldTime, mode: .time, selector: #selector(timeDonePressed))
        setupDatePicker(for: txtFldEndTime, mode: .time, selector: #selector(endTimeDonePressed))
    }

    func setupDatePicker(for textField: UITextField, mode: UIDatePicker.Mode, selector: Selector) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        textField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: selector)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar

        // Associate the date picker with the text field
        if textField == txtFldDate {
            datePicker.tag = 1
        } else if textField == txtfldTime {
            datePicker.tag = 2
        }else if textField == txtFldEndTime{
            datePicker.tag = 3
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender.tag == 1 { // Date Picker for txtFldDate
            txtFldDate.text = formatDate(sender.date, format: "yyyy-MM-dd")
        } else if sender.tag == 2 { // Time Picker for txtfldTime
            txtfldTime.text = formatDate(sender.date, format: "h:mm a")
        }else if sender.tag == 3{
            txtFldEndTime.text = formatDate(sender.date, format: "h:mm a")
        }
        updateCombinedDateTime()
    }

    @objc func dateDonePressed() {
        if let datePicker = txtFldDate.inputView as? UIDatePicker {
            txtFldDate.text = formatDate(datePicker.date, format: "yyyy-MM-dd")
        }
        txtFldDate.resignFirstResponder()
        updateCombinedDateTime()
    }

    @objc func timeDonePressed() {
        if let datePicker = txtfldTime.inputView as? UIDatePicker {
            txtfldTime.text = formatDate(datePicker.date, format: "h:mm a")
        }
        txtfldTime.resignFirstResponder()
        updateCombinedDateTime()
    }
    @objc func endTimeDonePressed() {
        if let datePicker = txtFldEndTime.inputView as? UIDatePicker {
            txtFldEndTime.text = formatDate(datePicker.date, format: "h:mm a")
        }
        txtFldEndTime.resignFirstResponder()
        
    }
    private func updateCombinedDateTime() {
        guard let dateText = txtFldDate.text, !dateText.isEmpty,
              let timeText = txtfldTime.text, !timeText.isEmpty else {
            timing = ""
            return
        }

        let dateTimeString = "\(dateText) \(timeText)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        dateFormatter.timeZone = TimeZone.current

        if let combinedDate = dateFormatter.date(from: dateTimeString) {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            timing = isoFormatter.string(from: combinedDate)
        }
    }

    private func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

// MARK: - Popup
extension CreateItineraryVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
