//
//  Router.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//
import UIKit
public protocol Router: AnyObject {
  func present(_ viewController: UIViewController, animated: Bool)
  func present(_ viewController: UIViewController,animated: Bool,
  onDismissed: (()->Void)?)
  func dismiss(animated: Bool)
   }

extension Router {
  public func present(_ viewController: UIViewController,
                      animated: Bool) {
    present(viewController, animated: animated, onDismissed: nil)
  }
}
