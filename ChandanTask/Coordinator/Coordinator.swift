//
//  Coordinator.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 03/09/25.
//

import UIKit

protocol Coordinator {
    var navigationController: MainNavigationController { get set }
    func start() async
}

final class MainCoordinator: Coordinator {
    var navigationController: MainNavigationController

    init(navigationController: MainNavigationController) {
        self.navigationController = navigationController
    }

    @MainActor
    func start() {
        let service = NetworkService(
            baseURL: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
        )
        let viewModel = PortfolioViewModel(service: service)
        let portfolioVC = PortfolioViewController(viewModel)

        navigationController.setViewControllers([portfolioVC], animated: false)
    }
}

