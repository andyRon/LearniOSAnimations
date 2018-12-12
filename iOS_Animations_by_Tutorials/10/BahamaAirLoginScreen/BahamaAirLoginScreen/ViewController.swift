//
//  ViewController.swift
//  BahamaAirLoginScreen
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/8/19.
//  Copyright © 2018年 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    @IBOutlet weak var cloud3: UIImageView!
    @IBOutlet weak var cloud4: UIImageView!
    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    let status = UIImageView(image: UIImage(named: "banner"))

    var statusPosition = CGPoint.zero
    
    
    let info = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 8.0
        
        spinner.frame = CGRect(x: -20, y: 6.0, width: 20.0, height: 20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)
        
        status.isHidden = true
        status.center = loginButton.center
        view.addSubview(status)
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)
        
        statusPosition = status.center
        
        // 设置提示信息UILabel
        setInfoLabel()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // heading,username,password的图层动画
//        let flyRight = CABasicAnimation(keyPath: "position.x")
//        flyRight.fromValue = -view.bounds.size.width/2
//        flyRight.toValue = view.bounds.size.width/2
//        flyRight.duration = 0.5
//        flyRight.delegate = self
//        flyRight.setValue("form", forKey: "name")
//        flyRight.setValue(heading.layer, forKey: "layer")
//        heading.layer.add(flyRight, forKey: nil)
//
//
//        flyRight.beginTime = CACurrentMediaTime() + 0.3
//        flyRight.fillMode = kCAFillModeBoth
//        flyRight.setValue(username.layer, forKey: "layer")
//        username.layer.add(flyRight, forKey: nil)
//
//        flyRight.beginTime = CACurrentMediaTime() + 0.4
//        flyRight.setValue(password.layer, forKey: "layer")
//        password.layer.add(flyRight, forKey: nil)
//        // 把原来图层设置到屏幕中间
//        username.layer.position.x = view.bounds.size.width/2
//        password.layer.position.x = view.bounds.size.width/2
        
        // 替换为组动画形式
        let formGroup = CAAnimationGroup()
        formGroup.duration = 0.5
        formGroup.fillMode = kCAFillModeBackwards
        
        let flyRight = CABasicAnimation(keyPath: "position.x")
        flyRight.fromValue = -view.bounds.size.width/2
        flyRight.toValue = view.bounds.size.width/2
        
        let fadeFieldIn = CABasicAnimation(keyPath: "opacity")
        fadeFieldIn.fromValue = 0.25
        fadeFieldIn.toValue = 1.0
        
        formGroup.animations = [flyRight, fadeFieldIn]
        heading.layer.add(formGroup, forKey: nil)
        
        formGroup.delegate = self
        formGroup.setValue("form", forKey: "name")
        formGroup.setValue(username.layer, forKey: "layer")
        
        formGroup.beginTime = CACurrentMediaTime() + 0.3
        username.layer.add(formGroup, forKey: nil)
        
        formGroup.setValue(password.layer, forKey: "layer")
        formGroup.beginTime = CACurrentMediaTime() + 0.4
        password.layer.add(formGroup, forKey: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 云淡入的图层动画
        let cloudFade = CABasicAnimation(keyPath: "alpha")
        cloudFade.duration = 0.5
        cloudFade.fromValue = 0.0
        cloudFade.toValue = 1.0
        cloudFade.fillMode = kCAFillModeBackwards
        
        cloudFade.beginTime = CACurrentMediaTime() + 0.5
        cloud1.layer.add(cloudFade, forKey: nil)
        
        cloudFade.beginTime = CACurrentMediaTime() + 0.7
        cloud2.layer.add(cloudFade, forKey: nil)
        
        cloudFade.beginTime = CACurrentMediaTime() + 0.9
        cloud3.layer.add(cloudFade, forKey: nil)
        
        cloudFade.beginTime = CACurrentMediaTime() + 1.1
        cloud4.layer.add(cloudFade, forKey: nil)
        
        
        // 登录按钮的组动画
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = CACurrentMediaTime() + 0.5
        groupAnimation.duration = 0.5
        groupAnimation.fillMode = kCAFillModeBackwards
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)  // Animation easing
        
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 3.5
        scaleDown.toValue = 1.0
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = .pi / 4.0
        rotate.toValue = 0.0
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.0
        fade.toValue = 1.0
        
        groupAnimation.animations = [scaleDown, rotate, fade]
        loginButton.layer.add(groupAnimation, forKey: nil)
        
        
        animateCloud(layer: cloud1.layer)
        animateCloud(layer: cloud2.layer)
        animateCloud(layer: cloud3.layer)
        animateCloud(layer: cloud4.layer)

        // 提示信息Label的两个动画
        let flyLeft = CABasicAnimation(keyPath: "position.x")
        flyLeft.fromValue = info.layer.position.x + view.frame.size.width
        flyLeft.toValue = info.layer.position.x
        flyLeft.duration = 5.0
        flyLeft.repeatCount = 4
        flyLeft.autoreverses = true
        flyLeft.speed = 2.0
