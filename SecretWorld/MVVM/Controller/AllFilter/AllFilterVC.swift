//
//  AllFilterVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 09/01/25.
//

import UIKit



class AllFilterVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblVwFilter: UITableView!
    var arrHeader = [FilterHeaderData]()
    
    var type = 0
    var isSelect1 = false
    var isSelect2 = false
    var isSelect3 = false
    var isSelect4 = false
    var isSelect5 = false
    var isSelect6 = false
    
    var selectTaskType = [Int]()
    var selectDistance = [Int]()
    var selectTaskDuration = [Int]()
    var selectPayoutRange = [Int]()
    var selectUrgency = [Int]()
    var selectSpots = [Int]()
    
    var minDistance = 0.0
    var maxDistance = 1000000.0
    var callBack:((_ radius:Double?)->())?
    var distance = 0.0
    var isSelectDistance = true
    
    var selectCategory = [Int]()
    var selectDateTime = [Int]()
    var selectAvailability = [Int]()
    var selectRatingReview = [Int]()
    
    var isSelectCategory = false
    var isSelectDateTime = false
    var isSelectAvailbility = false
    var isSelectReviewRating = false
    
    var selectBusinessCategory = [Int]()
    var selectDealsOffer = [Int]()
    var selectHours = [Int]()
    var selectCustomerRating = [Int]()
    var selectSpecialFeature = [Int]()
    
    var isSelectBusinessCategory = false
    var isSelectDealsOffer = false
    var isSelectHours = false
    var isSelectCustomerRating = false
    var isSelectSpecialFeature = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupTableView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if (Store.isSelectGigFilter ?? false){
            
            
            
            selectTaskType = Store.filterData?["roleType"] as? [Int] ?? []
            selectTaskDuration = Store.filterData?["taskDuration"] as? [Int] ?? []
            selectPayoutRange = Store.filterData?["payoutRange"] as? [Int] ?? []
            selectUrgency = Store.filterData?["urgencyType"] as? [Int] ?? []
            selectSpots = Store.filterData?["momentType"] as? [Int] ?? []
            
            if selectTaskType.count > 0{
                isSelect1 = true
            }else{
                isSelect1 = false
            }
            if selectTaskDuration.count > 0{
                isSelect2 = true
            }else{
                isSelect2 = false
            }
            if selectPayoutRange.count > 0{
                isSelect3 = true
            }else{
                isSelect3 = false
            }
            if selectUrgency.count > 0{
                isSelect4 = true
            }else{
                isSelect4 = false
            }
            if selectSpots.count > 0{
                isSelect5 = true
            }else{
                isSelect5 = false
            }
            
        }else if (Store.isSelectPopUpFilter ?? false){
            selectCategory = Store.filterDataPopUp?["categoryType"] as? [Int] ?? []
            selectDateTime = Store.filterDataPopUp?["datetime"] as? [Int] ?? []
            selectAvailability = Store.filterDataPopUp?["availability"] as? [Int] ?? []
            selectRatingReview = Store.filterDataPopUp?["popupRating"] as? [Int] ?? []
            
            if selectCategory.count > 0{
                isSelectCategory = true
            }else{
                isSelectCategory = false
            }
            if selectDateTime.count > 0{
                isSelectDateTime = true
            }else{
                isSelectDateTime = false
            }
            if selectAvailability.count > 0{
                isSelectAvailbility = true
            }else{
                isSelectAvailbility = false
            }
            if selectRatingReview.count > 0{
                isSelectReviewRating = true
            }else{
                isSelectReviewRating = false
            }
           
        }else{
            selectBusinessCategory = Store.filterDataBusiness?["category"] as? [Int] ?? []
            selectDealsOffer = Store.filterDataBusiness?["deals"] as? [Int] ?? []
            selectHours = Store.filterDataBusiness?["taskHours"] as? [Int] ?? []
            selectCustomerRating = Store.filterDataBusiness?["businessRating"] as? [Int] ?? []
            selectSpecialFeature = Store.filterDataBusiness?["specialFeatures"] as? [Int] ?? []
            if selectBusinessCategory.count > 0{
                isSelectBusinessCategory = true
            }else{
                isSelectBusinessCategory = false
            }
            
            if selectDealsOffer.count > 0{
                isSelectDealsOffer = true
            }else{
                isSelectDealsOffer = false
            }
            
            if selectHours.count > 0{
                isSelectHours = true
            }else{
                isSelectHours = false
            }
            
            if selectCustomerRating.count > 0{
                isSelectCustomerRating = true
            }else{
                isSelectCustomerRating = false
            }
            
            if selectSpecialFeature.count > 0{
                isSelectSpecialFeature = true
            }else{
                isSelectSpecialFeature = false
            }
        }
       
    }
    
    func convertMilesToMeters(miles: Double) -> Double {
        return miles * 1609.344
    }
    func convertMeterToMiles(miles: Double) -> Double {
        return miles / 1609.344
    }
    @IBAction func actionCross(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func actionResetAll(_ sender: UIButton) {
        if self.type == 1{
            Store.filterData = [:]
            Store.taskMiles = []
            Store.isSelectGigFilter = false
        }else if type == 2{
            Store.filterDataPopUp = [:]
            Store.isSelectPopUpFilter = false
        }else{
            Store.filterDataBusiness = [:]
            Store.isSelectBusinessFilter = false
        }
        tblVwFilter.reloadData()
        callBack?(maxDistance)
        dismiss(animated: true)
    }
    
    @IBAction func actionApplyFilter(_ sender: UIButton) {
        if type == 1{
            Store.taskMiles = selectDistance
            if isSelectMomentDistance{
                if momentMiles == 15{
                    minDistance = 0
                    maxDistance = 1000000
                }else{
                    minDistance = 0
                    maxDistance = convertMilesToMeters(miles: momentMiles)
                }
            }else{
                minDistance = 0
                maxDistance = 8046.72
            }
            let filterMapping: [(flag: Bool, key: String, value: Any)] = [
                (isSelect1, "roleType", selectTaskType),
                (isSelect2, "minDistanceInMeters", minDistance),
                (isSelect2, "maxDistanceInMeters", maxDistance),
                (isSelect3, "taskDuration", selectTaskDuration),
                (isSelect4, "payoutRange", selectPayoutRange),
                (isSelect5, "urgencyType", selectUrgency),
                (isSelect6, "momentType", selectSpots)
            ]
            
          
           
            for (flag, key, value) in filterMapping {
                if flag {
                    Store.filterData?[key] = value
                    isSelectDistance = false
                }
                if isSelectDistance == true{
                    Store.filterData = ["minDistanceInMeters":minDistance,"maxDistanceInMeters":maxDistance]
                }
            }
            
            print(Store.filterData ?? [:])
            
            Store.isSelectGigFilter = true
        }else if type == 2{
            if isSelectPopUpDistance{
                if popUpMiles == 15{
                    minDistance = convertMilesToMeters(miles: popUpMiles)
                    maxDistance = 1000000
                }else{
                    minDistance = 0
                    maxDistance = convertMilesToMeters(miles: popUpMiles)
                }
            }else{
                minDistance = 0
                maxDistance = 8046.72
            }
         
            let filterMapping: [(flag: Bool, key: String, value: Any)] = [
                (isSelectCategory, "categoryType", selectCategory),
                (isSelectPopUpDistance, "minDistanceInMeters", minDistance),
                (isSelectPopUpDistance, "maxDistanceInMeters", maxDistance),
                (!isSelectPopUpDistance, "minDistanceInMeters", minDistance),
                (!isSelectPopUpDistance, "maxDistanceInMeters", maxDistance),
                (isSelectDateTime, "datetime", selectDateTime),
                (isSelectAvailbility, "availability", selectAvailability),
                (isSelectReviewRating, "popupRating", selectRatingReview)
            ]
           
           
            for (flag, key, value) in filterMapping {
                if flag {
                    Store.filterDataPopUp?[key] = value
                    isSelectDistance = false
                }
                if isSelectDistance == true{
                    Store.filterDataPopUp = ["minDistanceInMeters":minDistance,"maxDistanceInMeters":maxDistance]
                }
            }
            Store.isSelectPopUpFilter = true
            print(Store.filterDataPopUp ?? [:])
            
        }else{
            if isSelectBusinessDistance{
                if businessMiles == 15{
                    minDistance = convertMilesToMeters(miles: businessMiles)
                    maxDistance = 1000000
                }else{
                    minDistance = 0
                    maxDistance = convertMilesToMeters(miles: businessMiles)
                }
            }else{
                minDistance = 0
                maxDistance = 8046.72
            }
            let filterMapping: [(flag: Bool, key: String, value: Any)] = [
                (isSelectBusinessCategory, "category", selectBusinessCategory),
                (isSelectDealsOffer, "deals", selectDealsOffer),
                (isSelectBusinessDistance, "minDistanceInMeters", minDistance),
                (isSelectBusinessDistance, "maxDistanceInMeters", maxDistance),
                (!isSelectBusinessDistance, "minDistanceInMeters", minDistance),
                (!isSelectBusinessDistance, "maxDistanceInMeters", maxDistance),
                (isSelectHours, "taskHours", selectHours),
                (isSelectCustomerRating, "businessRating", selectCustomerRating),
                (isSelectSpecialFeature, "specialFeatures", selectSpecialFeature)
            ]
         
           
            for (flag, key, value) in filterMapping {
                if flag {
                    Store.filterDataBusiness?[key] = value
                    isSelectDistance = false
                }
                if isSelectDistance == true{
                    Store.filterDataBusiness = ["minDistanceInMeters":minDistance,"maxDistanceInMeters":maxDistance]
                }
            }
            Store.isSelectBusinessFilter = true
            print(Store.filterDataBusiness ?? [:])
        }
        dismiss(animated: true)
        callBack?(distance)
    }
    func extractFilterData(input: [String: Any?]) -> [String: [Int]] {
        var result: [String: [Int]] = [:]
        
        for (key, value) in input {
            if let arrayValue = value as? NSArray {
                // Convert NSArray elements to strings and store them in the result dictionary
                result[key] = arrayValue.map { ($0) as? Int ?? 0}
            }
        }
        
        return result
    }
    
    private func setupTableView() {
        if type == 1{
            self.lblTitle.text = "Find moment Near You"
            arrHeader.insert(FilterHeaderData(title: "Role type", img: "category"), at: 0)
            arrHeader.insert(FilterHeaderData(title: "Distance", img: "distance"), at: 1)
            arrHeader.insert(FilterHeaderData(title: "Task duration", img: "taskDuration"), at: 2)
            arrHeader.insert(FilterHeaderData(title: "Payout range", img: "payout"), at: 3)
            arrHeader.insert(FilterHeaderData(title: "Urgency", img: "urgency"), at: 4)
            arrHeader.insert(FilterHeaderData(title: "Moment type", img: "spots"), at: 5)
        }else if type == 2{
            self.lblTitle.text = "Find Popups Near You"
            arrHeader.insert(FilterHeaderData(title: "Distance", img: "distance"), at: 0)
            arrHeader.insert(FilterHeaderData(title: "Category", img: "category"), at: 1)
            
        }else{
            self.lblTitle.text = "Find Local Business"
            arrHeader.insert(FilterHeaderData(title: "Category", img: "category"), at: 0)
            arrHeader.insert(FilterHeaderData(title: "Offers", img: "dateTime"), at: 1)
            arrHeader.insert(FilterHeaderData(title: "Distance", img: "distance"), at: 2)
            arrHeader.insert(FilterHeaderData(title: "Hours", img: "hours"), at: 3)
            arrHeader.insert(FilterHeaderData(title: "Customer ratings", img: "customerRating"), at: 4)
          
        }
        
        tblVwFilter.estimatedRowHeight = 50
        tblVwFilter.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension AllFilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrHeader.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Dequeue the custom header cell
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderTVC") as? FilterHeaderTVC else {
            return nil
        }
        
        // Configure the header
        headerCell.lblHeader.text = arrHeader[section].title
        headerCell.imgVwHeader.image = UIImage(named: arrHeader[section].img ?? "")
        
        return headerCell.contentView
    }
    
    // Section Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 // Set your desired height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Each section has one row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // Adjust row height automatically
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == 1{
            switch indexPath.section {
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceTVC", for: indexPath) as? DistanceTVC else {
                    return UITableViewCell()
                }
                cell.customSlider.minimumValue = 0
                cell.customSlider.maximumValue = 15
                if (Store.isSelectGigFilter ?? false){
                    if Store.filterData?["maxDistanceInMeters"] as? Double ?? 0 == 1000000{
                        let distance = convertMeterToMiles(miles: Store.filterData?["maxDistanceInMeters"] as? Double ?? 0)
                        cell.customSlider.currentValue = Float(Int(distance))
                        cell.customSlider.thumbLabel.text = "15 miles"
                        momentMiles = distance
                    }else{
                        let distance = convertMeterToMiles(miles: Store.filterData?["maxDistanceInMeters"] as? Double ?? 0)
                        cell.customSlider.currentValue = Float(Int(distance))
                        cell.customSlider.thumbLabel.text = "\(Int(distance)) miles"
                        momentMiles = distance
                    }
                }else{
                    cell.customSlider.currentValue = 0
                    cell.customSlider.thumbLabel.text = "0 miles"
                }
                cell.customSlider.index = 1
                cell.customSlider.type = 1
                return cell
                
            case 0, 2, 3, 4, 5:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTVC", for: indexPath) as? SelectCategoryTVC else {
                    return UITableViewCell()
                }
                 cell.uiSet(for: indexPath.section, type: self.type)
                
                cell.callBack0 = { (taskType) in
                    if taskType.count > 0{
                        self.isSelect1 = true
                    }else{
                        self.isSelect1 = false
                    }
                    self.selectTaskType = taskType
                }
             
                cell.callBack2 = { (taskDuration) in
                    if taskDuration.count > 0{
                        self.isSelect3 = true
                    }else{
                        self.isSelect3 = false
                    }
                    self.selectTaskDuration = taskDuration
                }
                cell.callBack3 = { (payoutRange) in
                    if payoutRange.count > 0{
                        self.isSelect4 = true
                    }else{
                        self.isSelect4 = false
                    }
                    self.selectPayoutRange = payoutRange
                }
                cell.callBack4 = { (urgency) in
                    if urgency.count > 0{
                        self.isSelect5 = true
                    }else{
                        self.isSelect5 = false
                    }
                    self.selectUrgency = urgency
                }
                cell.callBack5 = { (spot) in
                    if spot.count > 0{
                        self.isSelect6 = true
                    }else{
                        self.isSelect6 = false
                    }
                    self.selectSpots = spot
                }
                return cell
                
            default:
                return UITableViewCell()
            }
        }else if type == 2{
            switch indexPath.section {
                
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceTVC", for: indexPath) as? DistanceTVC else {
                    return UITableViewCell()
                }
                cell.customSlider.minimumValue = 0
                cell.customSlider.maximumValue = 15
                if (Store.isSelectPopUpFilter ?? false){
                    if Store.filterDataPopUp?["maxDistanceInMeters"] as? Double ?? 0 == 1000000{
                        let distance = convertMeterToMiles(miles: Store.filterDataPopUp?["minDistanceInMeters"] as? Double ?? 0)
                        cell.customSlider.currentValue = Float(Int(distance))
                        cell.customSlider.thumbLabel.text = "\(Int(distance)) miles"
                        popUpMiles = distance
                    }else{
                        let distance = convertMeterToMiles(miles: Store.filterDataPopUp?["maxDistanceInMeters"] as? Double ?? 0)
                        cell.customSlider.currentValue = Float(Int(distance))
                        cell.customSlider.thumbLabel.text = "\(Int(distance)) miles"
                        popUpMiles = distance
                    }
                }else{
                    cell.customSlider.currentValue = 0
                    cell.customSlider.thumbLabel.text = "0 miles"
                }
                cell.customSlider.index = 1
                cell.customSlider.type = 2
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTVC", for: indexPath) as? SelectCategoryTVC else {
                    return UITableViewCell()
                }
                cell.type = self.type
                cell.uiSet(for: indexPath.section - 1, type: type) // Pass section offset
                cell.callBackCategory = { (category) in
                    print(category)
                    if category.count > 0{
                        self.isSelectCategory = true
                    }else{
                        self.isSelectCategory = false
                    }
                    self.selectCategory = category
                    print(self.selectCategory,self.isSelectCategory)
                }
                cell.callBackDateTime = { (dateTime) in
                    print(dateTime)
                    if dateTime.count > 0{
                        self.isSelectDateTime = true
                    }else{
                        self.isSelectDateTime = false
                    }
                    self.selectDateTime = dateTime
                }
                cell.callBackAvailability = { (availibility) in
                    print(availibility)
                    if availibility.count > 0{
                        self.isSelectAvailbility = true
                    }else{
                        self.isSelectAvailbility = false
                    }
                    self.selectAvailability = availibility
                }
                cell.callBackRatingReview = { (ratingReview) in
                    print(ratingReview)
                    if ratingReview.count > 0{
                        self.isSelectReviewRating = true
                    }else{
                        self.isSelectReviewRating = false
                    }
                    self.selectRatingReview = ratingReview
                }
                return cell
            
            default:
                return UITableViewCell()
            }
        }else{
            switch indexPath.section {
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceTVC", for: indexPath) as? DistanceTVC else {
                    return UITableViewCell()
                }
                cell.customSlider.minimumValue = 0
                cell.customSlider.maximumValue = 15
                cell.customSlider.index = 1
                cell.customSlider.type = 3
                if Store.filterDataBusiness?["maxDistanceInMeters"] as? Double ?? 0 == 1000000{
                    let distance = convertMeterToMiles(miles: Store.filterDataBusiness?["minDistanceInMeters"] as? Double ?? 0)
                    cell.customSlider.currentValue = Float(Int(distance))
                    cell.customSlider.thumbLabel.text = "\(Int(distance)) miles"
                    businessMiles = distance
                }else{
                    let distance = convertMeterToMiles(miles: Store.filterDataBusiness?["maxDistanceInMeters"] as? Double ?? 0)
                    cell.customSlider.currentValue = Float(Int(distance))
                    cell.customSlider.thumbLabel.text = "\(Int(distance)) miles"
                    businessMiles = distance
                }
                return cell
            case 0...1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTVC", for: indexPath) as? SelectCategoryTVC else {
                    return UITableViewCell()
                }
                cell.type = self.type
                cell.uiSet(for: indexPath.section, type: type)
                cell.callBackBusinessCategory = { (category) in
                    
                    if category.count > 0{
                        self.isSelectBusinessCategory = true
                    }else{
                        self.isSelectBusinessCategory = false
                    }
                    self.selectBusinessCategory = category
                }
                
                cell.callBackDealOffer = { (dealOffer) in
                    
                    if dealOffer.count > 0{
                        self.isSelectDealsOffer = true
                    }else{
                        self.isSelectDealsOffer = false
                    }
                    self.selectDealsOffer = dealOffer
                }
                
              
                
                return cell
            case 3...4:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTVC", for: indexPath) as? SelectCategoryTVC else {
                    return UITableViewCell()
                }
                cell.type = self.type
                cell.uiSet(for: indexPath.section - 1, type: type)
                cell.callBackHours = { (hours) in
                    
                    if hours.count > 0{
                        self.isSelectHours = true
                    }else{
                        self.isSelectHours = false
                    }
                    self.selectHours = hours
                }
                
                cell.callBackCustomerRating = { (customerRating) in
                    
                    if customerRating.count > 0{
                        self.isSelectCustomerRating = true
                    }else{
                        self.isSelectCustomerRating = false
                    }
                    self.selectCustomerRating = customerRating
                }
                
                cell.callBackSpeacialFeature = { (specialFeature) in
                    
                    if specialFeature.count > 0{
                        self.isSelectSpecialFeature = true
                    }else{
                        self.isSelectSpecialFeature = false
                    }
                    self.selectSpecialFeature = specialFeature
                }
                return cell
                
            default:
                return UITableViewCell()
            }
        }
        
    }
}

struct FilterHeaderData{
    var title:String?
    var img:String?
    init(title: String? = nil, img: String? = nil) {
        self.title = title
        self.img = img
    }
}
