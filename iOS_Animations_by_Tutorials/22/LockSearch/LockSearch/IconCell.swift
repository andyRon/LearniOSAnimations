//
//  ViewController.swift
//  LockSearch
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//


import UIKit

class IconCell: UICollectionViewCell {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var icon: UIImageView!
  
  var animator: UIViewPropertyAnimator?
  
  func iconJiggle() {
    // 让动画在运行时，点击没有效果
    if let animator = animator, animator.isRunning {
      return
    }
    
    animator = AnimatorFactory.jiggle(view: icon)
  }
  
}
