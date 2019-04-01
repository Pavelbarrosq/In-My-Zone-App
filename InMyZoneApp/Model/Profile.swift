//
//  Profile.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-04-01.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation
import Firebase

class Profile{
    
    var username: String
    var email: String
    var photoUrl: String
    
    
    init(username: String, email: String, photoUrl: String) {
        self.username = username
        self.email = email
        self.photoUrl = photoUrl
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        username = snapshotValue["username"] as! String
        email = snapshotValue["email"] as! String
        photoUrl = snapshotValue["photo"] as! String
    }
    
    
    func toAny() -> [String: Any] {
        return ["username": username,
                "email": email,
                "photoUrl": photoUrl]
    }
}
