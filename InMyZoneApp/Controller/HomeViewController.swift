//
//  HomeViewController.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-07.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var postListener: ListenerRegistration?
    var posts = [Post]()
    
    var db: Firestore!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        tableView.dataSource = self
        tableView.delegate = self
        

        
        loadPost()
        
//        var post = Post(postDescription: "test", audioUrl: "url")
//        print(post.postDescription)
//        print(post.audioUrl)
        
        Design.shared.setBackground(view: view)

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
                    let description = data["postDescription"] as! String ?? ""
                    let url = data["audioUrl"] as! String ?? ""
                    let post = Post(postDescription: description, audioUrl: url)
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
        cell.addCellData(post: newPost)
        cell.backgroundColor = UIColor.gray
        return cell
    }
    

    
}
