//
//  ClothDetailViewController.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 02/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation

class ClothDetailViewController: UITableViewController, ClothDetailViewDelegate {
    
    var helper: ClothDetailViewControllerHelper!
    
    override func awakeFromNib() {
        
        self.helper = ClothDetailViewControllerHelper(viewController: self)
        
    }
        
}

extension ClothDetailViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.helper.tableView(tableView, numberOfRowsInSection: section)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return self.helper.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.helper.tableView(tableView, estimatedHeightForRowAtIndexPath: indexPath)
        
    }
    
}

extension ClothDetailViewController {
    
    func didSelectDetailsForCloth(clothId: NSNumber) {
        
        self.helper.clothId = clothId
    
    }
    
}