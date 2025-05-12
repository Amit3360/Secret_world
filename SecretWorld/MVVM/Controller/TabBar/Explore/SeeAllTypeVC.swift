//
//  SeeAllTypeVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 14/02/25.
//

import UIKit

class SeeAllTypeVC: UIViewController {

    @IBOutlet weak var tblVwMoment: UITableView!
    @IBOutlet weak var tblVwTask: UITableView!
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collVwPopup: UICollectionView!
    @IBOutlet weak var collVwBusiness: UICollectionView!
    
    var arrData = [FilteredItem]()
    var arrSearchData = [HomeSearch]()
    var isSelect = 1
    var arrSkills = [SkillsCategory]()
    var isComingSearch = false
    var callBack:(()->())?
    var currentDay:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSet()
    }
    func uiSet(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        currentDay = dateFormatter.string(from: Date())
        let nibNearBy = UINib(nibName: "GigNearByTVC", bundle: nil)
        tblVwTask.register(nibNearBy, forCellReuseIdentifier: "GigNearByTVC")
        let nib = UINib(nibName: "StoreCVC", bundle: nil)
        collVwPopup.register(nib, forCellWithReuseIdentifier: "StoreCVC")
        let nibBusiness = UINib(nibName: "PopularServicesCVC", bundle: nil)
        collVwBusiness.register(nibBusiness, forCellWithReuseIdentifier: "PopularServicesCVC")
        let nibMoment = UINib(nibName: "MomentsListTVC", bundle: nil)
        tblVwMoment.register(nibMoment, forCellReuseIdentifier: "MomentsListTVC")
        tblVwMoment.showsVerticalScrollIndicator = false
        tblVwMoment.separatorStyle = .none
        if isSelect == 1{
            tblVwMoment.isHidden = true
            tblVwTask.isHidden = false
            collVwPopup.isHidden = true
            collVwBusiness.isHidden = true
            tblVwTask.reloadData()
            lblHeader.text = "Task list"
        }else if isSelect == 3{
            tblVwMoment.isHidden = true
            tblVwTask.isHidden = true
            collVwPopup.isHidden = false
            collVwBusiness.isHidden = true
            collVwBusiness.reloadData()
            lblHeader.text = "Popup list"
        }else if isSelect == 4{
            tblVwTask.isHidden = true
            collVwPopup.isHidden = true
            collVwBusiness.isHidden = true
            tblVwMoment.isHidden = false
            tblVwMoment.reloadData()
            lblHeader.text = "Moment list"
        }else{
            tblVwMoment.isHidden = true
            tblVwTask.isHidden = true
            collVwPopup.isHidden = true
            collVwBusiness.isHidden = false
            collVwPopup.reloadData()
            lblHeader.text = "Business list"
        }
    }

   
    @IBAction func actionBack(_ sender: UIButton) {
        arrData.removeAll()
        
        self.navigationController?.popViewController(animated: true)
        callBack?()
    }
    
}

