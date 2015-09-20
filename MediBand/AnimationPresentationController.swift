//
//  AnimationPresentationController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/11/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class AnimationPresentationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    
    var frame: CGRect!
    var y : CGFloat!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController:UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController:UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        var fromViewControllerFrame = fromViewController.view.frame

        fromViewControllerFrame.size = CGSizeMake(fromViewControllerFrame.size.width * 0.8, UIScreen.mainScreen().bounds.size.height * 0.45)
        
        let finalFrame = CGRectMake(32, 82, 250, 225)
        
        if isPresenting {
            let containerView:UIView = transitionContext.containerView()!
            let screenBounds = UIScreen.mainScreen().bounds
            
            toViewController.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height)
            containerView.addSubview(fromViewController.view)
            containerView.addSubview(toViewController.view)
            
            
            let duration = self.transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                fromViewController.view.alpha = 0.9
                toViewController.view.frame = fromViewControllerFrame
                toViewController.view.center = fromViewController.view.center
                toViewController.view.layer.cornerRadius = 5
                }) { (Bool finished) -> Void in
                    transitionContext.completeTransition(true)
                    UIApplication.sharedApplication().keyWindow?.addSubview(toViewController.view)
            }
            
        }else {

            toViewController.view.userInteractionEnabled = true
            
            var frame = fromViewController.view.frame
            let bounds = UIScreen.mainScreen().bounds
            
            let containerView = transitionContext.containerView()
            containerView!.addSubview(toViewController.view)
            containerView!.addSubview(fromViewController.view)
            UIApplication.sharedApplication().keyWindow?.addSubview(toViewController.view)
            
            frame.origin.y += bounds.size.height
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                toViewController.view.alpha = 1
                fromViewController.view.frame = frame
            }, completion: { (Bool done) -> Void in
                
                UIApplication.sharedApplication().keyWindow?.addSubview(toViewController.view)
                transitionContext.completeTransition(true)
            })
            
            
        }
//

        

        
    }
   
}
