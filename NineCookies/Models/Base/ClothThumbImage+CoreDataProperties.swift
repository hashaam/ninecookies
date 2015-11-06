//
//  ClothThumbImage+CoreDataProperties.swift
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

extension ClothThumbImage {

    @NSManaged var imageData: NSData?
    @NSManaged var url: String?
    @NSManaged var cloth: Cloth?

}
