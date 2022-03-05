//
//  LabelViewController.swift
//  NavigationExample
//
//  Created by David He on 3/4/22.
//

import Foundation
import UIKit

class LabelViewController: UIViewController {
  
  init(text: String, backgroundColor: UIColor) {
    self.text = text
    self.backgroundColor = backgroundColor
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let text: String
  let backgroundColor: UIColor
  
  var onTap: (() -> Void)? = nil
  
  var topLeftText: String? = nil
  var onTopLeftTap: (() -> Void)? = nil
  var showTopLeftButton: Bool = false {
    didSet {
      topLeftButton?.isHidden = !showTopLeftButton
    }
  }
  
  private var topLeftButton: UIButton? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let label = UIButton()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.setTitle(text, for: .normal)
    label.setTitleColor(.darkText, for: .normal)
    label.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    
    let topLeftButton = UIButton()
    topLeftButton.translatesAutoresizingMaskIntoConstraints = false
    topLeftButton.setTitle(topLeftText, for: .normal)
    topLeftButton.setTitleColor(.darkText, for: .normal)
    topLeftButton.addTarget(self, action: #selector(didTapTopLeft), for: .touchUpInside)
    
    view.addSubview(topLeftButton)
    NSLayoutConstraint.activate([
      topLeftButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
      topLeftButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
    ])
    
    topLeftButton.isHidden = !showTopLeftButton
    self.topLeftButton = topLeftButton
    
    view.backgroundColor = backgroundColor
  }
  
  @objc func didTap() {
    onTap?()
  }
  
  @objc func didTapTopLeft() {
    onTopLeftTap?()
  }
}
