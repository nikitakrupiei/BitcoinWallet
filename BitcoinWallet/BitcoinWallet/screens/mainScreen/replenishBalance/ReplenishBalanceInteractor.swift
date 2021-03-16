//
//  ReplenishBalanceInteractor.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation

protocol ReplenishBalanceInteractorDelegate{
    func presentError(error: Error)
    func presentStartBusy()
    func presentStopBusy()
}

class ReplenishBalanceInteractor: ReplenishBalanceViewDelegate{
    var delegate: ReplenishBalanceInteractorDelegate?
}
