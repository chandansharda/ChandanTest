//
//  UITableView+ExtensionTests.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 04/09/25.
//

import XCTest
@testable import ChandanTask
import UIKit

final class BackgroundStateTests: XCTestCase {

    private var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: 320, height: 480) // ensure bounds
    }

    override func tearDown() {
        tableView = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testBackgroundStateNone() {
        tableView.setBackgroundState(.none)

        XCTAssertNil(tableView.backgroundView, "Background view should be nil for `.none` state")
        XCTAssertEqual(tableView.separatorStyle, .singleLine, "Separator style should be singleLine for `.none` state")
    }

    func testBackgroundStateMessage() {
        let message = "No data available"
        tableView.setBackgroundState(.message(message))

        guard let backgroundView = tableView.backgroundView else {
            return XCTFail("Background view should not be nil for `.message` state")
        }

        XCTAssertEqual(tableView.separatorStyle, .none, "Separator should be none for `.message` state")

        let label = backgroundView.subviews.first { $0 is UILabel } as? UILabel
        XCTAssertNotNil(label, "Background should contain UILabel")
        XCTAssertEqual(label?.text, message, "Label text should match the provided message")
        XCTAssertEqual(label?.textColor, .secondaryLabel, "Label color should be secondaryLabel")
    }

    func testBackgroundStateError() {
        let errorMessage = "Something went wrong"
        tableView.setBackgroundState(.error(errorMessage))

        guard let backgroundView = tableView.backgroundView else {
            return XCTFail("Background view should not be nil for `.error` state")
        }

        XCTAssertEqual(tableView.separatorStyle, .none, "Separator should be none for `.error` state")

        let label = backgroundView.subviews.first { $0 is UILabel } as? UILabel
        XCTAssertNotNil(label, "Background should contain UILabel")
        XCTAssertEqual(label?.text, errorMessage, "Label text should match the provided error message")
        XCTAssertEqual(label?.textColor, .systemRed, "Label color should be red for `.error` state")
    }
}
