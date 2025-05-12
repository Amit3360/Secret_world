//
//  RecieveVoiceRecodingTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 03/04/25.
//

import UIKit

class RecieveVoiceRecodingTVC: UITableViewCell,VoicePlayableCell {

    @IBOutlet weak var bottomReactionVw: NSLayoutConstraint!
    @IBOutlet weak var vwReactionSecond: UIView!
    @IBOutlet weak var vwReactionThird: UIView!
    @IBOutlet weak var vwReactionFirst: UIView!
    @IBOutlet weak var vwWave: UIView!
  
    @IBOutlet weak var vwNotch: UIView!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var lblRecordTime: UILabel!
    @IBOutlet weak var btnPlay: IndexPathButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
