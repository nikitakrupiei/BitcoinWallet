//
//  WalletInteractor.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation
import CoreData

protocol WalletInteractorDelegate{
    func presentError(error: Error)
    func presentStartBusy()
    func presentStopBusy()
}

class WalletInteractor: WalletViewDelegate{
    var delegate: WalletInteractorDelegate?
    
    func fetchedBitcoinRate() -> NSFetchedResultsController<BitcoinRate> {
        return BitcoinRateService.fetchedBitcoinRate()
    }
    
    func fetchedCurrentBalance() -> NSFetchedResultsController<CurrentBalance> {
        return CurrentBalanceService.fetchedCurrentBalance()
    }
    
    func fetchedTransactions() -> NSFetchedResultsController<Transaction> {
        let controller = TransactionService.fetchedTransactionsController
        return self.performFetch(for: controller, limit: 20)
    }
    
    func performFetch(for controller: NSFetchedResultsController<Transaction>, limit: Int) -> NSFetchedResultsController<Transaction> {
        return TransactionService.performFetch(limit: limit, for: controller)
    }
}
