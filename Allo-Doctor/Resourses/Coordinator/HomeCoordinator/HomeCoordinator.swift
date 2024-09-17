//
//  HomeCoordinator.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import Foundation
import UIKit
protocol TabbarCoordinator{
  
}
protocol HomeCoordinatorContact: AnyObject {
    func showRegisterScreen()
    func showProfileVC() -> UIViewController
    func showActivityVc() -> UIViewController
    func showOffersVC() -> UIViewController
    func showServicesVC() -> UIViewController
    func showTabBar()
    func showSubServicesVC()
    func showSearchScreen()
    func dismiss(completion: (() -> Void)?)
    
    var navigationController: UINavigationController { get }
}

final class HomeCoordinator: Coordinator, TabbarCoordinator {
    var navigationController: UINavigationController
    private var servicesVC: ServicesViewController?
    private var profileVc: MyProfileViewController?
    private var activityVc : MyActivityViewController?
    private var offercsVC : OffersViewController?
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// starts the coordinator
    func start() {
        showSubServiceScreen()
    }
    
}
extension HomeCoordinator: HomeCoordinatorContact {
    func showSubServicesVC() {
        let viewModel = SubServiceViewModel(coordinator: self)
        let viewController = SubServiceViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showTabBar() {
        let tabBar = MainTabBarController()
        tabBar.coordinator = self
        navigationController.setViewControllers([tabBar], animated: false)
    }
    

    
    func showRegisterScreen() {
        let viewModel = RegisterViewModel(coordinator: self)
        let viewController = RegisterViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func dismiss(completion: (() -> Void)?) {
        
    }
    
    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    func showServicesVC() -> UIViewController {
        if servicesVC == nil {
            let viewModel = ServicesViewModel()
            servicesVC = ServicesViewController(viewModel: viewModel)
              }
              return servicesVC!
    }
    
    func showActivityVc() -> UIViewController {
        if activityVc == nil {
            let viewModel = MyActivityViewModel()
            activityVc = MyActivityViewController(viewModel: viewModel)
              }
              return activityVc!
    }
    
    func showProfileVC() -> UIViewController {
        if profileVc == nil {
            let viewModel = MyProfileViewModel()
            profileVc = MyProfileViewController(viewModel: viewModel)
              }
              return profileVc!
    }
    
    func showOffersVC() -> UIViewController {
        if offercsVC == nil {
            let viewModel = OffersViewModel()
            offercsVC = OffersViewController(viewModel: viewModel)
              }
              return offercsVC!
    }
    func showLaunchscrean (){
        let viewController = LaunchScreenViewController()
        navigationController.setViewControllers([viewController], animated: false)
    }
    func showSubServiceScreen(){
        let viewModel = SubServiceViewModel()
        viewModel.coordinator = self
        let viewController = SubServiceViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    func showSearchScreen(){
        let viewController = SearchViewController()
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
}
