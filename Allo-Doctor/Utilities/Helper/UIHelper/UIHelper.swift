//
//  UIHelper.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/01/2025.
//

import UIKit

struct UIHelper {
    static func showCallActionSheet(phoneNumber: String, on viewController: UIViewController) {
        let actionSheet = UIAlertController(title:AppLocalizedKeys.ContactUs.localized, message: "", preferredStyle: .actionSheet)
        
        let callAction = UIAlertAction(title: "Call \(phoneNumber)", style: .default) { _ in
            if let phoneURL = URL(string: "tel://\(phoneNumber)"),
               UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL)
            } else {
                let alert = UIAlertController(title: "Error", message: "Calling is not supported on this device.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController.present(alert, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(callAction)
        actionSheet.addAction(cancelAction)
        
        viewController.present(actionSheet, animated: true)
    }
}
