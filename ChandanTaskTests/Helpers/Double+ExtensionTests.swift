//
//  Double+ExtensionTests.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 04/09/25.
//

import XCTest
@testable import ChandanTask

final class DoubleRoundingTests: XCTestCase {

    func testRoundingUp() {
        let value = 3.14159
        let result = value.rounded(toPlaces: 2)
        XCTAssertEqual(result, 3.14, accuracy: 0.0001, "Should round π to 2 decimal places")
    }

    func testRoundingDown() {
        let value = 2.71828
        let result = value.rounded(toPlaces: 3)
        XCTAssertEqual(result, 2.718, accuracy: 0.0001, "Should round e to 3 decimal places")
    }

    func testAlreadyRoundedValue() {
        let value = 5.5
        let result = value.rounded(toPlaces: 1)
        XCTAssertEqual(result, 5.5, "Value already rounded should remain unchanged")
    }

    func testZeroDecimalPlaces() {
        let value = 9.876
        let result = value.rounded(toPlaces: 0)
        XCTAssertEqual(result, 10.0, "Should round to nearest integer when places = 0")
    }

    func testNegativeNumber() {
        let value = -3.14159
        let result = value.rounded(toPlaces: 2)
        XCTAssertEqual(result, -3.14, accuracy: 0.0001, "Negative numbers should also round correctly")
    }

    func testLargeDecimalPlaces() {
        let value = 1.23456789
        let result = value.rounded(toPlaces: 6)
        XCTAssertEqual(result, 1.234568, accuracy: 0.0000001, "Should round correctly for large decimal places")
    }
}
