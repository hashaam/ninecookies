//
//  ClothThumbImageService.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 02/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation
import CoreData

class ClothThumbImageService {
    
    let cloth: Cloth
    let managedObjectContext: NSManagedObjectContext
    
    init(cloth: Cloth, managedObjectContext: NSManagedObjectContext) {
        
        self.cloth = cloth
        self.managedObjectContext = managedObjectContext
        
    }
    
    func addThumbImage(url: String, imageData: NSData? = nil) {
        
        let clothThumbImage = NSEntityDescription.insertNewObjectForEntityForName("ClothThumbImage", inManagedObjectContext: self.managedObjectContext) as! ClothThumbImage
        
        clothThumbImage.url = url
        clothThumbImage.imageData = imageData
        clothThumbImage.cloth = self.cloth
        
    }
    
}