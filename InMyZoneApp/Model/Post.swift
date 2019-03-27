//
//  Post.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-27.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation

class Post {
    var audioURL: String?
    var postDescription: String?
    
    init (audioURL: String, postDescription: String) {
        self.audioURL = audioURL
        self.postDescription = postDescription
    }
}
