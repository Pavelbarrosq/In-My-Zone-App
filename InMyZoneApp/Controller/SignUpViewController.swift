//
//  SignUpViewController.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-08.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUpButton(_ sender: UIButton) {
        
        if passwordTextField.text != repeatPassword.text {
            
            let alertController = UIAlertController(title: "Password do not match", message: "Retype passwords", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            
        }   else {
            
            Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                    
                }   else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    @IBAction func backButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
