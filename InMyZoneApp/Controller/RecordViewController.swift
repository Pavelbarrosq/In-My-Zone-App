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

class RecordViewController: UIViewController {// , AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
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
    
    var recording = false
    
    var currentUuid: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        descriptionTextView.layer.cornerRadius = 20.0
        Design.shared.setBackground(view: view)
        Design.shared.adjustUITextViewHeight(arg: descriptionTextView)
        
        db = Firestore.firestore()
        auth = Auth.auth()
        storage = Storage.storage()
        
        let fileName = getFileURL()
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.prepareToRecord()
        }   catch {
            displayAlert(title: "Ops!", message: "Recording failed")
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("Accepted")
            }
        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        audioRecorder.record()
        audioRecorder.stop()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
                do {
                    let url = getFileURL()
                    try FileManager.default.removeItem(at: url)
                    print("Success removing item from url")
                } catch {
                    print("error removing item from url")
                }
    }
    @IBAction func shareBarButtonAction(_ sender: UIBarButtonItem) {
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
                                                   "userId": user.uid,
                                                   "timestamp": FieldValue.serverTimestamp()]) { (error) in
                                                    if error != nil {
                                                        print("Error while adding doc: \(error)")
                                                    }
                                                    self.addPostToProfile()
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
    
    func addPostToProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = db.collection("users").document(uid).collection("userposts")
        ref.addDocument(data: ["postDescription": self.descriptionTextView.text,
                               "audioUrl": self.audioUrl!,
                               "userId": uid,
                               "timestamp": FieldValue.serverTimestamp()])
        
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
        print("start record ")
        
        if !recording { //audioRecorder == nil {
            recording = true
            print("start record 2 ")
            let image = UIImage(named: "stop-96")
            recordButton.setImage(image, for: .normal)

          
            // Start recording
           // do {
          //      audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
              //  audioRecorder.delegate = self
                audioRecorder.record()
                print("recording")
//            }   catch {
//                displayAlert(title: "Ops!", message: "Recording failed")
//            }
        }   else {
            // Stopping audio Recorder
            recording = false
            audioRecorder.stop()
            
            let image = UIImage(named: "record-96")
            recordButton.setImage(image, for: .normal)
            
          //  audioRecorder = nil
            
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
//            } catch let error as NSError {
//                print("Error: \(error.localizedDescription)")
//            }
//            audioPlayer.prepareToPlay()
//            audioPlayer.volume = 10.0
//            audioPlayer.play()
//            print("url String: \(String(describing: urlString))")
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
