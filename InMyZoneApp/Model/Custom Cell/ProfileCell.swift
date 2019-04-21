//
//  ProfileCell.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-04-21.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVFoundation

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var postDescription: UITextView!
    
    var recordUrl: String?
    var audioPlayer: AVAudioPlayer?
    var descriptionText: String?
    
    var db = Firestore.firestore()
    
    func addCellData(post: ProfilePost) {
//        getPostToProfile(post: post)
    }


//    func getPostToProfile(post: ProfilePost) {
//
//        guard let auth = Auth.auth().currentUser else {return}
//        let uid = post.userUid
//        let userRef = db.collection("users").document(uid).collection("userposts")
//        userRef.addSnapshotListener { (snapshot, error) in
//            if error != nil {
//                print("error getting data: \(error)")
//            } else {
//                for document in snapshot!.documents {
//                    let data = document.data()
//                    self.descriptionText = data["postDescription"] as? String ?? ""
//                    self.postDescription.text = self.descriptionText
//                    self.recordUrl = data["audioUrl"] as? String ?? ""
//                }
//            }
//        }
//
//    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        print("TAPTAP!")
        let ref = Storage.storage().reference(forURL: recordUrl!)
        ref.getData(maxSize: 100 * 1024 * 1024) { (data, error) in
            if error != nil {
                print("Error getting audio: \(error)")
            } else {
                do {
                    let dataPath = data
                    
                    self.audioPlayer = try AVAudioPlayer(data: dataPath!)
                    self.audioPlayer?.prepareToPlay()
                    self.audioPlayer?.volume = 10.0
                    self.audioPlayer?.play()
                } catch {
                    print("err!!!!!!")
                }
            }
        }
    }
}
