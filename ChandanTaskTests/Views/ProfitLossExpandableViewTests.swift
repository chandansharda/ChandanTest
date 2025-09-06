//
//  ProfitLossExpandableViewTests.swift
//  ChandanTaskTests
//
//  Created by Chandan Sharda on 06/09/25.
//

import XCTest
@testable import ChandanTask

final class ProfitLossExpandableViewTests: XCTestCase {

    // MARK: - Helpers
    private func makeModel() -> ProfitLossExpandableView.Model {
        return .init(
            totalCurrentValue: 10000,
            totalInvestment: 8000,
            todaysProfitAndLoss: 2000,
            totalProfitLoss: 2000
        )
    }

    // MARK: - Tests

    func test_apply_setsFooterModelCorrectly() {
        let model = makeModel()
        let sut = ProfitLossExpandableView()
        let hook = sut.testHook

        sut.apply(model: model)

        XCTAssertEqual(hook.footerView.model?.key, "Profit & Loss*")
        XCTAssertEqual(hook.footerView.model?.value, model.totalProfitLoss.toINR())
        XCTAssertEqual(hook.footerView.model?.isProfitable, true)
        XCTAssertEqual(hook.footerView.model?.expandButtonVisible, true)
    }

    func test_applySnapshot_whenCollapsed_hidesLineAndRemovesItems() {
        let model = makeModel()
        let sut = ProfitLossExpandableView()
        let hook = sut.testHook
        sut.model = model

        sut.applySnapShot(isExpanded: false)

        XCTAssertTrue(hook.lineView.isHidden)
        XCTAssertEqual(hook.snapshotItemCount, 0)
    }

    func test_applySnapshot_whenExpanded_showsLineAndAddsItems() {
        let model = makeModel()
        let sut = ProfitLossExpandableView()
        let hook = sut.testHook
        sut.model = model

        sut.applySnapShot(isExpanded: true)

        XCTAssertFalse(hook.lineView.isHidden)
        XCTAssertEqual(hook.snapshotItemCount, model.returnList().count)
    }

    func test_updateTableViewHeight_updatesConstraint() {
        let model = makeModel()
        let sut = ProfitLossExpandableView()
        let hook = sut.testHook
        sut.model = model

        sut.applySnapShot(isExpanded: true)
        sut.updateTableViewHeight()

        let expectedHeight = hook.tableView.contentSize.height
        XCTAssertEqual(hook.tableViewHeightConstraint?.constant, expectedHeight)
    }

    func test_didTapOnExpandView_delegatesToApplySnapshot() {
        let model = makeModel()
        let sut = ProfitLossExpandableView()
        let hook = sut.testHook
        sut.model = model

        sut.didTapOnExpandView(isExpanded: true)

        XCTAssertFalse(hook.lineView.isHidden)

        sut.didTapOnExpandView(isExpanded: false)

        XCTAssertTrue(hook.lineView.isHidden)
    }
}
