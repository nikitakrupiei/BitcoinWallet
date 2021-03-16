//
//  CurrentBalanceService.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation
import CoreData

class CurrentBalanceService {
    static func fetchedCurrentBalance() -> NSFetchedResultsController<CurrentBalance>{
        let context = PersistentService.context
        let fetchRequest: NSFetchRequest<CurrentBalance> = CurrentBalance.fetchRequest()
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
    
    static var defaultBalance: String {
        return "0\(CurrencyType.BTC.sign)"
    }
}
