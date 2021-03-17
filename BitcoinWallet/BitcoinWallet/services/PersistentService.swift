//
//  PersistentService.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import Foundation
import CoreData

//Service for CoreData control
class PersistentService {
    static let shared = PersistentService()
    private init() {}
    
    private static let datamodelName = "BitcoinWalletDB"
    private static let storeType = "sqlite"
    
    private let url: URL = {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("\(PersistentService.datamodelName).\(PersistentService.storeType)")
        return url
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: PersistentService.datamodelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return PersistentService.shared.persistentContainer.viewContext
    }
    
    static func addOne<Entity: NSManagedObject & Decodable>(data: Data, ofType type: Entity.Type, success:@escaping((Entity)->()), fail:@escaping((Error)->())) {
        let context = PersistentService.context
        DecodableService.decodeOne(data: data, context: context, success: { (result: Entity) in
            context.saveIfNeed()
            success(result)
        }, fail: { error in
            context.reset()
            fail(error)
        })
    }
}

extension NSManagedObjectContext {
    func clearEntity<Entity: NSManagedObject>(ofType type: Entity.Type){
        let request = type.fetchRequest() as! NSFetchRequest<Entity>
        let objects = try? self.fetch(request)
        _ = objects?.map{self.delete($0)}
    }
    
    func saveIfNeed() {
        self.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if self.hasChanges {
            self.perform {
                do {
                    try self.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}
