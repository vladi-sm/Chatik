//
//  CoreDataService.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 07.04.2022.
//

import Foundation
import CoreData

protocol CoreDataService{
    func fetchChannels() -> [DBChannel]
    func performSave(_ block: @escaping(NSManagedObjectContext) -> Void)
}

final class CoreDataServiceImp: CoreDataService{
    
    //create container
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatikCoreData")
        container.loadPersistentStores{ storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }else {
                print(storeDescription)
            }
        }
        return container
    }()
    
//    read
    public func fetchChannels() -> [DBChannel]{
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        do{
            let channels = try container.viewContext.fetch(fetchRequest)
            return channels
        }catch let error as NSError{
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    
    public func performSave(_ block: @escaping(NSManagedObjectContext) -> Void) {
        let context = container.newBackgroundContext()
        context.perform {
            block(context)
            if context.hasChanges{
                do{
                    try self.performSave(in: context)
                }catch{
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }

    private func performSave(in context: NSManagedObjectContext) throws{
        try context.save()
        if let parent = context.parent {
            try performSave(in: parent)
        }
    }
}
