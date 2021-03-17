//
//  AddTransactionConfigurator.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import Foundation

class AddTransactionConfigurator{
    static let shared = AddTransactionConfigurator()
    private init(){}
    
    func configure(vc: AddTransactionViewController) {
        vc.router = AddTransactionRouter(vc: vc)
        let interactor = AddTransactionInteractor()
        let presenter = AddTransactionPresenter()
        vc.delegate = interactor
        interactor.delegate = presenter
        presenter.delegate = vc
    }
}
