//
//  SceneDelegate.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 03/09/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navController = MainNavigationController()
        coordinator = MainCoordinator(navigationController: navController)
        coordinator?.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
    }
}
