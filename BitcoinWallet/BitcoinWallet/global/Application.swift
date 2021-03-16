//
//  Application.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation
import UIKit

class Application {
    static var shared = Application()
    private init(){}
    
    func initialize() {
        if #available(iOS 12.0, *) {
            NSSecureUnarchiveTransformerRegistrator.register()
        }
    }
    
    var topViewController: UIViewController? {
        if var top = UIApplication.shared.keyWindow?.rootViewController {
            while((top.presentedViewController) != nil){
                top = top.presentedViewController!
            }
            return top
        }
        return nil
    }
    
    func getBitcoinRate() {
        BitcoinRateService.getBitcoinRate(success: { _ in
        }, fail: { error in
            if let error = error as? APIError {
                self.topViewController?.showError(message: error.local)
            }
        })
    }
}
