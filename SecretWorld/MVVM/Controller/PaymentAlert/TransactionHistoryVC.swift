//
//  TransactionHistoryVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/08/24.
//

import UIKit

class TransactionHistoryVC: UIViewController {
//MARK: - OUTLETS
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var tblVwHistory: UITableView!
    //MARK: - VARIABLES
    var viewMOdel = PaymentVM()
    var arrTransactions = [TransactionLog]()
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                   swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        tblVwHistory.showsVerticalScrollIndicator = false
        getTransactionApi()

    }
    override func viewWillAppear(_ animated: Bool) {
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblVwHistory.addSubview(refreshControl)

    }
    @objc func refresh(_ sender: AnyObject) {
        WebService.hideLoader()
        getTransactionApi()
        refreshControl.endRefreshing()
    }
    @objc func handleSwipe() {
               navigationController?.popViewController(animated: true)
           }
    //MARK: - FUNCTIONS
    func getTransactionApi(){
        viewMOdel.GetTransactionApi { data in
            self.arrTransactions = data?.transactionLogs?.reversed() ?? []
            if  self.arrTransactions.count > 0{
                self.lblNoData.isHidden = true
            }else{
                self.lblNoData.isHidden = false
            }
            self.tblVwHistory.reloadData()
        }
       
    }
    //MARK: - BUTTON ACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: -UITableViewDelegate
extension TransactionHistoryVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrTransactions.count > 0{
            return  arrTransactions.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHistoryTVC", for: indexPath) as! TransactionHistoryTVC
        let transaction = arrTransactions[indexPath.row]
        // 0 added,1 withdra,2deduct,5 refundded else
        if transaction.checkStatus == 0{
            cell.lblAddedOrWithdra.text = "Added"
            cell.imgVwArrow.image = UIImage(named: "add")
            cell.lblAmount.textColor = UIColor(hex: "#00C013")
        }else if transaction.checkStatus == 1{
            cell.lblAddedOrWithdra.text = "Withdraw"
            cell.lblAmount.textColor = UIColor(hex: "#FF1D1D")
            cell.imgVwArrow.image = UIImage(named: "withdraw")
        }else if transaction.checkStatus == 2{
            cell.lblAddedOrWithdra.text = "Deducted"
            cell.lblAmount.textColor = UIColor(hex: "#FF1D1D")
            cell.imgVwArrow.image = UIImage(named: "withdraw")
        }else if transaction.checkStatus == 5{
            cell.lblAddedOrWithdra.text = "Refunded"
            cell.lblAmount.textColor = UIColor(hex: "#00C013")
            cell.imgVwArrow.image = UIImage(named: "add")
        }else{
            print("no status")
        }
        
        if let amount = transaction.amount {
            cell.lblAmount.text = String(format: "$%.2f", amount)
        }
        if let createdAt = transaction.createdAt {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.timeZone = TimeZone.current

            if let date = inputFormatter.date(from: createdAt) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MMM dd yyyy HH:mm"
                outputFormatter.locale = Locale(identifier: "en_US_POSIX")
                outputFormatter.timeZone = TimeZone.current
                cell.lblDate.text = outputFormatter.string(from: date)
            }
        }

        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
