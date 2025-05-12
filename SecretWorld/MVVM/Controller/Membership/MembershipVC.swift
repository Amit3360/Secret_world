//
//  MembershipVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 12/05/25.
//

import UIKit

class MembershipVC: UIViewController {

    @IBOutlet weak var heightMembertshipTbl: NSLayoutConstraint!
    @IBOutlet weak var lblMembershipName: UILabel!
    @IBOutlet weak var tblVwMembership: UITableView!
    
    var arrMembership = ["monthly","quarterly","biAnnually","annually"]
    var arrMembershipName = ["Monthly Membership","Quarterly Membership","Bi-annually Membership","Annually Membership"]
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
 
  
}

extension MembershipVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMembership.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipTVC", for: indexPath) as! MembershipTVC
        cell.imgVwType.image = UIImage(named: arrMembership[indexPath.row])
        cell.lblMembership.text = arrMembershipName[indexPath.row]
        return  cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 182
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MembershipDetailVC") as! MembershipDetailVC
        vc.type = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
