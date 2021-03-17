//
//  AddTransactionInteractor.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import Foundation

protocol AddTransactionInteractorDelegate{
    func presentError(error: Error)
    func presentStartBusy()
    func presentStopBusy()
}

class AddTransactionInteractor: AddTransactionViewDelegate{
    var delegate: AddTransactionInteractorDelegate?
    
    func addTransaction(amount: Int64, date: Date, category: TransactionCategory) {
        CurrentBalanceService.replenishBalance(balance: -amount)
        TransactionService.addTransaction(amount: amount, date: date, category: category)
    }
}
