//
//  ProfitLossDescriptionViewTests.swift
//  ChandanTaskTests
//
//  Created by Chandan Sharda on 06/09/25.
//

import XCTest
@testable import ChandanTask

final class ProfitLossDescriptionViewTests: XCTestCase {
    
    // MARK: - Mock Delegate
    class MockDelegate: ProfitLossDescriptionViewPresentable {
        var didExpandCalled = false
        var lastExpandState: Bool?
        
        func didTapOnExpandView(isExpanded: Bool) {
            didExpandCalled = true
            lastExpandState = isExpanded
        }
    }
    
    // MARK: - Tests
    
    func test_initialModelSetup_setsLabelsCorrectly() {
        let model = ProfitLossDescriptionView.Model(
            key: "Total Value",
            value: "₹10,000",
            isProfitable: true,
            expandButtonVisible: true
        )
        
        let sut = ProfitLossDescriptionView(model)
        sut.layoutIfNeeded()
        
        let hook = sut.testHook
        
        XCTAssertEqual(sut.model?.key, "Total Value")
        XCTAssertEqual(sut.model?.value, "₹10,000")
        XCTAssertEqual(hook.keyLabel.text, "Total Value")
        XCTAssertEqual(hook.valueLabel.text, "₹10,000")
        XCTAssertEqual(hook.valueLabel.textColor, .systemGreen)
        XCTAssertFalse(hook.expandButton.isHidden)
    }
    
    func test_updateModel_setsLabelsAndColors() {
        let sut = ProfitLossDescriptionView()
        
        sut.model = ProfitLossDescriptionView.Model(
            key: "Profit",
            value: "₹-500",
            isProfitable: false,
            expandButtonVisible: false
        )
        
        let hook = sut.testHook
        
        XCTAssertEqual(hook.keyLabel.text, "Profit")
        XCTAssertEqual(hook.valueLabel.text, "₹-500")
        XCTAssertEqual(hook.valueLabel.textColor, .systemRed)
        XCTAssertTrue(hook.expandButton.isHidden)
    }
    
    func test_expandButtonToggle_updatesImageAndCallsDelegate() {
        let model = ProfitLossDescriptionView.Model(
            key: "Expandable",
            value: "₹5,000",
            expandButtonVisible: true
        )
        
        let sut = ProfitLossDescriptionView(model)
        let hook = sut.testHook
        let delegate = MockDelegate()
        sut.delegate = delegate
        
        // Initially collapsed
        XCTAssertFalse(hook.isExpanded)
        
        // Simulate tap
        sut.tappedOnExpandButton()
        
        XCTAssertTrue(hook.isExpanded)
        XCTAssertTrue(delegate.didExpandCalled)
        XCTAssertEqual(delegate.lastExpandState, true)
        
        // Tap again -> collapse
        sut.tappedOnExpandButton()
        
        XCTAssertFalse(hook.isExpanded)
        XCTAssertEqual(delegate.lastExpandState, false)
    }
    
    func test_expandButtonImageChanges_whenToggled() {
        let model = ProfitLossDescriptionView.Model(
            key: "Expandable",
            value: "₹5,000",
            expandButtonVisible: true
        )
        
        let sut = ProfitLossDescriptionView(model)
        let hook = sut.testHook
        
        // Initial state
        let initialImage = hook.expandButton.image(for: .normal)
        
        // Toggle
        sut.tappedOnExpandButton()
        let toggledImage = hook.expandButton.image(for: .normal)
        
        XCTAssertNotEqual(initialImage, toggledImage)
    }
}
