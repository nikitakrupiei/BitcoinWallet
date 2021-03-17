//
//  StyleSettings.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import UIKit

enum AppColor: String {
    
    case bitcoinOrange
    case bitcoinGrey
    case greyLight
    
    func color() -> UIColor {
        guard let color = UIColor(named: self.rawValue) else {
            return defaultColor
        }
        return color
    }
    
    func cgColor() -> CGColor {
        return self.color().cgColor
    }
    
    private var defaultColor: UIColor {
        switch self {
        case .bitcoinOrange:
            return #colorLiteral(red: 0.9490196078, green: 0.662745098, blue: 0, alpha: 1)
        case .bitcoinGrey:
            return #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3058823529, alpha: 1)
        case .greyLight:
            return #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        }
    }
}
