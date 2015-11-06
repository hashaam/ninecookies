//
//  ClothLargeImageService.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 02/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation
import CoreData

class ClothLargeImageService {
    
    let cloth: Cloth
    let managedObjectContext: NSManagedObjectContext
    
    init(cloth: Cloth, managedObjectContext: NSManagedObjectContext) {
        
        self.cloth = cloth
        self.managedObjectContext = managedObjectContext
        
    }
    
    func addLargeImage(url: String, imageData: NSData? = nil) {
        
        let clothLargeImage = NSEntityDescription.insertNewObjectForEntityForName("ClothLargeImage", inManagedObjectContext: self.managedObjectContext) as! ClothLargeImage
        
        clothLargeImage.url = url
        clothLargeImage.imageData = imageData
        clothLargeImage.cloth = self.cloth
        
    }
    
}