//
//  CustomTableView.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/04/24.
//

import Foundation
import UIKit
class CustomTableView: UITableView {
  private let maxHeight = CGFloat(300)
  private let minHeight = CGFloat(100)
  override public func layoutSubviews() {
    super.layoutSubviews()
    if bounds.size != intrinsicContentSize {
      invalidateIntrinsicContentSize()
    }
  }
  override public var intrinsicContentSize: CGSize {
    layoutIfNeeded()
    if contentSize.height > maxHeight {
      return CGSize(width: contentSize.width, height: maxHeight)
    }
    else if contentSize.height < minHeight {
      return CGSize(width: contentSize.width, height: minHeight)
    }
    else {
      return contentSize
    }
  }
}


