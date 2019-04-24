//
//  ProfileViewController.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-07.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import AVFoundation

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var isTapped = false
    var db = Firestore.firestore()
    var profilePicUrl: String?
    var username: String?
    var userListener: ListenerRegistration?
    var ownPosts: [ProfilePost] = []
    var postListener: ListenerRegistration?
    var recordingSession: AVAudioSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        Design.shared.setBackground(view: view)
        
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("Accepted")
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getUserprofile()
        getAboutMeText()
        loadProfilePost()
        
//        Design.shared.adjustUITextViewHeight(arg: aboutMeTextView)
        
        
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if aboutMeTextView.isEditable == false {
            aboutMeTextView.isEditable = true
            editButton.setTitle("Save", for: .normal)
            aboutMeTextView.layer.cornerRadius = 20.0
            aboutMeTextView.backgroundColor = .white
            aboutMeTextView.textColor = .black
            
        } else {
            aboutMeTextView.isEditable = false
            let uid = Auth.auth().currentUser?.uid
            let postRef = db.collection("users").document(uid!)
            postRef.setData(["aboutMe": aboutMeTextView.text], merge: true)
            
            aboutMeTextView.backgroundColor = .clear
            aboutMeTextView.textColor = .white
            editButton.setTitle("Edit", for: .normal)
        }
    }
//    let uid = Auth.auth().currentUser?.uid
//    let postRef = db.collection("users").document(uid!)
//    postRef.setData(["aboutMe": aboutMeTextView.text], merge: true)
    
    func getAboutMeText () {
        let uid = Auth.auth().currentUser?.uid
        let postRef = db.collection("users").document(uid!)
        postRef.getDocument { (snapshot, error) in
            if error != nil {
                print("error: \(error)")
            } else {
                print("SUCCESS")
                if let snapshot = snapshot {
                    let data = snapshot.data()
                    self.aboutMeTextView.text = data!["aboutMe"] as? String ?? ""
                }
            }
        }
    }
    
    func getUserprofile() {
        print("!!!!!")
        let uid = Auth.auth().currentUser?.uid
        let postRef = db.collection("users").document(uid!)
        print("UID IS!!!!!!!: \(uid)")
        postRef.getDocument { (snapshot, error) in
            if error != nil {
                print("ERROR \(error)")
            } else {
                print("SUCCESS")
                if let snapshot = snapshot {
                    let data = snapshot.data()
                    self.usernameLabel.text = data!["username"] as? String ?? ""
                    self.profilePicUrl = data!["photoUrl"] as? String ?? ""
                    self.profilePicture.sd_setImage(with: URL(string: self.profilePicUrl!), placeholderImage: UIImage(named: "profilePlaceholder"))
                }
            }
        }
    }
    
    func loadProfilePost() {
        let uid = Auth.auth().currentUser?.uid
        let postRef = db.collection("users").document(uid!).collection("userposts")
        postListener = postRef.order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("Error: \(error)")
            } else {
                self.ownPosts.removeAll()
                for document in snapshot!.documents {
                    let data = document.data()
                    guard let description = data["postDescription"] as? String else {return}
                    guard let url = data["audioUrl"] as? String else {return}
                    let profilePost = ProfilePost(postDescription: description, userUid: uid!, audioUrl: url)
                    self.ownPosts.append(profilePost)
                }
            }
            self.tableView.reloadData()
            print("Success profile Data!!!!!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ownPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newPost = ownPosts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.postDescription.text = ownPosts[indexPath.row].postDescription
        cell.recordUrl = ownPosts[indexPath.row].audioUrl
        Design.shared.adjustUITextViewHeight(arg: cell.postDescription)
        Design.shared.setButton(button: cell.playButton)
        cell.addCellData(post: newPost)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    @IBAction func signOutButton(_ sender: UIBarButtonItem) {
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
}
