//
//  PopUpVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 26/12/23.
//

import UIKit

class PopUpVC: UIViewController {
    @IBOutlet weak var tblVwList: UITableView!
    var arrTitle = [String]()
    var callBack:((_ indexx:Int,_ title:String)->())?
    var isSelect = 0
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if isSelect == 0{
           arrTitle.append("Permanent")
           arrTitle.append("Temporary")
        }else if isSelect == 1{
            arrTitle.append("Male")
            arrTitle.append("Female")
            arrTitle.append("Other")
        }else if isSelect == 2{
            arrTitle.append("Carnivore")
            arrTitle.append("Omnivore")
            arrTitle.append("Halal")
            arrTitle.append("Vegan")
            arrTitle.append("Vegetarian")
            arrTitle.append("Kosher")
            arrTitle.append("Other")
        }else if isSelect == 3{
            arrTitle.append("worldwide")
            arrTitle.append("inMyLocation")
           
        }
    }
  
}
//MARK: - UITableViewDelegate
extension PopUpVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrTitle.count > 0{
            return arrTitle.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpTVC", for: indexPath) as! PopUpTVC
        if arrTitle.count > 0{
        cell.imgVwType.image = UIImage(named: arrTitle[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        self.dismiss(animated: false)
        callBack?(indexPath.row, arrTitle[indexPath.row])
    }
}
