//
//  UserHolding.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 03/09/25.
//

/*
1. Current value = sum of (Last traded price * quantity of holding ) of all the holdings
2. Total investment = sum of (Average Price * quantity of holding ) of all the holdings
3. Total PNL = Current value - Total Investment
4. Today’s PNL = sum of ((Close - LTP ) * quantity) of all the holdings
*/

import Foundation


// MARK: - UserHolding
struct UserHolding: Codable, Hashable {
    let symbol: String
    let quantity: Int
    let ltp, avgPrice, close: Double

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
        hasher.combine(quantity)
        hasher.combine(avgPrice)
        hasher.combine(ltp)
    }

    // MARK: - Computed Getters
    
    /// Current market value = LTP * Quantity
    var currentValue: Double {
        ltp * Double(quantity)
    }

    /// Investment value = Average Price * Quantity
    var investmentValue: Double {
        avgPrice * Double(quantity)
    }

    /// total pnl currentVlaur - investmentValue
    var totalPnlCurrentValue: Double {
        (currentValue - investmentValue).rounded(toPlaces: 2)
    }

    /// today pnl close
    var todayPnl: Double {
        (close - ltp) * Double(quantity)
    }

    /// is profitable today
    var isProfitableToday: Bool {
        currentValue >= investmentValue
    }
}
