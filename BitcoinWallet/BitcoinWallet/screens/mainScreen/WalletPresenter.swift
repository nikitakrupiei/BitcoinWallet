//
//  WalletPresenter.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation

protocol WalletPresenterDelegate: BasePresenterDelegate{
    func showStartBusy()
    func showStopBusy()
}

class WalletPresenter: WalletInteractorDelegate {
    weak var delegate: WalletPresenterDelegate?
    
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
