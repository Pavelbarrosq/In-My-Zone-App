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
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            AuthUtilitys.signUp(username: usernameTextField.text!, email: emailTextfield.text!, password: passwordTextField.text!, onSuccess: {
                AuthUtilitys.setUserInformaition(username: self.usernameTextField.text!, email: self.emailTextfield.text!, onSuccess: {
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                })
                
                
            }) { (error) in
                let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
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
