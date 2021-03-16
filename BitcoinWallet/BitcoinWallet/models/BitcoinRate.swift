//
//  BitcoinRate.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import UIKit
import CoreData

class BitcoinRate: NSManagedObject, Codable {
    
    private enum CodingKeys: String, CodingKey{
        case chartName = "chartName"
        case bpi = "bpi"
    }

    var usdRate: String? {
        guard rate != 0 else {
            return nil
        }
        return "\(rate.currencyFormat())\(CurrencyType.USD.sign) per 1\(CurrencyType.BTC.sign)"
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "BitcoinRate", in: context) else {
                fatalError("Failed to decode bitcoin rate")
        }
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chartName = try container.decode(String.self, forKey: .chartName)
        self.rate = try container.decodeIfPresent(BitcoinRateDPI.self, forKey: .bpi)?.usd?.rate ?? 0
        
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chartName, forKey: .chartName)
    }
}

class BitcoinRateDPI: NSObject, NSSecureCoding, Decodable {
    let usd: BitcoinRateToCurrency?
    
    static var supportsSecureCoding: Bool = true
    
    enum CodingKeys: String, CodingKey{
        case usd = "USD"
    }
    
    func encode(with coder: NSCoder) {}
    
    required init?(coder: NSCoder) {
        usd = coder.decodeObject(of: BitcoinRateToCurrency.self, forKey: CodingKeys.usd.rawValue)
    }
}

class BitcoinRateToCurrency:  NSObject, NSSecureCoding, Decodable {
    let rate: Double?
    
    static var supportsSecureCoding: Bool = true
    
    enum CodingKeys: String, CodingKey{
        case rate = "rate_float"
    }
    
    func encode(with coder: NSCoder) {}
    
    required init?(coder: NSCoder) {
        rate = coder.decodeObject(of: NSNumber.self, forKey: CodingKeys.rate.rawValue)?.doubleValue
    }
}
