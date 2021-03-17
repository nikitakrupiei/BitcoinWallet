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
        return Formatter.onlyDay.string(from: self.convertedDate)
    }
    
    var onlyDate: Date? {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents)
        }
    }
    
    var convertedDate:Date {
        
        let dateFormatter = DateFormatter()
        
        let dateFormat = "dd MMM yyyy HH:mm:ss"
        dateFormatter.dateFormat = dateFormat
        let formattedDate = dateFormatter.string(from: self)
        
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        dateFormatter.dateFormat = dateFormat as String
        let sourceDate = dateFormatter.date(from: formattedDate as String)
        
        return sourceDate!
    }
    
    var startOfTheDay: Date{
        return Calendar.current.startOfDay(for: self)
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
