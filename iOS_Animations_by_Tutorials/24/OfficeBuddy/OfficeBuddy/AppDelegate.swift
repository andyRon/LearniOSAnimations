//
//  ViewController.swift
//  BeginnerCook
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
   
    // Override point for customization after application launch.
    
    application.statusBarStyle = UIStatusBarStyle.lightContent
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let centerNav = storyboard.instantiateViewController(withIdentifier: "CenterNav") as! UINavigationController
    let menuVC = storyboard.instantiateViewController(withIdentifier: "SideMenu") as! SideMenuViewController
    menuVC.centerViewController = centerNav.viewControllers.first as? CenterViewController
    
    let containerVC = ContainerViewController(sideMenu: menuVC, center: centerNav)
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = containerVC
    window?.backgroundColor = UIColor.black
    window?.makeKeyAndVisible()
    
    return true
  }
  
}
