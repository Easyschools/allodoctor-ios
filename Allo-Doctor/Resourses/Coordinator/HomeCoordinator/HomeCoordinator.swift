//
//  HomeCoordinator.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import Foundation
import UIKit

// MARK: - HomeCoordinatorContact Protocol

protocol HomeCoordinatorContact: AnyObject {
    func showRegisterScreen()
    func showTabBar()
    func showSubServicesVC()
    func showSearchScreen()
    func navigateBack()
    func dismiss(completion: (() -> Void)?)
    func showOnboardingScreen()
    func showPhonenumberScreen()
    func showOtpScreen()
    var navigationController: UINavigationController { get }
    func showDoctorSearch()
    func showClinicProfile(clinicID:String)
    func showClinicsSearch()
    func showSelectLanguageScreen()
    func navToLabsAndScanSearchScreen(type:String)
    func showLabsAndScanSearchScreen(url: String,type:String)
    func presentModally(_ viewController: UIViewController)
    func dismissPresnet(_ viewController: UIViewController)
    func showHospitalSearch()
    func showDoctorProfile(doctorID: String)
    // Add this to the protocol
}

// MARK: - HomeCoordinator

final class HomeCoordinator: Coordinator {
    var window: UIWindow?
    var navigationController: UINavigationController

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
    }

    func start() {
        showLaunchScreen()
    }

   
    // Show MainTabBarController as the root of the window
    func showTabBar() {
        let viewmodel = TabBarViewModel(coordinator: self)
        viewmodel.coordinator = self
        let tabBar = MainTabBarController(viewModel: viewmodel)


        window?.rootViewController = tabBar
        
        window?.makeKeyAndVisible()
    }
}

// MARK: - HomeCoordinatorContact Implementation

extension HomeCoordinator: HomeCoordinatorContact {
    func showHospitalSearch() {
        let viewModel = HospitalSearchViewModel(coordinator: self)
        let viewController =  HospitalSearchViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
        
    }
    
    func showOtpScreen() {
        let viewModel = OTPViewModel()
        viewModel.coordinator = self
        let viewController = OTPViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showPhonenumberScreen() {
        let viewModel = PhoneNumberViewModel(coordinator: self)
        let viewController = PhoneNumberViewController(viewModel: viewModel)
   
            navigationController.pushViewController(viewController, animated: false)
 
    }
    
    func showClinicProfile(clinicID:String) {
        let viewModel = ClinicProfileViewModel(coordinator: self, clinicID: clinicID)
        let viewController = ClinicProfileViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }

    func showSubServicesVC() {
        let viewModel = SubServiceViewModel(coordinator: self)
        let viewController = SubServiceViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
                navController.pushViewController(viewController, animated: true)
            }

    }
    
    func showSelectLanguageScreen() {
        let viewModel = SelectlanguageViewModel()
        viewModel.coordinator = self
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

    func dismiss(completion: (() -> Void)?) {
        navigationController.dismiss(animated: true, completion: completion)
    }

    func navigateBack() {   if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
        navController.popViewController(animated: true)}
    }

    
    func navigateToRoot() {
        navigationController.popToRootViewController(animated: true)
    }

    func showLaunchScreen() {
        let viewController = LaunchScreenViewController()
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: true)
    }

    func showSearchScreen() {
        let viewModel = SearchViewModel(coordinator: self)
        let viewController = SearchViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
                navController.pushViewController(viewController, animated: true)
            }
    }

    func showDoctorProfile(doctorID: String) {
        let viewModel = DoctorProfileViewModel(coordinator: self, doctorId: doctorID)
        let viewController = DoctorProfileViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }

    func showOnboardingScreen() {
        let viewModel = OnBoardingScreensViewModel()
        let viewController = OnBoardingScreensViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showDoctorSearch() {
        let viewModel = DoctorSearchViewModel(coordinator: self)
        let viewController = DoctorSearchViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }

    func showClinicsSearch() {
        let viewModel = ClinicSearchScreenViewModel(coordinator: self)
        let viewController = ClinicSearchScreenViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }

    func navToLabsAndScanSearchScreen(type:String) {
        let viewModel = LabsSearchScreenViewModel(coordinator: self, screenType: type)
        let viewController = LabsSearchScreenViewController(viewModel: viewModel)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }

    func showLabsAndScanSearchScreen(url: String,type:String) {
        let viewController = LabsAndScanProfileViewController(imageUrl: url, screenType:type)
        if let navController = (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
              navController.pushViewController(viewController, animated: true)
          }
    }
 
  func presentModally(_ viewController: UIViewController) {
          navigationController.present(viewController, animated: true, completion: nil)
           
       }
    func dismissPresnet(_ viewController: UIViewController) {
            navigationController.dismiss(animated: true)
             
         }
}
