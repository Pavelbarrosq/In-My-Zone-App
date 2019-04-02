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
    
    @IBOutlet weak var sessionTableView: UITableView!
    
    var ref: DocumentReference? = nil
    var db: Firestore!
    var documentArrray: [GetPost] = []
    var postUuid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.hideKeyboardWhenTappedAround()
        Design.shared.setBackground(view: view)
        sessionTableView.delegate = self
        sessionTableView.dataSource = self
        
        var vc = RecordViewController()
        
        postUuid = vc.currentUuid
        
        
       
        
        
        
        sessionTableView.register(UINib(nibName: "SessionCell", bundle: nil), forCellReuseIdentifier: "customSessionCell")
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPost()
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
    
    func loadPost() {
        guard let user = Auth.auth().currentUser else {return}
        
        let itemRef = self.db.collection("users").document("\(user.uid)").collection("posts")
        itemRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error listnening: \(error)")
            }   else {
                if let snapshot = snapshot {
                    
//                    let description =  snapshot.get("postDescription") as? String
//                    print(description)
//
                    for docs in snapshot.documents {
                        let docs = docs.data()
                        let postD = docs["postDescrition"] as? String ?? "NoDescription Available"
                        let postA = GetPost(postDescrition: postD)
                        self.documentArrray.append(postA)
                    }
//                    if let data = snapshot.data(){
//                        let description = data["postDescrition"] as? String ?? ""
//
//                        let newPost = GetPost(postDescrition: description)
//                        self.documentArrray.append(newPost)
//
//
//                        print("!!!!!!!!!!!! \( description)")
                    } else {
                        print("!!!!! data nil")
                    }
                    //                    for document in snapshot.documentID {
                    //
                    //                    }
                }
            
                print(self.documentArrray.count)
                self.sessionTableView.reloadData()
            }
        }
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentArrray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newpost =  documentArrray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedCell
        cell.addCellData(post:newpost )
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    
    
    
}
