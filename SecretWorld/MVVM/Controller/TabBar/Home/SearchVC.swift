//
//  SearchVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 02/01/24.
//

import UIKit
import CoreData

struct SearchData:Codable{
    var name:String?
    var id:String?
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

class SearchVC: UIViewController {
    
    @IBOutlet var lblNodata: UILabel!
    @IBOutlet var tblVwSearch: UITableView!
    @IBOutlet var txtFldSearch: UITextField!
    
    var sectionsData = [String]()
    var viewModel = PopUpVM()
    var offset = 1
    var limit = 10
    var searchText = ""
    var totalPages = 0
    var currentDay = String()
    var isLoading = false
    var arrSearchResultes = [SearchList]()
    var arrRecentSearch = [String]()
    private let recentSearchesKey = "RecentSearchesKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        
        noSearchdata()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)

        registerNib()
        tblVwSearch.showsVerticalScrollIndicator = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardWhileClick))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        if self.arrSearchResultes.count > 0{
            self.lblNodata.isHidden = true
        }else{
            self.lblNodata.isHidden = false
        }
    }
    func noSearchdata(){
        txtFldSearch.text = ""
        txtFldSearch.becomeFirstResponder()
        searchText = ""
        offset = 0
        sectionsData.removeAll()
        arrSearchResultes.removeAll()
        arrRecentSearch = Store.SearchResult
        if arrRecentSearch.count > 0{
            sectionsData.append("Recent Search")
        }
        tblVwSearch.reloadData()
        lblNodata.isHidden = false
    }
    func registerNib(){
        let nibNearBy = UINib(nibName: "BusinessesTVC", bundle: nil)
        tblVwSearch.register(nibNearBy, forCellReuseIdentifier: "BusinessesTVC")
        let nibNearBy2 = UINib(nibName: "TempraryStoreTVC", bundle: nil)
        tblVwSearch.register(nibNearBy2, forCellReuseIdentifier: "TempraryStoreTVC")
        let nib22 = UINib(nibName: "BusinessHourTVC", bundle: nil)
        tblVwSearch.register(nib22, forCellReuseIdentifier: "BusinessHourTVC")

    }
    @objc func handleSwipe() {
                navigationController?.popViewController(animated: true)
            }

    @objc func dismissKeyboardWhileClick() {
        view.endEditing(true)
    }
    func searchAllApi(search: Bool) {
        viewModel.searchAllApi(offset: offset, limit: limit, search: searchText) { data in
            guard let data = data else {
                self.isLoading = false
                return
            }
            self.totalPages = data.totalPages ?? 0
            
            if search {
                self.offset = 1
                self.arrSearchResultes = data.data ?? []
                self.sectionsData.removeAll()
                
                if self.arrRecentSearch.count > 0 {
                    self.sectionsData.append("Recent Search")
                    
                }
                if self.arrSearchResultes.count > 0 {
                    if !self.searchText.isEmpty{
                        self.sectionsData.append("Recent View")
                    }
                }
            }
            //else {
//                self.arrSearchResultes.append(contentsOf: data.data ?? [])
//                if self.arrRecentSearch.count > 0 {
//                    self.sectionsData = ["Recent Search", "Recent View"]
//                } else {
//                    self.sectionsData = ["Recent View"]
//                }
           // }
            
            self.lblNodata.isHidden = self.arrSearchResultes.count > 0
            
            self.tblVwSearch.reloadData()
            self.isLoading = false
        }
    }

    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}
