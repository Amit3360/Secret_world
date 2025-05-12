//
//  HomeSearchVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 21/02/25.
//

import UIKit

class HomeSearchVC: UIViewController {

    @IBOutlet weak var heightTblVwMoment: NSLayoutConstraint!
    @IBOutlet weak var tblVwMoment: UITableView!
    @IBOutlet weak var vwMoment: UIView!
    @IBOutlet weak var btnAllMoment: UIButton!
    @IBOutlet weak var btnAllPopup: UIButton!
    @IBOutlet weak var btnAllBusiness: UIButton!
    @IBOutlet weak var btnAllTask: UIButton!
    @IBOutlet weak var heightCollVwPopup: NSLayoutConstraint!
    @IBOutlet weak var collVwPopup: UICollectionView!
    @IBOutlet weak var vwPopUp: UIView!
    @IBOutlet weak var heightCollVwBusiness: NSLayoutConstraint!
    @IBOutlet weak var collVwBusiness: UICollectionView!
    @IBOutlet weak var vwBusiness: UIView!
    @IBOutlet weak var heightTblVw: NSLayoutConstraint!
    @IBOutlet weak var tblVwTask: UITableView!
    @IBOutlet weak var vwTask: UIView!
    @IBOutlet weak var lblResultFound: UILabel!
    @IBOutlet weak var txtFldSearch: UITextField!
    
    var arrSearchTask = [HomeSearch]()
    var arrSearchPopUp = [HomeSearch]()
    var arrSearchBusiness = [HomeSearch]()
    var arrSearchMoment = [HomeSearch]()
    var viewModel = PopUpVM()
    var currentLat = Double()
    var currentLong = Double()
    var arrSkills = [SkillsCategory]()
    var currentDay:String?
    var callBack:((_ index:Int?,_ type:String?,_ id:String?,_ taskStatus:Int,_ userId:String)->())?
    var callBackSeeAll:((_ data:[HomeSearch]?,_ tag:Int?)->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
    }
    
    func registerCell(){
        print("Token",Store.authKey ?? "")
        btnAllTask.underline()
        btnAllBusiness.underline()
        btnAllPopup.underline()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        currentDay = dateFormatter.string(from: Date())
        
        let nib = UINib(nibName: "StoreCVC", bundle: nil)
        collVwPopup.register(nib, forCellWithReuseIdentifier: "StoreCVC")
        let nibBusiness = UINib(nibName: "PopularServicesCVC", bundle: nil)
        collVwBusiness.register(nibBusiness, forCellWithReuseIdentifier: "PopularServicesCVC")
        collVwBusiness.decelerationRate = .fast
        collVwPopup.decelerationRate = .fast
        let nibNearBy = UINib(nibName: "GigNearByTVC", bundle: nil)
        tblVwTask.register(nibNearBy, forCellReuseIdentifier: "GigNearByTVC")
        tblVwTask.showsVerticalScrollIndicator = false
        tblVwTask.separatorStyle = .none
        
        let nibMoment = UINib(nibName: "MomentsListTVC", bundle: nil)
        tblVwMoment.register(nibMoment, forCellReuseIdentifier: "MomentsListTVC")
        tblVwMoment.showsVerticalScrollIndicator = false
        tblVwMoment.separatorStyle = .none
        
    }
    
