//
//  Double+Extension.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 04/09/25.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    func toINR() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₹"
        formatter.locale = Locale(identifier: "en_IN") // Indian numbering system
        return formatter.string(from: NSNumber(value: self)) ?? "₹0"
    }
}
