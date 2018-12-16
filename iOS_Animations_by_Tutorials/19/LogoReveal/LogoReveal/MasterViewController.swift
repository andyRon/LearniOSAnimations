//
//  ViewController.swift
//  BeginnerCook
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/11/25.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//


import UIKit
import QuartzCore

func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class MasterViewController: UIViewController {
  
  let logo = RWLogoLayer.logoLayer()
    
  let transition = RevealAnimator()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Start"

    navigationController?.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    view.addGestureRecognizer(pan)
    
    // add the logo to the view
    logo.position = CGPoint(x: view.layer.bounds.size.width/2,
      y: view.layer.bounds.size.height/2 - 30)
    logo.fillColor = UIColor.white.cgColor
    view.layer.addSublayer(logo)
  }
  
  //
  // MARK: Gesture recognizer handler
  //
  @objc func didTap() {
    performSegue(withIdentifier: "details", sender: nil)
  }
  /// 平移手势
  @objc func didPan(_ recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
        transition.interactive = true
        performSegue(withIdentifier: "details", sender: nil)
    default:
        transition.handlePan(recognizer)
    }
  }
  
}

extension MasterViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.operation = operation
        return transition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !transition.interactive {
            return nil
        }
        return transition as! UIViewControllerInteractiveTransitioning
    }
}
