//
//  UIDesign.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-18.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation
import UIKit

class Design {
    
    static var shared = Design()
    
    func setBackground(view: UIView) {
        
        let fadeBackground = CAGradientLayer()
        fadeBackground.frame = view.bounds
        fadeBackground.colors = [UIColor.init(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.init(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor]
        fadeBackground.locations = [0, 0.2, 0.8, 1]
        view.layer.insertSublayer(fadeBackground, at: 0)
        
    }
    
    func setButton(button: UIButton) {
        
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor
        
    }
    
    func textFieldDesign(textField: UITextField) {
        
        let bottomlayerUsername = CALayer()
        bottomlayerUsername.frame = CGRect(x: 0, y:29, width: textField.frame.width, height: 0.6)
        bottomlayerUsername.backgroundColor = UIColor.init(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        textField.backgroundColor = UIColor.clear
        textField.tintColor = UIColor.white
        textField.textColor = UIColor.white
        textField.layer.addSublayer(bottomlayerUsername)
        
    }
    
}
