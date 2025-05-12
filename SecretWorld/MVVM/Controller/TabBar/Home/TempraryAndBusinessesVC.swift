//
//  TempraryAndBusinessesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 16/01/24.
//

import UIKit
import SkeletonView
class TempraryAndBusinessesVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var txtFldSearch: UITextField!
    @IBOutlet var tblVw: UITableView!
    @IBOutlet var lblScreenTitle: UILabel!
    //MARK: - VARIABLES
    var isSelect = 0
    var arrBusiness = [Businessss]()
    var viewModel = ExploreVM()
    var currentDay:String?
    var offset = 1
    var limit = 10
    var datassss = 0
    var businessName = ""
    var popupName = ""
    var loadData = false
    var totalPages = 0
    var isLoading = false
    var viewModelPopup = PopUpVM()
    var arrTempraryStores = [GetAllPopupsData]()
    var currentLat:Double?
    var currentLong:Double?
    var callBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)

        uiSet()
    }
    @objc func handleSwipe() {
        callBack?()
        self.navigationController?.popViewController(animated: true)
         }

    func uiSet(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        currentDay = dateFormatter.string(from: Date())
        tblVw.showsVerticalScrollIndicator = false
        if isSelect == 0{
            lblScreenTitle.text = "Businesses"
            let nibNearBy = UINib(nibName: "BusinessesTVC", bundle: nil)
            tblVw.register(nibNearBy, forCellReuseIdentifier: "BusinessesTVC")
            tblVw.showsVerticalScrollIndicator = false
            arrBusiness.removeAll()
            GetAllBusinessApi(showLoader: true, search: true)
            
        }else{
            let nibNearBy = UINib(nibName: "TempraryStoreTVC", bundle: nil)
            tblVw.register(nibNearBy, forCellReuseIdentifier: "TempraryStoreTVC")
            lblScreenTitle.text = "Temporary Stores"
            arrTempraryStores.removeAll()
            GetAllTempraryStoresApi(showLoader: true, search: true)
            
        }
    }
    func GetAllBusinessApi(showLoader: Bool, search: Bool) {
        if search {
            arrBusiness.removeAll()
        }
        viewModel.GetAllBusinessApi(offset: offset, limit: limit, Businessname: businessName, latitude: currentLat ?? 0.0, longitude: currentLong ?? 0.0, hideHud: showLoader) { data in
            self.totalPages = data?.totalPages ?? 0
            let newBusinesses = data?.business ?? []
            for business in newBusinesses {
                if !self.arrBusiness.contains(where: { $0.id == business.id }) {
                    self.arrBusiness.append(business)
                }
            }
            self.isLoading = false
            if self.arrBusiness.isEmpty {
                self.lblNoData.text = "Data Not Found!"
            } else {
                self.lblNoData.text = ""
            }
            self.tblVw.reloadData()
        }
    }

    func GetAllTempraryStoresApi(showLoader: Bool, search: Bool) {
        if search {
            arrTempraryStores.removeAll()
            //offset = 1
        }
        viewModelPopup.getAllPopupApi(offset: offset, limit: limit, name: popupName, loader: showLoader) { data in
            self.totalPages = data?.totalPages ?? 0
            //self.arrTempraryStores = data?.data ?? []
            let newStores = data?.data ?? []
            for store in newStores {
                if !self.arrTempraryStores.contains(where: { $0.id == store.id }) {
                    self.arrTempraryStores.append(store)
                }
            }
            self.isLoading = false
            if self.arrTempraryStores.isEmpty {
                self.lblNoData.text = "Data Not Found!"
            } else {
                self.lblNoData.text = ""
            }
            self.tblVw.reloadData()
        }
    }

    //MARK: - BUTTON ACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        callBack?()
        self.navigationController?.popViewController(animated: true)
       
    }
}
//MARK: -UITableViewDelegate
extension TempraryAndBusinessesVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelect == 0{
            if arrBusiness.count > 0{
                return arrBusiness.count
            }else{
                return 0
            }
        }else{
            if arrTempraryStores.count > 0{
                return arrTempraryStores.count
            }else{
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSelect == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessesTVC", for: indexPath) as! BusinessesTVC
            cell.viewShadow.layer.masksToBounds = false
            cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
            cell.viewShadow.layer.shadowOpacity = 0.44
            cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewShadow.layer.shouldRasterize = true
            cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
            cell.viewShadow.layer.cornerRadius = 10
            cell.contentView.layer.cornerRadius = 10
            if arrBusiness.count > 0{
                let business = arrBusiness[indexPath.row]
                cell.imgVwService.imageLoad(imageUrl: business.profilePhoto ?? "")
                cell.lblBusinessName.text = business.businessname ?? ""
                cell.lblPlace.text = business.place ?? ""
                let rating = arrBusiness[indexPath.row].userRating ?? 0.0
                let formattedRating = String(format: "%.1f", rating)
                cell.lblrating.text = formattedRating
                cell.isComing = true
                cell.indexx = indexPath.row
                cell.arrBusiness = self.arrBusiness
                cell.uiSet(load: true)
                var openingHoursFound = false
                for openingHour in business.openingHours ?? [] {
                    if openingHour.day == currentDay {
                        openingHoursFound = true
                        let startTime12 = convertTo12HourFormat(openingHour.starttime ?? "")
                        let endTime12 = convertTo12HourFormat(openingHour.endtime ?? "")
                        cell.lblTiming.text = "\(startTime12) - \(endTime12)"
                        break
                    }
                }
                if !openingHoursFound {
                    cell.lblTiming.text = "Closed"
                }
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
            if arrTempraryStores.count > 0{
                cell.imgVwStore.imageLoad(imageUrl: arrTempraryStores[indexPath.row].businessLogo ?? "")
                cell.lblStoreName.text = arrTempraryStores[indexPath.row].name ?? ""
                cell.lblUserName.text = arrTempraryStores[indexPath.row].user ?? ""
                let rating = arrTempraryStores[indexPath.row].rating ?? 0.0
                let formattedRating = String(format: "%.1f", rating)
                cell.lblrating.text = formattedRating
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMoreDataIfNeeded(for: indexPath)
    }
    func loadMoreDataIfNeeded(for indexPath: IndexPath) {
        // Check if the last cell is about to be displayed
        if isSelect == 0{
            if indexPath.row == arrBusiness.count - 1 && !isLoading && offset < totalPages {
                isLoading = true
                offset += 1
                GetAllBusinessApi(showLoader: false, search: false)
            }
        }else{
            if indexPath.row == arrTempraryStores.count - 1 && !isLoading && offset < totalPages {
                isLoading = true
                offset += 1
                GetAllTempraryStoresApi(showLoader: false, search: false)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelect == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
            if arrBusiness.count > 0{
                vc.businessId = arrBusiness[indexPath.row].id ?? ""
                Store.BusinessUserIdForReview = arrBusiness[indexPath.row].id ?? ""
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
            if arrTempraryStores.count > 0{
                vc.popupId = arrTempraryStores[indexPath.row].id ?? ""
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSelect == 0{
            return 110
        }else{
            return 120
        }
    }
}
extension TempraryAndBusinessesVC {
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
//MARK: - TEXTFIELD DELEGATES
extension TempraryAndBusinessesVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let isEmpty = newString.isEmpty
        
        if isSelect == 0 {
            businessName = isEmpty ? "" : newString
            GetAllBusinessApi(showLoader: false, search: !isEmpty)
        } else {
            popupName = isEmpty ? "" : newString
            GetAllTempraryStoresApi(showLoader: false, search: !isEmpty)
        }
        
        offset = 1
        arrBusiness.removeAll()
        
        return true
    }

    // Handles return key press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let searchText = textField.text, !searchText.isEmpty {
            if isSelect == 0 {
                businessName = searchText
                GetAllBusinessApi(showLoader: false, search: true)
            } else {
                popupName = searchText
                GetAllTempraryStoresApi(showLoader: false, search: true)
            }
        }
        
        return true
    }
}
