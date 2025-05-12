//
//  ItineraryVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 02/01/25.
//

import UIKit
import FSCalendar
import CalendarKit

class ItineraryVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var bottomVw: NSLayoutConstraint!
    @IBOutlet var viewNoTask: UIView!
    @IBOutlet var lblMonthYear: UILabel!
    @IBOutlet var eventView: UIView!
  
    //MARK: - variables
    private var dayView: DayView!
    private var eventsDictionary: [Date: [Event]] = [:]
    var viewModel = ItineraryVM()
    var viewModelGig = AddGigVM()
    var data = [ItirenaryData]()
    var arrAppliedGigs = [GetAppliedData]()
    var serviceId = ""
    var selectDate = ""
    var startTime = ""
    var endTime = ""
    let deviceHasNotch = UIApplication.shared.hasNotch
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if deviceHasNotch{
            if UIDevice.current.hasDynamicIsland {
                bottomVw.constant = 58
            }else{
                bottomVw.constant = 48
            }
        }else{
            bottomVw.constant = 80
        }
        uiSet()
        setupDayView()
        getItineraryApi()
        getAppliedGigApi()
    }
    func getItineraryApi() {
//        viewModel.GetItineraryApi { [weak self] data in
//            guard let self = self else { return }
//            self.data = data ?? []

            // Clear the events dictionary
//            self.eventsDictionary.removeAll()
//
//            // Parse the itinerary data and create events
//            let formatter = ISO8601DateFormatter()
//            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//          
//            for itinerary in self.data {
                // Ensure itinerary has required properties
//                guard let dateStr = itinerary.reminderTime,
//                      let eventDate = formatter.date(from: dateStr),
//                      let title = itinerary.title,
//                      let description = itinerary.description else {
//                    continue
//                }
                
                // Create an event
//                if let formattedDate = formatDateString(inputDateString: itinerary.reminderTime ?? "") {
//                    print("Formatted Date String: \(formattedDate)") // Output: "10:38 PM"
//                    if let formattedDate2 = formatDateString(inputDateString: itinerary.endTime ?? "") {
//                        print("Formatted Date String: \(formattedDate)") // Output: "10:38 PM"
//                        let event = Event()
//                      
//                        event.text = "\(title)\n\n\(itinerary.description ?? "")"
//                        event.description = "\n\(formattedDate) - \(formattedDate2)"
//                        event.selectTask = itinerary.title  ?? ""
//                        event.color = UIColor(hex: "#F1F8F0") // Customize event color
//                        event.textColor = .black
//                        event.backgroundColor = UIColor(hex: "#f1f8f0")
//                        event.dateInterval = DateInterval(start: eventDate, duration: 60 * 60) // Example: 1-hour duration
//                        
//                        // Get the date without time for dictionary key
//                        let calendar = Calendar.current
//                        let dateOnly = calendar.startOfDay(for: eventDate)
//                        
//                        // Store the event in the dictionary
//                        if self.eventsDictionary[dateOnly] != nil {
//                            self.eventsDictionary[dateOnly]?.append(event)
//                        } else {
//                            self.eventsDictionary[dateOnly] = [event]
//                        }
//                    } else {
//                        print("Invalid date format")
//                    }
//                } else {
//                    print("Invalid date format")
//                }
               
            }

            // Reload the DayView with updated events
