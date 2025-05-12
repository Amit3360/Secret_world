//
//  GigNearByVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/24.
//

import UIKit

class GigNearByVC: UIViewController {

    @IBOutlet var viewBack: UIView!
    @IBOutlet var tblVwGig: UITableView!
    
    var callBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibNearBy = UINib(nibName: "GigNearByTVC", bundle: nil)
            tblVwGig.register(nibNearBy, forCellReuseIdentifier: "GigNearByTVC")
        viewBack.layer.cornerRadius = 20
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    


}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE

extension GigNearByVC: UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigNearByTVC", for: indexPath) as! GigNearByTVC
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        callBack?()
    }
}
