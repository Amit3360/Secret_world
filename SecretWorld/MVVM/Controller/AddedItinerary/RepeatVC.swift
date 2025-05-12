//
//  RepeatVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/01/25.
//

import UIKit
protocol backData{
    func passIndex(index: IndexPath,title:String)
}
class RepeatVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var tblVwList: UITableView!
    @IBOutlet var heightTblVw: NSLayoutConstraint!
    
    //MARK: - variables
    var arrList = ["Does not repeat","Every day","Every week","Every month","Every Year"]
    var selectedIndex:IndexPath?
    var callBack: backData?
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibReiew = UINib(nibName: "RepeatTVC", bundle: nil)
        tblVwList.register(nibReiew, forCellReuseIdentifier: "RepeatTVC")
        heightTblVw.constant = CGFloat(arrList.count * 40)
    }

}
//MARK: -UITableViewDelegate
extension RepeatVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatTVC", for: indexPath) as! RepeatTVC
        cell.lblTitle.text = arrList[indexPath.row]
        if selectedIndex == indexPath{
            cell.imgVwSelect.image = UIImage(named: "select")
        } else {
            cell.imgVwSelect.image = UIImage(named: "deselect")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tblVwList.reloadData()
        callBack?.passIndex(index: indexPath, title: arrList[indexPath.row])
        self.dismiss(animated: true)
    }
}


