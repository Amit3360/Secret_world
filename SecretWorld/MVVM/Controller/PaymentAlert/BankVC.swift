//
//  BankVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/09/24.
//

import UIKit

class BankVC: UIViewController {

    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var tblVwBankList: UITableView!
   
    var viewModel = PaymentVM()
    var arrBank = [BankAccountDetailData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        tblVwBankList.showsVerticalScrollIndicator = false
        
        let nibNearBy = UINib(nibName: "BankDetailTVC", bundle: nil)
        tblVwBankList.register(nibNearBy, forCellReuseIdentifier: "BankDetailTVC")
        
    }
    @objc func handleSwipe() {
              navigationController?.popViewController(animated: true)
          }

    override func viewWillAppear(_ animated: Bool) {
        getBankDetails()
    }
    func getBankDetails(){
        viewModel.getBankDetailsApi { data in
            self.arrBank = data?.data ?? []
            if self.arrBank.count > 0{
                self.lblNoData.isHidden = true
            }else{
                WebService.hideLoader()
                self.lblNoData.isHidden = false
            }
            self.tblVwBankList.reloadData()
        }
    }
    @IBAction func actionAdd(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBankVC") as! AddBankVC
        vc.isComing = false
        vc.bankListCount = arrBank.count
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
//MARK: -UITableViewDelegate
extension BankVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrBank.count > 0{
            return arrBank.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BankDetailTVC", for: indexPath) as! BankDetailTVC
            cell.viewBack.layer.masksToBounds = false
            cell.viewBack.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
            cell.viewBack.layer.shadowOpacity = 0.44
            cell.viewBack.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewBack.layer.shouldRasterize = true
            cell.viewBack.layer.rasterizationScale = UIScreen.main.scale
            cell.viewBack.layer.cornerRadius = 10
            cell.contentView.layer.cornerRadius = 10
        cell.btnDefault.tag = indexPath.row
        cell.btnDefault.addTarget(self, action: #selector(actionDefault), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(actionDelete), for: .touchUpInside)
        cell.lblBankName.text = arrBank[indexPath.row].bankName ?? ""
        cell.lblAccountNumber.text = "********\(arrBank[indexPath.row].last4 ?? "")"
        cell.lblRoutingNumber.text = arrBank[indexPath.row].routingNumber ?? ""
        if arrBank[indexPath.row].defaultForCurrency == true{
            cell.lblDefault.text = "Default"
            cell.btnDelete.isHidden = true
            cell.btnDefault.isSelected = true
        }else{
            cell.lblDefault.text = "Set as default"
            cell.btnDelete.isHidden = false
            cell.btnDefault.isSelected = false
        }
        return cell
        
    }
    @objc func actionDefault(sender:UIButton){
        if arrBank[sender.tag].defaultForCurrency == false{
            viewModel.DefaultBankApi(bankAccountId: arrBank[sender.tag].id ?? "") { message in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                vc.modalPresentationStyle = .overFullScreen
                vc.isSelect = 10
                vc.message = message
                vc.callBack = {[weak self] in
                    guard let self = self else { return }
                    self.getBankDetails()
                }
                self.navigationController?.present(vc, animated: false)
            }
        }
    }
    
    @objc func actionDelete(sender:UIButton){
       
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelGigVC") as! CancelGigVC
            vc.isSelect = 3
        vc.bankId = arrBank[sender.tag].id ?? ""
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = { [weak self] message in
            guard let self = self else { return }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
            vc.modalPresentationStyle = .overFullScreen
            vc.isSelect = 10
            vc.message = message
            vc.callBack = { [weak self] in
                guard let self = self else { return }
                self.getBankDetails()
            }
            self.navigationController?.present(vc, animated: false)
            
        }
            self.navigationController?.present(vc, animated: false)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
}
