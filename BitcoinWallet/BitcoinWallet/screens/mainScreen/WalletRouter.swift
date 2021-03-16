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
    
    func navigateToReplenishBalance() {
        let replenishView = ReplenishBalanceViewController(nibName: nil, bundle: nil)
//        replenishView.modalPresentationStyle = .fullScreen
//        vc.present(replenishView, animated: true)
        
//        vc.addChild(replenishView)
//        //replenishView.view.frame = vc.view.frame
//        vc.view.addSubview(replenishView.view)
//        replenishView.didMove(toParent: vc)
        
        self.vc.addChild(replenishView)
        replenishView.view.frame = vc.view.frame
        self.vc.view.addSubview(replenishView.view)
        replenishView.didMove(toParent: vc)
    }
}
