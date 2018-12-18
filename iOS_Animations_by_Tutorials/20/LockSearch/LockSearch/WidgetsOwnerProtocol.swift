//
//  ViewController.swift
//  LockSearch
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//


import UIKit

protocol WidgetsOwnerProtocol {
  var blurView: UIVisualEffectView {get}

  func startPreview(for: UIView)
  func updatePreview(percent: CGFloat)
  func finishPreview()
  func cancelPreview()
}

extension WidgetsOwnerProtocol {
  func startPreview(for forView: UIView) { }
  func updatePreview(percent: CGFloat) { }
  func finishPreview() { }
  func cancelPreview() { }
}
