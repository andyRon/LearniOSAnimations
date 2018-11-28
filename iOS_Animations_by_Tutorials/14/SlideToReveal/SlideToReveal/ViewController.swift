//
//  ViewController.swift
//  SlideToReveal
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/11/13.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var slideView: AnimateMaskLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 滑动手势动画
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.didSlide))
        swipe.direction = .right
        slideView.addGestureRecognizer(swipe)
    }

    @objc func didSlide() {
        let image = UIImageView(image: UIImage(named: "meme"))
        image.center = view.center
        image.center.x += view.bounds.size.width
        view.addSubview(image)
        
        UIView.animate(withDuration: 0.33, delay: 0.0, animations: {
            self.time.center.y -= 200.0
            self.slideView.center.y += 200.0
            image.center.x -= self.view.bounds.size.width
        }, completion: nil)
        
        UIView.animate(withDuration: 0.33, delay: 1.0, animations: {
            self.time.center.y += 200.0
            self.slideView.center.y -= 200.0
            image.center.x += self.view.bounds.size.width
        }, completion: { _ in
            image.removeFromSuperview()
        })
        
    }

}

