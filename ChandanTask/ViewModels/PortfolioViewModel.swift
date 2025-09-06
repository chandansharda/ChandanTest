//
//  PortfolioViewModel.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 04/09/25.
//

import Foundation
import Combine

@MainActor
final class PortfolioViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case loaded([UserHolding])
        case failed(String)
    }

    // MARK: - Properties
    private let service: NetworkServicing

    @Published private(set) var state: State = .idle
    @Published var errorMessage: String?
    @Published var isSearchVisible: Bool = false
    @Published var searchQuery: String = ""

    private var items: [UserHolding] = []
    private var cancellables = Set<AnyCancellable>()

    init(service: NetworkServicing) {
        self.service = service
        bindSearch()
    }

    func fetchPortfolio() async {
        state = .loading
        do {
            let userData: UserData = try await service.request(
                endpoint: "",
                method: .get,
                body: nil
            )
            items = userData.data.userHolding
            state = .loaded(items)
        } catch {
            state = .failed("Failed to load portfolio: \(error.localizedDescription)")
        }
    }

    func bindSearch() {
        $searchQuery.sink { [weak self] query in
            self?.filterSearch(withQuery: query)
        }.store(in: &cancellables)
    }

    func getOveralPOrtfolioBalance() -> ProfitLossExpandableView.Model {
        let currentValue = items.reduce(0) { $0 + $1.currentValue }
        let totalInvestment = items.reduce(0) { $0 + $1.investmentValue }
        let todaysPortFolio = items.reduce(0) { $0 + $1.todayPnl }
        let totalProfitAndLoss = currentValue - totalInvestment
        return .init(
            totalCurrentValue: currentValue.rounded(toPlaces: 2),
            totalInvestment: totalInvestment.rounded(toPlaces: 2),
            todaysProfitAndLoss: todaysPortFolio.rounded(toPlaces: 2),
            totalProfitLoss: totalProfitAndLoss.rounded(toPlaces: 2)
        )
    }
    

    func refresh() async {
        await fetchPortfolio()
    }

    func filterSearch(withQuery query: String) {
        // filter search logic will come here
    }

    func sortList() {
        /// all sorting logic comes here
    }

    func toggleSearch() {
        isSearchVisible.toggle()
    }
}

