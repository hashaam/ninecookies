//
//  ClothViewControllerHelper.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 31/10/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation
import CoreData

class ClothViewControllerHelper: NSObject, NSFetchedResultsControllerDelegate {
    
    var clothViewController: ClothViewController!
    
    var clothService: ClothService!
    
    var sortKey = "name"
    var ascending = true
    
    // MARK: - Results Controller -
    lazy var resultController: NSFetchedResultsController = self.getResultController()
    
    func getResultController() -> NSFetchedResultsController {
        
        let rc = self.clothService.getAllClothes(self.sortKey, ascending: self.ascending)
        rc.delegate = self
        return rc
        
    }
    
    init(viewController: ClothViewController) {
        
        self.clothViewController = viewController
        self.clothService = ClothService(managedObjectContext: CoreDataStack.sharedInstance.context)
        
        // super init
        super.init()
        
        self.clothViewController.tableView.estimatedRowHeight = 126.0
        self.clothViewController.tableView.rowHeight = UITableViewAutomaticDimension
        
        // setup notifications
        self.setupNotifications()
        
        // init data
        self.initData()
        
    }
    
    func setupNotifications() {
        
        // data success notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "feedResponseSuccessHandler:", name: NOTIFICATION_FEED_RESPONSE_SUCCESS, object: nil)
        
        // data failed notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "feedResponseFailedHandler:", name: NOTIFICATION_FEED_RESPONSE_FAILED, object: nil)
        
    }
    
    func initData() {
        
         self.clothService.fetchClothes()
        
    }
    
}

extension ClothViewControllerHelper {
    
    func feedResponseSuccessHandler(note: NSNotification) {
        
        guard let obj = note.object as? String
            where obj == FEED_TYPE.CLOTHES.rawValue else {
                
            return
                
        }
        
    }
    
    func feedResponseFailedHandler(note: NSNotification) {
        
        guard let obj = note.object as? String
            where obj == FEED_TYPE.CLOTHES.rawValue else {
            
            return
            
        }
        
        let message = "Failed to fetch clothes.\nPlease try again later."
        Core.showCustomAlertView(.Information, withMessage: message, inParentView: self.clothViewController.view)
        
    }
    
}

extension ClothViewControllerHelper {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.resultController.sections![section]
        return sectionInfo.numberOfObjects
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cloth = self.resultController.objectAtIndexPath(indexPath) as! Cloth
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cloth List Cell", forIndexPath: indexPath) as! ClothListCell
        cell.loadClothInfo(cloth)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cloth = self.resultController.objectAtIndexPath(indexPath) as! Cloth
        self.clothViewController.delegate?.didSelectDetailsForCloth(cloth.clothId!)
        
        guard let detailViewController = self.clothViewController.delegate as? ClothDetailViewController else {
            
            return
            
        }
        
        if let loaderView = detailViewController.helper.loaderView {
            
            loaderView.removeFromSuperview()
            
        }
        
        self.clothViewController.splitViewController?.showDetailViewController(detailViewController, sender: nil)
        detailViewController.helper.initData()
        
    }
    
}

extension ClothViewControllerHelper {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.clothViewController.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
            
        case NSFetchedResultsChangeType.Insert:
            self.clothViewController.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            
        case NSFetchedResultsChangeType.Delete:
            self.clothViewController.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            
        default:
            return
            
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
            
        case NSFetchedResultsChangeType.Insert:
            self.clothViewController.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            
        case NSFetchedResultsChangeType.Delete:
            self.clothViewController.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            
        case NSFetchedResultsChangeType.Update:
            self.clothViewController.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            
        case NSFetchedResultsChangeType.Move:
            self.clothViewController.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            self.clothViewController.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.clothViewController.tableView.endUpdates()
    }
    
    // MARK: - Configure Cell -
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        guard let c = cell as? ClothListCell else {
            
            return
            
        }
        
        let cloth = self.resultController.objectAtIndexPath(indexPath) as! Cloth
        c.loadClothInfo(cloth)
        
    }
    
}

extension ClothViewControllerHelper {
    
    func sort(sender: AnyObject) {
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let nameAction = UIAlertAction(title: "Name", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            
            if self.sortKey == "name" {
                self.ascending = !self.ascending
            } else {
                self.sortKey = "name"
                self.ascending = true
            }
            
            self.resultController = self.getResultController()
            self.clothViewController.tableView.reloadData()
            
        }
        let brandAction = UIAlertAction(title: "Brand", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
            
            if self.sortKey == "brand" {
                self.ascending = !self.ascending
            } else {
                self.sortKey = "brand"
                self.ascending = true
            }
            
            self.resultController = self.getResultController()
            self.clothViewController.tableView.reloadData()
            
        }
        let priceAction = UIAlertAction(title: "Price", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
            
            if self.sortKey == "price" {
                self.ascending = !self.ascending
            } else {
                self.sortKey = "price"
                self.ascending = true
            }
            
            self.resultController = self.getResultController()
            self.clothViewController.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction) -> Void in
            
            self.clothViewController.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        ac.addAction(nameAction)
        ac.addAction(brandAction)
        ac.addAction(priceAction)
        
        ac.addAction(cancelAction)
        
//        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
        
            let button = sender as! UIBarButtonItem
            ac.popoverPresentationController?.barButtonItem = button
            ac.popoverPresentationController?.sourceView = self.clothViewController.view
            
//        }
        
        self.clothViewController.presentViewController(ac, animated: true, completion: nil)
        
    }
    
}