//
//  ClothDetailListCell.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 02/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation
import CoreData

class ClothDetailListCell: UITableViewCell {
    
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
        
        guard let firstLarge = cloth.largeImages?.firstObject as? ClothLargeImage else {
            
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
                
            }
            
            return
            
        }
        
        if firstLarge.imageData?.length > 0 {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                
                let thumb = UIImage(data: firstLarge.imageData!, scale: 2.0)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.clothImageView.image = thumb
                    
                })
                
            })
            
        } else {
            

            self.clothImageView.urlString = firstLarge.url
            
            let urlRequest = NSURLRequest(URL: NSURL(string: firstLarge.url!)!)
            
            self.clothImageView.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) -> Void in
                
                if self.clothImageView.urlString == firstLarge.url {
                    
                    self.clothImageView.image = image
                    
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    let imageData = UIImageJPEGRepresentation(image, 1.0)
                    
                    let localMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
                    localMOC.parentContext = CoreDataStack.sharedInstance.context
                    
                    let firstLargeLocal = localMOC.objectWithID(firstLarge.objectID) as! ClothLargeImage
                    firstLargeLocal.imageData = imageData
                        
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        do {
                            
                            try localMOC.save()
                            
                        } catch {
                            
                            
                            
                        }
                        
                        
                    })
                    
                })
                
            }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) -> Void in
                
                
                    
            }
            
            
        }
        

    }
    
    override func prepareForReuse() {
        
        self.clothImageView.image = nil
        
    }
    
}