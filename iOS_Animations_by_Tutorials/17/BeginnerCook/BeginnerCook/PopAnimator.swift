//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by Andy Ron on 2018/12/2.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (()->Void)?
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//        let toView = transitionContext.view(forKey: .to)!
//        containerView.addSubview(toView)
//        toView.alpha = 0.0
//        UIView.animate(withDuration: duration, animations: {
//            toView.alpha = 1.0
//        }, completion: { _ in
//            transitionContext.completeTransition(true)
//        })
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let herbView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        // 初始和最终动画frame
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
        
        // x轴和y轴上视图变化的**比例因子（scale factor）** 。
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        // 当需要呈现新视图时，设置transform，并且定位（设置center）
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            herbView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: herbView)
        
        
        let herbController = transitionContext.viewController(forKey: presenting ? .to : .from) as! HerbDetailsViewController
        
        if presenting {
            herbController.containerView.alpha = 0.0
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            
            // 给特定的containerView设置渐变
            herbController.containerView.alpha = self.presenting ? 1.0 : 0.0
            
            herbView.layer.cornerRadius = self.presenting ? 0.0 : 20.0/xScaleFactor
        }) { (_) in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        }
    }
    
    
}
