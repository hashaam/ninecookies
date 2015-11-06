//
//  CoreDataStack.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 31/10/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack {
    
    static let sharedInstance = CoreDataStack()
    
    public init() {
        
    }
    
    public var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = NSBundle.mainBundle().URLForResource("NineCookies", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        
    }()
    
    var applicationSupportDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("NineCookies.sqlite")
        
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true
        ]
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            
            var store = try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
            
        } catch let error as NSError {
            
            print("Failed to load store")
            print("Unresolved error \(error.localizedDescription), \(error.userInfo)\nAttempted to create store at \(storeURL)")
            abort()
            
        }
        
        do {
            
            try storeURL.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey)
            
        } catch let error as NSError {
            
            print("error in excluding psc from backing up in icloud. \(error.localizedDescription)")
            abort()
            
        }
        
        return psc
        
    }()
    
    public lazy var context: NSManagedObjectContext = {
        
        let c = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        c.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return c
        
    }()
    
    
    public func saveContext() {
        
        if !context.hasChanges {
            return
        }
        
        do  {
        
            try context.save()
            
            
        } catch let error as NSError {
            
            print("Error saving context: \(error.localizedDescription)\n\(error.userInfo)")
            abort()
            
        }
        
    }
    
}