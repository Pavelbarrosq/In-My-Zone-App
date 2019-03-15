//
//  StartViewController.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-08.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fadeBackground = CAGradientLayer()
        fadeBackground.frame = view.bounds
        fadeBackground.colors = [UIColor.init(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.init(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor]
        fadeBackground.locations = [0, 0.2, 0.8, 1]
        view.layer.insertSublayer(fadeBackground, at: 0)
        
        
        loginButton.backgroundColor = UIColor.clear
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.init(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor
        
        signUpButton.backgroundColor = UIColor.clear
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = UIColor(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "StartToHome", sender: self)
        }
        
    }

}
