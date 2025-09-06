//
//  MainCoordinatorTests.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 03/09/25.
//

import XCTest
@testable import ChandanTask


// MARK: - Tests
final class MainCoordinatorTests: XCTestCase {
    var spyNav: MainNavigationController!
    var sut: MainCoordinator!

    override func setUp() {
        super.setUp()
        spyNav = MainNavigationController()
        sut = MainCoordinator(navigationController: spyNav)
    }

    override func tearDown() {
        spyNav = nil
        sut = nil
        super.tearDown()
    }

    @MainActor func test_start_pushesFleetManagerViewController() {
        sut.start()
        XCTAssertNotNil(spyNav.viewControllers.first)
        XCTAssertTrue(spyNav.viewControllers.first is PortfolioViewController,
                      "start() should push FleetManagerViewController")
    }
}

