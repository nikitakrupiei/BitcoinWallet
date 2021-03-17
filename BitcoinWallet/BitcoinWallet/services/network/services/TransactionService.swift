//
//  TransactionService.swift
//  BitcoinWallet
//
//  Created by admin on 17.03.2021.
//

import Foundation
import CoreData

//Transactions balance Coredata service

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
    
    /*
     
        Here I faced some problemes with pagination.
        
        I know that I must increment use fetchOffset every time I increment fetchLimit but I fail to achieve the behavior I wanted
     
        
        I can achieve this by using     try context.fetch(fetchRequest)
        Here I get an Array of Transactions. I can create an instanse of Array in ViewController and append it every time with new items. But then I have to group them and devide by sections. A lot of additional work
     
        NSFetchedResultsController can automatically group everything I need. So I thought it's better to use it. Also I can implemet delegate and know when new Transaction will be added. In first scenario I'd use NotificationCenter
     
        
        I couldn't find the good way to use NSFetchedResultsController and fetchOffset together yet :(
     
     */
    
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
