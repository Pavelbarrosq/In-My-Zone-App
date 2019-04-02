//
//  Post.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-27.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Firebase

class Post {
    var audioURL: String?
    var postDescription: String?
    
    
    init (audioURL: String, postDescription: String) {
        self.audioURL = audioURL
        self.postDescription = postDescription
    }
    
    func toAny() -> [String: Any] {
        return ["audioURL": audioURL!,
                "postDescrition": postDescription!]
    }
    
    
}

class GetPost {
   
    var postDescrition: String?
    
    init(postDescrition: String) {
        self.postDescrition = postDescrition
    }
    
//    init(snapshot: QueryDocumentSnapshot) {
//        let snapshotValue = snapshot.data() as [String: Any]
//        username = snapshotValue["username"] as? String
//        postDescrition = snapshotValue["postDescrition"] as? String
//    }
    
    func toAny() -> [String: Any] {
        return ["postDescrition": postDescrition!]
    }
   
    
    
}
