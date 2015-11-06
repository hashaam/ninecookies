//
//  AFNetworkingService.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 01/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation

class AFNetworkingService {
    
    static let sharedInstance = AFNetworkingService()
    
    var manager: AFHTTPRequestOperationManager
    
    var reachabilityView: UIView?
    var reachabilityViewBottomConstraint: NSLayoutConstraint?
    
    init() {
        
        // setup afnetworking manager
        self.manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: API_SERVER_URL))
        
        // lower security to allow invalid certificated
        self.manager.securityPolicy.allowInvalidCertificates = true
        self.manager.securityPolicy.validatesDomainName = false
        
        let operationQueue = manager.operationQueue
        operationQueue.maxConcurrentOperationCount = 1
        
        self.manager.reachabilityManager.setReachabilityStatusChangeBlock { (status: AFNetworkReachabilityStatus) -> Void in
            
            switch(status) {
                
            case AFNetworkReachabilityStatus.NotReachable:
                operationQueue.suspended = true
                self.showReachabilityAlert(true)
                
            case AFNetworkReachabilityStatus.ReachableViaWiFi:
                operationQueue.suspended = false
                self.showReachabilityAlert(false)
                
            case AFNetworkReachabilityStatus.ReachableViaWWAN:
                operationQueue.suspended = false
                self.showReachabilityAlert(false)
                
            default:
                operationQueue.suspended = true
                self.showReachabilityAlert(false)
                
            }
        }
        
        self.manager.reachabilityManager.startMonitoring()
        
    }
    
    func showReachabilityAlert (flag: Bool) {
        
        let ad = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let _ = self.reachabilityView {
            
            if let window = ad.window, let rView = self.reachabilityView, let _ = self.reachabilityViewBottomConstraint {
                
                window.bringSubviewToFront(rView)
                
                var bottomValue: CGFloat!
                
                if flag {
                    
                    bottomValue = 0.0
                    
                } else {
                    
                    bottomValue = 50.0
                    
                }
                
                self.reachabilityViewBottomConstraint?.constant = bottomValue
                window.setNeedsUpdateConstraints()
                
                UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                    
                    window.layoutIfNeeded()
                    
                    
                    }, completion: nil)
                
            }
            
        } else {
            
            let rView = UIView()
            
            rView.alpha = 1
            rView.backgroundColor = UIColor.blackColor()
            rView.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "No Internet Connection"
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.whiteColor()
            
            rView.addSubview(label)
            
            let labelViewDict: [String: AnyObject] = [
                "label": label
            ]
            
            rView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(14)-[label]-(15)-|", options: [], metrics: nil, views: labelViewDict)
            )
            
            rView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-(8)-[label]-(8)-|", options: [], metrics: nil, views: labelViewDict)
            )
            
            if let window = ad.window {
                
                window.addSubview(rView)
                
                let viewDict: [String: AnyObject] = [
                    "rView": rView
                ]
                
                var bottomValue: CGFloat!
                
                if flag {
                    
                    bottomValue = 0
                    
                } else {
                    
                    bottomValue = 50.0
                    
                }
                
                let rViewBottomConstraint = NSLayoutConstraint(
                    item: rView, attribute: .Bottom, relatedBy: .Equal,
                    toItem: window, attribute: .Bottom, multiplier: 1.0, constant: bottomValue
                )
                
                window.addConstraint(
                    rViewBottomConstraint
                )
                
                window.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-5)-[rView]-(-5)-|", options: [], metrics: nil, views: viewDict)
                )
                
                self.reachabilityView = rView
                self.reachabilityViewBottomConstraint = rViewBottomConstraint
                
            }
            
        }
        
    }
    
    func isReachable() -> Bool {
        
        return self.manager.reachabilityManager.reachable
        
    }
    
}