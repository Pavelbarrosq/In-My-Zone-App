//
//  Post.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-04-07.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation
import Firebase

class Post {
    var postDescription: String
    var audioUrl: String
    var userUid: String
    var timestamp: Date!
    
    init(postDescription: String, audioUrl: String, userUid: String) {
        self.postDescription = postDescription
        self.audioUrl = audioUrl
        self.userUid = userUid
    }
    
//    init(snapshot: QueryDocumentSnapshot) {
//        let snapshotValue = snapshot.data() as [String : Any]
//        postDescription = snapshotValue["postDescription"] as! String
//        audioUrl = snapshotValue["audioUrl"] as! String
//        userUid = snapshotValue["userUid"] as! String
//        timestamp = snapshotValue["timestamp"] as? Date ?? Date()
//    }
    
    func toAny() -> [String: Any] {
        return ["postDescription": postDescription,
                "audioUrl": audioUrl,
                "userUid": userUid,
                "timestamp": timestamp]
    }
}

class ProfilePost {
    var postDescription: String
    var userUid: String
    var timestamp: Date!
    var audioUrl: String
    
    init(postDescription: String, userUid: String, audioUrl: String) {
        self.postDescription = postDescription
        self.userUid = userUid
        self.audioUrl = audioUrl
    }
    
    func toAny() -> [String: Any] {
        return ["postDescription": postDescription,
                "userUid": userUid,
                "timestamp": timestamp,
                "audioUrl": audioUrl]
    }
}
