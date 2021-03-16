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
}
