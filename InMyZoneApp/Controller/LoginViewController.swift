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
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        Design.shared.setBackground(view: view)
        Design.shared.setButton(button: loginButton)
        loginButton.isEnabled = false
        loginButton.setTitleColor(UIColor.lightText, for: .normal)
        
        Design.shared.textFieldDesign(textField: email)
        Design.shared.textFieldDesign(textField: password)
        email.attributedPlaceholder = NSAttributedString(string: email.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        password.attributedPlaceholder = NSAttributedString(string: password.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 0.6)])
        
        textFieldsChange()
        
    }
    
    func textFieldsChange() {
        
        email.addTarget(self, action: #selector(LoginViewController.textFieldsCheck), for: UIControl.Event.editingChanged)
        password.addTarget(self, action: #selector(LoginViewController.textFieldsCheck), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldsCheck() {
        
        guard let email = email.text, !email.isEmpty, let password = password.text, !password.isEmpty else {
            
            loginButton.setTitleColor(UIColor.lightText, for: .normal)
            loginButton.layer.borderColor = UIColor.lightText.cgColor
            
            return
        }
        
        loginButton.setTitleColor(UIColor(red: 148/255, green: 55/255, blue: 255/255, alpha: 1), for: .normal)
        loginButton.layer.borderColor = UIColor.init(red: 148/255, green: 55/255, blue: 255/255, alpha: 1).cgColor
        loginButton.isEnabled = true
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
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
