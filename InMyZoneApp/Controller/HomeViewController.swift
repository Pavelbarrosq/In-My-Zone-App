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
    var postSorter: ListenerRegistration?
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
        
        loadPost()
        

    }

    
    func loadPost() {
        let postRef = db.collection("posts")
        postListener = postRef.order(by: "timestamp", descending: true).addSnapshotListener({ (snapshot, error) in
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
    }
    
//    func sortPosts() {
//        let postRef = db.collection("posts")
//        postSorter = postRef.order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error.localizedDescription)")
//            } else {
//                guard let snapshot = snapshot else { return }
//
//               self.posts.removeAll()
//                for document in snapshot.documents {
//                    let sorter = Post(snapshot: document)
//                    self.posts.append(sorter)
//                }
//                self.tableView.reloadData()
//            }
//        }
//    }
    
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
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
        Design.shared.setButton(button: cell.playAudioButton)
        cell.addCellData(post: newPost)
        cell.backgroundColor = UIColor.black
        Design.shared.adjustUITextViewHeight(arg: cell.postDescriptionView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    

    
}
