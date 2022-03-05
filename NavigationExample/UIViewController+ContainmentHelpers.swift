//
//  UIViewController+ContainmentHelpers.swift
//  NavigationExample
//
//  Created by David He on 3/4/22.
//

import Foundation
import UIKit

extension UIViewController {
  
  /// The view controller containment dance for adding a child view controller.
  /// - Parameters:
  ///   - childViewController: a child view controller containing the view that you wish to add to the receiver's view hierarchy
  ///   - addChildViewToViewHierarchy: a custom closure which is called with `childViewController`'s view. Callers should add this view to the receivers view hierarchy.
  public func install(
    _ childViewController: UIViewController,
    addChildViewToViewHierarchy: ((UIView) -> Void)?
  ) {
    if childViewController.parent != nil {
      // If childViewController already has a parent, but it's not the receiver, uninstall it and continue.
      if childViewController.parent != self {
        uninstallFromParent()
      } else {
        // If the childViewController's parent is the receiver, do nothing
        return
      }
    }
    
    guard let childView = childViewController.view,
          let view = self.view
    else {
      return
    }
    
    if let addChildViewToViewHierarchy = addChildViewToViewHierarchy {
      addChildViewToViewHierarchy(childView)
    } else {
      view.addSubview(childView)
    }
    addChild(childViewController)
    childViewController.didMove(toParent: self)
  }
  
  /// The view controller containment dance for removing the receiver from a parent view controlller.
  public func uninstallFromParent() {
    guard parent != nil else {
      return
    }
    
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
  
  public func installAndFill(_ child: UIViewController) {
    child.uninstallFromParent()
    addChild(child)
    view.addSubview(child.view)
    
    // satify both autolayout & non-autolayout
    child.view.frame = view.bounds
    child.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    NSLayoutConstraint.activate([
      child.view.topAnchor.constraint(equalTo: view.topAnchor),
      child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
}
