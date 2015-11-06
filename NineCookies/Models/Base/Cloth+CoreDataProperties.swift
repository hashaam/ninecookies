//
//  Cloth+CoreDataProperties.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 02/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Cloth {

    @NSManaged var brand: String?
    @NSManaged var clothId: NSNumber?
    @NSManaged var desc: String?
    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var detailUrl: String?
    @NSManaged var largeImages: NSOrderedSet?
    @NSManaged var thumbImages: NSOrderedSet?

}
