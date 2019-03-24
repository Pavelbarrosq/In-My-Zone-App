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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        Design.shared.setBackground(view: view)

        sessionTableView.register(UINib(nibName: "SessionCell", bundle: nil), forCellReuseIdentifier: "customSessionCell")
        
        configureTableView()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customSessionCell", for: indexPath) as! CustomSessionCell
        let descriptionArray = ["First Audio", "Second saasdasdasdasdasdasddasdlkhasdlkahjdlkajhsdlkhjsadfölhkasdflöhsefölkjhsadfölkhsdfölaskhdfölkhsadfölkhsadfölkjsadfölkjasdfölkjasdfölkjasdfölkjasdfölkjsadföljAudio", "Third Audio"]
        
        cell.descriptionLabel.text = descriptionArray[indexPath.row]
        
        return cell
    }
    
    func configureTableView() {
        
        sessionTableView.rowHeight = UITableView.automaticDimension
        sessionTableView.estimatedRowHeight = 150.0
        
    }

}
