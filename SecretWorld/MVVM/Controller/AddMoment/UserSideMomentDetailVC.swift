//
//  UserSideMomentDetailVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 09/04/25.
//

import UIKit
import MapboxMaps
import Solar
import MapKit
import CoreLocation

class UserSideMomentDetailVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var viewUserDetails: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblrating: UILabel!
    @IBOutlet var lblUserNAme: UILabel!
    @IBOutlet var lblLocationAwayFromYou: UILabel!
    @IBOutlet var btnCastProfile: UIButton!
    @IBOutlet var btnMessage: UIButton!
    @IBOutlet var viewGotoMAp: UIView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewMap: MapView!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var heightTblVwTaskList: NSLayoutConstraint!
    @IBOutlet var tblVwTaskList: UITableView!
    
    //MARK: - variables
    var withFiveMinuteStartTime = ""
    var timers: [IndexPath: Timer] = [:] // Store timers for each cell
    var taskTimer: TaskTimer?
    private var solar: Solar?
    var viewModel = MomentsVM()
    var arrTasks = [MomentTask]()
    var momentId:String?
    var MomentData:MomentData?
    var lat:Double?
    var long:Double?
    var callBack:(()->())?
    var momentUserDetail:userDetailzz?
    var appliedOrNot:Bool?
    var arrPointAnnotaion: [PointAnnotation] = []
    var pointAnnotationManagerPop: PointAnnotationManager!
    var placeName:String?
    var paymentMethod:String?
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        taskTimer?.stopTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tblVwTaskList.layoutIfNeeded()
        heightTblVwTaskList.constant = tblVwTaskList.contentSize.height
    }
    
    private func uiSet(){
        let tapGestureUserDetail = UITapGestureRecognizer(target: self, action: #selector(self.userDetailTapped(_:)))
        self.viewUserDetails.addGestureRecognizer(tapGestureUserDetail)

        handleMapView()
        let nib = UINib(nibName: "UserSideMomentTaskListTVC", bundle: nil)
        tblVwTaskList.register(nib, forCellReuseIdentifier: "UserSideMomentTaskListTVC")
        viewMap.translatesAutoresizingMaskIntoConstraints = false
        tblVwTaskList.translatesAutoresizingMaskIntoConstraints = false
        tblVwTaskList.estimatedRowHeight = 400
        tblVwTaskList.rowHeight = UITableView.automaticDimension
        getMomentApi()
    }
    @objc func userDetailTapped(_ sender: UITapGestureRecognizer){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewVC") as! ProfileViewVC
        vc.isComingChat = true
        vc.id = MomentData?.userId?.id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)

    }
    //MARK: - API Call
    func getMomentApi() {
        viewModel.getMomentDetails(id: momentId ?? "") { data in
            self.MomentData = data
            self.lblrating.text = "\(data?.ownerReview ?? 0.0)"
            self.lblUserNAme.text = data?.userId?.name ?? "".capitalized
            self.imgVwUser.imageLoad(imageUrl: data?.userId?.profilePhoto ?? "")
            self.momentUserDetail = data?.userId
            self.placeName = data?.place ?? ""
            self.lat = data?.lat ?? 0
            self.long = data?.long ?? 0
            self.lblTitle.text = data?.title ?? ""
            if data?.location?.exactLocation == false{
                self.lblLocation.text = data?.place ?? ""
                self.getDistanceText(markerLat: data?.lat ?? 0, markerLong: data?.long ?? 0) { distanceText in
                    if let text = distanceText {
                        self.lblLocationAwayFromYou.text = text
                    }
                }
                
            }else{
                self.lblLocationAwayFromYou.text = ""
                self.getCityName(latitude: data?.lat ?? 0, longitude: data?.long ?? 0) { city in
                    if let city = city {
                        print("City: \(city)")
                        self.lblLocation.text = city
                    } else {
                        print("City not found.")
                        self.lblLocation.text = "N/A"
                    }
                }
                
            }
            self.lblDate.text = self.formatDateString(data?.startDate ?? "")
            self.lblTime.text = self.formatTimeString(data?.startDate ?? "")
            self.downloadAnnotationImage(for: CLLocationCoordinate2D(latitude: data?.lat  ?? 0, longitude: data?.long ?? 0), exactLocation: data?.location?.exactLocation ?? false)
            self.arrTasks = data?.tasks ?? []
            /// ✅ Check if any task is applied
            if self.arrTasks.contains(where: { $0.taskStatus != 0
            }) {
                self.appliedOrNot = true
            }else{
                self.appliedOrNot = false
            }
            for task in data?.tasks ?? [] {
                switch task.taskStatus {
                case 0, 1, 3:
                    self.btnMessage.isEnabled = false
                    self.btnMessage.alpha = 0.5
                default:
                    self.btnMessage.isEnabled = true
                    self.btnMessage.alpha = 1.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.tblVwTaskList.reloadData()
                self.tblVwTaskList.layoutIfNeeded()
                self.heightTblVwTaskList.constant = self.tblVwTaskList.contentSize.height
                self.view.layoutIfNeeded()
            }
            self.updateTableViewHeight()
        }
    }
    func convertDurationToMinutes(_ duration: String) -> Int? {
        var totalMinutes = 0
        let pattern = #"(?:(\d+)\s*h(?:ours?)?)?\s*(?:(\d+)\s*m(?:in(?:utes?)?)?)?"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        guard let regex = regex else { return nil }
        
        let range = NSRange(duration.startIndex..., in: duration)
        if let match = regex.firstMatch(in: duration, options: [], range: range) {
            let hourRange = Range(match.range(at: 1), in: duration)
            let minuteRange = Range(match.range(at: 2), in: duration)
            
            let hours = hourRange != nil ? Int(duration[hourRange!]) ?? 0 : 0
            let minutes = minuteRange != nil ? Int(duration[minuteRange!]) ?? 0 : 0
            
            totalMinutes = hours * 60 + minutes
            return totalMinutes > 0 ? totalMinutes : nil
        }
        
        return nil
    }
    
    
    
    func getCityName(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                let city = placemark.locality // City name
                completion(city)
            } else {
                completion(nil)
            }
        }
    }
    
    @objc func mapTapped(_ sender: UITapGestureRecognizer) {
        getLatLongs(lat: lat ?? 0, long: long ?? 0, placeName: placeName ?? "")
    }
    func getDistanceText(markerLat: Double, markerLong: Double, completion: @escaping (String?) -> Void) {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        guard CLLocationManager.locationServicesEnabled(),
              let currentLocation = locationManager.location else {
            completion(nil)
            return
        }
        
        let markerLocation = CLLocation(latitude: markerLat, longitude: markerLong)
        let distanceInMeters = currentLocation.distance(from: markerLocation)
        
        let distanceText: String
        if distanceInMeters < 1000 {
            distanceText = String(format: "%.0f meters away from you", distanceInMeters)
        } else {
            let distanceInKm = distanceInMeters / 1000.0
            distanceText = String(format: "%.1f km away from you", distanceInKm)
        }
        
        completion(distanceText)
    }
    
    func getLatLongs(lat: Double, long: Double, placeName: String) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    
    func updateTableViewHeight() {
        tblVwTaskList.reloadData()
        tblVwTaskList.layoutIfNeeded()
        heightTblVwTaskList.constant = tblVwTaskList.contentSize.height
        view.layoutIfNeeded()
    }
    
    private func formatDateString(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dMMMMYYYY" // e.g., 4July2025
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
    private func formatTimeString(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX") // Recommended for fixed formats
        
        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a" // e.g., 4:30 PM
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            outputFormatter.timeZone = TimeZone.current // or set explicitly if needed
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
    
    private func handleMapView(){
        if let solar = Solar(coordinate: CLLocationCoordinate2D(latitude: lat ?? 0, longitude: long ?? 0)) {
            self.solar = solar
            let isDaytime = solar.isDaytime
            print(isDaytime ? "It's day time!" : "It's night time!")
            if isDaytime{
                if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                    viewMap.mapboxMap.loadStyleURI(StyleURI(url: styleURL) ?? .light)
                }
                
            }else{
                if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                    viewMap.mapboxMap.loadStyleURI(StyleURI(url: styleURL) ?? .light)
                }
            }
        }
        viewMap.ornaments.scaleBarView.isHidden = true
        viewMap.ornaments.logoView.isHidden = true
        viewMap.ornaments.attributionButton.isHidden = true
        
        
    }
    func downloadAnnotationImage(for coordinate: CLLocationCoordinate2D,exactLocation:Bool) {
        let centerCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        if !exactLocation{
            let image = self.combineImagesPopUp(overlayImage: UIImage(named: "redMarker") ?? UIImage(), overlaySize: CGSize(width: 24, height: 30))
            
            let pointAnnotation = self.createPointAnnotation(for: centerCoordinate, withImage: image ?? UIImage())
            self.updatePopUpAnnotations(with: pointAnnotation)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.mapTapped(_:)))
            self.viewGotoMAp.addGestureRecognizer(tapGesture)

            // Set camera to zoom to the location of the annotation
            self.viewMap.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: lat ?? 0, longitude: long ?? 0),zoom: 12,bearing: 0,pitch: 0))
            
        }else{
            self.viewMap.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: lat ?? 0, longitude: long ?? 0),zoom: 9,bearing: 0,pitch: 0))
            
        }
        
    }
    
    private func updatePopUpAnnotations(with pointAnnotation: PointAnnotation) {
        
        arrPointAnnotaion.append(pointAnnotation)
        
        
        DispatchQueue.main.async {
            self.pointAnnotationManagerPop = self.viewMap.annotations.makePointAnnotationManager()
            self.pointAnnotationManagerPop?.annotations = self.arrPointAnnotaion
        }
    }
    func createPointAnnotation(for coordinate: CLLocationCoordinate2D, withImage image: UIImage) -> PointAnnotation {
        var annotation = PointAnnotation(coordinate: coordinate)
        annotation.image = .init(image: image, name: "redMarker") // Ensure unique name
        return annotation
    }
    func combineImagesPopUp(
        overlayImage: UIImage,
        overlaySize: CGSize
    ) -> UIImage? {
        // Set up adjusted base size
        let adjustedBaseSize = CGSize(width: overlaySize.width, height: overlaySize.height)
        
        // Start graphics context
        UIGraphicsBeginImageContextWithOptions(adjustedBaseSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to create graphics context.")
            return nil
        }
        
        // Define overlay position
        let overlayOrigin = CGPoint(x: 0, y: 0)
        let overlayRect = CGRect(origin: overlayOrigin, size: overlaySize)
        
        overlayImage.draw(in: overlayRect)
        context.restoreGState()
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
    }
    
    //MARK: - IBAction
    @IBAction func actionCastProfile(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CastProfilesVC") as! CastProfilesVC
        vc.momentId = MomentData?._id ?? ""
        //        vc.callBack = {
        //            self.uiSet()
        //        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func actionBAck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.callBack?()
        
    }
    @IBAction func actionMessage(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
        vc.typeName = MomentData?.title ?? ""
        vc.receiverId = MomentData?.userId?.id ?? ""
        vc.typeId = MomentData?._id ?? ""
        vc.chatType = "task"
        vc.isMoment = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: -UITableViewDelegate
extension UserSideMomentDetailVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrTasks.count > 0 {
            return arrTasks.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSideMomentTaskListTVC", for: indexPath) as! UserSideMomentTaskListTVC
        cell.momentTask = arrTasks[indexPath.row]
        cell.uiSet()
        let task = arrTasks[indexPath.row]
        let accepted = task.personAccepted ?? 0
        let needed = task.personNeeded ?? 0
        cell.lblRole.text = task.role ?? ""
        cell.lblRoleInstruction.text = task.roleInstruction ?? ""
        cell.lblSpots.text = "Spots (\(accepted)/\(task.personNeeded ?? 0))"
        
        if task.taskPaymentMethod == 1{
            //barter
            cell.viewOfferBarter.isHidden = false
            cell.viewAmount.isHidden = true
        }else  if task.taskPaymentMethod == 2{
            //barter+money
            cell.viewOfferBarter.isHidden = false
            cell.viewAmount.isHidden = false
        }else{
            //0 for money
            cell.viewOfferBarter.isHidden = true
            cell.viewAmount.isHidden = false
        }

        // Avoid division by zero
        if needed > 0 {
            cell.progressView.progress = Float(accepted) / Float(needed)
        } else {
            cell.progressView.progress = 0.0
        }
        let price = task.perPersonAmount ?? 0
        let taskPaymentMethodtext:String?
        if task.taskPaymentMethod == 0{
            taskPaymentMethodtext = "Hourly"
        }else{
            taskPaymentMethodtext = "Fixed"
        }
        cell.lblAmount.text = "\(price) (\(taskPaymentMethodtext ?? ""))"
        cell.lblTaskCount.text = "Task \(indexPath.row + 1)"
        
        // taskStatus 0 can apply, 1 applied, 2 accepted, 3 rejected 4 ongoing 5 review
        switch task.taskStatus {
        case 1:
            cell.btnApply.backgroundColor = .app
            cell.btnApply.setTitle("Applied", for: .normal)
            cell.btnApply.alpha = 0.5
            cell.btnApply.isEnabled = false
            cell.lblDuration.text = task.taskDuration ?? ""
            cell.lblDuration.textColor = UIColor(hex: "#363636")
            
        case 2:
            cell.btnApply.backgroundColor = .app
            cell.btnApply.setTitle("Accepted", for: .normal)
            cell.btnApply.alpha = 0.5
            cell.btnApply.isEnabled = false
            cell.lblDuration.text = task.taskDuration ?? ""
            cell.lblDuration.textColor = UIColor(hex: "#363636")
            
        case 3:
            cell.btnApply.backgroundColor = UIColor(hex: "#898989")
            cell.btnApply.setTitle("Rejected", for: .normal)
            cell.btnApply.alpha = 0.5
            cell.btnApply.isEnabled = false
            cell.lblDuration.text = task.taskDuration ?? ""
            cell.lblDuration.textColor = UIColor(hex: "#363636")
            
        case 4:
            cell.btnApply.addTarget(self, action: #selector(actionApply), for: .touchUpInside)
            cell.btnApply.tag = indexPath.row
            cell.btnApply.backgroundColor = UIColor(hex: "#FFB21E")
            cell.btnApply.setTitle("Ongoing", for: .normal)
            cell.btnApply.alpha = 0.5
            cell.btnApply.isEnabled = false
            if self.MomentData?.type == "now"{
                let durationInSeconds = getDurationInSeconds(from: task.taskDuration ?? "")
                let startDateStr = MomentData?.acceptAt ?? ""
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                
                if let startDate = dateFormatter.date(from: startDateStr) {
                    // Removed the 5-minute buffer
                    let endDate = startDate.addingTimeInterval(TimeInterval(durationInSeconds))
                    
                    let taskTimer = TaskTimer(startDate: startDate, endDate: endDate) { [weak cell] remainingTime in
                        let totalDuration = endDate.timeIntervalSince(startDate)
                        let remainingTimeInterval = endDate.timeIntervalSince(Date())
                        let elapsedPercentage = min(1, max(0, 1 - (remainingTimeInterval / totalDuration)))
                        
                        DispatchQueue.main.async {
                            cell?.updateCustomProgressBar(progress: elapsedPercentage)
                            cell?.lblDuration.textColor = UIColor(hex: "#FF8205")
                            if cell?.lblDuration.text != remainingTime {
                                cell?.lblDuration.text = remainingTime
                            }
                        }
                    }
                    
                    if Date() < startDate {
                        cell.lblDuration.text = task.taskDuration ?? ""
                    }
                    
                    taskTimer.startTimer()
                }
            }else{
                let durationInSeconds = getDurationInSeconds(from: task.taskDuration ?? "")
                let startDateStr = MomentData?.startDate ?? ""
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                
                if let startDate = dateFormatter.date(from: startDateStr) {
                    let bufferDelay: TimeInterval = 300 // 5-minute buffer
                    let actualStartDate = startDate.addingTimeInterval(bufferDelay)
                    let endDate = actualStartDate.addingTimeInterval(TimeInterval(durationInSeconds))
                    
                    let taskTimer = TaskTimer(startDate: actualStartDate, endDate: endDate) { [weak cell] remainingTime in
                        let totalDuration = endDate.timeIntervalSince(actualStartDate)
                        let remainingTimeInterval = endDate.timeIntervalSince(Date())
                        let elapsedPercentage = min(1, max(0, 1 - (remainingTimeInterval / totalDuration)))
                        
                        DispatchQueue.main.async {
                            cell?.updateCustomProgressBar(progress: elapsedPercentage)
                            cell?.lblDuration.textColor = UIColor(hex: "#FF8205")
                            if cell?.lblDuration.text != remainingTime {
                                cell?.lblDuration.text = remainingTime
                            }
                        }
                    }
                    
                    if Date() < actualStartDate {
                        cell.lblDuration.text = task.taskDuration ?? ""
                    }
                    
                    taskTimer.startTimer()
                }
            }
            
        case 5:
            
            cell.btnApply.addTarget(self, action: #selector(actionAddReview), for: .touchUpInside)
            cell.btnApply.tag = indexPath.row
            
            cell.viewDurationProgress.backgroundColor = UIColor(hex: "#ACFFA5")
            cell.btnApply.backgroundColor = UIColor(hex: "#FFB21E")
            cell.btnApply.setTitle("Review", for: .normal)
            cell.btnApply.alpha = 1.0
            cell.btnApply.isEnabled = true
            cell.lblDuration.text = "Completed"
            cell.lblDuration.textColor = UIColor(hex: "#FF8205")
        default:
            cell.lblDuration.text = task.taskDuration ?? ""
            cell.lblDuration.textColor = UIColor(hex: "#363636")
            
            cell.btnApply.backgroundColor = .app
            if accepted >= needed{
                cell.btnApply.setTitle("Spots already filled", for: .normal)
                cell.btnApply.isEnabled = false
                cell.btnApply.alpha = 0.5
            }else{
                cell.btnApply.addTarget(self, action: #selector(actionApply), for: .touchUpInside)
                cell.btnApply.tag = indexPath.row
                
                cell.btnApply.setTitle("Apply", for: .normal)
                if appliedOrNot == true{
                    cell.btnApply.isEnabled = false
                    cell.btnApply.alpha = 0.5
                }else{
                    cell.btnApply.isEnabled = true
                    cell.btnApply.alpha = 1.0
                    
                }
                
            }
        }
        
        
        
        return cell
    }
    func getDurationInSeconds(from duration: String) -> Int {
        let lowercased = duration.lowercased()
        
        var totalSeconds = 0
        
        // Extract hours
        if let hourRange = lowercased.range(of: #"(\d+)\s*hr"#, options: .regularExpression) {
            let hourString = lowercased[hourRange]
            if let hour = Int(hourString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                totalSeconds += hour * 3600
            }
        }
        
        // Extract minutes
        if let minRange = lowercased.range(of: #"(\d+)\s*min"#, options: .regularExpression) {
            let minString = lowercased[minRange]
            if let min = Int(minString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                totalSeconds += min * 60
            }
        }
        
        return totalSeconds
    }
    
    @objc func actionAddReview(sender:UIButton){
        print("reviewclicked")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupReviewVC") as! PopupReviewVC
        vc.isComingPopUp = true
        vc.MomentData = MomentData
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = { message in
            let vcSuccess = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
            vcSuccess.isSelect = 10
            vcSuccess.message = message
            vcSuccess.callBack = {[weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.uiSet()
                }
                
            }
            vcSuccess.modalPresentationStyle = .overFullScreen
            self.present(vcSuccess, animated: true)
            
        }
        self.present(vc, animated: true)
    }
    @objc func actionApply(sender:UIButton){
        print("applyclicked")
        // Input formatter for ISO 8601 format
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Because the "Z" indicates UTC
        
        // Output in 12-hour format with AM/PM
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone.current // Local time zone
        
        if let startDateTime = inputFormatter.date(from: MomentData?.startDate ?? "") {
            let newTime = Calendar.current.date(byAdding: .minute, value: 5, to: startDateTime)!
            let newTimeString = outputFormatter.string(from: newTime)
            print("Start Time + 5 minutes: \(newTimeString)")
            withFiveMinuteStartTime = newTimeString
        } else {
            print("Failed to parse start time.")
        }
        
        
        DispatchQueue.main.async {
            //            if self.MomentData?.paymentMethod == 0{
            //                //online
            //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
            //                vc.isSelect = 10
            //                vc.message = "If you are hired, please be punctual and make sure to reach at the task location on time.Your tasks will start 5 minutes after the scheduled time, i.e.,\(self.withFiveMinuteStartTime)"
            //                vc.callBack = {[weak self] in
            //                    guard let self = self else { return }
            //                    DispatchQueue.main.async {
            //                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
            //                        vc.isSelect = 10
            //                        vc.message = "After task completion, you can raise a dispute within 24 hours. If no dispute is raised, the payment will be processed after 24-hours window."
            //                        vc.callBack = {[weak self] in
            //                            guard let self = self else { return }
            //                            DispatchQueue.main.async {
            //                                let UserDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
            //                                UserDetailVC.modalPresentationStyle = .overFullScreen
            //                                UserDetailVC.isComing = 0
            //                                UserDetailVC.MomentData = self.MomentData
            //                                UserDetailVC.momentTaskId = self.arrTasks[sender.tag].id ?? ""
            //                                UserDetailVC.callBack = { [weak self] message in
            //                                    guard let self = self else { return }
            //                                    
            //                                    let vcSuccess = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
            //                                    vcSuccess.isSelect = 10
            //                                    vcSuccess.message = message
            //                                    vcSuccess.callBack = {[weak self] in
            //                                        guard let self = self else { return }
            //                                        self.uiSet()
            //                                    }
            //                                    vcSuccess.modalPresentationStyle = .overFullScreen
            //                                    self.navigationController?.present(vcSuccess, animated: true)
            //                                    
            //                                }
            //                                self.navigationController?.present(UserDetailVC, animated: true)
            //                            }
            //                        }
            //                        vc.modalPresentationStyle = .overFullScreen
            //                        self.navigationController?.present(vc, animated: true)
            //                    }
            //                }
            //                vc.modalPresentationStyle = .overFullScreen
            //                self.navigationController?.present(vc, animated: true)
            //                
            //                
            //            }else{
            //cash
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
            vc.isSelect = 10
            if self.MomentData?.type == "now"{
                vc.message = "Your task will start 9 minutes after you are accepted."
            }else{
                vc.message = "If you are hired, please be punctual and make sure to reach at the moment location on time.Your tasks will start 5 minutes after the scheduled time, i.e.,\(self.withFiveMinuteStartTime)"
            }
            
            vc.callBack = {[weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    let UserDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
                    UserDetailVC.modalPresentationStyle = .overFullScreen
                    UserDetailVC.isComing = 0
                    UserDetailVC.MomentData = self.MomentData
                    UserDetailVC.momentTaskId = self.arrTasks[sender.tag].id ?? ""
                    UserDetailVC.callBack = { [weak self] message in
                        guard let self = self else { return }
                        
                        let vcSuccess = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                        vcSuccess.isSelect = 10
                        vcSuccess.message = message
                        vcSuccess.callBack = {[weak self] in
                            guard let self = self else { return }
                            self.uiSet()
                        }
                        vcSuccess.modalPresentationStyle = .overFullScreen
                        self.navigationController?.present(vcSuccess, animated: true)
                        
                    }
                    self.navigationController?.present(UserDetailVC, animated: true)
                }
                
                
            }
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true)
            
            
        }
        //}
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - Handle TaskTimer with Start and End Time
class TaskTimer {
    private var timer: Timer?
    private var startDate: Date
    private var endDate: Date
    private var updateLabel: ((String) -> Void)?
    private var lastDisplayedTime: String?
    
    init(startDate: Date, endDate: Date, updateLabel: @escaping (String) -> Void) {
        self.startDate = startDate
        self.endDate = endDate
        self.updateLabel = updateLabel
    }
    
    func startTimer() {
        let now = Date()
        if now < startDate {
            let delay = startDate.timeIntervalSince(now)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.beginTimer()
            }
        } else {
            beginTimer()
        }
    }
    
    private func beginTimer() {
        updateTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc private func updateTimer() {
        let now = Date()
        
        if now >= endDate {
            timer?.invalidate()
            updateLabel?("Completed")
            return
        }
        
        let remainingSeconds = Int(endDate.timeIntervalSince(now))
        
        if remainingSeconds < 60 {
            let formattedTime = "\(remainingSeconds) sec Remaining"
            if formattedTime != lastDisplayedTime {
                lastDisplayedTime = formattedTime
                updateLabel?(formattedTime)
            }
        } else {
            let hours = remainingSeconds / 3600
            let minutes = (remainingSeconds % 3600) / 60
            
            var timeParts: [String] = []
            if hours > 0 { timeParts.append("\(hours) hr") }
            if minutes > 0 { timeParts.append("\(minutes) min") }
            
            let formattedTime = timeParts.joined(separator: " ") + " Remaining"
            if formattedTime != lastDisplayedTime {
                lastDisplayedTime = formattedTime
                updateLabel?(formattedTime)
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopTimer()
    }
}
