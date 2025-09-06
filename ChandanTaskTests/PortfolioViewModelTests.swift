//
//  PortfolioViewModelTests.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 06/09/25.
//

import XCTest
import Combine
@testable import ChandanTask

import XCTest
import Combine
@testable import ChandanTask

// MARK: - Mock Network Service
final class MockNetworkService: NetworkServicing {
    var response: UserData?
    var error: Error?

    func request<T>(endpoint: String, method: HTTPMethod, body: Data?) async throws -> T where T : Decodable {
        if let error = error { throw error }
        guard let response = response as? T else { fatalError("Mock response type mismatch") }
        return response
    }
}

// MARK: - Unit Tests
@MainActor
final class PortfolioViewModelTests: XCTestCase {

    var sut: PortfolioViewModel!
    var service: MockNetworkService!

    override func setUp() {
        super.setUp()
        service = MockNetworkService()
        sut = PortfolioViewModel(service: service)
    }

    override func tearDown() {
        sut = nil
        service = nil
        super.tearDown()
    }

    func test_initialState_isIdle() {
        XCTAssertEqual(sut.state, .idle)
        XCTAssertFalse(sut.isSearchVisible)
        XCTAssertEqual(sut.searchQuery, "")
    }

    func test_fetchPortfolio_success_updatesStateAndItems() async {
        // Given
        let holdings = [
            UserHolding(symbol: "AAPL", quantity: 10, ltp: 150, avgPrice: 145, close: 148),
            UserHolding(symbol: "GOOG", quantity: 5, ltp: 2800, avgPrice: 2700, close: 2750)
        ]
        service.response = UserData(data: .init(userHolding: holdings))

        // When
        await sut.fetchPortfolio()

        // Then
        if case let .loaded(items) = sut.state {
            XCTAssertEqual(items.count, 2)
            XCTAssertEqual(items[0].symbol, "AAPL")
            XCTAssertEqual(items[1].symbol, "GOOG")
        } else {
            XCTFail("Expected state to be .loaded")
        }
    }

    func test_fetchPortfolio_failure_updatesStateToFailed() async {
        // Given
        service.error = URLError(.notConnectedToInternet)

        // When
        await sut.fetchPortfolio()

        // Then
        if case let .failed(message) = sut.state {
            XCTAssertTrue(message.contains("Failed to load portfolio"))
        } else {
            XCTFail("Expected state to be .failed")
        }
    }

    func test_toggleSearch_togglesVisibility() {
        XCTAssertFalse(sut.isSearchVisible)
        sut.toggleSearch()
        XCTAssertTrue(sut.isSearchVisible)
        sut.toggleSearch()
        XCTAssertFalse(sut.isSearchVisible)
    }

    func test_getOverallPortfolioBalance_calculatesCorrectly() async {
        // Given
        let holdings = [
            UserHolding(symbol: "AAPL", quantity: 10, ltp: 150, avgPrice: 145, close: 148),
            UserHolding(symbol: "GOOG", quantity: 5, ltp: 2800, avgPrice: 2700, close: 2750)
        ]
        service.response = UserData(data: .init(userHolding: holdings))
        await sut.fetchPortfolio()

        // When
        let model = sut.getOveralPOrtfolioBalance()
        let currentValue = holdings.reduce(0) { $0 + $1.currentValue }
        let totalInvestment = holdings.reduce(0) { $0 + $1.investmentValue }
        let todaysPortFolio = holdings.reduce(0) { $0 + $1.todayPnl }
        let totalProfitAndLoss = currentValue - totalInvestment

        XCTAssertEqual(model.totalCurrentValue, currentValue.rounded(toPlaces: 2))
        XCTAssertEqual(model.totalInvestment, totalInvestment.rounded(toPlaces: 2))
        XCTAssertEqual(model.todaysProfitAndLoss, todaysPortFolio.rounded(toPlaces: 2))
        XCTAssertEqual(model.totalProfitLoss, totalProfitAndLoss.rounded(toPlaces: 2))
    }
    
    func test_searchQuery_bindingDoesNotCrash() async {
        // Since filterSearch is empty, just verify binding doesn't crash
        sut.searchQuery = "AAPL"
        XCTAssertEqual(sut.searchQuery, "AAPL")
    }
}
