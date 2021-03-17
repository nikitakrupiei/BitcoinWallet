//
//  Transaction.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import Foundation

enum TransactionCategory: String, CaseIterable {
    case groceries
    case taxi
    case electronics
    case restaurant
    case other
    case replenishment
    
    static var allowedForAddingTransaction: [TransactionCategory] {
        return TransactionCategory.allCases.filter({ $0 != .replenishment })
    }
}
