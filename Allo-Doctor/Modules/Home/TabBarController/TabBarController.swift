//
//  TabbarController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//
import UIKit



final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    private let viewModel: TabBarViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupAppearance()
        self.viewControllers = viewModel.getViewControllers()
    }

    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAppearance() {
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .darkBlue295DA8
        tabBar.barTintColor = .white
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .white

        for item in tabBar.items ?? [] {
            item.image = item.image?.withRenderingMode(.alwaysTemplate)
            item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysTemplate)
        }
    }
}
