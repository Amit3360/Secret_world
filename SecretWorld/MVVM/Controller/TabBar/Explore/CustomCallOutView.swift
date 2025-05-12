//
//  CustomCallOutView.swift
//  SecretWorld
//
//  Created by Ideio Soft on 03/10/24.
//

import Foundation
import UIKit

class CustomCallOutView: UIView {
    // Designated initializer
    override init(frame: CGRect) {
        super.init(frame: frame) // Call the superclass initializer
        self.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) // Call the superclass initializer
    }

    @objc func onTap() {
        // Handle the tap
    }
}
