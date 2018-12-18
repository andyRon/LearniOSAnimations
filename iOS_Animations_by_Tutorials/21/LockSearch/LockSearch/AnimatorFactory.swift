//
//  ViewController.swift
//  BeginnerCook
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit

class AnimatorFactory {
  
  static func scaleUp(view: UIView) -> UIViewPropertyAnimator {
    let scale = UIViewPropertyAnimator(duration: 0.33, curve: .easeIn)
    
    scale.addAnimations {
      view.alpha = 1.0
    }
    
    scale.addAnimations({
      view.transform = .identity
    }, delayFactor: 0.33)
    
    scale.addCompletion { (_) in
      print("ready")
    }
    
    return scale
  }
  
  @discardableResult
  static func jiggle(view: UIView) -> UIViewPropertyAnimator {
    
    return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.33, delay: 0, animations: {
      
      UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
          view.transform = CGAffineTransform(rotationAngle: -.pi/8)
        }
        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75) {
          view.transform = CGAffineTransform(rotationAngle: +.pi/8)
        }
        UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1.0) {
          view.transform = CGAffineTransform.identity
        }
      }, completion: nil)
    }, completion: { _ in
      view.transform = .identity
    })
    
  }
  
  @discardableResult
  static func fade(view: UIView, visible: Bool) -> UIViewPropertyAnimator {
    return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
      view.alpha = visible ? 1.0 : 0.0
    }, completion: nil)
  }
  
  // 自动布局动画
  @discardableResult
  static func animateConstraint(view: UIView, constraint: NSLayoutConstraint, by: CGFloat) -> UIViewPropertyAnimator {
    let spring = UISpringTimingParameters(dampingRatio: 0.55)
    let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
    
    animator.addAnimations {
      constraint.constant += by
      view.layoutIfNeeded()
    }
    return animator
  }
}
