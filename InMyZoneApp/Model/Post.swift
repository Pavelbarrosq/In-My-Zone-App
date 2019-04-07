//
//  Post.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-04-07.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation

class Post {
    var postDescription: String
    var audioUrl: String
    
    init(postDescription: String, audioUrl: String) {
        self.postDescription = postDescription
        self.audioUrl = audioUrl
    }
}
