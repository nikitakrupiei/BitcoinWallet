//
//  ReplenishBalanceInteractor.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation
import CoreData

protocol ReplenishBalanceInteractorDelegate{
    func presentError(error: Error)
    func presentStartBusy()
    func presentStopBusy()
}

class ReplenishBalanceInteractor: ReplenishBalanceViewDelegate{
    var delegate: ReplenishBalanceInteractorDelegate?
    
    func replenishBalance(balance: Int64) {
        CurrentBalanceService.replenishBalance(balance: balance)
    }
    
    private func fetchedCurrentBalance() -> NSFetchedResultsController<CurrentBalance> {
        return CurrentBalanceService.fetchedCurrentBalance()
    }
}
