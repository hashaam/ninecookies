//
//  ClothDetailDescListCell.swift
//  NineCookies
//
//  Created by Hashaam Siddiq on 03/11/2015.
//  Copyright © 2015 Hashaam. All rights reserved.
//

import Foundation

class ClothDetailDescListCell: UITableViewCell {
    
    @IBOutlet weak var clothDescLabel: UILabel!
    
    var cloth: Cloth!
    
    override func awakeFromNib() {
        
        self.selectionStyle = .None
        
    }
    
    func loadClothInfo(cloth: Cloth) {
        
        self.cloth = cloth
        
        guard let desc = self.cloth.desc else {
            
            return
            
        }
        
        self.clothDescLabel.text = desc
        
    }
    
    override func prepareForReuse() {
        
        self.clothDescLabel.text = " "
        
    }
    
}