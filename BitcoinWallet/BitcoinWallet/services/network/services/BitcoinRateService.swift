//
//  BitcoinRateService.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation
import CoreData

//Bitcoin Rate API and Coredata service
class BitcoinRateService {
    static func getBitcoinRate(success:@escaping((BitcoinRate) -> Void), fail:@escaping((Error) -> Void)){
        BitcoinRateServiceEndpoint.getBitcoinRate.addOne(toStore: PersistentService.context, success: success, fail: fail)
    }
}

fileprivate enum BitcoinRateServiceEndpoint: APIConfiguration {
    
    case getBitcoinRate
    
    var method: HTTPMethod{
        switch self {
        case .getBitcoinRate:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .getBitcoinRate:
            return "bpi/currentprice.json"
        }
    }
}

extension BitcoinRateService {
    static func fetchedBitcoinRate() -> NSFetchedResultsController<BitcoinRate>{
        let context = PersistentService.context
        let fetchRequest: NSFetchRequest<BitcoinRate> = BitcoinRate.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = []
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try aFetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return aFetchedResultsController
    }
}
