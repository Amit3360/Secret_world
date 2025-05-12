//
//  DealTVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 01/04/25.
//
import UIKit
class DealTVC: UITableViewCell {
  // MARK: - outlets
  @IBOutlet var heightTblvw: NSLayoutConstraint!
  @IBOutlet var tblVwServices: UITableView!
  @IBOutlet var btnEdit: UIButton!
  @IBOutlet var btnDelete: UIButton!
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var btnSwitch: UIButton!
  var arrService = [BUserServicesID]()
  override func awakeFromNib() {
    super.awakeFromNib()
  }
   func uiSet(){
    tblVwServices.delegate = self
    tblVwServices.dataSource = self
    let nibReiew = UINib(nibName: "DealsServiceTVC", bundle: nil)
    tblVwServices.register(nibReiew, forCellReuseIdentifier: "DealsServiceTVC")
     heightTblvw.constant = CGFloat(arrService.count*25)
     DispatchQueue.main.async {
       self.tblVwServices.reloadData()
     }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    tblVwServices.layoutIfNeeded()
    tblVwServices.reloadData()
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
//MARK: -UITableViewDelegate
extension DealTVC: UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrService.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DealsServiceTVC", for: indexPath) as! DealsServiceTVC
    cell.lblService.text = "• \(arrService[indexPath.row].serviceName ?? "")"
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 25
  }
}
