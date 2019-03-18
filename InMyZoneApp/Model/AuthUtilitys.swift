//
//  AuthUtilitys.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-18.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase


class AuthUtilitys {
    
    static func login(email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (_ error: String?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

            if error != nil {

                onFailure(error?.localizedDescription)
                return
            
            }
            
            onSuccess()

        }
        
    }
    
    static func signUp(username: String, email: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping (_ error: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                
                onFailure(error?.localizedDescription)
                return
                
            }
            
            onSuccess()
                
            }
        
    }
    
    static func setUserInformaition(username: String, email: String, onSuccess: @escaping () -> Void) {
        // push user to Firebase/Database
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let userRef = ref.child("users") // child recefence in the http site.com/users
        let newUserRef = userRef.child(userID!)
        newUserRef.setValue(["username": username, "email": email])
        print("descrition \(newUserRef.description())")
        onSuccess()
        
    }
    
}


