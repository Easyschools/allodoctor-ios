//
//  MainCoordinator.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//

import UIKit

class MainCoordinator: Coordinator {
    private let window: UIWindow
    private var children: [Coordinator] = []
    var navigationController: UINavigationController

    init(window: UIWindow, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.window = window
    }

    func start() {
        let vc = PhoneNumberViewController()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: false)
    }
    func goToBoarding() {
        let vc = SelectlanguageViewController()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: false)
          
       }

}
