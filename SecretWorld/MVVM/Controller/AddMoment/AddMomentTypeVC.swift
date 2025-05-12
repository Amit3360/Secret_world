//
//  AddMomentTypeVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 06/05/25.
//

import UIKit

class AddMomentTypeVC: UIViewController {

    @IBOutlet var btnStoryLine: UIButton!
    @IBOutlet var btnSIngle: UIButton!
    
    var callBack:((String?)->())?
    private var momentType = "single"
    override func viewDidLoad() {
        super.viewDidLoad()
        selectMomentType("single", button: btnSIngle)
    }
    @IBAction func actionStoryLine(_ sender: UIButton) {
        selectMomentType("storyline", button: sender)
    }
    @IBAction func actionSingleMOment(_ sender: UIButton) {
        selectMomentType("single", button: sender)
    }
    private func selectMomentType(_ type: String, button: UIButton) {
        momentType = type
        [btnSIngle, btnStoryLine].forEach {
            $0?.borderCol = UIColor(hex: "#515151")
            $0?.backgroundColor = .white
            $0?.setTitleColor(.app, for: .normal)
        }
        button.borderCol = UIColor(hex: "#3E9C35")
        button.backgroundColor = UIColor(hex: "#CFEACD")
        button.setTitleColor(.app, for: .normal)
    }

    @IBAction func actionStartPosting(_ sender: UIButton) {
        dismiss(animated: true) {
                    self.callBack?(self.momentType)
                }
    }
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