//            DispatchQueue.main.async {
//                self.dayView.reloadData()
//            }
//        }
//    }
    func formatDateString(inputDateString: String,
                          inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                          outputFormat: String = "hh:mm a") -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Match the input's timezone (UTC)

        // Convert the string to a Date object
        if let date = inputFormatter.date(from: inputDateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = outputFormat
            outputFormatter.locale = Locale(identifier: "en_US_POSIX") // Consistent formatting
//            outputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Local timezone

            // Return the formatted string
            return outputFormatter.string(from: date)
        } else {
            return nil // Invalid date format
        }
    }
    func formatSelectDate(inputDateString: String,
                          inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                          outputFormat: String = "yyyy-MM-dd hh:mm a") -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Match the input's timezone (UTC)

        // Convert the string to a Date object
        if let date = inputFormatter.date(from: inputDateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = outputFormat
            outputFormatter.locale = Locale(identifier: "en_US_POSIX") // Consistent formatting
//            outputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Local timezone

            // Return the formatted string
            return outputFormatter.string(from: date)
        } else {
            return nil // Invalid date format
        }
    }
    
    func getAppliedGigApi(){
        viewModelGig.GetUserAppliedGigApi(offset: 1, limit: 10, type: 1) { data in
            self.arrAppliedGigs.removeAll()
            self.arrAppliedGigs = data?.gigs ?? []
        }
    }
    func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let calendar = Calendar.current
        let dateOnly = calendar.startOfDay(for: date)
        return eventsDictionary[dateOnly] ?? []
    }
    // MARK: - Setup UI
    private func uiSet() {
           
            eventView.isHidden = false
          
        }
    private func setupDayView() {
        dayView = DayView()
        dayView.translatesAutoresizingMaskIntoConstraints = false
        eventView.addSubview(dayView)
        NSLayoutConstraint.activate([
            dayView.topAnchor.constraint(equalTo: eventView.topAnchor),
            dayView.bottomAnchor.constraint(equalTo: eventView.bottomAnchor),
            dayView.leadingAnchor.constraint(equalTo: eventView.leadingAnchor),
            dayView.trailingAnchor.constraint(equalTo: eventView.trailingAnchor)
        ])

        // Set the DayView's delegate to self
        dayView.delegate = self
        dayView.dataSource = self
    
        dayView.reloadData()
    }
    @IBAction func actionAdd(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateItineraryVC") as! CreateItineraryVC
        vc.modalPresentationStyle = .overFullScreen
        vc.arrAppliedGigs = self.arrAppliedGigs
        vc.callBack = { [weak self] gigId,title, date, time, description,endTime in
            let combinedDateTimeString = "\(date) \(time)"
            let endTimeDateCombined = "\(date) \(endTime)"
            // Create a DateFormatter to parse the combined string
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm a" // Adjust to input format (e.g., no leading zero in hours)
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
            
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Adjust if your input is in UTC or another timezone
            
            // Convert the combined string to a Date object
            if let dateTime = dateFormatter.date(from: combinedDateTimeString) {
                // Create an ISO8601 DateFormatter
                let isoDateFormatter = ISO8601DateFormatter()
                isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure output is in UTC
                
                // Format the Date object to an ISO8601 string
                let isoDateString = isoDateFormatter.string(from: dateTime)
                
                print("Formatted ISO8601 Date String: \(isoDateString)")
                // You can now use isoDateString as needed
                if let dateEndTime = dateFormatter.date(from: endTimeDateCombined) {
                    // Create an ISO8601 DateFormatter
                    let isoDateFormatter = ISO8601DateFormatter()
                    isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure output is in UTC
                    
                    // Format the Date object to an ISO8601 string
                    let isoDateString2 = isoDateFormatter.string(from: dateEndTime)
                    
                    print("Formatted ISO8601 Date String: \(isoDateString)")
//                    self?.viewModel.AddItitneraryApi(gigId: gigId, title: title, endTime: isoDateString2, description: description, location: "", reminderTime: isoDateString) {
//                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
//                            self?.getItineraryApi()
//                        }
//                       
//                    }
                } else {
                    print("Failed to parse the date and time. Input was: \(combinedDateTimeString)")
                }
                
            } else {
                print("Failed to parse the date and time. Input was: \(combinedDateTimeString)")
            }
        }

        
        self.present(vc, animated: true)
        
    }
    @IBAction func actionCalenderType(_ sender: UIButton) {
    
        
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - EventDataSource
extension ItineraryVC:EventDataSource,DayViewDelegate {

    func dayViewDidSelectEventView(_ eventView: CalendarKit.EventView) {
        print("dayViewDidSelectEventView")
        if selectDate == ""{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            selectDate = formatter.string(from: Date())
        }
        var text = eventView.textView.text ?? ""
        var title = ""
        var description = ""
        var time = ""
        
        // Split text by newline
        let lines = text.split(separator: "\n")
        
        // Extract title (first line)
        if lines.count > 0 {
            title = String(lines[0])
        }
        
        // Extract description (middle lines)
        if lines.count > 2 {
            description = lines[1..<lines.count-1].joined(separator: "\n")
        }
        
        // Extract time (last line)
        if lines.count > 1 {
            // Extract the time range (last line)
            let timeRange = String(lines[lines.count - 1])
            print(timeRange)
            
            // Split the time range by " - " (assuming format is "start time - end time")
            let timeParts = timeRange.split(separator: "-")
            
            // Check if the time range is valid (contains start and end times)
            if timeParts.count == 2 {
                let startTime = timeParts[0].trimmingCharacters(in: .whitespaces)
                let endTime = timeParts[1].trimmingCharacters(in: .whitespaces)
                self.startTime = startTime
                self.endTime = endTime
            }
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateItineraryVC") as! CreateItineraryVC
        vc.modalPresentationStyle = .overFullScreen
        vc.arrAppliedGigs = self.arrAppliedGigs
        vc.itineraryData = ItineraryData(title: title, description: description, date: selectDate, startTime: startTime,endTime: endTime)
        self.present(vc, animated: true)
    }
    
    func dayViewDidLongPressEventView(_ eventView: CalendarKit.EventView) {
        print("dayViewDidLongPressEventView")
    }
    
    func dayView(dayView: CalendarKit.DayView, didTapTimelineAt date: Date) {
        print("didTapTimelineAt",date)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateItineraryVC") as! CreateItineraryVC
        vc.modalPresentationStyle = .overFullScreen
        vc.arrAppliedGigs = self.arrAppliedGigs
        vc.callBack = { [weak self] gigId,title, date, time, description,endTime in
            let combinedDateTimeString = "\(date) \(time)"
            let endTimeDateCombined = "\(date) \(endTime)"
            // Create a DateFormatter to parse the combined string
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm a" // Adjust to input format (e.g., no leading zero in hours)
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
            
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Adjust if your input is in UTC or another timezone
            
            // Convert the combined string to a Date object
            if let dateTime = dateFormatter.date(from: combinedDateTimeString) {
                // Create an ISO8601 DateFormatter
                let isoDateFormatter = ISO8601DateFormatter()
                isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure output is in UTC
                
                // Format the Date object to an ISO8601 string
                let isoDateString = isoDateFormatter.string(from: dateTime)
                
                print("Formatted ISO8601 Date String: \(isoDateString)")
                // You can now use isoDateString as needed
                if let dateEndTime = dateFormatter.date(from: endTimeDateCombined) {
                    // Create an ISO8601 DateFormatter
                    let isoDateFormatter = ISO8601DateFormatter()
                    isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure output is in UTC
                    
                    // Format the Date object to an ISO8601 string
                    let isoDateString2 = isoDateFormatter.string(from: dateEndTime)
                    
                    print("Formatted ISO8601 Date String: \(isoDateString)")
//                    self?.viewModel.AddItitneraryApi(gigId: gigId, title: title, endTime: isoDateString2, description: description, location: "", reminderTime: isoDateString) {
//                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
//                            self?.getItineraryApi()
//                        }
//                       
//                    }
                } else {
                    print("Failed to parse the date and time. Input was: \(combinedDateTimeString)")
                }
                
            } else {
                print("Failed to parse the date and time. Input was: \(combinedDateTimeString)")
            }
        }

        
        self.present(vc, animated: true)
      
    }
    
    func dayView(dayView: CalendarKit.DayView, didLongPressTimelineAt date: Date) {
        print("didLongPressTimelineAt")
    }
    
    func dayViewDidBeginDragging(dayView: CalendarKit.DayView) {
        print("dayViewDidBeginDragging")
    }
    
    func dayViewDidTransitionCancel(dayView: CalendarKit.DayView) {
        print("dayViewDidTransitionCancel")
    }
    
    func dayView(dayView: CalendarKit.DayView, willMoveTo date: Date) {
        updateMonthYearLabel(for: date)
    }

    func dayView(dayView: CalendarKit.DayView, didMoveTo date: Date) {
        updateMonthYearLabel(for: date)
    }

    // Example check for subviews or custom content property
  
    private func updateMonthYearLabel(for date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectDate = dateFormatter.string(from: date)
        lblMonthYear.text = formatter.string(from: date)
    }

    func dayView(dayView: CalendarKit.DayView, didUpdate event: any CalendarKit.EventDescriptor) {
        print("didUpdate")
    }
    

}


// MARK: - Popup
extension ItineraryVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
public extension Date {
    func dateOnly(calendar: Calendar) -> Date {
        calendar.startOfDay(for: self)
    }
}
