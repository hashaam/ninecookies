//
//  ClothListCell.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 31/10/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ClothListCell: UITableViewCell {
    
    @IBOutlet weak var clothImageView: UIImageView!
    @IBOutlet weak var clothNameLabel: UILabel!
    @IBOutlet weak var clothBrandLabel: UILabel!
    @IBOutlet weak var clothPriceLabel: UILabel!
    
    var cloth: Cloth!
    
    override func awakeFromNib() {
        
        self.selectionStyle = .None
        
    }
    
    func loadClothInfo(cloth: Cloth) {
        
        self.cloth = cloth
        
        self.clothNameLabel.text = cloth.name
        self.clothBrandLabel.text = cloth.brand
        self.clothPriceLabel.text = "$\(cloth.price!.stringValue)"
        
        guard let firstThumb = cloth.thumbImages?.firstObject as? ClothThumbImage else {
            
            return
            
        }
        
        if firstThumb.imageData?.length > 0 {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                
                let thumb = UIImage(data: firstThumb.imageData!, scale: 2.0)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.clothImageView.image = thumb
                    
                })
                
            })
            
        } else {
            
            self.clothImageView.urlString = firstThumb.url
            
            let urlRequest = NSURLRequest(URL: NSURL(string: firstThumb.url!)!)
            
            self.clothImageView.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) -> Void in
                
                if self.clothImageView.urlString == firstThumb.url {
                    
                    self.clothImageView.image = image
                    
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    let imageData = UIImageJPEGRepresentation(image, 1.0)
                    
                    let coreDataStack = CoreDataStack()
                    
                    let localMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
                    localMOC.parentContext = coreDataStack.context
                    
                    let firstThumbLocal = localMOC.objectWithID(firstThumb.objectID) as! ClothThumbImage
                    firstThumbLocal.imageData = imageData
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        do {
                         
                            try localMOC.save()
                            
                        } catch {
                            
                            
                            
                        }
                        
                        
                    })
                    
                })
                
            }, failure: { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) -> Void in
                    
            })
            
        }
        
    }
    
    override func prepareForReuse() {
        
        self.clothImageView.image = nil
        
    }
    
}