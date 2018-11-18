//
//  ViewController.swift
//  Flight Info
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/8/20.
//  Copyright © 2018年 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var summaryIcon: UIImageView!
    @IBOutlet weak var summary: UILabel!
    
    @IBOutlet weak var flightNr: UILabel!
    @IBOutlet weak var gateNr: UILabel!
    @IBOutlet weak var departingFrom: UILabel!
    @IBOutlet weak var arrivingTo: UILabel!
    
    @IBOutlet weak var planeImage: UIImageView!
    
    @IBOutlet weak var statusBanner: UIImageView!
    @IBOutlet weak var flightStatus: UILabel!
    
    var snowView: SnowView!
    
    enum AnimationDirection: Int {
        case positive = 1
        case negative = -1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summary.addSubview(summaryIcon)
        summaryIcon.center.y = summary.frame.size.height / 2
        
        snowView = SnowView(frame: CGRect(x: -150, y: -100, width: 300, height: 50))
        let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
        snowClipView.clipsToBounds = true
        snowClipView.addSubview(snowView)
        view.addSubview(snowClipView)
        
        changeFlight(to: londonToParis)
    }
    /// 更新航班数据
    func changeFlight(to data: FlightData, animated: Bool = false) {
 
        if animated {
            // 背景图和❄️动画
            fade(imageView: bgImageView,
                 toImage: UIImage(named: data.weatherImageName)!,
                 showEffects: data.showWeatherEffects)
            // 航班号和入口号的Label转换动画
            let direction: AnimationDirection = data.isTakingOff ?
                .positive : .negative
            cubeTransition(label: flightNr, text: data.flightNr, direction: direction)
            cubeTransition(label: gateNr, text: data.gateNr, direction: direction)
            
            // 启程地和目的地Label动画
            let offsetDeparting = CGPoint(x: CGFloat(direction.rawValue * 80), y: 0.0)
            moveLabel(label: departingFrom, text: data.departingFrom,
                      offset: offsetDeparting)
            let offsetArriving = CGPoint(x: 0.0, y: CGFloat(direction.rawValue * 50))
            moveLabel(label: arrivingTo, text: data.arrivingTo,
                      offset: offsetArriving)
            // 航班状态动画
            cubeTransition(label: flightStatus, text: data.flightStatus, direction: direction)
            // 飞机移动动画
            planeDepart()
            // 航班时间变化时间
            summarySwitch(to: data.summary)
        } else {
            // 不需要动画时
            bgImageView.image = UIImage(named: data.weatherImageName)
            snowView.isHidden = !data.showWeatherEffects
            
            flightNr.text = data.flightNr
            gateNr.text = data.gateNr
            
            departingFrom.text = data.departingFrom
            arrivingTo.text = data.arrivingTo
            
            flightStatus.text = data.flightStatus
            
            summary.text = data.summary
        }
        
        delay(seconds: 3.0) {
            self.changeFlight(to: data.isTakingOff ? parisToRome : londonToParis, animated: true)
        }
    }
    /// 背景图片的变化
    func fade(imageView: UIImageView, toImage: UIImage, showEffects: Bool) {
        UIView.transition(with: imageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            imageView.image = toImage
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.snowView.alpha = showEffects ? 1.0 : 0.0
        }, completion: nil)
    }
    
    /// 假装3D效果
    /// label: 想要做动画的Label
    /// text: 展示在Label的新文本
    /// direction: 为新文本标签设置动画的位置; 是视图的顶部或底部。
    func cubeTransition(label: UILabel, text: String, direction: AnimationDirection) {
        // 构造一个辅助Label
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = UIColor.clear  // 去除背景黑色
        // 辅助Label的高度从一半变换为0.1
        let auxLabelOffset = CGFloat(direction.rawValue) * label.frame.size.height/2.0
        auxLabel.transform = CGAffineTransform(translationX: 0.0, y: auxLabelOffset).scaledBy(x: 1.0, y: 0.1)
        label.superview?.addSubview(auxLabel)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            auxLabel.transform = .identity
            // 原本的Label在Y轴上向反方向转换
            label.transform = CGAffineTransform(translationX: 0.0, y: -auxLabelOffset).scaledBy(x: 1.0, y: 0.1)
        },completion: { _ in
            // 把辅助Label的文本赋值给原来的Label，然后删除辅助Label
            label.text = auxLabel.text
            label.transform = .identity
            
            auxLabel.removeFromSuperview()
        }
        )
    }
    /// 航班起点和终点的位置名称变化效果
    func moveLabel(label: UILabel, text: String, offset: CGPoint) {
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = .clear
        
        auxLabel.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
        auxLabel.alpha = 0
        view.addSubview(auxLabel)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            label.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
            label.alpha = 0.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseIn, animations: {
            auxLabel.transform = .identity
            auxLabel.alpha = 1.0
        }, completion: { _ in
            auxLabel.removeFromSuperview()
            label.text = text
            label.alpha = 1.0
            label.transform = .identity
        })
    }
    
    
    /// 飞机✈️移动动画
    func planeDepart() {
        let originalCenter = planeImage.center
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                self.planeImage.center.x += 80.0
                self.planeImage.center.y -= 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4, animations: {
                self.planeImage.transform = CGAffineTransform(rotationAngle: -.pi/8)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                self.planeImage.center.x += 100.0
                self.planeImage.center.y -= 50.0
                self.planeImage.alpha = 0.0
            })

            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01, animations: {
                self.planeImage.transform = .identity
                self.planeImage.center = CGPoint(x: 0.0, y: originalCenter.y)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: {
                self.planeImage.alpha = 1.0
                self.planeImage.center = originalCenter
            })
        }, completion: nil)
    }
    // 航班时间
    func summarySwitch(to summaryText: String) {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.45, animations: {
                self.summary.center.y -= 100.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.45, animations: {
                self.summary.center.y += 100.0
            })
        }, completion: nil)
        
        delay(seconds: 0.5) {
            self.summary.text = summaryText
        }
    }
}

func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

