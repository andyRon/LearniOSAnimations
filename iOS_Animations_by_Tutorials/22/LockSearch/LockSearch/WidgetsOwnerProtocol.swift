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
  
  /// 3D touch 开始时调用
  func startPreview(for: UIView)
  /// 按下的过程中会被反复调用
  func updatePreview(percent: CGFloat)
  func finishPreview()
  /// 按下但未完成操作时，调用
  func cancelPreview()
}

extension WidgetsOwnerProtocol {

  func startPreview(for forView: UIView) { }
  func updatePreview(percent: CGFloat) { }
  func finishPreview() { }
  func cancelPreview() { }
}
