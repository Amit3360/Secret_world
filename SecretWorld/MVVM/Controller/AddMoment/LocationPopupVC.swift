//
//  LocationPopupVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 15/04/25.
//

import UIKit

class LocationPopupVC: UIViewController {

    @IBOutlet var tblVwList: UITableView!
    var isSelect = false
    var arrTitle = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
   private func uiSet(){
       self.view.backgroundColor = .white
        let nib = UINib(nibName: "LocationPopupTVC", bundle: nil)
       tblVwList.register(nib, forCellReuseIdentifier: "LocationPopupTVC")
        if isSelect{
            arrTitle.append("Exact location hidden, till hired")
        }else{
            arrTitle.append("Exact location visible, till end")
        }

    }


}
//MARK: - UITableViewDelegate
extension LocationPopupVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationPopupTVC", for: indexPath) as! LocationPopupTVC
        cell.lblTitle.text = arrTitle[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
}
