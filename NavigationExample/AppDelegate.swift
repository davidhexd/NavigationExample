//
//  AppDelegate.swift
//  NavigationExample
//
//  Created by David He on 3/4/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow? = nil
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    let vc = RootViewController(style: .doubleColumn)
    vc.presentsWithGesture = false
    vc.preferredDisplayMode = .secondaryOnly
    
    let window = UIWindow()
    window.rootViewController = vc
    window.makeKeyAndVisible()
    
    self.window = window
    return true
  }

}

