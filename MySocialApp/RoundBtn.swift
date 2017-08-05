//
//  RoundBtn.swift
//  MySocialApp
//
//  Created by Apostolos Chalkias on 05/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit

class RoundBtn: UIButton {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //Set shadow color, opacity, radius and offset
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        //Dont strech the image
        imageView?.contentMode = .scaleAspectFit
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Set some perfect round corners. Do it here because the frame size has been decided
        layer.cornerRadius = self.frame.width / 2
        
        
    }
    
    
}
