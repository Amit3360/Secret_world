//
//  InventoryPopupVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 29/04/25.
//

import UIKit

class InventoryPopupVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    var callBack:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

 
    @IBAction func actionOk(_ sender: UIButton) {
        dismiss(animated: true)
        callBack?()
    }
    
}
