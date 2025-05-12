//
//  SpecialOfferVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/02/25.
//

import UIKit

class SpecialOfferVC: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet var tblVwList: UITableView!
    
    // MARK: - variables
    var arrList = ["Promo code","Deals","Membership"]
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    private func uiSet(){
        let nibReiew = UINib(nibName: "SpecialOfferTVC", bundle: nil)
        tblVwList.register(nibReiew, forCellReuseIdentifier: "SpecialOfferTVC")
        tblVwList.reloadData()
    }

    // MARK: - IBAction
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: -UITableViewDelegate
extension SpecialOfferVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialOfferTVC", for: indexPath) as! SpecialOfferTVC
        cell.lblTitle.text = arrList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPromoVC") as! VerifyPromoVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DealVC") as! DealVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MembershipListVC") as! MembershipListVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
}


