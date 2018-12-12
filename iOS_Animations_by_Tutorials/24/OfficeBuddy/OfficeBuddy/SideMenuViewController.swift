//
//  ViewController.swift
//  OfficeBuddy
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {
  
  var centerViewController: CenterViewController!
  var headerHeight: CGFloat = 0

  // MARK: UITableViewDataSource
  
  override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
    return MenuItem.sharedItems.count
  }
  
  override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for:indexPath) as UITableViewCell
    
    let menuItem = MenuItem.sharedItems[indexPath.row]
    cell.textLabel?.backgroundColor = .clear
    cell.textLabel?.textColor = .white
    cell.textLabel?.font = UIFont(name: "Helvetica", size: 36.0)
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.text = menuItem.symbol
    
    cell.contentView.backgroundColor = menuItem.color
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView  {
    return tableView.dequeueReusableCell(withIdentifier: "HeaderCell")!
  }
  
  // MARK: UITableViewDelegate
  
  override func tableView(_ tableView:UITableView, didSelectRowAt indexPath:IndexPath) {
    tableView.deselectRow(at: indexPath, animated:true)
    
    centerViewController.menuItem = MenuItem.sharedItems[indexPath.row]
    
    let containerVC = parent as! ContainerViewController
    containerVC.toggleSideMenu()
  }
  
  override func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
    return 84.0
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return headerHeight
  }
}