//MARK: -UITableViewDelegate
extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionsData.count == 1{
            if sectionsData[section] == "Recent Search"{
                
                return arrRecentSearch.count
                
            }else{
                
                return arrSearchResultes.count
                
            }
        }else{
            if section == 0{
                
                return arrRecentSearch.count
                
            }else{
                return arrSearchResultes.count
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "BusinessHourTVC") as! BusinessHourTVC
        
        headerCell.lblday.font = UIFont.boldSystemFont(ofSize: 15)
        headerCell.lblday.text = sectionsData[section]
        
        headerCell.lblTime.text = ""
        headerCell.btnCross.isHidden = true
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sectionsData.count == 1{
            
            if sectionsData[indexPath.section] == "Recent Search"{
                
                let recentSearchCell = tableView.dequeueReusableCell(withIdentifier: "BusinessHourTVC") as! BusinessHourTVC
                recentSearchCell.btnCross.isHidden = false
                recentSearchCell.lblday.text = arrRecentSearch[indexPath.row]
                recentSearchCell.lblTime.text = ""
                
                recentSearchCell.btnCross.tag = indexPath.row
                recentSearchCell.btnCross.addTarget(self, action: #selector(actionRemoveRecentSearch), for: .touchUpInside)
                return recentSearchCell
            }else{
                guard indexPath.row < arrSearchResultes.count else {
                    return UITableViewCell()
                }
                
                if arrSearchResultes[indexPath.row].type == "business"{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessesTVC", for: indexPath) as! BusinessesTVC
                    cell.viewShadow.layer.masksToBounds = false
                    cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                    cell.viewShadow.layer.shadowOpacity = 0.44
                    cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.viewShadow.layer.shouldRasterize = true
                    cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
                    cell.viewShadow.layer.cornerRadius = 10
                    cell.contentView.layer.cornerRadius = 10
                    if arrSearchResultes.count > 0{
                        let business = arrSearchResultes[indexPath.row]
                        cell.imgVwService.imageLoad(imageUrl: business.businessID ?? "")
                        cell.imgVwService.imageLoad(imageUrl: business.coverPhoto ?? "")
                        cell.lblBusinessName.text = business.businessname ?? ""
                        cell.lblPlace.text = business.place ?? ""
                        let rating = arrSearchResultes[indexPath.row].userRating ?? 0.0
                        let formattedRating = String(format: "%.1f", rating)
                        cell.lblrating.text = formattedRating
                        
                        cell.lblPlace.textColor = .black
                        cell.lblPlace.font = UIFont.systemFont(ofSize: 13)
                        cell.heightTimeImg.constant = 12
                        cell.heightLocationImg.constant = 18
                        cell.widthTimeImg.constant = 12
                        cell.widthLocationImg.constant = 18
                        
                        cell.indexx = indexPath.row
                        cell.arrSearchBusiness = self.arrSearchResultes
                        cell.uiSet(load: true)
                        cell.isComing = false
                        let currentDay = currentDay
                        for openingHour in business.openingHours ?? [] {
                            if openingHour.day?.lowercased() == currentDay.lowercased() {
                                let startTime12 = convertTo12HourFormat(openingHour.starttime ?? "")
                                let endTime12 = convertTo12HourFormat(openingHour.endtime ?? "")
                                cell.lblTiming.text = "\(startTime12) - \(endTime12)"
                            }else{
                                cell.lblTiming.text = "Closed"
                            }
                            break
                        }
                    }
                    return cell
                }else if arrSearchResultes[indexPath.row].type == "gig"{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessesTVC", for: indexPath) as! BusinessesTVC
                    cell.viewShadow.layer.masksToBounds = false
                    cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                    cell.viewShadow.layer.shadowOpacity = 0.44
                    cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.viewShadow.layer.shouldRasterize = true
                    cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
                    cell.viewShadow.layer.cornerRadius = 10
                    cell.contentView.layer.cornerRadius = 10
                    if arrSearchResultes.count > 0{
                        cell.heightTimeImg.constant = 0
                        cell.heightLocationImg.constant = 0
                        cell.widthTimeImg.constant = 0
                        cell.widthLocationImg.constant = 0
                        let business = arrSearchResultes[indexPath.row]
                        if business.image == "" || business.image == nil{
                            cell.imgVwService.image = UIImage(named: "dummy")
                        }else{
                            cell.imgVwService.imageLoad(imageUrl: business.image ?? "")
                        }

                        
                        cell.lblBusinessName.text = business.title ?? ""
                        cell.lblPlace.text = "$\(business.price ?? 0)"
                        cell.lblPlace.font = UIFont.boldSystemFont(ofSize: 15)
                        cell.lblPlace.textColor = .app
                        let rating = arrSearchResultes[indexPath.row].userRating ?? 0.0
                        let formattedRating = String(format: "%.1f", rating)
                        cell.lblrating.text = formattedRating
                        cell.lblTiming.text = business.name ?? ""
                        cell.lblTiming.font =  UIFont.systemFont(ofSize: 14)
                        cell.indexx = indexPath.row
                        cell.arrSearchBusiness = self.arrSearchResultes
                        cell.uiSet(load: true)
                        cell.isComing = false
                        cell.heightCollvwCategories.constant = 0
                        
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TempraryStoreTVC", for: indexPath) as! TempraryStoreTVC
                    cell.viewShadow.layer.masksToBounds = false
                    cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                    cell.viewShadow.layer.shadowOpacity = 0.44
                    cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.viewShadow.layer.shouldRasterize = true
                    cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
                    cell.viewShadow.layer.cornerRadius = 10
                    cell.viewImgVwBack.layer.masksToBounds = false
                    cell.viewImgVwBack.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                    cell.viewImgVwBack.layer.shadowOpacity = 0.44
                    cell.viewImgVwBack.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.viewImgVwBack.layer.shouldRasterize = true
                    cell.viewImgVwBack.layer.rasterizationScale = UIScreen.main.scale
                    cell.contentView.layer.cornerRadius = 10
                    let tempraryStore = arrSearchResultes[indexPath.row]
                    
                    cell.imgVwStore.imageLoad(imageUrl: tempraryStore.businessLogo ?? "")
                    cell.lblStoreName.text = tempraryStore.name ?? ""
                    if case let .userIDClass(userIDClass) = tempraryStore.userID {
                        if let name = userIDClass.name {
                            cell.lblUserName.text = name
                            
                        }
                    }
                    
                    let rating = tempraryStore.userRating ?? 0.0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblrating.text = formattedRating
                    return cell
                    
                }
            }
        }else{
            
            if indexPath.section == 0{
                let recentSearchCell = tableView.dequeueReusableCell(withIdentifier: "BusinessHourTVC") as! BusinessHourTVC
                recentSearchCell.btnCross.isHidden = false
                recentSearchCell.lblday.text = arrRecentSearch[indexPath.row]
                recentSearchCell.lblTime.text = ""
                recentSearchCell.btnCross.tag = indexPath.row
                recentSearchCell.btnCross.addTarget(self, action: #selector(actionRemoveRecentSearch), for: .touchUpInside)
                return recentSearchCell
            }else{
                guard indexPath.row < arrSearchResultes.count else {
                    return UITableViewCell()
                }
                
                if arrSearchResultes[indexPath.row].type == "business"{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessesTVC", for: indexPath) as! BusinessesTVC
                    cell.viewShadow.layer.masksToBounds = false
                    cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                    cell.viewShadow.layer.shadowOpacity = 0.44
                    cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.viewShadow.layer.shouldRasterize = true
                    cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
                    cell.viewShadow.layer.cornerRadius = 10
                    cell.contentView.layer.cornerRadius = 10
                    if arrSearchResultes.count > 0{
                        let business = arrSearchResultes[indexPath.row]
                        cell.imgVwService.imageLoad(imageUrl: business.businessID ?? "")
                        cell.imgVwService.imageLoad(imageUrl: business.coverPhoto ?? "")
                        cell.lblBusinessName.text = business.businessname ?? ""
                        cell.lblPlace.text = business.place ?? ""
                        let rating = arrSearchResultes[indexPath.row].userRating ?? 0.0
                        let formattedRating = String(format: "%.1f", rating)
                        cell.lblrating.text = formattedRating
                        
                        cell.lblPlace.textColor = .black
                        cell.lblPlace.font = UIFont.systemFont(ofSize: 13)
                        cell.heightTimeImg.constant = 12
                        cell.heightLocationImg.constant = 18
                        cell.widthTimeImg.constant = 12
                        cell.widthLocationImg.constant = 18
                        
                        cell.indexx = indexPath.row
                        cell.arrSearchBusiness = self.arrSearchResultes
                        cell.uiSet(load: true)
                        cell.isComing = false
                        let currentDay = currentDay
                        for openingHour in business.openingHours ?? [] {
                            if openingHour.day?.lowercased() == currentDay.lowercased() {
                                let startTime12 = convertTo12HourFormat(openingHour.starttime ?? "")
                                let endTime12 = convertTo12HourFormat(openingHour.endtime ?? "")
                                cell.lblTiming.text = "\(startTime12) - \(endTime12)"
                            }else{
                                cell.lblTiming.text = "Closed"
                            }
                            break
                        }
                    }
                    return cell
                }else if arrSearchResultes[indexPath.row].type == "gig"{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessesTVC", for: indexPath) as! BusinessesTVC
                    cell.viewShadow.layer.masksToBounds = false
                    cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                    cell.viewShadow.layer.shadowOpacity = 0.44
                    cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.viewShadow.layer.shouldRasterize = true
                    cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
                    cell.viewShadow.layer.cornerRadius = 10
                    cell.contentView.layer.cornerRadius = 10
                    if arrSearchResultes.count > 0{
                        cell.heightTimeImg.constant = 0
                        cell.heightLocationImg.constant = 0
                        cell.widthTimeImg.constant = 0
                        cell.widthLocationImg.constant = 0
                        let business = arrSearchResultes[indexPath.row]
                        cell.imgVwService.imageLoad(imageUrl: business.image ?? "")
                        cell.lblBusinessName.text = business.title ?? ""
                        cell.lblPlace.text = "$\(business.price ?? 0)"
                        cell.lblPlace.font = UIFont.boldSystemFont(ofSize: 15)
                        cell.lblPlace.textColor = .app
                        let rating = arrSearchResultes[indexPath.row].userRating ?? 0.0
                        let formattedRating = String(format: "%.1f", rating)
                        cell.lblrating.text = formattedRating
                        cell.lblTiming.text = business.name ?? ""
                        cell.lblTiming.font =  UIFont.systemFont(ofSize: 14)
                        cell.indexx = indexPath.row
                        cell.arrSearchBusiness = self.arrSearchResultes
                        cell.uiSet(load: true)
                        cell.isComing = false
                        cell.heightCollvwCategories.constant = 0
                        
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TempraryStoreTVC", for: indexPath) as! TempraryStoreTVC
                    cell.viewShadow.layer.masksToBounds = false
                    cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                    cell.viewShadow.layer.shadowOpacity = 0.44
                    cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.viewShadow.layer.shouldRasterize = true
                    cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
                    cell.viewShadow.layer.cornerRadius = 10
                    cell.viewImgVwBack.layer.masksToBounds = false
                    cell.viewImgVwBack.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                    cell.viewImgVwBack.layer.shadowOpacity = 0.44
                    cell.viewImgVwBack.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.viewImgVwBack.layer.shouldRasterize = true
                    cell.viewImgVwBack.layer.rasterizationScale = UIScreen.main.scale
                    cell.contentView.layer.cornerRadius = 10
                    let tempraryStore = arrSearchResultes[indexPath.row]
                    
                    cell.imgVwStore.imageLoad(imageUrl: tempraryStore.businessLogo ?? "")
                    cell.lblStoreName.text = tempraryStore.name ?? ""
                    if case let .userIDClass(userIDClass) = tempraryStore.userID {
                        if let name = userIDClass.name {
                            cell.lblUserName.text = name
                            
                        }
                    }
                    let rating = tempraryStore.userRating ?? 0.0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblrating.text = formattedRating
                    return cell
                    
                }
            }
        }
        
    }
    
    @objc func actionRemoveRecentSearch(sender: UIButton) {
        arrRecentSearch.remove(at: sender.tag)
        Store.SearchResult.remove(at: sender.tag)
        if arrRecentSearch.count == 0{
            sectionsData.remove(at: 0)
        }
        tblVwSearch.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sectionsData.count == 1{
            if sectionsData[indexPath.section] == "Recent Search"{
                
                return 35
            }else{
                guard indexPath.row < arrSearchResultes.count else {
                    return 0
                }
                if arrSearchResultes[indexPath.row].type == "business"{
                    return 120
                }else if arrSearchResultes[indexPath.row].type == "gig"{
                    return 100
                }else{
                    return 120
                }
            }
        }else{
            if indexPath.section == 0{
                if arrRecentSearch.count > 0{
                    return 35
                }else{
                    return 0
                }
                
            }else{
                
                guard indexPath.row < arrSearchResultes.count else {
                    return 0
                }
                if arrSearchResultes[indexPath.row].type == "business"{
                    return 120
                }else if arrSearchResultes[indexPath.row].type == "gig"{
                    return 100
                }else{
                    
                    return 120
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMoreDataIfNeeded(for: indexPath)
    }
    func loadMoreDataIfNeeded(for indexPath: IndexPath) {
        if indexPath.row == arrSearchResultes.count - 1 && !isLoading && offset < totalPages {
            isLoading = true
            offset += 1
            searchAllApi(search: true)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sectionsData.count == 1{
            if sectionsData[indexPath.section] == "Recent Search"{
                txtFldSearch.text =  arrRecentSearch[indexPath.row]
                searchText = arrRecentSearch[indexPath.row]
                offset = 1
                arrSearchResultes.removeAll()
                searchAllApi(search: true)
            }else{
                
                if arrSearchResultes.count > 0{
                    if arrSearchResultes[indexPath.row].type == "business"{
                        if !Store.SearchResult.contains(self.arrSearchResultes[indexPath.row].businessname ?? "") {
                                                 // Insert valueToInsert into Store.SearchResult
                          if Store.SearchResult.count >= 3 {
                             Store.SearchResult.removeLast()
                            }
                         Store.SearchResult.insert(self.arrSearchResultes[indexPath.row].businessname ?? "", at: 0)
                        }
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
                        vc.businessId = arrSearchResultes[indexPath.row].id ?? ""
                        Store.BusinessUserIdForReview = arrSearchResultes[indexPath.row].id ?? ""
                        vc.callBack = { index in
                            self.noSearchdata()
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else if arrSearchResultes[indexPath.row].type == "gig"{
                        if !Store.SearchResult.contains(self.arrSearchResultes[indexPath.row].title ?? "") {
                                                 // Insert valueToInsert into Store.SearchResult
                          if Store.SearchResult.count >= 3 {
                             Store.SearchResult.removeLast()
                            }
                         Store.SearchResult.insert(self.arrSearchResultes[indexPath.row].title ?? "", at: 0)
                        }
                       
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                        vc.gigId = arrSearchResultes[indexPath.row].id ?? ""
                        vc.callBack = {
                            self.noSearchdata()
                        }
                        Store.BusinessUserIdForReview = arrSearchResultes[indexPath.row].id ?? ""
                        
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        if !Store.SearchResult.contains(self.arrSearchResultes[indexPath.row].name ?? "") {
                                                 // Insert valueToInsert into Store.SearchResult
                          if Store.SearchResult.count >= 3 {
                             Store.SearchResult.removeLast()
                            }
                         Store.SearchResult.insert(self.arrSearchResultes[indexPath.row].name ?? "", at: 0)
                        }
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
//                        vc.popupId = arrSearchResultes[indexPath.row].id ?? ""
//                        vc.arrSearchResultes = arrSearchResultes
//                        Store.BusinessUserIdForReview = arrSearchResultes[indexPath.row].id ?? ""
//                        vc.callBack = { index in
//                            self.noSearchdata()
//                        }
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }else{
            
            if indexPath.section > 0{
                if arrSearchResultes.count > 0{
                    if arrSearchResultes[indexPath.row].type == "business"{
                        if !Store.SearchResult.contains(self.arrSearchResultes[indexPath.row].businessname ?? "") {
                            // Insert valueToInsert into Store.SearchResult
                            if Store.SearchResult.count >= 3 {
                                Store.SearchResult.removeLast()
                            }
                            Store.SearchResult.insert(self.arrSearchResultes[indexPath.row].businessname ?? "", at: 0)
                        }
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
                        vc.businessId = arrSearchResultes[indexPath.row].id ?? ""
                        Store.BusinessUserIdForReview = arrSearchResultes[indexPath.row].id ?? ""
                        vc.callBack = { index in
                            self.noSearchdata()
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else if arrSearchResultes[indexPath.row].type == "gig"{
                        if !Store.SearchResult.contains(self.arrSearchResultes[indexPath.row].title ?? "") {
                            // Insert valueToInsert into Store.SearchResult
                            if Store.SearchResult.count >= 3 {
                                Store.SearchResult.removeLast()
                            }
                            Store.SearchResult.insert(self.arrSearchResultes[indexPath.row].title ?? "", at: 0)
                        }
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyGigVC") as! ApplyGigVC
//                        vc.gigId = arrSearchResultes[indexPath.row].id ?? ""
//                        Store.BusinessUserIdForReview = arrSearchResultes[indexPath.row].id ?? ""
//                        vc.callBack = {
//                            self.noSearchdata()
//                        }
//                        self.navigationController?.pushViewController(vc, animated: true)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                        vc.gigId = arrSearchResultes[indexPath.row].id ?? ""
                        Store.BusinessUserIdForReview = arrSearchResultes[indexPath.row].id ?? ""
                        vc.callBack = {
                            self.noSearchdata()
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        if !Store.SearchResult.contains(self.arrSearchResultes[indexPath.row].name ?? "") {
                            // Insert valueToInsert into Store.SearchResult
                            if Store.SearchResult.count >= 3 {
                                Store.SearchResult.removeLast()
                            }
                            Store.SearchResult.insert(self.arrSearchResultes[indexPath.row].name ?? "", at: 0)
                        }
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpDeatilVC") as! PopUpDeatilVC
//                        vc.popupId = arrSearchResultes[indexPath.row].id ?? ""
//                        vc.arrSearchResultes = arrSearchResultes
//                        Store.BusinessUserIdForReview = arrSearchResultes[indexPath.row].id ?? ""
//                        vc.callBack = { index in
//                            self.noSearchdata()
//                        }
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }else{
                txtFldSearch.text =  arrRecentSearch[indexPath.row]
                              searchText = arrRecentSearch[indexPath.row]
                              offset = 1
                              arrSearchResultes.removeAll()
                              print("arrRecentSearch:-\(arrRecentSearch[indexPath.row])")
                              searchAllApi(search: true)
            }
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
    @objc func actionBookMark(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected != true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemoveBookMarkVC") as! RemoveBookMarkVC
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true)
        }
    }
    
}
// MARK: - UITextFieldDelegate
extension SearchVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newString.isEmpty {
            searchText = ""
            offset = 0
            sectionsData.removeAll()
            arrSearchResultes.removeAll()
            arrRecentSearch = Store.SearchResult
            
            if !arrRecentSearch.isEmpty{
                sectionsData.append("Recent Search")
            }
            tblVwSearch.reloadData()
        } else {
            searchText = newString
            offset = 1
            arrSearchResultes.removeAll()
            searchAllApi(search: true)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
