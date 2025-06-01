//
//  AuthNavigationModule.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/01/2025.
//


// MARK: - Auth Modules Navigations
import UIKit
extension HomeCoordinator{
    func showSelectLanguageScreen() {
        let viewModel = SelectlanguageViewModel(coordinator: self)
        let viewController = SelectlanguageViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: false)
          }
        else{
            navigationController.pushViewController(viewController, animated: false)}
    }

    func showRegisterScreen() {
        let viewModel = RegisterViewModel(coordinator: self)
        let viewController = RegisterViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    func showOnboardingScreen() {
        let viewModel = OnBoardingScreensViewModel()
        viewModel.coordinator = self
        let viewController = OnBoardingScreensViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    func showOtpScreen() {
        let viewModel = OTPViewModel()
        viewModel.coordinator = self
        let viewController = OTPViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
        else{
            navigationController.pushViewController(viewController, animated: true)}
    }
    
    func showPhonenumberScreen() {
        
        let viewModel = PhoneNumberViewModel(coordinator: self)
        let viewController = PhoneNumberViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
        else {
            navigationController.pushViewController(viewController, animated: false)}
 
    }
}
