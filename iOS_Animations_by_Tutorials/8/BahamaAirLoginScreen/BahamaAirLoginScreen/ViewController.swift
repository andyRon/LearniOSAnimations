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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // heading,username,password的图层动画
        let flyRight = CABasicAnimation(keyPath: "position.x")
        flyRight.fromValue = -view.bounds.size.width/2
        flyRight.toValue = view.bounds.size.width/2
        flyRight.duration = 0.5
        heading.layer.add(flyRight, forKey: nil)
        
        flyRight.beginTime = CACurrentMediaTime() + 0.3
        flyRight.fillMode = kCAFillModeBoth
        username.layer.add(flyRight, forKey: nil)
        
        flyRight.beginTime = CACurrentMediaTime() + 0.4
        password.layer.add(flyRight, forKey: nil)
        // 把实际图层设置到屏幕中间
        username.layer.position.x = view.bounds.size.width/2
        password.layer.position.x = view.bounds.size.width/2
        
        loginButton.center.y += 30.0
        loginButton.alpha = 0.0
        

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
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.center.y -= 30.0
            self.loginButton.alpha = 1.0
        }, completion: nil)
        
        animateCloud(cloud: cloud1)
        animateCloud(cloud: cloud2)
        animateCloud(cloud: cloud3)
        animateCloud(cloud: cloud4)
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
            self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
            self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
            self.spinner.alpha = 1.0
        }, completion: nil)

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
            self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
            self.loginButton.bounds.size.width -= 80.0
            self.loginButton.center.y -= 60.0
        }, completion: nil)
    }
    /// 云动画
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

}

func delay(_ seconds: Double, completion: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}


func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
    let tint = CABasicAnimation(keyPath: "backgroundColor")
    tint.fromValue = layer.backgroundColor
    tint.toValue = toColor.cgColor
    tint.duration = 0.5
    layer.add(tint, forKey: nil)
    layer.backgroundColor = toColor.cgColor
}
