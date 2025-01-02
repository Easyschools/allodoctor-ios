//
//  Coordinator.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }

    func start()
}
