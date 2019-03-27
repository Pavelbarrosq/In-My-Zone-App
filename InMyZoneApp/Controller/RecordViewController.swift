//
//  CameraViewController.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-07.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButtonImage: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var listOfPost: [Post] = []
    
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var currentAudioUrl: String!
    var sessionRecord = "Recorded Audio"
    
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
        
    }
    @IBAction func shareButton(_ sender: UIButton) {

        let post = Post.init(audioURL: currentAudioUrl, postDescription: descriptionTextField.text!)
        
        listOfPost.append(post)
        let db = Firestore.firestore().collection("posts")
        
        for item in listOfPost {
            db.addDocument(data: item.toAny())
        }
        
//        let post = Post.init(audioURL: currentAudioUrl, postDescription: descriptionTextField.text!)
//
//        let db = Firestore.firestore().collection("posts")
//            db.addDocument(data: post.toAny()) { (error) in
//            if error != nil{
//                print("Error when performing add:  ")
//            }   else {
//                print("Succes adding")
//                }
//        }
        
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        listenToSession()
    }
    
    @IBAction func recordButton(_ sender: UIButton) {
        if audioRecorder == nil {
            
            let fileName = getDirectory().appendingPathComponent("\(sessionRecord).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start Audio Recording
            do {
                recordingLabel.text = "Press To Stop Session"
                
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()

                
                let image = UIImage(named: "stop-96")
                recordButtonImage.setImage(image, for: .normal)
                
            }   catch {
                displayAlert(title: "Ops!", message: "Recording Failed")
            }
        }   else {
            //Stopping Audio Recording
            audioRecorder.stop()

            
            currentAudioUrl = "\(audioRecorder.url)"
            print("Current Audio URL: \(currentAudioUrl!)")
            print("Current Audio : \(sessionRecord)")
            
            audioRecorder = nil
            
            let image = UIImage(named: "record-96")
            recordButtonImage.setImage(image, for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline:.now() + 1.0, execute: {
                self.performSegue(withIdentifier:"sessionToEdit",sender: self)
            })
        }
        
        
        
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func listenToSession() {
        
        let path = getDirectory().appendingPathComponent("\(sessionRecord).m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        }   catch {
            
        }
    }
}
