//
//  CameraViewController.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-07.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButtonImage: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    var sessionRecord = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("Accepted")
            }
        }
        
        
    }
    
    @IBAction func recordButton(_ sender: UIButton) {
        if audioRecorder == nil {
            let fileName = getDirectory().appendingPathComponent("\(sessionRecord).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start Audio Recording
            do {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                recordingLabel.text = "Press To Stop Session"
                
                let image = UIImage(named: "icons8-stop-96")
                recordButtonImage.setImage(image, for: .normal)
                
            }   catch {
                displayAlert(title: "Ops!", message: "Recording Failed")
            }
        }   else {
            //Stopping Audio Recording
            audioRecorder.stop()
            audioRecorder = nil
            
            recordingLabel.text = "Please Wait..."
            
            let image = UIImage(named: "icons8-record-96")
            recordButtonImage.setImage(image, for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline:.now() + 2.0, execute: {
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
    
    
    
}
