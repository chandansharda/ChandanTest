//
//  MainNavigationController.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 03/09/25.
//

import UIKit

final class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }

    private func configureAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0/255, green: 51/255, blue: 102/255, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance

        navigationBar.tintColor = .white
        navigationBar.prefersLargeTitles = false
    }
}
