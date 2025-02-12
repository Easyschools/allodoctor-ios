//
//  UIViewController+Extentions.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//

import UIKit


extension UIViewController {
    static func instantiate() -> Self {
        return Self(nibName: String(describing: self), bundle: nil)
    }
}
