//
//  CustomNavigationController.swift
//  NavigationExample
//
//  Created by David He on 3/4/22.
//

import Foundation
import UIKit

protocol CustomNavigationControllerDataSource: NSObject {
  func viewControllerToPush(_ navigationController: CustomNavigationController) -> UIViewController?
}

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
  
  weak var dataSource: CustomNavigationControllerDataSource? = nil
  
  private var interactionController: UIPercentDrivenInteractiveTransition?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationBar.isHidden = true
    self.delegate = self
    
    self.interactivePopGestureRecognizer?.delegate = nil
    
    let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeFromRightEdge(_:)))
    edgeSwipeGestureRecognizer.edges = .right
    view.addGestureRecognizer(edgeSwipeGestureRecognizer)
  }
  
  @objc func handleSwipeFromRightEdge(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
    guard let view = gestureRecognizer.view else {
      return
    }
    
    let percent = abs(gestureRecognizer.translation(in: view).x / view.bounds.size.width)
    let velocity = gestureRecognizer.velocity(in: view)
    
    switch gestureRecognizer.state {
    case .possible:
      break
    case .began:
      guard let viewControllerToPush = dataSource?.viewControllerToPush(self) else {
        gestureRecognizer.isEnabled = false
        gestureRecognizer.isEnabled = true
        return
      }
      
      interactionController = UIPercentDrivenInteractiveTransition()
      pushViewController(viewControllerToPush, animated: true)
      
      interactionController?.update(percent)
    case .changed:
      interactionController?.update(percent)
    case .ended:
      let didComplete = percent > 0.3 || abs(velocity.x) > 700
      if didComplete {
        interactionController?.finish()
      } else {
        interactionController?.cancel()
      }
      interactionController = nil
    case .failed, .cancelled:
      interactionController?.cancel()
      interactionController = nil
    @unknown default:
      break
    }
  }
  
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch operation {
    case .push:
      return PushAnimationController()
    default:
      return nil
    }
  }
  
  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactionController
  }
  
}
