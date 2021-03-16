//
//  ReplenishBalanceConfigurator.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation

class ReplenishBalanceConfigurator{
    static let shared = ReplenishBalanceConfigurator()
    private init(){}
    
    func configure(vc: ReplenishBalanceViewController) {
        vc.router = ReplenishBalanceRouter(vc: vc)
        let interactor = ReplenishBalanceInteractor()
        let presenter = ReplenishBalancePresenter()
        vc.delegate = interactor
        interactor.delegate = presenter
        presenter.delegate = vc
    }
}
