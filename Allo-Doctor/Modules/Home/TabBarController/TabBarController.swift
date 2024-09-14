//
//  TabbarController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var serviceVC: UIViewController!
    var profileVC: UIViewController!
    var offersVC: UIViewController!
    var activityVC: UIViewController!
    var coordinator: HomeCoordinatorContact?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
       
        // Setup tabs and appearance
        setupTabs()
        setupAppearance()
        
        // Set the default selected index
        self.selectedIndex = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = false
    }


    /// Configure the tab bar appearance
    private func setupAppearance() {
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .darkBlue295DA8
        tabBar.barTintColor = .white
        tabBar.tintColor = .white // Selected item color
        tabBar.unselectedItemTintColor = .gray // Unselected item color
    }
    
    /// Initialize the view controllers for the tab bar
    private func setupTabs() {
        // Configure tab bar items with the actual view controllers or placeholders
        let serviceTab = createTab(with: "Services", image: UIImage(systemName: "gearshape"), vc: serviceVC ?? ServicesViewController(viewModel: ServicesViewModel()))
        let profileTab = createTab(with: "My Profile", image: UIImage(systemName: "person"), vc: profileVC ?? MyProfileViewController(viewModel: MyProfileViewModel()))
        let offersTab = createTab(with: "Offers", image: UIImage(systemName: "tag"), vc: offersVC ?? OffersViewController(viewModel: OffersViewModel()))
        let activityTab = createTab(with: "Activity", image: UIImage(systemName: "clock"), vc: activityVC ?? MyActivityViewController(viewModel: MyActivityViewModel()))

        // Set the view controllers for the tab bar
        self.viewControllers = [serviceTab, activityTab, offersTab, profileTab]
    }

    /// Create a tab item with a view controller and associated icon
    private func createTab(with title: String, image: UIImage?, vc: UIViewController) -> UIViewController {
        vc.tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
        vc.tabBarItem.badgeColor = .white
        return vc
    }
 

}
