//
//  ViewController.swift
//  LockSearch
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//


import UIKit

class FooterCell: UITableViewCell {

  var didPressEdit: (()->Void)?

  @IBAction func edit() {
    didPressEdit?()
  }
}
