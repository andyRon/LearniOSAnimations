//
//  ViewController.swift
//  BeginnerCook
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/11/25.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//


import UIKit
import QuartzCore

class RWLogoLayer {
  
  //
  // Function to create a RW logo shape layer
  //
  class func logoLayer() -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.isGeometryFlipped = true
    
    //the RW bezier
    let bezier = UIBezierPath()
    bezier.move(to: CGPoint(x: 0.0, y: 0.0))
    bezier.addCurve(to: CGPoint(x: 0.0, y: 66.97), controlPoint1:CGPoint(x: 0.0, y: 0.0), controlPoint2:CGPoint(x: 0.0, y: 57.06))
    bezier.addCurve(to: CGPoint(x: 16.0, y: 39.0), controlPoint1: CGPoint(x: 27.68, y: 66.97), controlPoint2:CGPoint(x: 42.35, y: 52.75))
    bezier.addCurve(to: CGPoint(x: 26.0, y: 17.0), controlPoint1: CGPoint(x: 17.35, y: 35.41), controlPoint2:CGPoint(x: 26, y: 17))
    bezier.addLine(to: CGPoint(x: 38.0, y: 34.0))
    bezier.addLine(to: CGPoint(x: 49.0, y: 17.0))
    bezier.addLine(to: CGPoint(x: 67.0, y: 51.27))
    bezier.addLine(to: CGPoint(x: 67.0, y: 0.0))
    bezier.addLine(to: CGPoint(x: 0.0, y: 0.0))
    bezier.close()
    
    //create a shape layer
    layer.path = bezier.cgPath
    layer.bounds = (layer.path?.boundingBox)!
    
    return layer
  }
  
}
