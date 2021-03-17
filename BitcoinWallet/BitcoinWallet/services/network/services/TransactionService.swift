//
//  TransactionService.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import Foundation
import CoreData

class TransactionService {

    static func addTransaction(amount: Int64, date: Date, category: TransactionCategory) {
        let context = PersistentService.context
        
        let transaction = Transaction(context: context)
        transaction.amount = amount
        transaction.addTime = Date()
        transaction.date = date
        transaction.day = date.startOfTheDay.convertedDate
        transaction.category = category.rawValue
        context.saveIfNeed()
    }
    
    var offset: Int = 0
    
    static var fetchedTransactionsController: NSFetchedResultsController<Transaction> = {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        let sortDescriptorDate = NSSortDescriptor(key: #keyPath(Transaction.date), ascending: false)
        let sortDescriptorLoadDate = NSSortDescriptor(key: #keyPath(Transaction.addTime), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorDate, sortDescriptorLoadDate]
        
        fetchRequest.fetchLimit = CoreDataConfiguration.paginationStep
        fetchRequest.fetchOffset = 0

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistentService.context, sectionNameKeyPath: #keyPath(Transaction.day), cacheName: "CACHENAME")
        return fetchedResultsController
    }()
    
    static func performFetch(limit: Int, for controller: NSFetchedResultsController<Transaction>) -> NSFetchedResultsController<Transaction> {
        controller.fetchRequest.fetchLimit = limit
        do {
            NSFetchedResultsController<Transaction>.deleteCache(withName: controller.cacheName)
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return controller
    }
}
