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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        Design.shared.setBackground(view: view)
        
        db = Firestore.firestore()

        sessionTableView.register(UINib(nibName: "SessionCell", bundle: nil), forCellReuseIdentifier: "customSessionCell")
        
        
        // Do any additional setup after loading the view.
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
        
        let itemRef = self.db.collection("users").document(user.uid).collection("posts")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
                cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = UIColor.lightGray
       return cell
    }
    
   

}
