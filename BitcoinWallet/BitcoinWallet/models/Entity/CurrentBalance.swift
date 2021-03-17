//
//  CurrentBalance.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation
import CoreData

extension CurrentBalance {
    var currentBalance: String? {
        return "\(self.balance)\(CurrencyType.BTC.sign)"
    }
}
