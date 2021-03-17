//
//  CurrentBalanceService.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation
import CoreData

//Current bitcoin balance Coredata service
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
    
    static func replenishBalance(balance: Int64) {
        let context = PersistentService.context
        let fetchRequest: NSFetchRequest<CurrentBalance> = CurrentBalance.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = []
        
        do {
            let balanceObjext = try context.fetch(fetchRequest)
            
            if let currentBalance = balanceObjext.first {
                currentBalance.balance += balance
            } else {
                let newBalance = CurrentBalance(context: context)
                newBalance.balance = balance
            }
            
            context.saveIfNeed()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    static var defaultBalance: String {
        return "0\(CurrencyType.BTC.sign)"
    }
}
