//
//  ViewController.swift
//  OfficeBuddy
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
  
  let menuWidth: CGFloat = 80.0
  let animationTime: TimeInterval = 0.5
  
  let menuViewController: UIViewController
  let centerViewController: UINavigationController
  
  var isOpening = false
  
  init(sideMenu: UIViewController, center: UINavigationController) {
    menuViewController = sideMenu
    centerViewController = center
    super.init(nibName: nil, bundle: nil)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    view.backgroundColor = .black
    setNeedsStatusBarAppearanceUpdate()
    
    addChildViewController(centerViewController)
    view.addSubview(centerViewController.view)
    centerViewController.didMove(toParentViewController: self)
    
    addChildViewController(menuViewController)
    view.addSubview(menuViewController.view)
    menuViewController.didMove(toParentViewController: self)
    
    // 设置转动锚点
    menuViewController.view.layer.anchorPoint.x = 1.0
    
    menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
    (menuViewController as! SideMenuViewController).headerHeight = centerViewController.navigationBar.frame.size.height
    
    let panGesture = UIPanGestureRecognizer(target:self, action:#selector(ContainerViewController.handleGesture(_:)))
    view.addGestureRecognizer(panGesture)
    
    // 让第一次也有3D效果
    setMenu(toPercent: 0.0)
  }
  // 手势处理
  @objc func handleGesture(_ recognizer: UIPanGestureRecognizer) {
    
    let translation = recognizer.translation(in: recognizer.view!.superview!)
    
    var progress = translation.x / menuWidth * (isOpening ? 1.0 : -1.0)
    progress = min(max(progress, 0.0), 1.0)
    
    switch recognizer.state {
    case .began:
      let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
      isOpening = isOpen == 1.0 ? false: true
      
      // 解决 3D效果时出现像素化（锯齿状边缘）
      menuViewController.view.layer.shouldRasterize = true
      menuViewController.view.layer.rasterizationScale = UIScreen.main.scale
      
    case .changed:
      setMenu(toPercent: isOpening ? progress: (1.0 - progress))
      
    case .ended: fallthrough
    case .cancelled: fallthrough
    case .failed:
      
      var targetProgress: CGFloat
      if (isOpening) {
        targetProgress = progress < 0.5 ? 0.0 : 1.0
      } else {
        targetProgress = progress < 0.5 ? 1.0 : 0.0
      }
      
      UIView.animate(withDuration: animationTime,
        animations: {
          self.setMenu(toPercent: targetProgress)
        },
        completion: {_ in
          self.menuViewController.view.layer.shouldRasterize = false
        }
      )
      
    default: break
    }
  }
  
  func toggleSideMenu() {
    let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
    let targetProgress: CGFloat = isOpen == 1.0 ? 0.0: 1.0
    
    UIView.animate(withDuration: animationTime,
      animations: {
        self.setMenu(toPercent: targetProgress)
      },
      completion: { _ in
        self.menuViewController.view.layer.shouldRasterize = false
      }
    )
  }
  
  func setMenu(toPercent percent: CGFloat) {
    centerViewController.view.frame.origin.x = menuWidth * CGFloat(percent)
//    menuViewController.view.frame.origin.x = menuWidth * CGFloat(percent) - menuWidth
    menuViewController.view.layer.transform = menuTransform(percent: percent)
    // 由于背景是黑色，通过降低透明度可营造出阴影的效果
    menuViewController.view.alpha = CGFloat(max(0.2, percent))
    
    // 菜单n按钮的旋转
    let centerVC = centerViewController.viewControllers.first as? CenterViewController
    if let menuButton = centerVC?.menuButton {
        menuButton.imageView.layer.transform = buttonTransform(percent: percent)
    }
  }
  
  func menuTransform(percent: CGFloat) -> CATransform3D {
    var identity = CATransform3DIdentity
    identity.m34 = -1.0/1000
    
    let remainingPercent = 1.0 - percent
    let angle = remainingPercent * .pi * -0.5
    
    let rotationTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
    let translationTransform = CATransform3DMakeTranslation(menuWidth * percent, 0, 0)
    return CATransform3DConcat(rotationTransform, translationTransform)
  }
    
  func buttonTransform(percent: CGFloat) -> CATransform3D {
    var identity = CATransform3DIdentity
    identity.m34 = -1.0/1000
    
    let angle = percent * .pi
    let rotationTransform = CATransform3DRotate(identity, angle, 1.0, 1.0, 0.0)
    
    return rotationTransform
  }
}
