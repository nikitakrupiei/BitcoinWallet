//
//  Global.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation

enum CurrencyType: Hashable{
    case BTC
    case UAH
    case USD
    case EUR
    case GBR
    case other(String)
    case empty
    
    init(code: String) {
        switch code {
        case "BIT":
            self = .BTC
        case "UAH":
            self = .UAH
        case "USD":
            self = .USD
        case "EUR":
            self = .EUR
        case "GBR":
            self = .GBR
        default:
            self = .other(code)
        }
    }
    
    var code: String {
        switch self {
        case .BTC:
            return "BIT"
        case .UAH:
            return "UAH"
        case .USD:
            return "USD"
        case .EUR:
            return "EUR"
        case .GBR:
            return "GBR"
        case .other(let code):
            return code
        case .empty:
            return ""
        }
    }
    
    var sign: String {
        switch self {
        case .BTC:
            return "₿"
        case .USD:
            return "$"
        case .EUR:
            return "€"
        case .GBR:
            return "\u{A3}"
        case .UAH:
            return "₴"
        case .other(let code):
            return code
        case .empty:
            return ""
        }
    }
}
