//
//  MembershipListVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 09/05/25.
//

import UIKit

class MembershipListVC: UIViewController {

    @IBOutlet weak var lblDataFound: UILabel!
    @IBOutlet weak var tblVwMembership: UITableView!
    
    var viewModel = MembershipVM()
    var arrMembership = [MembershipData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        getAllMembershipApi()
    }
    
    func getAllMembershipApi(){
        print(Store.authKey ?? "")
        arrMembership.removeAll()
        viewModel.getAllMembershipApi(page: 1, limit: 20) { data in
            if data?.data?.count ?? 0 > 0{
                self.lblDataFound.isHidden = true
            }else{
                self.lblDataFound.isHidden = false
            }
            self.arrMembership = data?.data ?? []
            self.tblVwMembership.reloadData()
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAdd(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateMembershipVC") as! CreateMembershipVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
  

}

extension MembershipListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMembership.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberlistTVC", for: indexPath) as! MemberlistTVC
        cell.arrPriceType = arrMembership[indexPath.row].plans ?? []
        cell.configure(plans: arrMembership[indexPath.row].plans, services: arrMembership[indexPath.row].services)
        cell.lblMembershipName.text = arrMembership[indexPath.row].name ?? ""
        if let plans = arrMembership[indexPath.row].plans {
            var benefitsText = ""
            for (index, plan) in plans.enumerated() {
                if let benefit = plan.benefits {
                    benefitsText += "\(index + 1). \(benefit)\n"
                }
            }
            cell.lblBenefits.text = benefitsText
        } else {
            cell.lblBenefits.text = ""
        }
        cell.btnEdit.addTarget(self, action: #selector(editMembership), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteMembership), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        return cell
    }
    
    @objc func editMembership(sender:UIButton){
        let vc = instantiateVC(CreateMembershipVC.self, id: "CreateMembershipVC")
        vc.isComing = true
        vc.memberShipData = arrMembership[sender.tag]
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func deleteMembership(sender:UIButton){
        let vc = instantiateVC(CancelGigVC.self, id: "CancelGigVC")
        vc.isSelect = 8
        vc.membershipId = arrMembership[safe: sender.tag]?.id ?? ""
      
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = { [weak self] message in
            showSwiftyAlert("", message ?? "", true)
            self?.getAllMembershipApi()
        }
        navigationController?.present(vc, animated: false)
      
    }
    private func instantiateVC<T: UIViewController>(_ type: T.Type, id: String) -> T {
        return storyboard?.instantiateViewController(withIdentifier: id) as! T
    }
}
