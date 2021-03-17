//
//  Transaction.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import Foundation
import UIKit

extension Transaction {
    var transactionCategory: TransactionCategory {
        guard let category = category else {
            return .other
        }
        return TransactionCategory(rawValue: category) ?? .other
    }
    
    var transactionAmount: String? {
        return "\(self.amount)\(CurrencyType.BTC.sign)"
    }
}

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
    
    var image: UIImage {
        switch self {
        case .groceries:
            return #imageLiteral(resourceName: "transactionCategoryGroceries")
        case .taxi:
            return #imageLiteral(resourceName: "transactionCategoryTaxi")
        case .electronics:
            return #imageLiteral(resourceName: "transactionCategoryElectronics")
        case .restaurant:
            return #imageLiteral(resourceName: "transactionCategoryRestaurant")
        case .other:
            return #imageLiteral(resourceName: "transactionCategoryOther")
        case .replenishment:
            return #imageLiteral(resourceName: "transactionCategoryReplenishment")
        }
    }
}
