//
//  SignUpViewController.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-08.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var showPassword: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fadeBackground = CAGradientLayer()
        fadeBackground.frame = view.bounds
        fadeBackground.colors = [UIColor.init(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.init(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor]
        fadeBackground.locations = [0, 0.2, 0.8, 1]
        view.layer.insertSublayer(fadeBackground, at: 0)
        
        let bottomlayerUsername = CALayer()
        bottomlayerUsername.frame = CGRect(x: 0, y:29, width: usernameTextField.frame.width, height: 0.6)
        bottomlayerUsername.backgroundColor = UIColor.init(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.tintColor = UIColor.white
        usernameTextField.textColor = UIColor.white
        usernameTextField.layer.addSublayer(bottomlayerUsername)
        
        let bottomlayerEmail = CALayer()
        bottomlayerEmail.frame = CGRect(x: 0, y:29, width: emailTextfield.frame.width, height: 0.6)
        bottomlayerEmail.backgroundColor = UIColor.init(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        emailTextfield.backgroundColor = UIColor.clear
        emailTextfield.tintColor = UIColor.white
        emailTextfield.textColor = UIColor.white
        emailTextfield.layer.addSublayer(bottomlayerEmail)
        
        let bottomlayerPassword = CALayer()
        bottomlayerPassword.frame = CGRect(x: 0, y:29, width: passwordTextField.frame.width, height: 0.6)
        bottomlayerPassword.backgroundColor = UIColor.init(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.layer.addSublayer(bottomlayerPassword)
        
        let bottomlayerPassword2 = CALayer()
        bottomlayerPassword2.frame = CGRect(x: 0, y:29, width: repeatPassword.frame.width, height: 0.6)
        bottomlayerPassword2.backgroundColor = UIColor.init(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        repeatPassword.backgroundColor = UIColor.clear
        repeatPassword.tintColor = UIColor.white
        repeatPassword.textColor = UIColor.white
        repeatPassword.layer.addSublayer(bottomlayerPassword2)
        
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
                    
                    let ref = Database.database().reference()
                    let userRef = ref.child("users")
                    
                    let userID = Auth.auth().currentUser?.uid
                    let newUserRef = userRef.child(userID!)
                    newUserRef.setValue(["username": self.usernameTextField.text!, "email": self.emailTextfield.text!])
                    print("descrition \(newUserRef.description())")
            
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
    @IBAction func showPasswordButton(_ sender: UIButton) {
        
        if passwordTextField.isSecureTextEntry == true {
            
            passwordTextField.isSecureTextEntry = false
            repeatPassword.isSecureTextEntry = false
            
            showPassword.setTitle("Hide", for: .normal)
            
        }   else {
            
            passwordTextField.isSecureTextEntry = true
            repeatPassword.isSecureTextEntry = true
            
            showPassword.setTitle("Show", for: .normal)
            
        }
        
    }
}
