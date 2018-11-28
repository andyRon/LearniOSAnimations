//
//  AnimateMaskLabel.swift
//  SlideToReveal
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/11/13.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class AnimateMaskLabel: UIView {

    // 渐变图层
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let colors = [
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.orange.cgColor,
            UIColor.cyan.cgColor,
            UIColor.red.cgColor,
            UIColor.yellow.cgColor
        ]
        gradientLayer.colors = colors
        let locations: [NSNumber] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.25]
        gradientLayer.locations = locations
        
        return gradientLayer
    }()
    
    @IBInspectable var text: String! {
        didSet {
            setNeedsDisplay()
            
            let image = UIGraphicsImageRenderer(size: bounds.size).image { (_) in
                text.draw(in: bounds, withAttributes: textAttributes)
            }
            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.clear.cgColor
            maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
            maskLayer.contents = image.cgImage
            gradientLayer.mask = maskLayer
        }
    }
    
    let textAttributes: [NSAttributedString.Key: Any] = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 28.0)!,
            NSAttributedString.Key.paragraphStyle: style
        ]
    }()
    
    override func layoutSubviews() {

        layer.borderColor = UIColor.green.cgColor
        // 把渐变图层大小设置成AnimateMaskLabel的3p倍大
        gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y, width: 3 * bounds.size.width, height: bounds.size.height)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.addSublayer(gradientLayer)

        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.0, 0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.65, 0.8, 0.85, 0.9, 0.95, 1.0]
        gradientAnimation.duration = 3.0
        gradientAnimation.repeatCount = .infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
    }

}