//        info.layer.speed = 2.0
//        view.layer.speed = 2.0
        info.layer.add(flyLeft, forKey: "infoappear")
        
        let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
        fadeLabelIn.fromValue = 0.2
        fadeLabelIn.toValue = 1.0
        fadeLabelIn.duration = 4.5
        info.layer.add(fadeLabelIn, forKey: "fadein")
        
        username.delegate = self
        password.delegate = self
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        view.endEditing(true)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options:[], animations: {
            self.loginButton.bounds.size.width += 80.0
        }, completion: { _ in
            self.showMessage(index: 0)
        })
        
        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.center.y += 60.0
            self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
            self.spinner.alpha = 1.0
        }, completion: nil)
        // 背景颜色变化的图层动画
        let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
        
        roundCorners(layer: loginButton.layer, toRadius: 25.0)
    }
    /// 状态信息显示
    func showMessage(index: Int) {
        label.text = messages[index]
        
        UIView.transition(with: status, duration: 0.33, options: [.curveEaseOut, .transitionCurlDown], animations: {
            self.status.isHidden = false
        }) { (_) in
            delay(2.0) {
                if index < self.messages.count - 1 {
                    self.removeMessage(index: index)
                } else {
                    self.resetForm()
                }
            }
        }
    }
    /// 状态信息消除
    func removeMessage(index: Int) {
        UIView.animate(withDuration: 0.33, delay: 0.0, options: [], animations: {
            self.status.center.x += self.view.frame.size.width
        }) { (_) in
            self.status.isHidden = true
            self.status.center = self.statusPosition
            
            self.showMessage(index: index+1)
        }
    }
    /// 信息标签和登录按钮等恢复到原来状态
    func resetForm() {
        // 状态信息标签消失动画
        UIView.transition(with: status, duration: 0.2, options: .transitionFlipFromTop, animations: {
            self.status.isHidden = true
            self.status.center = self.statusPosition
        }, completion: nil)
        // 登录按钮和菊花转恢复原来状态的动画
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.spinner.center = CGPoint(x: -20.0, y: 16.0)
            self.spinner.alpha = 0.0
            self.loginButton.bounds.size.width -= 80.0
            self.loginButton.center.y -= 60.0
        }, completion: { _ in
            // 背景颜色动画
            let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
            tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
            
            roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
        })
    }
    /// 云的视图动画
    func animateCloud(cloud: UIImageView) {
        // 假设云从进入屏幕到离开屏幕需要大约60.0s，可以计算出云移动的速度
        let cloudSpeed = view.frame.size.width / 60.0
        // 云的初始位置不一定是在左边缘
        let duration:CGFloat = (view.frame.size.width - cloud.frame.origin.x) / cloudSpeed
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear, animations: {
            cloud.frame.origin.x = self.view.frame.size.width
        }) { (_) in
            cloud.frame.origin.x = -cloud.frame.size.width
            self.animateCloud(cloud: cloud)
        }
    }
    /// 云的图层动画
    func animateCloud(layer: CALayer) {
        let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
        let duration: TimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
        print(duration)
        let cloudMove = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.toValue = self.view.bounds.width + layer.bounds.width/2
        cloudMove.delegate = self
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        layer.add(cloudMove, forKey: nil)
    }
    
    func setInfoLabel() {
        info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0,  width: view.frame.size.width, height: 30)
        info.backgroundColor = UIColor.clear
        info.font = UIFont(name: "HelveticaNeue", size: 12.0)
        info.textAlignment = .center
        info.textColor = UIColor.white
        info.text = "Tap on a field and enter username and password"
        view.insertSubview(info, belowSubview: loginButton)
    }

}

func delay(_ seconds: Double, completion: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

// 背景颜色变化的图层动画
func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
    let tint = CABasicAnimation(keyPath: "backgroundColor")
    tint.fromValue = layer.backgroundColor
    tint.toValue = toColor.cgColor
    tint.duration = 0.5
    layer.add(tint, forKey: nil)
    layer.backgroundColor = toColor.cgColor
}
// 圆角动画
func roundCorners(layer: CALayer, toRadius: CGFloat) {
    let round = CABasicAnimation(keyPath: "cornerRadius")
    round.fromValue = layer.cornerRadius
    round.toValue = toRadius
    round.duration = 0.33
    layer.add(round, forKey: nil)
    layer.cornerRadius = toRadius    
}


extension ViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print(anim.description, "动画完成")
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }

        if name == "form" {
            // `value(forKey:)`的结果总是`Any`，因此需要转换为所需类型
            let layer = anim.value(forKey: "layer") as? CALayer
            // 简单的脉动动画
            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.25
            pulse.toValue = 1.0
            pulse.duration = 0.25
            layer?.add(pulse, forKey: nil)
        }
        
        if name == "cloud" {
            if let layer = anim.value(forKey: "layer") as? CALayer {
                anim.setValue(nil, forKey: "layer")
                
                layer.position.x = -layer.bounds.width/2
                delay(0.5) {
                    self.animateCloud(layer: layer)
                }
            }
        }
        
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let runningAnimations = info.layer.animationKeys() else {
            return
        }
        print(runningAnimations)
        info.layer.removeAnimation(forKey: "infoappear")
    }
}
