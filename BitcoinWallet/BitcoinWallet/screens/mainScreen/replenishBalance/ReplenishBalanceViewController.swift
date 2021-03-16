//
//  ReplenishBalanceViewController.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import UIKit
import Stevia

protocol ReplenishBalanceViewDelegate{
}

class ReplenishBalanceViewController: BaseViewController,  ReplenishBalancePresenterDelegate{
    
    var delegate: ReplenishBalanceViewDelegate?
    var router: ReplenishBalanceRouter?
    
    override func settings() {
        super.settings()
        ReplenishBalanceConfigurator.shared.configure(vc: self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeAnimation))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        setUI()
        showAnimation()
    }
    
    private func setUI() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let mainView = UIView()
        self.view.sv(mainView)
        
        mainView.heightEqualsWidth()
        mainView.backgroundColor = .red
        mainView.fillHorizontally(m: 30).centerVertically()
        mainView.layer.cornerRadius = 24
    }
    
    func close() {
        willMove(toParent: nil)
        self.view.removeFromSuperview()
        removeFromParent()
    }
    
    func showAnimation() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    @objc func removeAnimation() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0
        } completion: { finished in
            self.close()
        }
    }
    
    func showStartBusy() {
    }
    
    func showStopBusy() {
    }
}

extension ReplenishBalanceViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