    func searchHomeApi(search:String){
        
        viewModel.searchHomeApi(lat: currentLat, long: currentLong, search: search) { data in
            self.arrSearchMoment.removeAll()
            self.arrSearchTask.removeAll()
            self.arrSearchBusiness.removeAll()
            self.arrSearchPopUp.removeAll()
            for i in data ?? []{
                if i.type == "gig"{
                    self.arrSearchTask.append(i)
                }else if i.type == "popUp"{
                    self.arrSearchPopUp.append(i)
                }else if i.type == "moment"{
                    self.arrSearchMoment.append(i)
                }else{
                    self.arrSearchBusiness.append(i)
                }
            }
            
       
          
            if self.arrSearchTask.count == 0{
                self.vwTask.isHidden = true
                self.heightTblVw.constant = CGFloat(0)
            }else if self.arrSearchTask.count < 2{
                self.vwTask.isHidden = false
                self.heightTblVw.constant = CGFloat((self.arrSearchTask.count*137))
            }else{
                self.vwTask.isHidden = false
                self.heightTblVw.constant = CGFloat((2*137))
            }
            
            if self.arrSearchBusiness.count == 0{
                self.vwBusiness.isHidden = true
                self.heightCollVwBusiness.constant = CGFloat(0)
            }else if self.arrSearchBusiness.count < 2{
                self.vwBusiness.isHidden = false
                self.heightCollVwBusiness.constant = CGFloat((self.arrSearchBusiness.count*100))
            }else{
                self.vwBusiness.isHidden = false
                self.heightCollVwBusiness.constant = CGFloat((200))
            }
            if self.arrSearchMoment.count == 0{
                self.vwMoment.isHidden = true
                self.heightTblVwMoment.constant = CGFloat(0)
            }else if self.arrSearchBusiness.count < 2{
                self.vwMoment.isHidden = false
                self.heightTblVwMoment.constant = CGFloat((self.arrSearchBusiness.count*120))
            }else{
                self.vwMoment.isHidden = false
                self.heightTblVwMoment.constant = CGFloat((240))
            }
            if self.arrSearchPopUp.count == 0{
                self.vwPopUp.isHidden = true
                self.heightCollVwPopup.constant = CGFloat(0)
            }else if self.arrSearchPopUp.count < 2{
                self.vwPopUp.isHidden = false
                self.heightCollVwPopup.constant = CGFloat((self.arrSearchPopUp.count*144))
            }else{
                self.vwPopUp.isHidden = false
                self.heightCollVwPopup.constant = CGFloat((144*2))
            }
            self.lblResultFound.text = "Result found: \(data?.count ?? 0)"
            self.tblVwTask.reloadData()
            self.collVwBusiness.reloadData()
            self.collVwPopup.reloadData()
            self.tblVwMoment.reloadData()
        }
    }
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
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionSeeAll(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            callBackSeeAll?(arrSearchTask,sender.tag)
            
        case 3:
            callBackSeeAll?(arrSearchPopUp,sender.tag)
          
        case 4:
            callBackSeeAll?(arrSearchMoment,sender.tag)
        default:
            callBackSeeAll?(arrSearchBusiness,sender.tag)
           
        }
        self.dismiss(animated: true)
    }
    

}

extension HomeSearchVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        print("Text-------",updatedText)
        searchHomeApi(search: updatedText)
        return true
    }
}

