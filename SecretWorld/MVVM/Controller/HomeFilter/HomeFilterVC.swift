//
//  HomeFilterVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 16/12/24.
//

//  HomeFilterVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 16/12/24.
//

import UIKit
import RangeUISlider
import RangeSeekSlider

class HomeFilterVC: UIViewController {

    @IBOutlet weak var tblVwFilter: UITableView!
    @IBOutlet weak var vwApply: UIView!
  
    private var arrGigFilter = [String]()
    private var arrFilterImg = [String]()

 
    
    var callBack: ((_ radius: Int) -> ())?
    var type:Int = 0
    var lat:Double = 0.0
    var long:Double = 0.0
    var gigType = 0
    var gigCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
   
        if type == 1{
            
            arrGigFilter.append("Distance")
            arrGigFilter.append("Price")
            arrGigFilter.append("Completion Time")
            
            arrFilterImg.append("distance")
            arrFilterImg.append("price")
            arrFilterImg.append("completion")
        }else if type == 2{
            arrGigFilter.append("Popularity")
//            arrGigFilter.append("Ending Soonest")
            arrGigFilter.append("Distance")
            
            arrFilterImg.append("popularity")
//            arrFilterImg.append("endingSoon")
            arrFilterImg.append("distance")
        }else{
            arrGigFilter.append("Distance")
            arrGigFilter.append("Deals")
            arrGigFilter.append("Rating")
            
            arrFilterImg.append("distance")
            arrFilterImg.append("deals")
            arrFilterImg.append("rating")
        }
    }
    
    private func setupTableView() {
        tblVwFilter.delegate = self
        tblVwFilter.dataSource = self
        tblVwFilter.estimatedRowHeight = 50
        tblVwFilter.rowHeight = UITableView.automaticDimension
        tblVwFilter.reloadData()
     
    }
    
    func setGigFilter() {
   
            switch (isSelectGigPrice, isSelectGigTime) {
            case (false, false):
                print("false", "false")
                if Store.GigType == 0 || Store.GigType == 1{
                   
                    let param = ["userId": Store.userId ?? "",
                                 "lat": lat,
                                 "long": long,
                                 "type":type,
                                 "gigType":Store.GigType ?? 0,
                                 "radius": radius] as [String: Any]
                    print("Param----", param)
                    SocketIOManager.sharedInstance.home(dict: param)
                    Store.filterData = ["radius":radius]
                }else{
                    let param = ["userId": Store.userId ?? "",
                                 "lat": lat,
                                 "long": long,
                                 "type":type,
                                 "radius": radius] as [String: Any]
                    print("Param----", param)
                    SocketIOManager.sharedInstance.home(dict: param)
                    Store.filterData = ["radius":radius]
                }
            case (true, false):
                print("true", "false")
                if Store.GigType == 0 || Store.GigType == 1{
                    let param = ["userId": Store.userId ?? "",
                                 "lat": lat,
                                 "long": long,
                                 "type":type,
                                 "gigType":Store.GigType ?? 0,
                                 "radius": radius,
                                 "price_min":minPrice,"price_max":maxPrice] as [String: Any]
                    print("Param----", param)
                    SocketIOManager.sharedInstance.home(dict: param)
                    Store.filterData = ["price_min":minPrice,"price_max":maxPrice,"radius":radius]
                }else{
                    let param = ["userId": Store.userId ?? "",
                                 "lat": lat,
                                 "long": long,
                                 "type":type,
                                 "radius": radius,
                                 "price_min":minPrice,"price_max":maxPrice] as [String: Any]
                    print("Param----", param)
                    SocketIOManager.sharedInstance.home(dict: param)
                    Store.filterData = ["price_min":minPrice,"price_max":maxPrice,"radius":radius]
                }
            case (false, true):
                print("false", "true")
                if Store.GigType == 0 || Store.GigType == 1{
                    
                    let param = ["userId": Store.userId ?? "",
                                 "lat": lat,
                                 "long": long,
                                 "type":type,
                                 "gigType":Store.GigType ?? 0,
                                 "radius": radius,
                                 "minHours":minTime,
                                 "maxHours":maxTime] as [String: Any]
                    print("Param----", param)
                    SocketIOManager.sharedInstance.home(dict: param)
                    Store.filterData = ["minHours":minTime,"maxHours":maxTime,"radius":radius]
                }else{
                    let param = ["userId": Store.userId ?? "",
                                 "lat": lat,
                                 "long": long,
                                 "type":type,
                                 "radius": radius,
                                 "minHours":minTime,
                                 "maxHours":maxTime] as [String: Any]
                    print("Param----", param)
                    SocketIOManager.sharedInstance.home(dict: param)
                    Store.filterData = ["minHours":minTime,"maxHours":maxTime,"radius":radius]
                }
            case (true, true):
                print("true", "true")
                if Store.GigType == 0 || Store.GigType == 1{
                    let param = ["userId": Store.userId ?? "",
                                 "lat": lat,
                                 "long": long,
                                 "type":type,
                                 "gigType":Store.GigType ?? 0,
                                 "radius": radius,
                                 "minHours":minTime,
                                 "maxHours":maxTime,"price_min":minPrice,"price_max":maxPrice] as [String: Any]
                    print("Param----", param)
                    SocketIOManager.sharedInstance.home(dict: param)
                    Store.filterData = ["minHours":minTime,"maxHours":maxTime,"price_min":minPrice,"price_max":maxPrice,"radius":radius]
                }else{
                    let param = ["userId": Store.userId ?? "",
                                 "lat": lat,
                                 "long": long,
                                 "type":type,
                                 "radius": radius,
                                 "minHours":minTime,
                                 "maxHours":maxTime,"price_min":minPrice,"price_max":maxPrice] as [String: Any]
                    print("Param----", param)
                    SocketIOManager.sharedInstance.home(dict: param)
                    Store.filterData = ["minHours":minTime,"maxHours":maxTime,"price_min":minPrice,"price_max":maxPrice,"radius":radius]
                }
            }
    }
    
    func setPopUpFilter() {
   
        switch (isSelectPopularity,isSelectEndingSoon) {
            case (false, false):
                print("false", "false")
              
                let param = ["userId": Store.userId ?? "",
                             "lat": lat,
                             "long": long,
                             "type":type,
                             "radius": radius] as [String: Any]
                print("Param----", param)
            SocketIOManager.sharedInstance.home(dict: param)
            Store.filterDataPopUp = ["radius":radius]
            case (true, false):
                print("true", "false")
            let param = ["userId": Store.userId ?? "",
                         "lat": lat,
                         "long": long,
                         "type":type,
                         "radius": radius,
                         "popularity":popularity] as [String: Any]
            print("Param----", param)
            SocketIOManager.sharedInstance.home(dict: param)
            Store.filterDataPopUp = ["popularity":popularity,"radius":radius]
            case (false, true):
                print("false", "true")
            let param = ["userId": Store.userId ?? "",
                         "lat": lat,
                         "long": long,
                         "type":type,
                         "radius": radius,
                         "endingSoon":endingSoon] as [String: Any]
            print("Param----", param)
            SocketIOManager.sharedInstance.home(dict: param)
            Store.filterDataPopUp = ["endingSoon":endingSoon,"radius":radius]
            case (true, true):
                print("true", "true")
            let param = ["userId": Store.userId ?? "",
                         "lat": lat,
                         "long": long,
                         "type":type,
                         "radius": radius,
                         "popularity":popularity,
                         "endingSoon":endingSoon] as [String: Any]
            print("Param----", param)
            SocketIOManager.sharedInstance.home(dict: param)
            Store.filterDataPopUp = ["popularity":popularity,"endingSoon":endingSoon,"radius":radius]
            }
    }
    func setBusinessFilter(){
        switch (isSelectDealing,isSelectRating) {
            case (false, false):
            print("false", "false")
            let param = ["userId": Store.userId ?? "",
                         "lat": lat,
                         "long": long,
                         "type":type,
                         "radius": radius] as [String: Any]
            print("Param----", param)
            SocketIOManager.sharedInstance.home(dict: param)
            Store.filterDataBusiness = ["radius":radius]
            
            case (true, false):
            print("true", "false")
            let param = ["userId": Store.userId ?? "",
                         "lat": lat,
                         "long": long,
                         "type":type,
                         "radius": radius,
                         "minDeal":minDeal,
                         "maxDeal":maxDeal] as [String: Any]
            print("Param----", param)
            SocketIOManager.sharedInstance.home(dict: param)
            Store.filterDataBusiness = ["minDeal":minDeal,"maxDeal":maxDeal,"radius":radius]
            
            case (false, true):
                print("false", "true")
            let param = ["userId": Store.userId ?? "",
                         "lat": lat,
                         "long": long,
                         "type":type,
                         "radius": radius,
                         "rating":rating] as [String: Any]
            print("Param----", param)
            SocketIOManager.sharedInstance.home(dict: param)
            Store.filterDataBusiness = ["rating":rating,"radius":radius]
            
            case (true, true):
                print("true", "true")
            let param = ["userId": Store.userId ?? "",
                         "lat": lat,
                         "long": long,
                         "type":type,
                         "radius": radius,
                         "minDeal":minDeal,
                         "maxDeal":maxDeal,"rating":rating] as [String: Any]
            print("Param----", param)
            SocketIOManager.sharedInstance.home(dict: param)
            Store.filterDataBusiness = ["minDeal":minDeal,"maxDeal":maxDeal,"rating":rating,"radius":radius]
            
            }
    }
   
    @IBAction func actionReset(_ sender: UIButton) {
        if type == 1{
            isSelectGigTime = false
            isSelectGigPrice = false
            isSelectGigTime = false
            isSelectGigPrice = false
            Store.filterData = ["minHours":1,"maxHours":24,"price_min":1,"price_max":10000,"radius":50]
            Store.isSelectGigFilter = false
        }else if type == 2{
            isSelectPopularity = false
            isSelectEndingSoon = false
            isSelectPopularity = false
            isSelectEndingSoon = false
            Store.filterDataPopUp = ["popularity":1,"endingSoon":1,"radius":50]
            Store.isSelectPopUpFilter = false
        }else{
            isSelectDealing = false
            isSelectRating = false
            isSelectDealing = false
            isSelectRating = false
            Store.filterDataBusiness = ["minDeal":1,"maxDeal":100,"rating":0,"radius":50]
            Store.isSelectBusinessFilter = false
        }
      
        
        tblVwFilter.reloadData()
        dismiss(animated: false)
        callBack?(radius)
    }
    @IBAction func actionCross(_ sender: UIButton) {
        isSelectGigTime = false
        isSelectGigPrice = false
        isSelectPopularity = false
        isSelectEndingSoon = false
        isSelectDealing = false
        isSelectRating = false
        dismiss(animated: false)
        callBack?(radius)
    }
    @IBAction func actionApply(_ sender: UIButton) {
      
        print(radius)
        if type == 1{
            callBack?(radius)
            setGigFilter()
           
            Store.isSelectGigFilter = true
        }else if type == 2{
            callBack?(radius)
            setPopUpFilter()
            Store.isSelectPopUpFilter = true
        }else{
            callBack?(radius)
            setBusinessFilter()
            Store.isSelectBusinessFilter = true
        }
        dismiss(animated: false)
        callBack?(radius)
    }
}
// MARK: - UITableViewDelegate & UITableViewDataSource
extension HomeFilterVC: UITableViewDelegate, UITableViewDataSource,RangeSeekSliderDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGigFilter.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFilterTVC", for: indexPath) as? HomeFilterTVC else {
            return UITableViewCell()
        }
       
        cell.lblTitle.text = arrGigFilter[indexPath.row]
        cell.imgVwDropdown.image = UIImage(named: arrFilterImg[indexPath.row])
        cell.uiSet()
        if type == 1{
            if indexPath.row == 0{
                cell.singleSlider.minimumValue = 50
                cell.singleSlider.maximumValue = 1000
                
                cell.singleSlider.currentValue = Float(Store.filterData?["radius"] as? Int ?? 50)
                cell.singleSlider.thumbLabel.text = "\(Store.filterData?["radius"] as? Int ?? 50)Km"
                cell.singleSlider.index = 0
                cell.singleSlider.type = type
                cell.doubleThumbVw.isHidden = true
                cell.singleThumbVw.isHidden = false
                cell.popularVw.isHidden = true
            }else if indexPath.row == 1{
                cell.doubleSlider.minValue = 50
                cell.doubleSlider.maxValue = 10000
                cell.doubleSlider.lowerValue = CGFloat(Store.filterData?["price_min"] as? Int ?? 1)
                cell.doubleSlider.upperValue = CGFloat(Store.filterData?["price_max"] as? Int ?? 10000)
                cell.doubleSlider.index = 1
                cell.doubleSlider.type = type
                
                cell.doubleThumbVw.isHidden = false
                cell.singleThumbVw.isHidden = true
                cell.popularVw.isHidden = true
            }else{
                cell.doubleSlider.index = 2
                cell.doubleSlider.type = type
                cell.doubleSlider.minValue = 1
                cell.doubleSlider.maxValue = 24
                cell.doubleSlider.lowerValue = CGFloat(Store.filterData?["minHours"] as? Int ?? 1)
                cell.doubleSlider.upperValue = CGFloat(Store.filterData?["maxHours"] as? Int ?? 24)
              
                cell.doubleThumbVw.isHidden = false
                cell.singleThumbVw.isHidden = true
                cell.popularVw.isHidden = true
            }
        }else if type == 2{
            if indexPath.row == 0{
                cell.doubleThumbVw.isHidden = true
                cell.singleThumbVw.isHidden = true
                cell.popularVw.isHidden = false
                cell.isSelectIndex = (Store.filterDataPopUp?["popularity"] as? Int ?? 1) - 1
                cell.uiSet()
                cell.callBacK = { index in
                    cell.isSelectIndex = index
                    cell.uiSet()
                }
//            }else if indexPath.row == 1{
//                cell.doubleThumbVw.isHidden = true
//                cell.singleThumbVw.isHidden = false
//                cell.popularVw.isHidden = true
//                cell.singleSlider.thumbLabel.text = "\(Store.filterDataPopUp?["endingSoon"] as? Int ?? 1) Hour"
//                cell.singleSlider.minimumValue = 1
//                cell.singleSlider.maximumValue = 24
//                cell.singleSlider.currentValue = (Float(CGFloat(Store.filterDataPopUp?["endingSoon"] as? Int ?? 0)))
//                cell.singleSlider.index = 1
//                cell.singleSlider.type = type
                
            }else{
                cell.doubleThumbVw.isHidden = true
                cell.singleThumbVw.isHidden = false
                cell.popularVw.isHidden = true
                cell.singleSlider.thumbLabel.text = "\(Store.filterDataPopUp?["radius"] as? Int ?? 50)Km"
                cell.singleSlider.minimumValue = 50
                cell.singleSlider.maximumValue = 1000
                cell.singleSlider.currentValue = Float(Store.filterDataPopUp?["radius"] as? Int ?? 50)
                cell.singleSlider.index = 2
                cell.singleSlider.type = type
            }
        }else{
            if indexPath.row == 0{
                cell.doubleThumbVw.isHidden = true
                cell.singleThumbVw.isHidden = false
                cell.popularVw.isHidden = true
                cell.singleSlider.thumbLabel.text = "\(Store.filterDataBusiness?["radius"] as? Int ?? 50)Km"
                cell.singleSlider.minimumValue = 50
                cell.singleSlider.maximumValue = 1000
                cell.singleSlider.currentValue = Float(Store.filterDataBusiness?["radius"] as? Int ?? 50)
                cell.singleSlider.index = 0
                cell.singleSlider.type = type
            }else if indexPath.row == 1{
                cell.doubleThumbVw.isHidden = false
                cell.singleThumbVw.isHidden = true
                cell.popularVw.isHidden = true
                cell.doubleSlider.minValue = 1
                cell.doubleSlider.maxValue = 100
                cell.doubleSlider.lowerValue = CGFloat(Store.filterDataBusiness?["minDeal"] as? Int ?? 1)
                cell.doubleSlider.upperValue = CGFloat(Store.filterDataBusiness?["maxDeal"] as? Int ?? 100)
                cell.doubleSlider.index = 1
                cell.doubleSlider.type = type
            }else{
                cell.doubleThumbVw.isHidden = true
                cell.singleThumbVw.isHidden = false
                cell.popularVw.isHidden = true
                cell.singleSlider.thumbLabel.text = "\(Store.filterDataBusiness?["rating"] as? Int ?? 0)Star"
                cell.singleSlider.minimumValue = 0
                cell.singleSlider.maximumValue = 5
                cell.singleSlider.currentValue = Float(Store.filterDataBusiness?["rating"] as? Int ?? 0)
                cell.singleSlider.index = 2
                cell.singleSlider.type = type
            }
        }
        return cell
    }
   
}
