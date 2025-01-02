//
//  AppCoordinator.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import UIKit
import GoogleMaps
/// A coordinator responsible for managing the app's navigation flows.
final class AppCoordinator: Coordinator {

    private let window: UIWindow
    private var children: [Coordinator] = []
    var navigationController: UINavigationController
     
    /// Initializes an instance of `AppCoordinator`.
    ///
    /// - Parameters:
    ///   - window: The main application window.
    ///   - navigationController: The root navigation controller for the app.
    init(window: UIWindow, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.window = window
        setupGoogleMaps()
    }

    /// Starts the app coordinator by configuring dependencies and displaying the home flow.
    func start() {
        // TODO: check auth status
        displayHomeFlow()
    }
}

// MARK: Flows Helpers
private extension AppCoordinator {

    /// Displays the home flow by initializing and starting the `DefaultHomeCoordinator`.
    func displayHomeFlow() {
        var coordinator: Coordinator
        coordinator = HomeCoordinator(navigationController: navigationController,window: window )
        coordinator.start()
        children.append(coordinator)
        replaceRootViewController(navigationController)
    }
    private func setupGoogleMaps() {
          let dispatchSemaphore = DispatchSemaphore(value: 0)
          
          let backgroundQueue = DispatchQueue(label: "com.yourapp.googleMaps.initialization",
                                            qos: .userInitiated)
          
          backgroundQueue.async {
              autoreleasepool {
                  GMSServices.provideAPIKey("AIzaSyDJkVY_BdzPGHKPRV1zvVNoqiw2sbOszXg")
                  dispatchSemaphore.signal()
              }
          }
          
          _ = dispatchSemaphore.wait(timeout: .now() + 5.0)
      }
}

// MARK: Window Replacement
private extension AppCoordinator {
    func replaceRootViewController(_ viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
