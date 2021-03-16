//
//  WalletViewController.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import UIKit

protocol WalletViewDelegate{
}

class WalletViewController: BaseViewController,  WalletPresenterDelegate{
    
    var delegate: WalletViewDelegate?
    var router: WalletRouter?
    
    override func settings() {
        super.settings()
        WalletConfigurator.shared.configure(vc: self)
        setTopBarLightContentStyle()
        self.view.backgroundColor = .white
    }
    
    func showStartBusy() {
    }
    
    func showStopBusy() {
    }
}
