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
    
    var username: String?
    var profilePicUrl: String?
    var recordUrl: String?
    var userId: String?

    
    var audioPlayer: AVAudioPlayer?
    
    var db = Firestore.firestore()
    
    func addCellData(post: Post) {
        getUserInfo(post: post)
    }
    
    
    func getUserInfo(post: Post) {
        guard let auth = Auth.auth().currentUser else {return}
        let uid = post.userUid
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { (document, error) in
            if error != nil {
                print("Error getting doc : \(String(describing: error))")
            }   else {
                if let document = document {
                    let docData = document.data()
                    self.username = docData?["username"] as? String ?? ""
                    self.usernameLabel.text = self.username
                    self.profilePicUrl = docData?["photoUrl"] as? String ?? ""
                    self.profileImage.sd_setImage(with: URL(string: self.profilePicUrl!), placeholderImage: UIImage(named: "profilePlaceholder"))
                }
            }
        }
    }
    
    
    @IBAction func playAudio(_ sender: UIButton) {
        print("!!!!!!!\(recordUrl!)")
        
        let ref = Storage.storage().reference(forURL: recordUrl!)
        ref.getData(maxSize: 100 * 1024 * 1024) {
            data, error in
            if let error = error {
                print("Error retreving data \(error.localizedDescription)")
            } else {
                do {
                    let dataPath = data
                    
                    self.audioPlayer = try AVAudioPlayer(data: dataPath!)
                    self.audioPlayer?.prepareToPlay()
                    self.audioPlayer?.volume = 10.0
//                    self.audioPlayer!.pan = 0.0
                    self.audioPlayer?.play()
                } catch {
                    print("!!!")
                }
            }
        }
    }
  
}
