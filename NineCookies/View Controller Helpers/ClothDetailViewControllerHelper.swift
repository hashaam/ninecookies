//
//  ClothDetailViewControllerHelper.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 02/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation

class ClothDetailViewControllerHelper: NSObject {
    
    var clothDetailViewController: ClothDetailViewController
    
    var clothId: NSNumber! {
        
        didSet {
            
            self.cloth = self.clothService.getCloth(clothId)
            self.clothDetailViewController.tableView.reloadData()
            
        }
        
    }
    var cloth: Cloth!
    
    var clothService: ClothService!
    
    var loaderView: UIView?
    
    init(viewController: ClothDetailViewController) {
        
        self.clothDetailViewController = viewController
        self.clothService = ClothService(managedObjectContext: CoreDataStack.sharedInstance.context)
        
        // super init
        super.init()
        
        self.clothDetailViewController.tableView.estimatedRowHeight = 218.0
        self.clothDetailViewController.tableView.rowHeight = UITableViewAutomaticDimension
        
        // setup notifications
        self.setupNotifications()
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        view.layer.cornerRadius = 5.0
        
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.startAnimating()
        
        view.addSubview(indicatorView)
        
        view.addConstraint(
            NSLayoutConstraint(item: indicatorView,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: view,
                attribute: .CenterX,
                multiplier: 1.0,
                constant: 0.0)
        )
        
        view.addConstraint(
            NSLayoutConstraint(item: indicatorView,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: view,
                attribute: .CenterY,
                multiplier: 1.0,
                constant: 0.0)
        )
        
        self.clothDetailViewController.tableView.addSubview(view)
        
        self.clothDetailViewController.tableView.addConstraint(
            NSLayoutConstraint(item: view,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self.clothDetailViewController.tableView,
                attribute: .CenterX,
                multiplier: 1.0,
                constant: 0.0)
        )
        
        self.clothDetailViewController.tableView.addConstraint(
            NSLayoutConstraint(item: view,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: self.clothDetailViewController.tableView,
                attribute: .CenterY,
                multiplier: 1.0,
                constant: 0.0)
        )
        
        self.clothDetailViewController.tableView.addConstraint(
            NSLayoutConstraint(item: view,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .Width,
                multiplier: 1.0,
                constant: 67.0)
        )
        
        self.clothDetailViewController.tableView.addConstraint(
            NSLayoutConstraint(item: view,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .Height,
                multiplier: 1.0,
                constant: 67.0)
        )
        
        self.loaderView = view
    }
    
    func setupNotifications() {
        
        // data success notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "feedResponseSuccessHandler:", name: NOTIFICATION_FEED_RESPONSE_SUCCESS, object: nil)
        
        // data failed notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "feedResponseFailedHandler:", name: NOTIFICATION_FEED_RESPONSE_FAILED, object: nil)
        
    }
    
    func initData() {
        
        self.clothService.fetchClothDetails(self.cloth)
        
    }

    func feedResponseSuccessHandler(note: NSNotification) {
        
        guard let obj = note.object as? String
            where obj == FEED_TYPE.CLOTH_DESCRIPTION.rawValue else {
                    
                return
                    
        }
        
        guard let cloth = note.userInfo?["cloth"] as? Cloth
            where cloth == self.cloth else {
                
                return
                
        }
        
        self.cloth = CoreDataStack.sharedInstance.context.objectWithID(cloth.objectID) as! Cloth
        self.clothDetailViewController.tableView.reloadData()
        
    }

    func feedResponseFailedHandler(note: NSNotification) {
        
        guard let obj = note.object as? String
            where obj == FEED_TYPE.CLOTH_DESCRIPTION.rawValue else {
                
                return
                
        }
        
        let message = "Failed to fetch clothes.\nPlease try again later."
        Core.showCustomAlertView(.Information, withMessage: message, inParentView: self.clothDetailViewController.view)
        
    }

}

extension ClothDetailViewControllerHelper {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowCount = 2
        
        if cloth == nil {
            
            rowCount = 0
            
        }
        
        return rowCount
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if indexPath.row == 0 {
            
            let mainCell = tableView.dequeueReusableCellWithIdentifier("Cloth Detail Cell", forIndexPath: indexPath) as! ClothDetailListCell
            
            if cloth != nil {
                
                mainCell.loadClothInfo(cloth)
                
            }
            
            cell = mainCell
            
        }
        
        if indexPath.row == 1 {
            
            let descCell = tableView.dequeueReusableCellWithIdentifier("Coth Detail Desc Cell", forIndexPath: indexPath) as! ClothDetailDescListCell
            
            if cloth != nil {
            
                descCell.loadClothInfo(cloth)
                
            }
            
            cell = descCell
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 218.0
        
    }
    
}
