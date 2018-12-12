//
//  ViewController.swift
//  Snow Scene
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//



import UIKit
import QuartzCore

class ViewController: UIViewController {
  
  @IBOutlet var bgImageView: UIImageView!
  
  @IBOutlet var summaryIcon: UIImageView!
  @IBOutlet var summary: UILabel!
  
  @IBOutlet var flightNr: UILabel!
  @IBOutlet var gateNr: UILabel!
  @IBOutlet var departingFrom: UILabel!
  @IBOutlet var arrivingTo: UILabel!
  @IBOutlet var planeImage: UIImageView!
  
  @IBOutlet var flightStatus: UILabel!
  @IBOutlet var statusBanner: UIImageView!
  
  //MARK: view controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //adjust ui
    summary.addSubview(summaryIcon)
    summaryIcon.center.y = summary.frame.size.height/2
    
    //start rotating the flights
    changeFlightDataTo(londonToParis)
    
    let rect = CGRect(x: 0.0, y: -70.0, width: view.bounds.width, height: 50.0)
    let emitter = CAEmitterLayer()
    emitter.frame = rect
    view.layer.addSublayer(emitter)
    
    emitter.emitterShape = kCAEmitterLayerRectangle
    
    emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
    emitter.emitterSize = rect.size
    
    
    let emitterCell = CAEmitterCell()
    emitterCell.contents = UIImage(named: "flake.png")?.cgImage
    
    emitterCell.birthRate = 20
    emitterCell.lifetime = 3.5
//    emitter.emitterCells = [emitterCell]
    
    emitterCell.yAcceleration = 70.0
    
    emitterCell.xAcceleration = 10.0
    
    emitterCell.velocity = 20.0
    emitterCell.emissionLongitude = .pi * -0.5
    // 随机
    emitterCell.velocityRange = 200.0
    
    emitterCell.emissionRange = .pi * 0.5
    
    // 改变粒子的颜色
    emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    emitterCell.redRange = 0.1
    emitterCell.greenRange = 0.1
    emitterCell.blueRange = 0.1
    
    // 随机化粒子外观
    emitterCell.scale = 0.8   // 初始大小
    emitterCell.scaleRange = 0.8  // 初始大小变化范围
    emitterCell.scaleSpeed = -0.15  // 运动中大小变化
    emitterCell.birthRate = 150
    emitterCell.alphaRange = 0.75
    emitterCell.alphaSpeed = -0.15
    
    emitterCell.emissionLongitude = -.pi
    
    emitterCell.lifetimeRange = 1.0
    
    
    
    //cell #2
    let cell2 = CAEmitterCell()
    cell2.contents = UIImage(named: "flake2.png")?.cgImage
    cell2.birthRate = 50
    cell2.lifetime = 2.5
    cell2.lifetimeRange = 1.0
    cell2.yAcceleration = 50
    cell2.xAcceleration = 50
    cell2.velocity = 80
    cell2.emissionLongitude = .pi
    cell2.velocityRange = 20
    cell2.emissionRange = .pi * 0.25
    cell2.scale = 0.8
    cell2.scaleRange = 0.2
    cell2.scaleSpeed = -0.1
    cell2.alphaRange = 0.35
    cell2.alphaSpeed = -0.15
    cell2.spin = .pi
    cell2.spinRange = .pi
    
    //cell #3
    let cell3 = CAEmitterCell()
    cell3.contents = UIImage(named: "flake3.png")?.cgImage
    cell3.birthRate = 20
    cell3.lifetime = 7.5
    cell3.lifetimeRange = 1.0
    cell3.yAcceleration = 20
    cell3.xAcceleration = 10
    cell3.velocity = 40
    cell3.emissionLongitude = .pi
    cell3.velocityRange = 50
    cell3.emissionRange = .pi * 0.25
    cell3.scale = 0.8
    cell3.scaleRange = 0.2
    cell3.scaleSpeed = -0.05
    cell3.alphaRange = 0.5
    cell3.alphaSpeed = -0.05
    
    //cell #4
    let cell4 = CAEmitterCell()
    cell4.contents = UIImage(named: "flake4.png")?.cgImage
    cell4.birthRate = 10
    cell4.lifetime = 5.5
    cell4.lifetimeRange = 1.0
    cell4.yAcceleration = 25
    cell4.xAcceleration = 30
    cell4.velocity = 20
    cell4.emissionLongitude = .pi
    cell4.velocityRange = 30
    cell4.emissionRange = .pi * 0.25
    cell4.scale = 0.8
    cell4.scaleRange = 0.2
    cell4.scaleSpeed = -0.05
    cell4.alphaRange = 0.5
    cell4.alphaSpeed = -0.05
    
    emitter.emitterCells = [emitterCell, cell2, cell3, cell4]
    
    
    
  }
  
  //MARK: custom methods
  
  func changeFlightDataTo(_ data: FlightData) {
    
    // populate the UI with the next flight's data
    summary.text = data.summary
    flightNr.text = data.flightNr
    gateNr.text = data.gateNr
    departingFrom.text = data.departingFrom
    arrivingTo.text = data.arrivingTo
    flightStatus.text = data.flightStatus
    bgImageView.image = UIImage(named: data.weatherImageName)
  }
  
  
}
