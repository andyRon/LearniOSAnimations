//
//  ViewController.swift
//  BeginnerCook
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
  
  var menuItem: MenuItem! {
    didSet {
      title = menuItem.title
      view.backgroundColor = menuItem.color
      symbol.text = menuItem.symbol
    }
  }
  
  @IBOutlet var symbol: UILabel!
  
  // MARK: ViewController
  
  var menuButton: MenuButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    menuButton = MenuButton()
    menuButton.tapHandler = {
      if let containerVC = self.navigationController?.parent as? ContainerViewController {
        containerVC.toggleSideMenu()
      }
    }
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    menuItem = MenuItem.sharedItems.first!
  }
  
}
