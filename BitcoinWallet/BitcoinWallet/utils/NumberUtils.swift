//
//  NumberUtils.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//
import Foundation

extension Double {
    func currencyFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        return formatter.string(for: floor(self * 100) / 100) ?? (floor(self * 100) / 100).description
    }
}
