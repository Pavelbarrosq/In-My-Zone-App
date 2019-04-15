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
import FirebaseStorage
import FirebaseAuth

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var db: Firestore!
    var auth: Auth!
    var storage: Storage!
    var storageRef: StorageReference!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var audioUrl: String?
    var url: URL!
    var urlString = ""
    
    var currentUuid: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        Design.shared.setButton(button: shareButton)
        Design.shared.setBackground(view: view)
        
        db = Firestore.firestore()
        auth = Auth.auth()
        storage = Storage.storage()
        
        url = getFileURL()
        
        print("URL = \(url)")
        
        
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("Accepted")
            }
        }
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        
        let uuid = NSUUID().uuidString
        guard let user = auth.currentUser else {return}
        
        let soundRef = storage.reference().child("audio/\(uuid)") // .m4a
        print("current UUID is : \(uuid)")
        let uploadTask = soundRef.putFile(from: url , metadata: nil) {
            metadata, error in
            if let metadata = metadata {
                
                    self.removeAudioItem()
//                    let url = self.getFileURL()
//                    try FileManager.default.removeItem(at: url)
                    
                    
                    soundRef.downloadURL { (url, error) in
                        if error != nil {
                            print("An error occured: \(error)")
                        }   else {
                            self.audioUrl = url?.absoluteString
                            print("Succes retreving audio URL")
                            
                            print("Current UUID for record is !!!!!!!!!: \(uuid)")
                            
                            let itemref = self.db.collection("posts")
                            itemref.addDocument(data: ["postDescription": self.descriptionTextView.text,
                                                       "audioUrl": self.audioUrl!,
                                                       "userId": user.uid   ]) { (error) in
                                                        if error != nil {
                                                            print("Error while adding doc: \(error)")
                                                        }
                                                        self.descriptionTextView.text = nil
                                                        self.tabBarController?.selectedIndex = 0
                            }
                        }
                    }
                
            } else {
                print("error")
            }
        }
    }
    
    func removeAudioItem() {
        do {
            let url = self.getFileURL()
            try FileManager.default.removeItem(at: url)
            print("Success removing item from url")
        } catch {
            print("error removing item from url")
        }
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        
        if audioRecorder == nil {
            let image = UIImage(named: "stop-96")
            recordButton.setImage(image, for: .normal)
            
            let fileName = getFileURL()
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start recording
            do {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
            }   catch {
                displayAlert(title: "Ops!", message: "Recording failed")
            }
        }   else {
            // Stopping audio Recorder
            audioRecorder.stop()
            
            let image = UIImage(named: "record-96")
            recordButton.setImage(image, for: .normal)
            
            audioRecorder = nil
            
          
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        urlString = path.absoluteString
        url = path.absoluteURL
        return path as URL
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
}
