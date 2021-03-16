//
//  ReplenishBalancePresenter.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation

protocol ReplenishBalancePresenterDelegate: BasePresenterDelegate{
    func showStartBusy()
    func showStopBusy()
}

class ReplenishBalancePresenter: ReplenishBalanceInteractorDelegate {
    weak var delegate: ReplenishBalancePresenterDelegate?
    
    func presentError(error: Error) {
        if let error = error as? APIError {
            delegate?.showError(message: error.local)
        }
    }
    
    func presentStartBusy() {
        delegate?.showStartBusy()
    }
    
    func presentStopBusy() {
        delegate?.showStopBusy()
    }
}
