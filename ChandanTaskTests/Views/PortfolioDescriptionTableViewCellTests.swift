//
//  PortfolioDescriptionTableViewCellTests.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 06/09/25.
//

import XCTest
@testable import ChandanTask

final class PortfolioDescriptionTableViewCellTests: XCTestCase {

    private func makeModel(
        key: String = "Test Key",
        value: String = "₹100",
        isProfitable: Bool = true
    ) -> ProfitLossDescriptionView.Model {
        return .init(
            key: key,
            value: value,
            isProfitable: isProfitable,
            expandButtonVisible: false
        )
    }

    func test_init_setsUpLayoutCorrectly() {
        let sut = PortfolioDescriptionTableViewCell(style: .default, reuseIdentifier: "cell")
        let hook = sut.testHook

        // background and selection style
        XCTAssertEqual(hook.backgroundColor, UIColor(named: "LightGray") ?? .white)
        XCTAssertEqual(hook.selection, .none)

        // descriptionView added as subview
        XCTAssertTrue(sut.contentView.subviews.contains(hook.descriptionView))
    }

    func test_configure_setsModelOnDescriptionView() {
        let sut = PortfolioDescriptionTableViewCell(style: .default, reuseIdentifier: "cell")
        let hook = sut.testHook
        let model = makeModel(key: "Profit", value: "₹200", isProfitable: true)

        sut.configure(with: model)

        XCTAssertEqual(hook.descriptionView.model?.key, "Profit")
        XCTAssertEqual(hook.descriptionView.model?.value, "₹200")
        XCTAssertEqual(hook.descriptionView.model?.isProfitable, true)
    }

    func test_configure_withNegativeProfit_setsModelCorrectly() {
        let sut = PortfolioDescriptionTableViewCell(style: .default, reuseIdentifier: "cell")
        let hook = sut.testHook
        let model = makeModel(key: "Loss", value: "₹-500", isProfitable: false)

        sut.configure(with: model)

        XCTAssertEqual(hook.descriptionView.model?.key, "Loss")
        XCTAssertEqual(hook.descriptionView.model?.value, "₹-500")
        XCTAssertEqual(hook.descriptionView.model?.isProfitable, false)
    }
}
