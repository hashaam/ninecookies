//
//  AppDelegateHelper.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 02/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation

class AppDelegateHelper {
    
    var appDelegate: AppDelegate
    
    init(appDelegate: AppDelegate) {
        
        self.appDelegate = appDelegate
        
        guard let window = self.appDelegate.window else {
            
            return
            
        }
        
        let splitViewController = window.rootViewController as! UISplitViewController
        let leftNavController = splitViewController.viewControllers.first as! UINavigationController
        let rightNavController = splitViewController.viewControllers.last as! UINavigationController
        let masterViewController = leftNavController.topViewController as! ClothViewController
        let detailViewController = rightNavController.topViewController as! ClothDetailViewController
        
        masterViewController.delegate = detailViewController
        
    }
    
    func applicationWillResignActive() {
        
        CoreDataStack.sharedInstance.saveContext()
        
    }
    
    func applicationDidEnterBackground() {
    
        CoreDataStack.sharedInstance.saveContext()
        
    }
    
    func applicationWillEnterForeground() {
        
    }
    
    func applicationDidBecomeActive() {
        
    }
    
    func applicationWillTerminate() {
        
        CoreDataStack.sharedInstance.saveContext()
        
    }
    
}