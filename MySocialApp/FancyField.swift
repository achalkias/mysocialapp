//
//  FancyField.swift
//  MySocialApp
//
//  Created by Apostolos Chalkias on 05/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit

class FancyField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set border color and width
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        
        //Set the corner radius
        layer.cornerRadius = 3.0
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        //Set placeholder left padding
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        //Set the padding when the user types
         return bounds.insetBy(dx: 10, dy: 5)
    }

}
