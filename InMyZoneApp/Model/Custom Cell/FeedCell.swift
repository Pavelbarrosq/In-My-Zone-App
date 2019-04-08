//
//  FeedCell.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-04-08.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SDWebImage
import AVFoundation

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var postDescriptionView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var playAudioButton: UIButton!
    
    var username: String!
    var profilePicUrl: String!
    
    var db = Firestore.firestore()
    
    func addCellData(post: Post) {
        getUserInfo()
    }
    
    
    func getUserInfo() {
        guard let auth = Auth.auth().currentUser else {return}
        let userRef = db.collection("users").document(auth.uid)
        userRef.getDocument { (document, error) in
            if error != nil {
                print("Error getting doc : \(error)")
            }   else {
                if let document = document {
                    let docData = document.data()
                    self.username = docData!["username"] as? String ?? ""
                    self.usernameLabel.text = self.username
                    self.profilePicUrl = docData!["photoUrl"] as? String ?? ""
                    self.profileImage.sd_setImage(with: URL(string: self.profilePicUrl), placeholderImage: UIImage(named: "profilePlaceholder"))
                }
            }
        }
    }
    
}