//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension HomeSearchVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwTask{
            return arrSearchTask.count
        }else{
            return arrSearchMoment.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwTask{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GigNearByTVC", for: indexPath) as! GigNearByTVC
            
            if arrSearchTask.count > 0 {
                cell.lblName.text = arrSearchTask[indexPath.row].name
                //                cell.lblTitle.text = arrSearchTask[indexPath.row].title
                if let category = arrSearchTask[indexPath.row].category {
                    switch category {
                        
                    case .objectValue(let categoryObject):
                        
                        cell.lblTitle.text = "\(arrSearchTask[indexPath.row].title ?? "") \(categoryObject.name ?? "")"
                        
                    case .intValue(_):
                        print("")
                    }
                }
                let value: Double = arrSearchTask[indexPath.row].price ?? 0
                let formattedValue = String(format: "%.2f", value)
                cell.lblPrice.text = "$\(formattedValue)"
                cell.lblAddress.text = arrSearchTask[indexPath.row].address ?? ""
                
                let skills = arrSearchTask[indexPath.row].skills ?? []
                cell.arrCategory = skills
                cell.uiSet(load: true)
                
                if let formattedDate = convertToDateFormat(arrSearchTask[indexPath.row].startDate ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"dd MMM yyyy") {
                    cell.lblDate.text = formattedDate
                } else {
                    print("Invalid date format")
                }
                
                let timeString = arrSearchTask[indexPath.row].serviceDuration ?? ""
                let components = timeString.split(separator: ":")
                if let hour = Int(components[0]), let minute = Int(components[1].split(separator: " ")[0]) {
                    
                    if let formattedTime = convertToDateFormat(arrSearchTask[indexPath.row].startDate ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"Ha") {
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
                
                let rating = arrSearchTask[indexPath.row].userRating ?? 0
                let formattedRating = String(format: "%.1f", rating)
                cell.lblRatingReview.text = formattedRating
                
                if let imageURL = arrSearchTask[indexPath.row].image, !imageURL.isEmpty {
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
            if indexPath.row < arrSearchMoment.count {
                let moments = arrSearchMoment[indexPath.row]
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVwTask{
            return 145
        }else{
            return 120
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVwTask{
            callBack?(indexPath.row, "task", arrSearchTask[indexPath.row].id ?? "", arrSearchTask[indexPath.row].status ?? 0, arrSearchTask[indexPath.row].userID ?? "")
        }else{
            callBack?(indexPath.row, "moment", arrSearchMoment[indexPath.row].id ?? "", arrSearchMoment[indexPath.row].status ?? 0, arrSearchMoment[indexPath.row].userID ?? "")
        }
        self.dismiss(animated: true)
    
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

//MARK: - UICollectionViewDelegate
extension HomeSearchVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwPopup{
            return arrSearchPopUp.count
          
        }else{
            return arrSearchBusiness.count
          
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if collectionView == collVwBusiness{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularServicesCVC", for: indexPath) as! PopularServicesCVC
            cell.vwShadow.layer.masksToBounds = false
            cell.vwShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
            cell.vwShadow.layer.shadowOpacity = 0.44
            cell.vwShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.vwShadow.layer.shouldRasterize = true
            cell.vwShadow.layer.rasterizationScale = UIScreen.main.scale
            cell.isComing = true
           
           if arrSearchBusiness.count > 0{
                    cell.indexpath = indexPath.row
                    
                    
                    let business = arrSearchBusiness[indexPath.row]
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
                           cell.widthCategoryVw.constant = 70
                       case 5:
                           cell.lblCategory.text = "Fitness"
                           cell.widthCategoryVw.constant = 70
                       case 6:
                           cell.lblCategory.text = "Entertainment"
                           cell.widthCategoryVw.constant = 100
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
         
            if arrSearchPopUp.count > 0{
                    cell.lblStoreName.text = arrSearchPopUp[indexPath.row].name ?? ""
                    cell.imgVwStore.imageLoad(imageUrl: arrSearchPopUp[indexPath.row].businessLogo ?? "")
//                    cell.lblUserName.text = arrSearchPopUp[indexPath.row].user?.name ?? ""
                if arrSearchPopUp[indexPath.row].categoryType == 1{
                    cell.lblUserName.text = "Food & Drinks"
                   
                }else if arrSearchPopUp[indexPath.row].categoryType == 2{
                    cell.lblUserName.text = "Services"
                }else if arrSearchPopUp[indexPath.row].categoryType == 3{
                    cell.lblUserName.text = "Clothes / Fashion"
                }else if arrSearchPopUp[indexPath.row].categoryType == 4{
                    cell.lblUserName.text = "Beauty / Self-Care"
                }else {
                    cell.lblUserName.text = "Low Key"
                }
                let rating = arrSearchPopUp[indexPath.row].userRating ?? 0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblAddress.text = arrSearchPopUp[indexPath.row].place ?? ""
                    cell.lblOffer.text = arrSearchPopUp[indexPath.row].deals ?? ""
                    if arrSearchPopUp[indexPath.row].endSoon ?? false{
                        cell.approveImg.image = UIImage(named: "redApprove")
                    }else{
                        cell.approveImg.image = UIImage(named: "greenApprove")
                    }
                    cell.lblRating.text = formattedRating
                    if let formattedStartDate = convertToDateFormat(arrSearchPopUp[indexPath.row].startDate ?? "",
                                                                    dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                                    convertFormat: "MMM dd, h:mm a"),
                       let formattedEndDate = convertToDateFormat(arrSearchPopUp[indexPath.row].endDate ?? "",
                                                                  dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                                  convertFormat: "MMM dd, h:mm a") {
                        cell.lblTime.text = "\(formattedStartDate) - \(formattedEndDate)"
                    } else {
                        print("Invalid date format")
                    }
                }
          
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        if collectionView == collVwBusiness{
            callBack?(indexPath.row, "business",arrSearchBusiness[indexPath.row].id ?? "", 0, "")
        }else{
            callBack?(indexPath.row, "popup",arrSearchPopUp[indexPath.row].id ?? "", 0, "")
        }
        dismiss(animated: true)
      
        }
            
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwBusiness{
            return CGSize(width: view.frame.size.width / 1-20, height: 100)
        }else{
            return CGSize(width: view.frame.size.width / 1-20, height: 144)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
            return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      
            return 0
        
    }
   
    
}


