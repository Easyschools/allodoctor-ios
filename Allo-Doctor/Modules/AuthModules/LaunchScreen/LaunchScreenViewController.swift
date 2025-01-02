//
//  LaunchScreenViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/09/2024.
//

import UIKit
import Reachability

class LaunchScreenViewController: UIViewController {
   
    @IBOutlet weak var offlineStackView: UIStackView!
    @IBOutlet weak var loadingGif: UIImageView!
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var retryButton: UnderlinedButton!
    var coordinator: HomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offlineView.isHidden = true
        retryButton.isHidden = true
        let loadingimage = UIImage.gifImageWithName("loading")
        loadingGif?.image = loadingimage
        // Add observers for connection status changes
        NotificationCenter.default.addObserver(self, selector: #selector(handleSlowConnection), name: .slowConnection, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGoodConnection), name: .goodConnection, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoConnection), name: .noConnection, object: nil)
        checkInternetAtStart()
    }
    
    @IBAction func retryAction(_ sender: Any) {
        checkInternetAgain()
    }
    
    func checkInternetAtStart() {
        if !ReachabilityManager.shared.isReachable() {
            AlertManager.showInternetAlert(on: self, message: "No Internet Connection. Please check your settings.")
            loadingGif.isHidden = true
            offlineView.isHidden = false
            retryButton.isHidden = false
        } else if ReachabilityManager.shared.isSlowConnection() {
            AlertManager.showInternetAlert(on: self, message: "Your connection is slow. Please check your settings.")
        } else {
            delayedNavigation()
        }
    }
    
    @objc func handleSlowConnection() {
        AlertManager.showInternetAlert(on: self, message: "Your connection is slow. Please check your settings.")
    }
    
    @objc func handleGoodConnection() {
        // Removed direct call to navigateToNextScreen()
    }
    
    @objc func handleNoConnection() {
        AlertManager.showInternetAlert(on: self, message: "No Internet Connection. Please check your settings.")
    }
    
    func delayedNavigation() {
        // Show loading indicator if it's not already visible
        loadingGif.isHidden = false
        
        // Delay navigation by 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.navigateToNextScreen()
        }
    }
    
    func navigateToNextScreen() {
        if UserDefaultsManager.sharedInstance.isLoggedIn() {
            coordinator?.showTabBar()
        } else {
            coordinator?.showSelectLanguageScreen()
        }
    }

    func checkInternetAgain() {
        if !ReachabilityManager.shared.isReachable() {
            AlertManager.showInternetAlert(on: self, message: "No Internet Connection. Please check your settings.")
            offlineView.isHidden = false
            retryButton.isHidden = false
            loadingGif.isHidden = true
        } else if ReachabilityManager.shared.isSlowConnection() {
            AlertManager.showInternetAlert(on: self, message: "Your connection is slow. Please check your settings.")
            loadingGif.isHidden = true
        } else {
            offlineView.isHidden = true
            retryButton.isHidden = true
            loadingGif.isHidden = false
            delayedNavigation()
        }
    }
}
