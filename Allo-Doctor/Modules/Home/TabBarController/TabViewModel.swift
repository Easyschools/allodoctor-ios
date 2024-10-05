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
        let activityVC = MyActivityViewController(viewModel: MyActivityViewModel())
        let offersVC = OffersViewController(viewModel: OffersViewModel())

        // Create UINavigationController instances and configure their tab bar items
        let serviceNav = createNavController(viewController: servicesVC, title: ToolBarVCs.services.rawValue, image: UIImage.homeunfilled, selectedImage: UIImage.homefilled)
        let profileNav = createNavController(viewController: profileVC, title: ToolBarVCs.profile.rawValue, image: UIImage.profileUnfilld, selectedImage: UIImage.profileImageFileld)
        let activityNav = createNavController(viewController: activityVC, title: ToolBarVCs.activity.rawValue, image: UIImage.activityUnfilled, selectedImage: UIImage.activityFilled)
        let offersNav = createNavController(viewController: offersVC, title: ToolBarVCs.offers.rawValue, image: UIImage.offersUnfilled, selectedImage: UIImage.offersfilled)

        // Return the navigation controllers as tab bar items
        return [serviceNav, activityNav, offersNav, profileNav]
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
