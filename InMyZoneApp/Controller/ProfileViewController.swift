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

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    var isTapped = false
    var db = Firestore.firestore()
    var profilePicUrl: String?
    var username: String?
    var userListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        Design.shared.setBackground(view: view)
        
        getUserprofile()
        getAboutMeText()
        
        Design.shared.adjustUITextViewHeight(arg: aboutMeTextView)
        
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
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if aboutMeTextView.isEditable == false {
            aboutMeTextView.isEditable = true
        } else {
            aboutMeTextView.isEditable = false
            let uid = Auth.auth().currentUser?.uid
            let postRef = db.collection("users").document(uid!)
            postRef.setData(["aboutMe": aboutMeTextView.text], merge: true)
            aboutMeTextView.text = nil
            
            getAboutMeText()
        }
    }
    
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

        
//        guard let auth = Auth.auth().currentUser else {return}
//        let uid = Auth.auth().currentUser?.uid
//        let userRef = db.collection("users").document("\(uid)")
//        userRef.getDocument { (document, error) in
//            if error != nil {
//                print("Error getting doc : \(String(describing: error))")
//            }   else {
//                if let document = document {
//                    let docData = document.data()
//                    self.username = docData?["username"] as? String ?? ""
//                    self.usernameLabel.text = self.username
//                    self.profilePicUrl = docData?["photoUrl"] as? String ?? ""
//                    self.profilePicture.sd_setImage(with: URL(string: self.profilePicUrl!), placeholderImage: UIImage(named: "profilePlaceholder"))
//                }
//            }
//        }
    }
    
    
    
    
//    func changeBarButtonToSave() {
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
//    }
//    func changeBarButtonToEdit() {
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
//    }
}
