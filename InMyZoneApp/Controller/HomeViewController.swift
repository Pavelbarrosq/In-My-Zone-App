//
//  HomeViewController.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-07.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var recordingSession: AVAudioSession!
    var postListener: ListenerRegistration?
    var posts = [Post]()
    
    var db: Firestore!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("Accepted")
            }
        }
        
        Design.shared.setBackground(view: view)
        db = Firestore.firestore()
        tableView.dataSource = self
        tableView.delegate = self
        
//        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
//            if hasPermission {
//                print("Accepted")
//            }
        
        loadPost()
        
//        var post = Post(postDescription: "test", audioUrl: "url")
//        print(post.postDescription)
//        print(post.audioUrl)

        
        play()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
      
        return path as URL
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let ref = Storage.storage().reference(forURL: "gs://inmyzomeapp.appspot.com/audio/14BF672C-075F-4918-85D1-14DE0420B182")
//
//
//        let downloadTask = ref.write(toFile: getFileURL() ){
//            url, error in
//
//            var audioPlayer : AVAudioPlayer!
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: self.getFileURL() as URL)
//            } catch let error as NSError {
//                print("Error: \(error.localizedDescription)")
//            }
//            audioPlayer.prepareToPlay()
//            audioPlayer.volume = 10.0
//            audioPlayer.play()
//
        
        
//        ref.getData(maxSize: 100 * 1024 * 1024) {
//            data, error in
//            if let error = error {
//                print("!!!! error")
//            } else {
//                do {
//                    print("!!! ja")
//                    let player = try AVAudioPlayer(data: data!)
//                    player.prepareToPlay()
//
//                    player.volume = 10.0
//                    player.play()
//
//                } catch {
//                    print("!!!")
//                }
//            }
//        }
    }
    
    
    func play() {
        //guard let url = URL(string: recordUrl!) else {return}
        
        
        let url = URL(string: "//https://firebasestorage.googleapis.com/v0/b/inmyzomeapp.appspot.com/o/audio%2F14BF672C-075F-4918-85D1-14DE0420B182?alt=media&token=dfcb5ca9-8b50-4592-a784-53332a9bdc90")
        let playerItem = AVPlayerItem(url: url!)
        let player = AVPlayer(playerItem: playerItem)
        
        
        player.play()
        
        
    }
    
    func loadPost() {
        let postRef = db.collection("posts")
        postListener = postRef.addSnapshotListener({ (snapshot, error) in
            if error != nil {
                print("Error listening \(error)")
            }   else {
                self.posts.removeAll()
                for document in snapshot!.documents {
                    let data = document.data()
                    let description = data["postDescription"] as? String ?? ""
                    guard let url = data["audioUrl"] as? String else {return}
                    guard let userId = data["userId"] as? String else {return}
                    let post = Post(postDescription: description, audioUrl: url, userUid: userId)
                    self.posts.append(post)
                }
            }
            self.tableView.reloadData()
            print("Succes obtaining data")
        })
        
//        postRef.getDocuments { (snapshot, error) in
//            if error != nil {
//                print("Error: \(error)")
//            }   else {
//                if let snapshot = snapshot {
//                    for docs in snapshot.documents {
//                        if let dict = docs.data() as? [String: Any] {
//                            let description = dict["postDescription"] as! String
//                            let url = dict["audioUrl"] as! String
//                            let post = Post(postDescription: description, audioUrl: url)
//                            self.posts.append(post)
//                            print(self.posts)
//
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func loadUserInfo () {
//        let userUid = Auth.auth().currentUser?.uid
//        let profileRef = db.collection("users").whereField("\(userUid)", isEqualTo: true)
//        profileRef.getDocuments { (snapshot, error) in
//            if error != nil {
//                print("Error getting userInfo: \(error)")
//            }   else {
//                for document in snapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
        }
            
        catch let signOutError as NSError {
            
            print("There was an error signing out \(signOutError)")
            
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let startVC = storyboard.instantiateViewController(withIdentifier: "StartViewControllerID")
        self.present(startVC, animated: true, completion: nil)
    }

        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newPost = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedCell
        cell.postDescriptionView.text = posts[indexPath.row].postDescription
        cell.recordUrl = posts[indexPath.row].audioUrl
    //   cell.audioPlayer?.delegate = self
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
        cell.addCellData(post: newPost)
        cell.backgroundColor = UIColor.black
        Design.shared.setButton(button: cell.playAudioButton)
        
        
        
        return cell
    }
    

    
}
