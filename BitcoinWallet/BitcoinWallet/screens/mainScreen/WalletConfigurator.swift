//
//  WalletConfigurator.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation

class WalletConfigurator{
    static let shared = WalletConfigurator()
    private init(){}
    
    func configure(vc: WalletViewController) {
        vc.router = WalletRouter(vc: vc)
        let interactor = WalletInteractor()
        let presenter = WalletPresenter()
        vc.delegate = interactor
        interactor.delegate = presenter
        presenter.delegate = vc
    }
}
