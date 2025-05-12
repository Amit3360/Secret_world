//
//  DatePickerVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 21/12/23.
//

import UIKit

class DatePickerVC: UIViewController {
    //MARK: - Outlets
  
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    
    var callBack:((_ datee:String?)->())?
    var isComing = false
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    
    func uiSet() {
        let calendar = Calendar(identifier: .gregorian)
        if Store.role == "b_user" {
            lblScreenTitle.text = "Since from"
            
            datePicker.maximumDate = Date()
            // Add target for valueChanged event
            datePicker.addTarget(self, action: #selector(datePickerValueChangedBusiness), for: .valueChanged)
            
            let initialDateFormatted = formatDate(date: datePicker.date)
            print("Initial Date: \(initialDateFormatted)") // Print the initial date (17 years ago)

        } else {
            lblScreenTitle.text = "Date of birth"
            
            // Set the minimum date (17 years ago)
            if let minDate = calendar.date(byAdding: .year, value: -17, to: Date()) {
                datePicker.minimumDate = minDate
            }
            
            // Set the maximum date (65 years ago)
            if let maxDate = calendar.date(byAdding: .year, value: -65, to: Date()) {
                datePicker.maximumDate = maxDate
            }
            
            // Set the initial date to 17 years ago
            if let initialDate = calendar.date(byAdding: .year, value: -17, to: Date()) {
                datePicker.date = initialDate
            }
            
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "en_US_POSIX")
            
            // Add target for valueChanged event
            datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            
            let initialDateFormatted = formatDate(date: datePicker.date)
            print("Initial Date: \(initialDateFormatted)") // Print the initial date (17 years ago)

        }
        
        viewBackground.layer.cornerRadius = 35
        viewBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        setupOverlayView()
    }
    @objc func datePickerValueChangedBusiness(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        
        // Prevent selecting a future date
        if selectedDate > Date() {
            print("Future dates are not allowed for business users.")
            sender.date = Date() // Reset to current date
        } else {
            print("Selected Date for Business: \(formatDate(date: selectedDate))")
        }
    }
    // Action method when the date picker value changes
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        
        // Calculate age based on the selected date
        let calendar = Calendar(identifier: .gregorian)
        let ageComponents = calendar.dateComponents([.year], from: selectedDate, to: Date())
        
        if let age = ageComponents.year {
            // If age is outside of the 17 to 65 range, prevent changing the value
            if age < 17 {
                print("Age must be at least 17 years old.")
                // Optionally, reset the date picker to the previous valid date
                sender.date = calendar.date(byAdding: .year, value: -17, to: Date())!
            } else if age > 65 {
                print("Age cannot be more than 65 years old.")
                // Optionally, reset the date picker to the previous valid date
                sender.date = calendar.date(byAdding: .year, value: -65, to: Date())!
            } else {
                // Print the valid age
                print("Selected Age: \(age)")
            }
        }
    }

    func setupOverlayView() {
            viewBackground = UIView(frame: self.view.bounds)
        viewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
              let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        viewBackground.addGestureRecognizer(tapGesture)
              self.view.insertSubview(viewBackground, at: 0)
          }
        @objc func overlayTapped() {
              self.dismiss(animated: true)
          }
    
    //MARK: - Button Actions
    @IBAction func actionDatePicker(_ sender: UIDatePicker) {
    }
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionContinue(_ sender: UIButton) {
        
        let selectedDate = formatDate(date: datePicker.date)
        print("Selected Date: \(selectedDate)")
        self.dismiss(animated: true)
        self.callBack?(selectedDate)
        
    }
     func formatDate(date: Date) -> String {
         
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           return dateFormatter.string(from: date)
         
       }
}
