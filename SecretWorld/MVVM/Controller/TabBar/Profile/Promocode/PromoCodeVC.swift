//
//  PromoCodeVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/01/24.
//

import UIKit

class PromoCodeVC: UIViewController {
    
    @IBOutlet var lblNodata: UILabel!
    @IBOutlet var tblVwList: UITableView!
    
    var arrPromoCodes = [GetUserPromoCodeData]()
    var viewModel = PromoCodeVM()
    var currentDateForPromo = String()
    var expiryDate = Date()
    var currentDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)

        let nibNearBy = UINib(nibName: "PromoCodeTVC", bundle: nil)
        tblVwList.register(nibNearBy, forCellReuseIdentifier: "PromoCodeTVC")
        tblVwList.showsVerticalScrollIndicator = false
        getCurrentDate()
        getPromoCodesApi()
    }
    @objc func handleSwipe() {
               navigationController?.popViewController(animated: true)
           }

    func getPromoCodesApi(){
        viewModel.GetUserPromoCodeListApi { data in
            self.arrPromoCodes = data ?? []
            if self.arrPromoCodes.count > 0{
                self.lblNodata.isHidden = true
            }else{
                self.lblNodata.isHidden = false
            }
            self.tblVwList.reloadData()
        }
        
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: -UITableViewDelegate
extension PromoCodeVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrPromoCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCodeTVC", for: indexPath) as! PromoCodeTVC
        cell.lblPromoOff.text = "\(arrPromoCodes[indexPath.row].discount ?? 0)%"
        cell.lblPromoCode.text = arrPromoCodes[indexPath.row].promoCode
        if arrPromoCodes[indexPath.row].status == 1{
            //used
            if let formattedDate = formatDate(dateString: arrPromoCodes[indexPath.row].updatedAt ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: "dd MMM yyyy") {
                cell.lblExpiryDate.text = "Used on \(formattedDate)"
            }
            cell.viewShadow.isHidden = false
            cell.viewPromoStatus.backgroundColor = UIColor(hex: "#CACACA")
            cell.imgVwPromoStatus.image = UIImage(named: "used")
            cell.viewBack.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 0.27)
        }else{
            if let formatDate = arrPromoCodes[indexPath.row].expiryTime {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                if let expiredDate = dateFormatter.date(from: formatDate) {
                    expiryDate = expiredDate
                    
                    if expiryDate > currentDate {
                        // Can use
                        cell.viewShadow.isHidden = true
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        let expiryDateString = dateFormatter.string(from: expiryDate)
                        cell.lblExpiryDate.text = "Expire on \(expiryDateString)"
                        cell.viewPromoStatus.backgroundColor = UIColor(hex: "#3E9C35")
                        cell.imgVwPromoStatus.image = UIImage(named: "canuse")
                        cell.btnCopy.tag = indexPath.row
                        cell.btnCopy.addTarget(self, action: #selector(actionCopy), for: .touchUpInside)
                    } else {
                        // Expired
                        cell.viewShadow.isHidden = false
                        cell.viewShadow.backgroundColor = UIColor(red: 254/255, green: 227/255, blue: 227/255, alpha: 0.38)
                        cell.lblExpiryDate.text = "Expired"
                        cell.viewPromoStatus.backgroundColor = UIColor(hex: "#E5E5E5")
                        cell.imgVwPromoStatus.image = UIImage(named: "expired")
                    }
                }
            }
            
            
            
            
        }
        return cell
    }
    @objc func actionCopy(sender:UIButton){
        let cell = tblVwList.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! PromoCodeTVC
        UIPasteboard.general.string =  cell.lblPromoCode.text
        showSwiftyAlert("", "Copied promo code", true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func getCurrentDate(){
        var currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = dateFormatter.string(from: currentDate)
        currentDateForPromo = dateString
        
    }
    func formatDate(dateString: String, inputFormat: String, outputFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
}
