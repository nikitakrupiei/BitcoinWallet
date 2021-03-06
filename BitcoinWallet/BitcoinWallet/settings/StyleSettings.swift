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
    case green
    case red
    
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
        case .green:
            return #colorLiteral(red: 0, green: 0.5882352941, blue: 0, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.9843137255, green: 0.05098039216, blue: 0.2, alpha: 1)
        }
    }
}
