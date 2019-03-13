//
//  LoginViewController.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-08.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        email.backgroundColor = UIColor.clear
        email.tintColor = UIColor.white
        email.textColor = UIColor.white
        email.attributedPlaceholder = NSAttributedString(string: email.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: email.frame.width, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        email.layer.addSublayer(bottomLayerEmail)
        
        password.backgroundColor = UIColor.clear
        password.tintColor = UIColor.white
        password.textColor = UIColor.white
        password.attributedPlaceholder = NSAttributedString(string: password.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: password.frame.width, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        password.layer.addSublayer(bottomLayerPassword)
        
        profileImage.layer.cornerRadius = 55
        profileImage.clipsToBounds = true
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            let ref = Database.database().reference()
            print(ref.description())
            
            if error == nil {
                
                self.performSegue(withIdentifier: "loginToHome", sender: self)
                
            }   else {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
