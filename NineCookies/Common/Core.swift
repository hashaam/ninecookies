//
//  Core.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 01/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation
import ObjectiveC

private var xoAssociationKey: UInt8 = 0

enum FEED_TYPE: String {
    
    case CLOTHES = "CLOTHES"
    case CLOTH_DESCRIPTION = "CLOTH_DESCRIPTION"
    
}

// MARK: UIImageView
extension UIImageView {
    
    var urlString: String! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

// MARK: UIView
extension UIView {
    
    var customAlertView: UIView? {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}

class Core {
    
    // MARK: - Delay -
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // MARK: - === Custom Alert View === -
    class func showCustomAlertView(viewType: CustomAlertViewType, withMessage message: String, inParentView parentView: UIView, withTopOffset topOffset: CGFloat = 0.0) {
        
        if let customAlertView = parentView.customAlertView {
            
            customAlertView.removeFromSuperview()
            
        }
        
        // get objects from nib file
        let objects = UINib(nibName: "CustomAlertViewXib", bundle: NSBundle.mainBundle()).instantiateWithOwner(nil, options: nil)
        
        // make custom alert view
        let customAlertView = objects.first as! CustomAlertView
        customAlertView.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.customAlertView = customAlertView
        
        // check view type
        if viewType == CustomAlertViewType.Information {
            
            customAlertView.backgroundColor = INFORMATION_COLOR
            
        } else {
            
            customAlertView.backgroundColor = SUCCESS_COLOR
            
        }
        
        // add as subview
        parentView.addSubview(customAlertView)
        
        // make views dictionary
        let views: [String: AnyObject] = [
            "customAlertView": customAlertView
        ]
        
        // add horizontal constraints
        parentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-(0)-[customAlertView]-(0)-|",
                options: [],
                metrics: nil,
                views: views))
        
        // make top constraint
        let topConstraint = NSLayoutConstraint(
            item: customAlertView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: parentView,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)
        
        // add top constraint
        parentView.addConstraint(topConstraint)
        
        // set message
        customAlertView.messageLabel.text = message
        
        // update constraints
        customAlertView.layoutIfNeeded()
        
        // get custom alert view height with updated message & extended view height
        let customAlertViewHeight = CGRectGetHeight(customAlertView.frame)
        
        // make offset including custom alert view height & top offset
        let offset = customAlertViewHeight + topOffset
        
        // set starting value
        topConstraint.constant = -offset
        
        // make view changes
        customAlertView.layoutIfNeeded()
        
        // animate from hidden position
        UIView.animateWithDuration(0.25,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                
                // animate to visible position
                topConstraint.constant = topOffset
                customAlertView.layoutIfNeeded()
                
            }, completion: { (completion: Bool) -> Void in
                
                // delay for some time
                Core.delay(7.0, closure: { () -> () in
                    
                    // animate from visible position
                    UIView.animateWithDuration(0.25,
                        delay: 0.0,
                        options: UIViewAnimationOptions.CurveEaseInOut,
                        animations: { () -> Void in
                            
                            // animate to hidden position
                            topConstraint.constant = -offset
                            customAlertView.layoutIfNeeded()
                            
                        }, completion: { (completion: Bool) -> Void in
                            
                            // on completion, get rid custom alert view
                            customAlertView.removeFromSuperview()
                            
                    })
                    
                })
                
        })
        
    }
    
}