//
//  GigPopOversVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 20/12/24.
//

import UIKit

class GigPopOversVC: UIViewController {
    
    @IBOutlet var tblVwList: UITableView!
    var arrTitle = [String]()
    var callBackParticipants:((_ type:String,_ title:String,_ userId:String,_ taskId:String)->())?
    var callBack:((_ type:String,_ title:String,_ id:String)->())?
    var callBackRoleType:((_ type:String,_ title:String,_ index:Int)->())?
    var selectedIndex = 0
    var type:String?
    var viewModelAuth = AuthVM()
    var arrGetCategories = [Skills]()
    var arrGetSkills = [Skills]()
    var arrSelectedSkills = [Skills]()
    var offset = 1
    var limit = 20
    var isWorldwide = false
    var locationType = ""
    var arrItemCategory = [String]()
    var arrAppliedGig = [GetAppliedData]()
    var arrProduct = [ServiceDetail]()
    var participantsList:[Participantzz]?
    var businessGigDetail:GetGigDetailData?
    var callBackBusiness:((_ name:String,_ index:Int)->())?
    var callBackItinerary:((_ type:String,_ title:String,_ id:String,_ price:Int)->())?
    var matchTitle:String?
    var arrSelectedDays = [String]()
    var arrItemDiscount = [DiscountData]()
    var arrSelectedItemDiscount = [DiscountData]()
    var arrParticipantsList: [AppliedUser] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    
    func uiSet(){
        
        if let popOverType = type {
            switch popOverType {
            case "roleType":
                arrTitle.append("Promote (Wear or hold something to advertise)")
                arrTitle.append("Support Online (Like, comment, or repost to boost someone)")
                arrTitle.append("Act in Scene (Play a role in someone's skit or video)")
                arrTitle.append("Run Errand (Help with simple tasks like pickup or waiting)")
                arrTitle.append("Show Up (Be present at an event or help fill a crowd)")
                arrTitle.append("Check Location (Take a photo or confirm a place is open)")
                arrTitle.append("Help Out (Be an extra hand or fill in for someone quickly)")
                
                tblVwList.reloadData()
            case "payBy":
                arrTitle.append("Money")
                arrTitle.append("Barter")
                arrTitle.append("Money + Barter")
            case "category":
                tblVwList.reloadData()
            case "duration":
                arrTitle.append(contentsOf: [
                    "15 min", "30 min", "45 min", "1 hr",
                    "1 hr 30 min", "2 hr", "2 hr 30 min", "3 hr",
                    "3 hr 30 min", "4 hr", "4 hr 30 min", "5 hr",
                    "5 hr 30 min", "6 hr", "6 hr 30 min", "7 hr",
                    "7 hr 30 min", "8 hr", "8 hr 30 min", "9 hr",
                    "9 hr 30 min", "10 hr", "10 hr 30 min", "11 hr",
                    "11 hr 30 min", "12 hr"
                ])
                
                //                let totalMinutes = 24 * 60 // 1440 minutes
                //                var interval = 15
                //                while interval <= totalMinutes {
                //                    if interval < 60 {
                //                        arrTitle.append("\(interval) min")
                //                    } else {
                //                        let hours = interval / 60
                //                        let minutes = interval % 60
                //
                //                        if minutes == 0 {
                //                            arrTitle.append("\(hours) hour" + (hours > 1 ? "s" : ""))
                //                        } else {
                //                            arrTitle.append("\(hours)h \(minutes)min")
                //                        }
                //                    }
                //                    interval += (interval < 60) ? 15 : 30
                //                }
            case "participants":
                tblVwList.reloadData()
            case "experience":
                arrTitle.append("Below 1 Year")
                arrTitle.append("1 Year")
                arrTitle.append("1-2 Year")
                arrTitle.append("2-3 Year")
            case "payment":
                arrTitle.append("Fixed")
                arrTitle.append("Hourly")
                
            case "tools":
                arrTitle.append("Add your own")
                arrTitle.append("Photoshop")
                arrTitle.append("Figma")
                arrTitle.append("Microsoft")
                arrTitle.append("Excel")
                
            case "itemCategory":
                tblVwList.reloadData()
                
            case "itemDiscount":
                tblVwList.reloadData()
                
            case "skills":
                tblVwList.reloadData()
            case "paymentMethod":
                if locationType == "worldwide"{
                    arrTitle.append("Online")
                }else{
                    arrTitle.append("Cash")
                    arrTitle.append("Online")
                }
            case "calender":
                tblVwList.reloadData()
            case "Product":
                tblVwList.reloadData()
            case "graphType":
                arrTitle.append("Weekly")
                arrTitle.append("Monthly")
                arrTitle.append("Yearly")
            case "sellingType":
                arrTitle.append("By weight")
                arrTitle.append("By unit")
                
            case "popupType":
                arrTitle.append("Food and drinks")
                arrTitle.append("Services")
                arrTitle.append("Crafts and goods")
                arrTitle.append("Events")
                arrTitle.append("Lowkey")
            case "CreateBusiness":
//                arrTitle.append("Restaurants")
//                arrTitle.append("Retail")
//                arrTitle.append("Beauty & wellness")
//                arrTitle.append("Events")
                arrTitle.append("Restaurants")
                arrTitle.append("Clothing/fashion")
                arrTitle.append("Tech/electronics")
                arrTitle.append("Grocery")
                arrTitle.append("Fitness")
                arrTitle.append("Entertainment")
                arrTitle.append("Other")
            case "review":
                participantsList = businessGigDetail?.participantsList ?? []
                tblVwList.reloadData()
            case "cast":
                arrTitle.append("Human")
                arrTitle.append("Animal")
                arrTitle.append("Bird")
                arrTitle.append("Robot")
            case "choosePriceType":
                arrTitle.append("Monthly")
                arrTitle.append("Quarterly")
                arrTitle.append("Bi-annually")
                arrTitle.append("Annually")
            case "days":
                arrTitle.append("Sunday")
                arrTitle.append("Monday")
                arrTitle.append("Tuesday")
                arrTitle.append("Wednesday")
                arrTitle.append("Thursday")
                arrTitle.append("Friday")
                arrTitle.append("Saturday")
            case "ChooseCategory":
                tblVwList.reloadData()
            default:
                break
            }
        }
        tblVwList.reloadData()
    }
    
}
//MARK: - UITableViewDelegate
extension GigPopOversVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == "category"{
            if arrGetCategories.count > 0{
                return arrGetCategories.count
            }else{
                return 0
            }
        }else if type == "skills"{
            if arrGetSkills.count > 0{
                return arrGetSkills.count
            }else{
                return 0
            }
        }else if type == "calender"{
            if arrAppliedGig.count > 0{
                return arrAppliedGig.count
            }else{
                return 0
            }
        }else if type == "Product"{
            if arrProduct.count > 0{
                return arrProduct.count
            }else{
                return 0
            }
        }else if type == "review"{
            if participantsList?.count ?? 0 > 0{
                return participantsList?.count ?? 0
            }else{
                return 0
            }
        }else if type == "itemCategory"{
            if arrGetCategories.count > 0{
                return arrGetCategories.count
            }else{
                return 0
            }
        }else if type == "itemDiscount"{
            if arrItemDiscount.count > 0{
                return arrItemDiscount.count
            }else{
                return 0
            }
        }else if type == "ChooseCategory"{
            if arrItemCategory.count > 0{
                return arrItemCategory.count
            }else{
                return 0
            }
        }else if type == "participants"{
            if arrParticipantsList.count > 0{
                return arrParticipantsList.count
            }else{
                return 0
            }
            
        }else{
            if arrTitle.count > 0{
                return arrTitle.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigPopOverTVC", for: indexPath) as! GigPopOverTVC
        cell.btnAdd.isHidden = true
        switch type {
        case "roleType","payment":
            let isSelected = (matchTitle == arrTitle[indexPath.row])
            cell.viewBAck.backgroundColor = isSelected ? .app : .white

            let fullText = arrTitle[indexPath.row]
            let attributedText = NSMutableAttributedString(string: fullText)

            // Set main font and color
            attributedText.addAttributes([
                .font: UIFont(name: "Nunito-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),
                .foregroundColor: isSelected ? UIColor.white : UIColor.black
            ], range: NSRange(location: 0, length: attributedText.length))

            // Apply smaller font and adjusted color to text inside parentheses
            if let range = fullText.range(of: #"\(.*?\)"#, options: .regularExpression) {
                let nsRange = NSRange(range, in: fullText)
                attributedText.addAttributes([
                    .font: UIFont(name: "Nunito-Regular", size: 10) ?? UIFont.systemFont(ofSize: 11),
                    .foregroundColor: isSelected ? UIColor.white : UIColor.black
                ], range: nsRange)
            }

            cell.lblTitle.attributedText = attributedText
            cell.lblTitle.numberOfLines = 0
            
            
        case "participants":
            if matchTitle == arrParticipantsList[indexPath.row].name ?? ""{
                cell.viewBAck.backgroundColor = .app
                cell.lblTitle.textColor = .white
            }else{
                cell.viewBAck.backgroundColor = .white
                cell.lblTitle.textColor = .black
            }
            cell.lblTitle.text = arrParticipantsList[indexPath.row].name ?? ""
        case "category":
            if matchTitle == arrGetCategories[indexPath.row].name{
                cell.viewBAck.backgroundColor = .app
                cell.lblTitle.textColor = .white
            }else{
                cell.viewBAck.backgroundColor = .white
                cell.lblTitle.textColor = .black
            }
            cell.lblTitle.text = arrGetCategories[indexPath.row].name
        case "skills":
            if arrSelectedSkills.contains(where:{$0.name == arrGetSkills[indexPath.row].name}){
                cell.viewBAck.backgroundColor = .app
                cell.lblTitle.textColor = .white
            }else{
                cell.viewBAck.backgroundColor = .white
                cell.lblTitle.textColor = .black
            }
            cell.lblTitle.text = arrGetSkills[indexPath.row].name
        case "calender":
            cell.lblTitle.text = "\(arrAppliedGig[indexPath.row].gig?.title ?? "") \(arrAppliedGig[indexPath.row].category?.name ?? "")"
            
        case "itemCategory":
            if arrSelectedSkills.contains(where:{$0.name == arrGetCategories[indexPath.row].name}){
                cell.viewBAck.backgroundColor = .app
                cell.lblTitle.textColor = .white
            }else{
                cell.viewBAck.backgroundColor = .white
                cell.lblTitle.textColor = .black
            }
            cell.lblTitle.text = arrGetCategories[indexPath.row].name
            
        case "itemDiscount":
            if arrSelectedItemDiscount.contains(where:{$0.discount == arrItemDiscount[indexPath.row].discount}){
                cell.viewBAck.backgroundColor = .app
                cell.lblTitle.textColor = .white
            }else{
                cell.viewBAck.backgroundColor = .white
                cell.lblTitle.textColor = .black
            }
            cell.lblTitle.text = arrItemDiscount[indexPath.row].discount ?? ""
            
        case "review":
            cell.lblTitle.text = participantsList?[indexPath.row].name ?? ""
            
        case "Product":
            cell.lblTitle.text = arrProduct[indexPath.row].serviceName ?? ""
        case "ChooseCategory":
            cell.lblTitle.text = arrItemCategory[indexPath.row]
            if matchTitle == arrItemCategory[indexPath.row]{
                cell.viewBAck.backgroundColor = .app
                cell.lblTitle.textColor = .white
            }else{
                cell.viewBAck.backgroundColor = .white
                cell.lblTitle.textColor = .black
            }
        default:
            if type == "category"{
                if matchTitle == arrTitle[indexPath.row]{
                    cell.viewBAck.backgroundColor = .app
                    cell.lblTitle.textColor = .white
                }else{
                    cell.viewBAck.backgroundColor = .white
                    cell.lblTitle.textColor = .black
                }
                cell.lblTitle.text = arrTitle[indexPath.row]
                
            }else  if type == "days"{
                if indexPath.row < arrTitle.count {
                    let currentTitle = arrTitle[indexPath.row]
                    let isSelected = arrSelectedDays.contains(currentTitle)
                    
                    cell.viewBAck.backgroundColor = isSelected ? .app : .white
                    cell.lblTitle.textColor = isSelected ? .white : .black
                    cell.lblTitle.text = currentTitle
                } else {
                    // Optional fallback in case arrTitle is shorter than expected
                    cell.viewBAck.backgroundColor = .white
                    cell.lblTitle.textColor = .black
                    cell.lblTitle.text = arrTitle[indexPath.row]
                }
            }else{
                if matchTitle == arrTitle[indexPath.row]{
                    cell.viewBAck.backgroundColor = .app
                    cell.lblTitle.textColor = .white
                }else{
                    cell.viewBAck.backgroundColor = .white
                    cell.lblTitle.textColor = .black
                }
                cell.lblTitle.text = arrTitle[indexPath.row]
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false)
        
        switch type {
        case "roleType","payment":
            callBackRoleType?(type ?? "",arrTitle[indexPath.row], indexPath.row)
            tblVwList.reloadData()
        case "participants":
            callBackParticipants?(
                type ?? "",
                arrParticipantsList[indexPath.row].name ?? "",
                arrParticipantsList[indexPath.row].id ?? "",
                arrParticipantsList[indexPath.row].taskId ?? ""
            )
            tblVwList.reloadData()
            
        case "category":
            callBack?(
                type ?? "",
                arrGetCategories[indexPath.row].name,
                arrGetCategories[indexPath.row].id
            )
            tblVwList.reloadData()
            
        case "skills":
            callBack?(
                type ?? "",
                arrGetSkills[indexPath.row].name,
                arrGetSkills[indexPath.row].id
            )
            
        case "calender":
            callBackItinerary?(
                type ?? "",
                "\(arrAppliedGig[indexPath.row].gig?.title ?? "") \(arrAppliedGig[indexPath.row].category?.name ?? "")",
                arrAppliedGig[indexPath.row].gig?.id ?? "",
                Int(arrAppliedGig[indexPath.row].gig?.price ?? 0)
            )
            
        case "Product":
            callBack?(
                type ?? "",
                arrProduct[indexPath.row].serviceName ?? "",
                arrProduct[indexPath.row]._id ?? ""
            )
            
        case "review":
            callBack?(
                type ?? "",
                participantsList?[indexPath.row].name ?? "",
                participantsList?[indexPath.row].id ?? ""
            )
            
        case "itemCategory":
            callBack?(
                type ?? "",
                arrGetCategories[indexPath.row].name,
                arrGetCategories[indexPath.row].id
            )
            
        case "itemDiscount":
            callBack?(
                type ?? "",
                arrItemDiscount[indexPath.row].discount ?? "",
                arrItemDiscount[indexPath.row].id ?? ""
            )
            
        case "ChooseCategory":
            callBack?(
                type ?? "",
                arrItemCategory[indexPath.row],
                ""
            )
            
        default:
            callBack?(
                type ?? "",
                arrTitle[indexPath.row],
                ""
            )
            callBackBusiness?(arrTitle[indexPath.row], indexPath.row + 1)
            tblVwList.reloadData()
        }
    }
}
