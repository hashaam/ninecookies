//
//  ClothViewController.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 31/10/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation
import CoreData

class ClothViewController: UITableViewController {
    
    var helper: ClothViewControllerHelper!
    
    weak var delegate: ClothDetailViewDelegate?
    
    override func viewDidLoad() {
        
        self.helper = ClothViewControllerHelper(viewController: self)
        
    }
    
}

extension ClothViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.helper.tableView(tableView, numberOfRowsInSection: section)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return self.helper.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.helper.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
    }
    
}

extension ClothViewController {
    
    @IBAction func sortHandler(sender: AnyObject) {
        
        self.helper.sort(sender)
        
    }
    
    
}