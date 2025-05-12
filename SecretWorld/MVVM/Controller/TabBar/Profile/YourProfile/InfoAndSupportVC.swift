//
//  InfoAndSupportVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/25.
//

import UIKit

class InfoAndSupportVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var tblVwInfo: UITableView!
    
    var arrProfile = [ProfileData]()
    var isComing = false
    var arrBank = [BankAccountDetailData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        if isComing{
            lblTitle.text = "Info & Support"
            arrProfile.append(ProfileData(title: "Help Center", img: "Help Center"))
            arrProfile.append(ProfileData(title: "Contact us", img: "Contact us"))
            arrProfile.append(ProfileData(title: "About us", img: "About us"))
            arrProfile.append(ProfileData(title: "Privacy Policy", img: "Privacy Policy"))
        }else{
            lblTitle.text = "Finance"
            arrProfile.append(ProfileData(title: "Wallet", img: "wallet"))
            arrProfile.append(ProfileData(title: "Bank", img: "bank"))
            arrProfile.append(ProfileData(title: "Transaction history", img: "transaction"))
        }
        
        tblVwInfo.reloadData()
    }
    @objc func handleSwipe() {
               navigationController?.popViewController(animated: true)
           }

    @IBAction func actionBackl(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE

extension InfoAndSupportVC: UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrProfile.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoAndSupportTVC", for: indexPath) as! InfoAndSupportTVC
        cell.imgVwTitle.image = UIImage(named: arrProfile[indexPath.row].img ?? "")
        cell.lbltitle.text = arrProfile[indexPath.row].title ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isComing{
            switch indexPath.row {
            case 0:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpCenterVC") as! HelpCenterVC
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                vc.isComing = 0
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                vc.isComing = 1
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                
                break
            }
        }else{
            switch indexPath.row {
            case 0:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
                isAddFunds = false
                vc.isComing = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                if arrBank.count > 0{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BankVC") as! BankVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBankVC") as! AddBankVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            case 2:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistoryVC") as! TransactionHistoryVC
               
                self.navigationController?.pushViewController(vc, animated: true)
     
            default:
                
                break
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
}
