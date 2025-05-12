//
//  BookMarkVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//

import UIKit

class BookMarkVC: UIViewController {

    @IBOutlet var tblVwBookMark: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibNearBy = UINib(nibName: "ServicesNearByTVC", bundle: nil)
        tblVwBookMark.register(nibNearBy, forCellReuseIdentifier: "ServicesNearByTVC")
    }
    

    @IBAction func actionBack(_ sender: UIButton) {
    }
    
}
//MARK: -UITableViewDelegate
extension BookMarkVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesNearByTVC", for: indexPath) as! ServicesNearByTVC
        
          cell.viewShadow.layer.masksToBounds = false
          cell.viewShadow.layer.shadowColor = UIColor.black.cgColor
          cell.viewShadow.layer.shadowOpacity = 0.1
          cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
          cell.viewShadow.layer.shouldRasterize = true
          cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
           cell.viewShadow.layer.cornerRadius = 10
        cell.btnBookMark.tag = indexPath.row
           cell.btnBookMark.addTarget(self, action: #selector(actionBookMark), for: .touchUpInside)
        cell.heighViewServiceNames.constant = 0
        cell.lblPrice.text = ""
        return cell
    }
    @objc func actionBookMark(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected != true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemoveBookMarkVC") as! RemoveBookMarkVC
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
          return  130
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
