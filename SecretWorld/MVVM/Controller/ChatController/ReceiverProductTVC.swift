//
//  ReceiverProductTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 03/04/25.
//

import UIKit

class ReceiverProductTVC: UITableViewCell {

    @IBOutlet weak var heightTblVw: NSLayoutConstraint!
    @IBOutlet weak var imgVwTick: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var tblVwProduct: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func uiSet(){
        tblVwProduct.delegate = self
        tblVwProduct.dataSource = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ReceiverProductTVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverProductMenuTVC", for: indexPath) as! ReceiverProductMenuTVC
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}
