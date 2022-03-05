//
//  PushAnimationController.swift
//  NavigationExample
//
//  Created by David He on 3/4/22.
//

import Foundation
import UIKit

class PushAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.35
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
          let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
    let containerView = transitionContext.containerView
    
    toViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.size.width, dy: 0.0)
    
    containerView.addSubview(toViewController.view)
    
    UIView.animate(
      withDuration: transitionDuration(using: transitionContext),
      delay: 0,
      animations: {
      toViewController.view.frame = containerView.bounds
      fromViewController.view.frame = containerView.bounds.offsetBy(dx: -containerView.frame.size.width * 0.25, dy: 0)
    }, completion: { (finished) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}

