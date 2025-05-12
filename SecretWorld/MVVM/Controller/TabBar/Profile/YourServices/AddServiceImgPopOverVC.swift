//
//  AddServiceImgPopOverVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 28/11/24.
//

import UIKit

class AddServiceImgPopOverVC: UIViewController {

    @IBOutlet var tblVwList: UITableView!
    var arrProfile = [ProfileData]()
    var callBack:((_ indexx:Int,_ title:String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        arrProfile.append(ProfileData(title: "Take a photo", img: "camera"))
        arrProfile.append(ProfileData(title: "Upload from gallery", img: "Group25"))
        tblVwList.reloadData()
    }
    

}
//MARK: - UITableViewDelegate
extension AddServiceImgPopOverVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrProfile.count > 0{
            return arrProfile.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddServiceImgPopOverTVC", for: indexPath) as! AddServiceImgPopOverTVC
        if arrProfile.count > 0{
            cell.imgVw.image =  UIImage(named: arrProfile[indexPath.row].img ?? "")
            cell.lblTitle.text = arrProfile[indexPath.row].title ?? ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: false)
        callBack?(indexPath.row, arrProfile[indexPath.row].title ?? "")
    }
}
