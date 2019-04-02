//
//  FeedCell.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-04-02.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SDWebImage

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var audioPlayButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postDescritionLabel: UILabel!
    
    var feedUsername: String?
    var urlDownloaded: String?

    
    func addCellData(post: GetPost) {
        getImageURl()
        getUsername()
      
        postDescritionLabel.text = post.postDescrition


        
    }
    func getUsername() {
        guard let auth = Auth.auth().currentUser else {return}
        let userRef = Firestore.firestore().collection("users")
        userRef.document(auth.uid).getDocument { (document, error) in
            if let error = error {
                print("Error retrweing document: \(error)")
            }   else {
                if let document = document {
                    let documentD = document.data()
                    self.feedUsername = documentD?["username"] as? String ?? ""
                    
                    self.usernameLabel.text = self.feedUsername
                }
            }
        }
    }
    
    func getImageURl () {
        guard let auth = Auth.auth().currentUser else {return}
        
        let storage = Storage.storage().reference().child("profileimage").child("\(auth.uid)")
        storage.downloadURL { (url, error) in
            if let error = error {
                print("Error getting URL for image: \(error)")
            } else {
                if let url = url {
                    self.urlDownloaded = url.absoluteString
                    
                    self.profileImage.sd_setImage(with: URL(string: self.urlDownloaded!), placeholderImage: UIImage(named: "profilePlaceholder"))
                    
                }
            }
            
        }
        
    }
}
