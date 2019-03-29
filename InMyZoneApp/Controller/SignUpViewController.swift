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

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var ref: DocumentReference? = nil
    var db: Firestore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        self.hideKeyboardWhenTappedAround() 
        
        Design.shared.setBackground(view: view)
        Design.shared.textFieldDesign(textField: usernameTextField)
        Design.shared.textFieldDesign(textField: emailTextfield)
        Design.shared.textFieldDesign(textField: passwordTextField)
        Design.shared.textFieldDesign(textField: repeatPassword)
        Design.shared.setButton(button: signInButton)
    
        textFieldsChange()
        
        signInButton.isEnabled = false
        signInButton.setTitleColor(UIColor.lightText, for: .normal)
        
    }
    
    @objc func textFieldsChange() {
        
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldsCheck), for: UIControl.Event.editingChanged)
        emailTextfield.addTarget(self, action: #selector(SignUpViewController.textFieldsCheck), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldsCheck), for: UIControl.Event.editingChanged)
        repeatPassword.addTarget(self, action: #selector(SignUpViewController.textFieldsCheck), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldsCheck() {
        
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextfield.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let password2 = repeatPassword.text, !password2.isEmpty else {
            
            signInButton.setTitleColor(UIColor.lightText, for: .normal)
            signInButton.layer.borderColor = UIColor.lightText.cgColor
            
            return
            
        }
        
        signInButton.setTitleColor(UIColor(red: 148/255, green: 55/255, blue: 255/255, alpha: 1), for: .normal)
        signInButton.layer.borderColor = UIColor(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor
        signInButton.isEnabled = true
        
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
                    
                    guard let user = Auth.auth().currentUser else {return}
                    
                    let itemRef = self.db.collection("users").document(user.uid)
                    
                    itemRef.setData([
                       "username": self.usernameTextField.text!,
                        "email": self.emailTextfield.text!
                        ]) { (error) in
                            if error != nil {
                                print(error!)
                            }   else {
                                print("Document added with ID: \(String(describing: self.ref?.documentID))")
                            }
                    }
                    
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
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
