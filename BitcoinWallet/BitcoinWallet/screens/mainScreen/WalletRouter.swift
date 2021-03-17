//
//  WalletRouter.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation
import UIKit

class WalletRouter{
    
    unowned var vc: WalletViewController
    
    init(vc: WalletViewController) {
        self.vc = vc
    }
    
    func navigateToReplenishBalance(currentBalance: Int64) {
        let replenishViewController = ReplenishBalanceViewController()
        replenishViewController.currentBitcoinAmount = currentBalance
        
        self.vc.addChild(replenishViewController)
        replenishViewController.view.frame = vc.view.frame
        self.vc.view.addSubview(replenishViewController.view)
        replenishViewController.didMove(toParent: vc)
    }
    
    func navigateToAddTransaction(currentBalance: Int64) {
        let addTransactionViewController = AddTransactionViewController()
        addTransactionViewController.currentBitcoinAmount = currentBalance
        
        self.vc.navigationController?.pushViewController(addTransactionViewController, animated: true)
    }
}