//MARK: - UICollectionViewDelegate
extension SeeAllTypeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isComingSearch{
            if arrSearchData.count > 0{
                return arrSearchData.count
            }else{
                return 0
            }
        }else{
            if arrData.count > 0{
                return arrData.count
            }else{
                return 0
            }
        }
       
         
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isComingSearch{
            if collectionView == collVwBusiness{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularServicesCVC", for: indexPath) as! PopularServicesCVC
                cell.vwShadow.layer.masksToBounds = false
                cell.vwShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                cell.vwShadow.layer.shadowOpacity = 0.44
                cell.vwShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.vwShadow.layer.shouldRasterize = true
                cell.vwShadow.layer.rasterizationScale = UIScreen.main.scale
                cell.isComing = true
                if arrSearchData.count > 0{
                    cell.indexpath = indexPath.row
   
                    let business = arrSearchData[indexPath.row]
                    let rating = business.userRating ?? 0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblRating.text = formattedRating
                    if let category = business.category {
                        switch category {
                        case .intValue(let intValue):
                            print("Category is an integer:", intValue)
                            
                            switch intValue {
                            case 1:
                                cell.lblCategory.text = "Restaurants"
                                cell.widthCategoryVw.constant = 70
                            case 2:
                                cell.lblCategory.text = "Clothing/fashion"
                                cell.widthCategoryVw.constant = 100
                            case 3:
                                cell.lblCategory.text = "Tech/electronics"
                                cell.widthCategoryVw.constant = 100
                            case 4:
                                cell.lblCategory.text = "Grocery"
                                cell.widthCategoryVw.constant = 60
                            case 5:
                                cell.lblCategory.text = "Fitness"
                                cell.widthCategoryVw.constant = 60
                            case 6:
                                cell.lblCategory.text = "Entertainment"
                                cell.widthCategoryVw.constant = 90
                            default:
                                cell.lblCategory.text = "Other"
                                cell.widthCategoryVw.constant = 45
                            }
                            
                            
                        case .objectValue(_):
                            break
                        }
                    }
                       
                    
                    cell.lblServiceName.text = business.businessname ?? "nil"
                    cell.imgVwUser.imageLoad(imageUrl: business.profilePhoto ?? "")
                    cell.lblAddress.text = business.place ?? ""
                    if business.status == 2{
                        cell.imgVwBlueTick.isHidden = false
                    }else{
                        cell.imgVwBlueTick.isHidden = true
                    }
                    var openingHoursFound = false
                    for openingHour in business.openingHours ?? [] {
                        if openingHour.day == currentDay {
                            openingHoursFound = true
                            let startTime12 = convertTo12HourFormat(openingHour.starttime ?? "")
                            let endTime12 = convertTo12HourFormat(openingHour.endtime ?? "")
                            cell.lblTime.text = "\(startTime12) - \(endTime12)"
                            break
                        }
                    }
                    if !openingHoursFound {
                        cell.lblTime.text = "Closed"
                    }
                }
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCVC", for: indexPath) as! StoreCVC
                cell.viewShadow.layer.masksToBounds = false
                cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                cell.viewShadow.layer.shadowOpacity = 0.44
                cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.viewShadow.layer.shouldRasterize = true
                cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
                if arrSearchData.count > 0{
                    cell.lblStoreName.text = arrSearchData[indexPath.row].name ?? ""
                    cell.imgVwStore.imageLoad(imageUrl: arrSearchData[indexPath.row].businessLogo ?? "")
                    cell.lblUserName.text = arrSearchData[indexPath.row].user?.name ?? ""
                    let rating = arrSearchData[indexPath.row].userRating ?? 0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblAddress.text = arrSearchData[indexPath.row].place ?? ""
                    cell.lblOffer.text = arrSearchData[indexPath.row].deals ?? ""
                    if arrSearchData[indexPath.row].endSoon ?? false{
                        cell.approveImg.image = UIImage(named: "redApprove")
                    }else{
                        cell.approveImg.image = UIImage(named: "greenApprove")
                    }
                    cell.lblRating.text = formattedRating
                    if let formattedStartDate = convertToDateFormat(arrSearchData[indexPath.row].startDate ?? "",
                                                                    dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                                    convertFormat: "MMM dd, h:mm a"),
                       let formattedEndDate = convertToDateFormat(arrSearchData[indexPath.row].endDate ?? "",
                                                                  dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                                  convertFormat: "MMM dd, h:mm a") {
                        cell.lblTime.text = "\(formattedStartDate) - \(formattedEndDate)"
                    } else {
                        print("Invalid date format")
                    }            }
                return cell
            
            }
        }else{
            if collectionView == collVwBusiness{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularServicesCVC", for: indexPath) as! PopularServicesCVC
                cell.vwShadow.layer.masksToBounds = false
                cell.vwShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                cell.vwShadow.layer.shadowOpacity = 0.44
                cell.vwShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.vwShadow.layer.shouldRasterize = true
                cell.vwShadow.layer.rasterizationScale = UIScreen.main.scale
                cell.isComing = true
                if arrData.count > 0{
                    cell.indexpath = indexPath.row
 
                    let business = arrData[indexPath.row]
                    let rating = business.UserRating ?? 0
                    
                    if let category = business.category {
                        switch category {
                        case .intValue(let intValue):
                            print("Category is an integer:", intValue)
                            
                            switch intValue {
                            case 1:
                                cell.lblCategory.text = "Restaurants"
                                cell.widthCategoryVw.constant = 70
                            case 2:
                                cell.lblCategory.text = "Clothing/fashion"
                                cell.widthCategoryVw.constant = 100
                            case 3:
                                cell.lblCategory.text = "Tech/electronics"
                                cell.widthCategoryVw.constant = 100
                            case 4:
                                cell.lblCategory.text = "Grocery"
                                cell.widthCategoryVw.constant = 60
                            case 5:
                                cell.lblCategory.text = "Fitness"
                                cell.widthCategoryVw.constant = 60
                            case 6:
                                cell.lblCategory.text = "Entertainment"
                                cell.widthCategoryVw.constant = 90
                            default:
                                cell.lblCategory.text = "Other"
                                cell.widthCategoryVw.constant = 45
                            }
                            
                            
                        case .objectValue(_):
                            break
                        }
                    }
                       
                    
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblRating.text = formattedRating
                  
                    cell.lblServiceName.text = business.businessname ?? ""
                    cell.imgVwUser.imageLoad(imageUrl: business.profilePhoto ?? "")
                    cell.lblAddress.text = business.place ?? ""
                    if business.status == 2{
                        cell.imgVwBlueTick.isHidden = false
                    }else{
                        cell.imgVwBlueTick.isHidden = true
                    }
                    var openingHoursFound = false
                    for openingHour in business.openingHours ?? [] {
                        if openingHour.day == currentDay {
                            openingHoursFound = true
                            let startTime12 = convertTo12HourFormat(openingHour.starttime ?? "")
                            let endTime12 = convertTo12HourFormat(openingHour.endtime ?? "")
                            cell.lblTime.text = "\(startTime12) - \(endTime12)"
                            break
                        }
                    }
                    if !openingHoursFound {
                        cell.lblTime.text = "Closed"
                    }
                }
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCVC", for: indexPath) as! StoreCVC
                cell.viewShadow.layer.masksToBounds = false
                cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                cell.viewShadow.layer.shadowOpacity = 0.44
                cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.viewShadow.layer.shouldRasterize = true
                cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
                if arrData.count > 0{
                    cell.lblStoreName.text = arrData[indexPath.row].name ?? ""
                    cell.imgVwStore.imageLoad(imageUrl: arrData[indexPath.row].businessLogo ?? "")
                    cell.lblUserName.text = arrData[indexPath.row].user?.name ?? ""
                    let rating = arrData[indexPath.row].UserRating ?? 0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblAddress.text = arrData[indexPath.row].place ?? ""
                    cell.lblOffer.text = arrData[indexPath.row].deals ?? ""
                    if arrData[indexPath.row].endSoon ?? false{
                        cell.approveImg.image = UIImage(named: "redApprove")
                    }else{
                        cell.approveImg.image = UIImage(named: "greenApprove")
                    }
                    cell.lblRating.text = formattedRating
                    if let formattedStartDate = convertToDateFormat(arrData[indexPath.row].startDate ?? "",
                                                                    dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                                    convertFormat: "MMM dd, h:mm a"),
                       let formattedEndDate = convertToDateFormat(arrData[indexPath.row].endDate ?? "",
                                                                  dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                                  convertFormat: "MMM dd, h:mm a") {
                        cell.lblTime.text = "\(formattedStartDate) - \(formattedEndDate)"
                    } else {
                        print("Invalid date format")
                    }            }
                return cell
            
            }
        }
      
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
           
                   
                    if collectionView == collVwBusiness{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
                      
                        vc.businessIndex = indexPath.row
                        if isComingSearch{
                            vc.businessId = arrSearchData[indexPath.row].id ?? ""
                            Store.BusinessUserIdForReview = arrSearchData[indexPath.row].id ?? ""
                        }else{
                            vc.businessId = arrData[indexPath.row].id ?? ""
                            Store.BusinessUserIdForReview = arrData[indexPath.row].id ?? ""
                        }
                      
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
                        if isComingSearch{
                            vc.popupId = arrSearchData[indexPath.row].id ?? ""
                        }else{
                            vc.popupId = arrData[indexPath.row].id ?? ""
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        //                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpDeatilVC") as! PopUpDeatilVC
                        //                    vc.popupId = arrData[indexPath.row].id ?? ""
                        //                    vc.popupIndex = indexPath.row
                        //                    vc.callBack = { [weak self] index in
                        //                        guard let self = self else { return }
                        //                        self.animateZoomInOut()
                        //                        self.getStoreData()
                        //                    }
                        //                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                
            
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      if collectionView == collVwBusiness{
            return CGSize(width: view.frame.size.width / 1-20, height: 100)
        }else{
            return CGSize(width: view.frame.size.width / 1-20, height: 144)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      
            return 0
        
       
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       
            return 0
        
    }

 
}

//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension SeeAllTypeVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isComingSearch{
            return arrSearchData.count
        }else{
            return arrData.count
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isComingSearch{
            if isSelect == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "GigNearByTVC", for: indexPath) as! GigNearByTVC
                
                if arrSearchData.count > 0 {
                    cell.lblName.text = arrSearchData[indexPath.row].name
                    cell.lblTitle.text = arrSearchData[indexPath.row].title
                    let value: Double = arrSearchData[indexPath.row].price ?? 0
                    let formattedValue = String(format: "%.2f", value)
                    cell.lblPrice.text = "$\(formattedValue)"
                    cell.lblAddress.text = arrSearchData[indexPath.row].address ?? ""
                    
                    let skills = arrSearchData[indexPath.row].skills ?? []
                    cell.arrCategory = skills
                    cell.uiSet(load: true)
                    
                    if let formattedDate = convertToDateFormat(arrSearchData[indexPath.row].startDate ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"dd MMM yyyy") {
                        cell.lblDate.text = formattedDate
                    } else {
                        print("Invalid date format")
                    }
                    
                    let timeString = arrSearchData[indexPath.row].serviceDuration ?? ""
                    let components = timeString.split(separator: ":")
                    if let hour = Int(components[0]), let minute = Int(components[1].split(separator: " ")[0]) {
                        
                        if let formattedTime = convertToDateFormat(arrSearchData[indexPath.row].startDate ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"Ha") {
                            if hour > 1 {
                                cell.lblTime.text = "\(formattedTime) (\(hour) H)"
                            } else {
                                let totalMinutes = (hour * 60) + minute
                                print("\(totalMinutes) M") // Output in minutes
                                cell.lblTime.text = "\(formattedTime) (\(totalMinutes) M)"
                            }
                        } else {
                            print("Invalid date format")
                        }
                        
                    }
                    
                    let rating = arrSearchData[indexPath.row].userRating ?? 0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblRatingReview.text = formattedRating
                    
                    if let imageURL = arrSearchData[indexPath.row].image, !imageURL.isEmpty {
                        cell.imgVwGig.imageLoad(imageUrl: imageURL)
                    } else {
                        cell.imgVwGig.image = UIImage(named: "dummy")
                    }
                    
                    cell.viewShadow.applyShadow()
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsListTVC", for: indexPath) as! MomentsListTVC
          
                cell.viewShadow.layer.masksToBounds = false
                cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                cell.viewShadow.layer.shadowOpacity = 0.44
                cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.viewShadow.layer.shouldRasterize = true
                cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
                cell.viewShadow.layer.cornerRadius = 10
                cell.contentView.layer.cornerRadius = 10
                if indexPath.row < arrSearchData.count {
                    let moments = arrSearchData[indexPath.row]
                    cell.lblTitle.text = moments.title ?? ""
                    let isoDate = moments.startDate ?? ""
                    cell.lblDate.text = formatDateString(isoDate)
                    cell.lblTime.text = formatTimeString(isoDate)
                    cell.lblLocation.text = moments.place
                    
                    if moments.tasks?.count ?? 0 == 1 {
                        cell.lblTaskCount.text = "\(moments.tasks?.count ?? 0) Task"
                    }else{
                        cell.lblTaskCount.text = "\(moments.tasks?.count ?? 0) Tasks"
                    }
                }
                return cell
            }
        }else{
            if isSelect == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "GigNearByTVC", for: indexPath) as! GigNearByTVC
                
                if arrData.count > 0 {
                    cell.lblName.text = arrData[indexPath.row].name
                    //                cell.lblTitle.text = arrData[indexPath.row].title
                    if let category = arrData[indexPath.row].category {
                        switch category {
                            
                        case .objectValue(let categoryObject):
                            
                            cell.lblTitle.text = "\(arrData[indexPath.row].title ?? "") \(categoryObject.name ?? "")"
                            
                        case .intValue(_):
                            print("")
                        }
                    }
                    let value: Double = arrData[indexPath.row].price ?? 0
                    let formattedValue = String(format: "%.2f", value)
                    cell.lblPrice.text = "$\(formattedValue)"
                    cell.lblAddress.text = arrData[indexPath.row].address ?? ""
                    
                    let skills = arrData[indexPath.row].skills ?? []
                    cell.arrCategory = skills
                    cell.uiSet(load: true)
                    
                    if let formattedDate = convertToDateFormat(arrData[indexPath.row].startDate ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"dd MMM yyyy") {
                        cell.lblDate.text = formattedDate
                    } else {
                        print("Invalid date format")
                    }
                    
                    let timeString = arrData[indexPath.row].serviceDuration ?? ""
                    let components = timeString.split(separator: ":")
                    if let hour = Int(components[0]), let minute = Int(components[1].split(separator: " ")[0]) {
                        
                        if let formattedTime = convertToDateFormat(arrData[indexPath.row].startDate ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"Ha") {
                            if hour > 1 {
                                cell.lblTime.text = "\(formattedTime) (\(hour) H)"
                            } else {
                                let totalMinutes = (hour * 60) + minute
                                print("\(totalMinutes) M") // Output in minutes
                                cell.lblTime.text = "\(formattedTime) (\(totalMinutes) M)"
                            }
                        } else {
                            print("Invalid date format")
                        }
                        
                    }
                    
                    let rating = arrData[indexPath.row].UserRating ?? 0.0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblRatingReview.text = formattedRating
                    
                    if let imageURL = arrData[indexPath.row].image, !imageURL.isEmpty {
                        cell.imgVwGig.imageLoad(imageUrl: imageURL)
                    } else {
                        cell.imgVwGig.image = UIImage(named: "dummy")
                    }
                    
                    cell.viewShadow.applyShadow()
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsListTVC", for: indexPath) as! MomentsListTVC
                cell.viewShadow.layer.masksToBounds = false
                cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                cell.viewShadow.layer.shadowOpacity = 0.44
                cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.viewShadow.layer.shouldRasterize = true
                cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
                cell.viewShadow.layer.cornerRadius = 10
                cell.contentView.layer.cornerRadius = 10
                if indexPath.row < arrData.count {
                    let moments = arrData[indexPath.row]
                    cell.lblTitle.text = moments.title ?? ""
                    let isoDate = moments.startDate ?? ""
                    cell.lblDate.text = formatDateString(isoDate)
                    cell.lblTime.text = formatTimeString(isoDate)
                    cell.lblLocation.text = moments.place
                    
                    if moments.tasks?.count ?? 0 == 1 {
                        cell.lblTaskCount.text = "\(moments.tasks?.count ?? 0) Task"
                    }else{
                        cell.lblTaskCount.text = "\(moments.tasks?.count ?? 0) Tasks"
                    }
                }
                return cell
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            self.dismiss(animated: true)
        if isSelect == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
            if isComingSearch{
                if arrSearchData.count > 0{
                    vc.gigId = arrSearchData[indexPath.row].id ?? ""
                }
            }else{
                if arrData.count > 0{
                    vc.gigId = arrData[indexPath.row].id ?? ""
                }
            }
             self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSideMomentDetailVC") as! UserSideMomentDetailVC
            if isComingSearch{
                if arrSearchData.count > 0{
                    vc.momentId = arrSearchData[indexPath.row].id ?? ""
                }
            }else{
                if arrData.count > 0{
                    vc.momentId = arrData[indexPath.row].id ?? ""
                }
            }
             self.navigationController?.pushViewController(vc, animated: true)
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
    func formatDateString(_ isoDate: String) -> String {
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
    func formatTimeString(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a" // e.g., 4 PM
            return outputFormatter.string(from: date)
        }
        
        return ""
    }

}

extension SeeAllTypeVC {
    func convertTo12HourFormat(_ time24: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date24 = dateFormatter.date(from: time24) {
            dateFormatter.dateFormat = "h:mm a"
            let time12 = dateFormatter.string(from: date24)
            return time12
        }
        return ""
    }
}
