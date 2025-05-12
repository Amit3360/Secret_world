//
//  DealVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 01/04/25.
//

import UIKit
class DealVC: UIViewController {
  // MARK: - outlets
  @IBOutlet weak var lblDataFound: UILabel!
  @IBOutlet var tblVwDealsList: UITableView!
  @IBOutlet weak var btnAdd: UIButton!
  // MARK: - variables
  var viewModel = DealsVM()
  var arrDeal = [GetDealsData]()
  var viewModelService = AddServiceVM()
  var arrService = [ServiceDetail]()
  var arrServiceId = [String]()
  var status = 0
  // MARK: - view life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    uiSet()
    getService()
  }
  private func getService(){
    print(Store.authKey ?? "")
    viewModelService.getAllService(loader: false, offSet: 1, limit: 100) { data in
      if data?.service?.count ?? 0 > 0{
          self.btnAdd.isHidden = false
      }else{
          self.btnAdd.isHidden = true
      }
      self.arrService = data?.service ?? []
    }
  }
  private func uiSet(){
    let nibReiew = UINib(nibName: "DealTVC", bundle: nil)
    tblVwDealsList.register(nibReiew, forCellReuseIdentifier: "DealTVC")
    getDealsApi()
  }
  private func getDealsApi(){
      lblDataFound.isHidden = true
    viewModel.getDealsApi { data in
      self.arrDeal = data ?? []
      self.tblVwDealsList.estimatedRowHeight = 150
      self.tblVwDealsList.rowHeight = UITableView.automaticDimension
      self.tblVwDealsList.reloadData()
      if data?.count ?? 0 > 0{
        self.lblDataFound.isHidden = true
      }else{
        self.lblDataFound.isHidden = false
      }
    }
  }
  // MARK: - IBAction
  @IBAction func actionBack(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  @IBAction func actionAddDeal(_ sender: UIButton) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddDealVC") as! AddDealVC
    vc.arrService = self.arrService
    vc.callBack = { (message) in
      showSwiftyAlert("", message ?? "", true)
      self.arrDeal.removeAll()
      self.getDealsApi()
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
//MARK: -UITableViewDelegate
extension DealVC: UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrDeal.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DealTVC", for: indexPath) as! DealTVC
    for i in arrDeal[indexPath.row].bUserServicesIds ?? []{
      self.arrServiceId.append(i.id ?? "")
    }
    cell.lblTitle.text = arrDeal[indexPath.row].title ?? ""
    if arrDeal[indexPath.row].status == 1{
      cell.btnSwitch.isSelected = true
    }else{
      cell.btnSwitch.isSelected = false
    }
    cell.arrService = arrDeal[indexPath.row].bUserServicesIds ?? []
    cell.uiSet()
    cell.btnDelete.addTarget(self, action: #selector(deleteDeal), for: .touchUpInside)
    cell.btnDelete.tag = indexPath.row
    cell.btnEdit.addTarget(self, action: #selector(editDeal), for: .touchUpInside)
    cell.btnEdit.tag = indexPath.row
    cell.btnSwitch.addTarget(self, action: #selector(updateStatus), for: .touchUpInside)
    cell.btnSwitch.tag = indexPath.row
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  @objc func editDeal(sender:UIButton){
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddDealVC") as! AddDealVC
    vc.isUpdate = true
    vc.arrService = self.arrService
    vc.dealDetail = arrDeal[sender.tag]
    vc.callBack = { (message) in
      showSwiftyAlert("", message ?? "", true)
      self.arrDeal.removeAll()
      self.getDealsApi()
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  @objc func deleteDeal(sender:UIButton){
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelGigVC") as! CancelGigVC
    vc.modalPresentationStyle = .overFullScreen
    vc.isSelect = 6
    vc.dealId = arrDeal[sender.tag].id ?? ""
    vc.callBack = { (message) in
      showSwiftyAlert("", message ?? "", true)
      self.getDealsApi()
    }
    self.navigationController?.present(vc, animated: false)
  }
  @objc func updateStatus(sender:UIButton){
    sender.isSelected = !sender.isSelected
    if sender.isSelected{
      status = 1
    }else{
      status = 0
    }
    viewModel.updateDealsApi(dealId: arrDeal[sender.tag].id ?? "", title: arrDeal[sender.tag].title ?? "", validTo: arrDeal[sender.tag].validTo ?? "", bUserServicesIds: arrServiceId, status: status) { message in
      showSwiftyAlert("", message ?? "", true)
      self.getDealsApi()
    }
  }
}









