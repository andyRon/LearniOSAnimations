//
//  ViewController.swift
//  BeginnerCook
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//


import UIKit

class IconEffectView: UIVisualEffectView {

  convenience init(blur: UIBlurEffectStyle) {

    self.init(effect: UIBlurEffect(style: blur))

    clipsToBounds = true
    layer.cornerRadius = 16.0

    let label = UILabel()
    label.text = "Customize Actions..."
    label.font = UIFont.systemFont(ofSize: 16.0)
    label.sizeToFit()
    label.center = CGPoint(x: 90, y: 30)
    contentView.addSubview(label)
  }
}
