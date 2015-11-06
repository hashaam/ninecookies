//
//  CustomAlertView.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 01/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation
import UIKit

enum CustomAlertViewType {
    
    case Information
    case Success
    
}

class CustomAlertView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    
}