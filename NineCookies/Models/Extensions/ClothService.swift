//
//  ClothService.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 31/10/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation
import CoreData

class ClothService: NSObject {
    
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        
        self.managedObjectContext = managedObjectContext
        
        super.init()
        
    }
    
    func addCloth(clothId clothId: Int64, name: String, brand: String, price: Float, detailUrl: String) -> Cloth {
        
        let cloth = NSEntityDescription.insertNewObjectForEntityForName("Cloth", inManagedObjectContext: self.managedObjectContext) as! Cloth
        
        cloth.clothId = NSNumber(longLong: clothId)
        cloth.name = name
        cloth.brand = brand
        cloth.price = price
        cloth.detailUrl = detailUrl
        
        return cloth
        
    }
    
    func getCloth(clothId: NSNumber) -> Cloth? {
        
        let fetchRequest = NSFetchRequest(entityName: "Cloth")
        fetchRequest.predicate = NSPredicate(format: "clothId = %@", clothId)
        
        var returnCloth: Cloth?
        
        do {
            
            let array = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            returnCloth = array.last as? Cloth
            
        } catch {
            
        }
        
        return returnCloth
        
    }
    
    func getAllClothes(sortKey: String, ascending: Bool) -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest(entityName: "Cloth")
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: ascending)]
        
        let resultController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            
            try resultController.performFetch()
            
        } catch {
            
            
            
        }
        
        return resultController
        
    }
    
    func checkDataExists() -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "Cloth")
        fetchRequest.fetchBatchSize = 1

        var error: NSError?
        let count = self.managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        
        if count > 0 {
            
            return true
            
        }
        
        return false
        
    }
    
    func contextSaveHandler(note: NSNotification) {
        
        let mergeChanges: () -> () = {
            CoreDataStack.sharedInstance.context.mergeChangesFromContextDidSaveNotification(note)
        }
        
        if NSThread.isMainThread() {
            
            mergeChanges()
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), mergeChanges)
            
        }
        
    }
    
    func fetchClothes() {
        
        let localMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        localMOC.parentContext = CoreDataStack.sharedInstance.context
        
        let clothServiceLocal = ClothService(managedObjectContext: localMOC)
        if clothServiceLocal.checkDataExists() {
            
            return
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextSaveHandler:", name: NSManagedObjectContextDidSaveNotification, object: localMOC)
        
        AFNetworkingService.sharedInstance.manager.GET(CLOTHING_URL, parameters: nil, success: { (request: AFHTTPRequestOperation, responseObject: AnyObject) -> Void in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                
                let response = JSON(responseObject)
                
                // results
                for (_, subJson):(String,JSON) in response["metadata"]["results"] {
                    
                    let clothId = subJson["id"].int64Value
                    let name = subJson["data"]["name"].stringValue
                    let brand = subJson["data"]["brand"].stringValue
                    let price = subJson["data"]["price"].floatValue
                    let detailUrl = subJson["data"]["url"].stringValue
                    
                    let cloth = clothServiceLocal.addCloth(clothId: clothId, name: name, brand: brand, price: price, detailUrl: detailUrl)
                    
                    // images
                    for (_, thumbJson):(String, JSON) in subJson["images"] {
                        
                        let url = thumbJson["path"].stringValue
                        
                        let clothThumbImageServiceLocal = ClothThumbImageService(cloth: cloth, managedObjectContext: localMOC)
                        clothThumbImageServiceLocal.addThumbImage(url)
                        
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    do {
                        
                        try localMOC.save()
                        
                    } catch let error as NSError {
                        
                        print (error)
                        
                    }
                    
                    // post notification: success
                    NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_FEED_RESPONSE_SUCCESS, object: FEED_TYPE.CLOTHES.rawValue)
                    
                })
                
            })
            
            
        }) { (request: AFHTTPRequestOperation, error: NSError) -> Void in
            
            // post notification: failed
            NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_FEED_RESPONSE_FAILED, object: FEED_TYPE.CLOTHES.rawValue)
            
        }
        
    }
    
    func fetchClothDetails(cloth: Cloth) {
        
        guard cloth.desc == nil else {
            
            return
            
        }
        
        let localMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        localMOC.parentContext = CoreDataStack.sharedInstance.context
        
        let clothServiceLocal = ClothService(managedObjectContext: localMOC)
        
        let clothLocal = clothServiceLocal.getCloth(cloth.clothId!)!
        
        AFNetworkingService.sharedInstance.manager.GET(cloth.detailUrl!, parameters: nil, success: { (request: AFHTTPRequestOperation, responseObject: AnyObject) -> Void in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                
                let response = JSON(responseObject)
                
                let desc = response["metadata"]["data"]["description"].stringValue
                
//                let clothLocal = localMOC.objectWithID(cloth.objectID) as! Cloth
//                clothLocal.clothId = cloth.clothId
//                clothLocal.name = cloth.name
//                clothLocal.brand = cloth.brand
//                clothLocal.price = cloth.price
                clothLocal.desc = desc
                
                for (_, imageJson):(String, JSON) in response["metadata"]["data"]["image_list"] {
                    
                    let url = imageJson["url"].stringValue
                    
                    let clothLargeImageServiceLocal = ClothLargeImageService(cloth: clothLocal, managedObjectContext: localMOC)
                    clothLargeImageServiceLocal.addLargeImage(url)
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    do {
                        
                        try localMOC.save()
                        
                    } catch {
                        
                        
                        
                    }
                    
                    // post notification: success
                    NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_FEED_RESPONSE_SUCCESS, object: FEED_TYPE.CLOTH_DESCRIPTION.rawValue, userInfo: ["cloth": cloth])
                    
                })
                
            })
            
            
            }) { (request: AFHTTPRequestOperation, error: NSError) -> Void in
                
                // post notification: failed
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_FEED_RESPONSE_FAILED, object: FEED_TYPE.CLOTH_DESCRIPTION.rawValue, userInfo: ["cloth": cloth])
                
        }
        
    }
    
}