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
        guard isNeedRateUpdate else {
            return
        }
        
        BitcoinRateService.getBitcoinRate(success: { _ in
            self.lastDateRateUpdated = Date()
        }, fail: { error in
            if let error = error as? APIError {
                self.topViewController?.showError(message: error.local)
            }
        })
    }
    
    private var isNeedRateUpdate: Bool {
        guard let lastDateRateUpdated = lastDateRateUpdated else {
            return true
        }
        
        let nextRequestDate = Calendar.current.date(byAdding: .hour, value: NetworkPauseConfiguration.bitcoinRateRequestPauseHours, to: lastDateRateUpdated)!
        
        if nextRequestDate <= Date() {
            return true
        }
        
        return false
    }
    
    var lastDateRateUpdated: Date?{
        get{
            return UserDefaults.standard.object(forKey: UserDefaultsKey.lastDateRateUpdated.rawValue) as? Date
        }
        set(newValue){
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.lastDateRateUpdated.rawValue)
        }
    }
}

enum UserDefaultsKey: String {
    case lastDateRateUpdated
}
