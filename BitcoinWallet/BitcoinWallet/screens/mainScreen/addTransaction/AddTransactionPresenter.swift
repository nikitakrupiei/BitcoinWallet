//
//  AddTransactionPresenter.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import Foundation

protocol AddTransactionPresenterDelegate: BasePresenterDelegate{
    func showStartBusy()
    func showStopBusy()
}

class AddTransactionPresenter: AddTransactionInteractorDelegate {
    weak var delegate: AddTransactionPresenterDelegate?
    
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
