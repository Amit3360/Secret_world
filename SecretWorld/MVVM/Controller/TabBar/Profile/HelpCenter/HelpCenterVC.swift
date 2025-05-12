//
//  HelpCenterVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 26/12/23.
//

import UIKit

class HelpCenterVC: UIViewController {
    
    @IBOutlet var tblVwHelp: UITableView!
    
    var isSelect = -1
    var getHelpCenter = [Datum]()
    var viewModel = UserProfileVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                   swipeRight.direction = .right
                   view.addGestureRecognizer(swipeRight)

        tblVwHelp.estimatedRowHeight = 100
        tblVwHelp.rowHeight = UITableView.automaticDimension
        tblVwHelp.showsVerticalScrollIndicator = false
        if Store.role == "b_user"{
            getHelpCenterUser(type: "business_user")
            
        }else{
            getHelpCenterUser(type: "user")
        }
        
    }
    @objc func handleSwipe() {
               navigationController?.popViewController(animated: true)
           }

    func getHelpCenterUser(type:String){
        viewModel.getHelpCenterApi(type: type) { data in
            self.getHelpCenter = data?.data ?? []
            self.tblVwHelp.reloadData()
            self.tblVwHelp.estimatedRowHeight = 50
            self.tblVwHelp.rowHeight = UITableView.automaticDimension
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE

extension HelpCenterVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return getHelpCenter.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (isSelect == section) ? 1 : 0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderHelpCenterTVC") as! HeaderHelpCenterTVC
        headerCell.lblTitle.text = getHelpCenter[section].question
        headerCell.btnDropDown.backgroundColor = (section == isSelect) ? UIColor.app : UIColor.lightGreen
        headerCell.lblTitle.textColor = (section == isSelect) ? UIColor.white :UIColor.black
        headerCell.imgDropDown.image = (section == isSelect) ? UIImage(named: "dropup") : UIImage(named: "downn")
        headerCell.btnDropDown.tag = section
        headerCell.btnDropDown.addTarget(self, action: #selector(actionDropDwown), for: .touchUpInside)
        headerCell.btnDropDown.layer.cornerRadius = 10
        if  section == isSelect {
            print("True")
            headerCell.btnDropDown.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }else{
            print("False")
            headerCell.btnDropDown.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
        return headerCell
    }
    @objc func actionDropDwown(sender:UIButton){
        
        if sender.tag == isSelect {
            
                isSelect = -1
            
            } else {
                
                isSelect = sender.tag
                
            }
           tblVwHelp.reloadData()

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 55
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCenterTVC", for: indexPath) as! HelpCenterTVC
        cell.viewBack.layer.cornerRadius = 10
        cell.viewBack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        if let data = getHelpCenter[indexPath.section].answer, indexPath.row < data.count {
                cell.lblAnswer.text = data
            }
        return cell
    }
   
    
}
