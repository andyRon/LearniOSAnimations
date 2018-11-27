//
//  ViewController.swift
//  Packing List
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/11/13.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class AvatarView: UIView {
  
  //constants
  let lineWidth: CGFloat = 6.0
  let animationDuration = 1.0
  
  //ui
  let photoLayer = CALayer()
  let circleLayer = CAShapeLayer()
  let maskLayer = CAShapeLayer()
  let label: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "ArialRoundedMTBold", size: 18.0)
    label.textAlignment = .center
    label.textColor = UIColor.black
    return label
  }()
  
  //variables
  @IBInspectable
  var image: UIImage? = nil {
    didSet {
      photoLayer.contents = image?.cgImage
    }
  }
  
  @IBInspectable
  var name: String? = nil {
    didSet {
      label.text = name
    }
  }
  // 搜索和连接完成的，为完成状态，true
  var shouldTransitionToFinishedState = false
  var isSquare = false
  
  override func didMoveToWindow() {
    layer.addSublayer(photoLayer)
    
    photoLayer.mask = maskLayer
    layer.addSublayer(circleLayer)   // 边框
    addSubview(label)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    guard let image = image else {
      return
    }
    
    //Size the avatar image to fit
    photoLayer.frame = CGRect(
      x: (bounds.size.width - image.size.width + lineWidth)/2,
      y: (bounds.size.height - image.size.height - lineWidth)/2,
      width: image.size.width,
      height: image.size.height)
    
    //Draw the circle
    circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
    circleLayer.strokeColor = UIColor.white.cgColor
    circleLayer.lineWidth = lineWidth
    circleLayer.fillColor = UIColor.clear.cgColor
    
    //Size the layer
    maskLayer.path = circleLayer.path
    maskLayer.position = CGPoint(x: 0.0, y: 10.0)
    
    //Size the label
    label.frame = CGRect(x: 0.0, y: bounds.size.height + 10.0, width: bounds.size.width, height: 24.0)
  }
  // 头像视图的反弹动画
  func bounceOff(point: CGPoint, morphSize: CGSize) {
        let originalCenter = center
        // 使用弹簧动画将头像移动到指定位置
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, animations: {
            self.center = point
        }, completion: {_ in
            if self.shouldTransitionToFinishedState {
                self.animateToSquare()
            }
        })
        // 使用弹簧动画将头像移动到原来位置
        UIView.animate(withDuration: animationDuration, delay: animationDuration, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, animations: {
            self.center = originalCenter
        }) { (_) in
            delay(seconds: 0.1) {
                if !self.isSquare {
                    self.bounceOff(point: point, morphSize: morphSize)
                }
            }
        }
        // 头像压扁的效果
        let morphedFrame = (originalCenter.x > point.x) ?
        CGRect(x: 0.0, y: bounds.height - morphSize.height, width: morphSize.width, height: morphSize.height) :
        CGRect(x: bounds.width - morphSize.width, y: bounds.height - morphSize.height, width: morphSize.width, height: morphSize.height)
    
        let morphAnimation = CABasicAnimation(keyPath: "path")
        morphAnimation.duration = animationDuration
        morphAnimation.toValue = UIBezierPath(ovalIn: morphedFrame).cgPath
    
        morphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    
        circleLayer.add(morphAnimation, forKey: nil)

        maskLayer.add(morphAnimation, forKey: nil)
  }
  // 变换为正方形动画
  func animateToSquare() {
    isSquare = true
    
    let squarePath = UIBezierPath(rect: bounds).cgPath
    let morph = CABasicAnimation(keyPath: "path")
    morph.duration = 0.25
    morph.fromValue = circleLayer.path
    morph.toValue = squarePath
    
    circleLayer.add(morph, forKey: nil)
    maskLayer.add(morph, forKey: nil)
    
    circleLayer.path = squarePath
    maskLayer.path = squarePath
    
  }
  
}
