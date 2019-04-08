//
//  SignUpViewController.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-08.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var addPhoto: UIImageView!
    
    var storage: Storage!
    var storageRef: StorageReference!
    var db: Firestore!
    var imagepicker: UIImagePickerController!
    var profileImageURL: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        storage = Storage.storage()
        
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
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker(_:)))
        addPhoto.isUserInteractionEnabled = true
        addPhoto.addGestureRecognizer(imageTap)
        addPhoto.layer.cornerRadius = addPhoto.frame.height/2
        addPhoto.clipsToBounds = true
        
        
        
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
                    
                    let user = Auth.auth().currentUser
                    let storageRef = self.storage.reference().child("profileimage/\(user!.uid)")
                    
                    let image = self.addPhoto.image
                    let imageData = image!.jpegData(compressionQuality: 0.5)
                    let uploadImage = storageRef.putData(imageData!, metadata: nil) { (query, error) in
                        print("Upload success")
                        storageRef.downloadURL(completion: { (url, error) in
                            if let error = error {
                                print("error downloading url: \(error)")
                            } else {
                                if let url = url {
                                    self.profileImageURL = url.absoluteString
                                    let itemRef = self.db.collection("users").document(user!.uid)
                                    
                                    let profileInfo = Profile(username: self.usernameTextField.text!, email: self.emailTextfield.text!, photoUrl: self.profileImageURL)
                                    itemRef.setData(profileInfo.toAny(), completion: { (error) in
                                        if error != nil {
                                            print(error)
                                        } else {
                                            print("Document added with userInfo")
                                            self.performSegue(withIdentifier: "signUpToHome", sender: self)
                                        }
                                    })
                                }
                            }
                        })
                    }
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
    
    @objc func openImagePicker(_ sender:Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        addPhoto.image = pickedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
}
