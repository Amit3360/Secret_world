//
//  GigSettingVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 23/09/24.
//

import UIKit

class GigSettingVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet var viewBack: UIView!
    @IBOutlet weak var tblVwGig: UITableView!
    //MARK: -VARIABLES
    var arrSetting = [[String:Any]]()
    var callBack:((_ isSelect:Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSet()
    }
    //MARK: - FUNCTIONS
    func uiSet(){
        arrSetting.append(["img" : "verify","title":"Complete your task"])
        arrSetting.append(["img" : "lock","title":"Private your profile"])
        setupOverlayView()
    }
    func setupOverlayView() {
        viewBack = UIView(frame: self.view.bounds)
        viewBack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        viewBack.addGestureRecognizer(tapGesture)
          self.view.insertSubview(viewBack, at: 0)
      }
    @objc func overlayTapped() {
          self.dismiss(animated: true)
      }
}
//MARK: - UITableViewDelegate
extension GigSettingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSetting.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigSettingTVC", for: indexPath) as! GigSettingTVC
        let setting = arrSetting[indexPath.row]
        cell.lblTitle.text = setting["title"] as? String
        cell.imgVwSetting.image = UIImage(named: setting["img"] as! String)
        return  cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            dismiss(animated: false)
            callBack?(indexPath.row)
       
    }
    
}
