//
//  DateUtils.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import Foundation

class DateUtils {
    static let shared = DateUtils()
    
    lazy var bitcoinCreationDate: Date? = {
        var dateComponents = DateComponents()
        dateComponents.year = 2009
        dateComponents.month = 1
        dateComponents.day = 3
    
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }()
}

extension Date {
    var simpleDay: String? {
        return Formatter.onlyDay.string(from: self)
    }
}
extension Formatter {
    static let onlyDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.dateFormat = DateTypes.simpleDay.rawValue
        return formatter
    }()
}

enum DateTypes: String {
    case simpleDay = "dd.MM.yyyy"
}
