//
//  AlertMangerCheckInternet.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//

import UIKit

class AlertManager {
    static func showInternetAlert(on viewController: UIViewController, message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { 
            let alert = UIAlertController(title: "Network Issue", message: message, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(settingsAction)
            alert.addAction(okAction)
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
