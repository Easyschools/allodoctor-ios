//
//  TabViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import UIKit

final class TabBarViewModel {
    weak var coordinator: HomeCoordinatorContact?

    init(coordinator: HomeCoordinatorContact) {
        self.coordinator = coordinator
    }

    func getViewControllers() -> [UIViewController] {
        // Create view controllers with their respective view models
        let servicesVC = ServicesViewController(viewModel: ServicesViewModel(coordinator: coordinator))
        let profileVC = MyProfileViewController(viewModel: MyProfileViewModel(coordinator: coordinator))
        let profileUnAuthVC = NonAuthUserViewController(viewModel:NonAuthUserViewModel(coordinator: coordinator))
        let activityVC = MyActivityViewController(viewModel: MyActivityViewModel(coordinator: coordinator))
        let offersVC = OffersViewController(viewModel: OffersViewModel(coordinator: coordinator))
        
        // Create UINavigationController instances and configure their tab bar items
        let serviceNav = createNavController(viewController: servicesVC, title: AppLocalizedKeys.Services.localized, image: .homeunfilled, selectedImage: .homefilled)
        let profileNav = createNavController(viewController: profileVC, title: AppLocalizedKeys.Profile.localized, image: .user, selectedImage: .userFilled)
        let activityNav = createNavController(viewController: activityVC, title: AppLocalizedKeys.Activity.localized, image: .activityUnfilled, selectedImage: .activityFilled)
        let offersNav = createNavController(viewController: offersVC, title: AppLocalizedKeys.Offers.localized, image: .offersUnfilled, selectedImage: .offersfilled)
        let profileNonAuthNav = createNavController(viewController: profileUnAuthVC, title: AppLocalizedKeys.Profile.localized, image: .user, selectedImage: .userFilled)
        

        // Return the navigation controllers as tab bar items
        if UserDefaultsManager.sharedInstance.isLoggedIn() {
            return [serviceNav, activityNav, offersNav, profileNav]
          } else {
              return [serviceNav, activityNav, offersNav, profileNonAuthNav]
          }
     
    }

    // Helper method to create UINavigationController and configure its tab bar item
    private func createNavController(viewController: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        
        // Configure tab bar item with image insets and title position adjustment for padding
        navController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0) // Padding between icon and label
        navController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5) // Adjust title position downwards
        
        return navController
    }
}
