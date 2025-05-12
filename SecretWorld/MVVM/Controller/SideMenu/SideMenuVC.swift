//
//  SideMenuVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 20/11/24.
//

import UIKit

class SideMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var tblVwSideMenu: UITableView!
    var arrSideMenu = ["noSelG","noSelBB","noSelP","typp","cur","ref"]
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSideMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as! SideMenuTVC
        cell.imgVwType.image = UIImage(named: arrSideMenu[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sideMenuController?.hideLeftView(animated: true)
        
    }

}
