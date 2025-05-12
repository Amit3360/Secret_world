//
//  ReportVC.swift
//  SecretWorld
//
//  Created by meet sharma on 18/04/24.
//

import UIKit
class ReportVC: UIViewController {
    @IBOutlet var viewTblVwBack: UIView!
    @IBOutlet weak var heightReasonVw: NSLayoutConstraint!
    @IBOutlet weak var tblVwReason: UITableView!
    @IBOutlet weak var btnReason: UIButton!
    @IBOutlet weak var txtVwComment: UITextView!
    @IBOutlet var vwReport: UIView!
    
    var viewModel = UploadImageVM()
    var receiverId = ""
    var arrReson = [Report]()
    var reasonId = ""
    var callBack:((_ message:String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        heightReasonVw.constant = 0
        viewTblVwBack.layer.masksToBounds = false
        viewTblVwBack.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
        viewTblVwBack.layer.shadowOpacity = 0.44
        viewTblVwBack.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewTblVwBack.layer.shouldRasterize = true
        viewTblVwBack.layer.rasterizationScale = UIScreen.main.scale
        viewTblVwBack.layer.cornerRadius = 10
        viewModel.getReportResason { data in
            self.arrReson.removeAll()
            self.arrReson = data ?? []
            self.tblVwReason.reloadData()
        }
       setupOverlayView()
    }
    
    func setupOverlayView() {
        vwReport = UIView(frame: self.view.bounds)
    
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        vwReport.addGestureRecognizer(tapGesture)
          self.view.insertSubview(vwReport, at: 0)
      }
    @objc func overlayTapped() {
          self.dismiss(animated: true)
      }
    
    @IBAction func actionSelectReason(_ sender: UIButton) {
        
        if self.arrReson.count > 5{
            self.heightReasonVw.constant = 200
        }else{
            self.heightReasonVw.constant = CGFloat(arrReson.count*40)
        }
    }
    @IBAction func actionCross(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func actionSubmit(_ sender: UIButton) {
        let trimmedText = txtVwComment.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if btnReason.titleLabel?.text == "Select Reason"{
            showSwiftyAlert("", "Select reason", false)
        }else{
            viewModel.addReport(reson: trimmedText, reportUserId: receiverId, reasonId: reasonId) { message in
                
//                showSwiftyAlert("", "User reported successfully", true)
                
                
                self.dismiss(animated: true)
                self.callBack?(message ?? "")
            }
        }
    }
    
}
extension ReportVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReson.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatOptionTVC", for: indexPath) as! ChatOptionTVC
        
        cell.lblOption.text = arrReson[indexPath.row].reason ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnReason.setTitle(arrReson[indexPath.row].reason ?? "", for: .normal)
        heightReasonVw.constant = 0
        self.reasonId = arrReson[indexPath.row].id ?? ""
    }
}









