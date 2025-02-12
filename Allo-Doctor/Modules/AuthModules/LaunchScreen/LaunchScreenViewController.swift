//
//  LaunchScreenViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/09/2024.
//

import UIKit
import Reachability

class LaunchScreenViewController: UIViewController {
   
    // MARK: - Outlets
    @IBOutlet private weak var offlineStackView: UIStackView!
    @IBOutlet private weak var loadingGif: UIImageView!
    @IBOutlet private weak var offlineView: UIView!
    @IBOutlet private weak var retryButton: UnderlinedButton!
    
    // MARK: - Properties
     var coordinator: HomeCoordinator?
    private let reachabilityManager = ReachabilityManager.shared
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        addObservers()
        checkInternetAtStart()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    private func setupInitialState() {
        offlineView.isHidden = true
        retryButton.isHidden = true
        loadingGif.image = UIImage.gifImageWithName("loading")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSlowConnection), name: .slowConnection, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGoodConnection), name: .goodConnection, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoConnection), name: .noConnection, object: nil)
    }
    
    // MARK: - Actions
    @IBAction private func retryAction(_ sender: Any) {
        checkInternet()
    }
    
    // MARK: - Internet Connection Handlers
    private func checkInternetAtStart() {
        if !reachabilityManager.isReachable() {
            handleNoConnectionState()
        } else if reachabilityManager.isSlowConnection() {
            handleSlowConnectionState()
        } else {
            navigateAfterDelay()
        }
    }
    
    private func checkInternet() {
        if !reachabilityManager.isReachable() {
            handleNoConnectionState()
        } else if reachabilityManager.isSlowConnection() {
            handleSlowConnectionState()
        } else {
            handleGoodConnectionState()
        }
    }
    
    private func handleNoConnectionState() {
        AlertManager.showInternetAlert(on: self, message: "No Internet Connection. Please check your settings.")
        updateUIForNoConnection()
    }
    
    private func handleSlowConnectionState() {
        AlertManager.showInternetAlert(on: self, message: "Your connection is slow. Please check your settings.")
        updateUIForSlowConnection()
    }
    
    private func handleGoodConnectionState() {
        offlineView.isHidden = true
        retryButton.isHidden = true
        loadingGif.isHidden = false
        navigateAfterDelay()
    }
    
    private func updateUIForNoConnection() {
        loadingGif.isHidden = true
        offlineView.isHidden = false
        retryButton.isHidden = false
    }
    
    private func updateUIForSlowConnection() {
        loadingGif.isHidden = true
    }
    
    // MARK: - Navigation
    private func navigateAfterDelay() {
        loadingGif.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.navigateToNextScreen()
        }
    }
    
    private func navigateToNextScreen() {
        if UserDefaultsManager.sharedInstance.isLoggedIn() {
            coordinator?.showTabBar()
        } else if UserDefaultsManager.sharedInstance.isLanguageSet() {
            navigateToOnboardingOrPhoneScreen()
        } else {
            coordinator?.showSelectLanguageScreen()
        }
    }
    
    private func navigateToOnboardingOrPhoneScreen() {
        if UserDefaultsManager.sharedInstance.checkingShowingOnboarding() {
            coordinator?.showPhonenumberScreen()
        } else {
            coordinator?.showOnboardingScreen()
        }
    }
    
    // MARK: - Notification Handlers
    @objc private func handleSlowConnection() {
        handleSlowConnectionState()
    }
    
    @objc private func handleGoodConnection() {
        handleGoodConnectionState()
    }
    
    @objc private func handleNoConnection() {
        handleNoConnectionState()
    }
}
