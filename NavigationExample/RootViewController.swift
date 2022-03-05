//
//  RootViewController.swift
//  NavigationExample
//
//  Created by David He on 3/4/22.
//

import UIKit
import Combine

class RootViewController: UISplitViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    traitCollectionSubject.send(traitCollection)
    
    view.backgroundColor = .white
    // Do any additional setup after loading the view.
    
    setViewController(primaryController, for: .primary)
    setViewController(secondaryController, for: .secondary)
    setViewController(compactController, for: .compact)
    
    compactController.viewControllers = [homeTabViewController]
    compactController.dataSource = self
    
    traitCollectionSubject
      .compactMap { $0 }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] traitCollection in
        self?.moveViewControllers(for: traitCollection)
      }.store(in: &cancellables)
  }
  
  override func willTransition(
    to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.willTransition(to: newCollection, with: coordinator)
    traitCollectionSubject.send(newCollection)
  }
  
  private let primaryController = UIViewController()
  private let secondaryController = UIViewController()
  private let compactController = CustomNavigationController(nibName: nil, bundle: nil)
  private let traitCollectionSubject = CurrentValueSubject<UITraitCollection?, Never>(nil)
  
  private var cancellables = Set<AnyCancellable>()
  private var shown = false
  
  private let interactionController = UIPercentDrivenInteractiveTransition()
  
  private enum Tab: String {
    case home = "Home"
    case activity = "Activity"
  }
  
  private lazy var bottomBarView: UIView = {
    let tabBar = UITabBar()
    tabBar.setItems(
      [
        UITabBarItem(title: Tab.home.rawValue, image: UIImage(systemName: "house"), selectedImage: nil),
        UITabBarItem(title: Tab.activity.rawValue, image: UIImage(systemName: "bell"), selectedImage: nil)
      ],
      animated: false)
    tabBar.translatesAutoresizingMaskIntoConstraints = false
    return tabBar
  }()
  
  private func installBottomBar() {
    compactController.view.addSubview(bottomBarView)
    
    NSLayoutConstraint.activate([
      bottomBarView.leadingAnchor.constraint(equalTo: compactController.view.leadingAnchor),
      bottomBarView.trailingAnchor.constraint(equalTo: compactController.view.trailingAnchor),
      bottomBarView.bottomAnchor.constraint(equalTo: compactController.view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  private func removeBottomBar() {
    bottomBarView.removeFromSuperview()
  }
  
  private lazy var webViewController: LabelViewController = {
    let vc = LabelViewController(text: "Page", backgroundColor: .white)
    vc.topLeftText = "🏠"
    vc.onTopLeftTap = { [weak self] in
      guard let self = self else {
        return
      }
      
      switch self.displayMode {
      case .secondaryOnly:
        self.show(.primary)
      case .oneOverSecondary, .oneBesideSecondary:
        self.hide(.primary)
      default:
        break
      }
    }
    return vc
  }()
  
  private lazy var homeTabViewController: LabelViewController = {
    let vc = LabelViewController(text: "Home", backgroundColor: .lightGray)
    vc.onTap = { [weak self] in
      guard let self = self else {
        return
      }
      self.compactController.pushViewController(self.webViewController, animated: true)
    }
    return vc
  }()
  
  private func moveViewControllers(for newTraitCollection: UITraitCollection) {
    if newTraitCollection.horizontalSizeClass == .regular
        && webViewController.parent != secondaryController
    {
      removeBottomBar()
      webViewController.showTopLeftButton = true
      secondaryController.installAndFill(webViewController)
    }
    
    if newTraitCollection.horizontalSizeClass == .regular
        && homeTabViewController.parent != primaryController
    {
      primaryController.installAndFill(homeTabViewController)
    }
    
    if newTraitCollection.horizontalSizeClass == .compact {
      installBottomBar()
      webViewController.showTopLeftButton = false
      compactController.setViewControllers([homeTabViewController, webViewController], animated: false)
    } else {
      removeBottomBar()
    }
  }
  
}

extension RootViewController: CustomNavigationControllerDataSource {
  
  func viewControllerToPush(_ navigationController: CustomNavigationController) -> UIViewController? {
    guard !navigationController.viewControllers.contains(webViewController) else {
      return nil
    }
    
    return webViewController
  }
  
}
