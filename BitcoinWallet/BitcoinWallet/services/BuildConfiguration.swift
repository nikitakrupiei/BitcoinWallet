//
//  BuildConfiguration.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation

class EnvironmentConfiguration {
    
    static var baseApiUrl : URL? {
        let path = "https://api.coindesk.com"
        return URL(string: path)
    }
    
    static var apiVersion: String? {
        return "/v1"
    }
}

class NetworkPauseConfiguration {
    static var bitcoinRateRequestPauseHours = 1
}

class BitcoinConfiguration {
    static var maximumBitcoinAmountInTheWorld: Int64 = 21_000_000
}
