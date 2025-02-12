//
//  SceneDelegate.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/09/2024.
//

import UIKit
import GoogleMaps
@_exported import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate, LocalizationDelegate {

    var window: UIWindow?
    private var appCoordinator: Coordinator?

    func resetAppAfterChangeLanguge() {
        guard let window = window else { return }
        let appCoordinator = AppCoordinator(window: window, navigationController: UINavigationController())
        self.appCoordinator = appCoordinator
        appCoordinator.start()
    }

    func resetAppFromTabBar() {
    }

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let appCoordinator = AppCoordinator(window: window, navigationController: UINavigationController())
        
        self.appCoordinator = appCoordinator
        appCoordinator.start()
        self.window = window
        LocalizationManager.shared.delegate = self
        LocalizationManager.shared.setAppInnitLanguage()
    }


  
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

extension SceneDelegate {
    static func shared() -> SceneDelegate? {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate else {
            return nil
        }
        return sceneDelegate
    }

    func resetToSplash() {
        guard let windowScene = window?.windowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.frame = UIScreen.main.bounds

        let appCoordinator = AppCoordinator(window: window, navigationController: UINavigationController())
        self.appCoordinator = appCoordinator
        appCoordinator.start()

        window.makeKeyAndVisible()
    }
}
