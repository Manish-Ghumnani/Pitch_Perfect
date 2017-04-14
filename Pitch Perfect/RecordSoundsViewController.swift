//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Manish Ghumnani on 14/4/17.
//  Copyright © 2017 Manish Ghumnani. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopButton.isEnabled = false
    }


    override func viewWillAppear(_ animated: Bool) {    
        super.viewWillAppear(animated)
    }
    
    @IBAction func startRecording(_ sender: Any) {
        recordLabel.text = "Recording Started!"
        stopButton.isEnabled = true
        startButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        recordLabel.text = "Tap to record!"
        stopButton.isEnabled = false
        startButton.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag)
        {
            print("finished recording!")
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else
        {
            print("Some error occured while saving the audio file!")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording")
        {
            let PlaySoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender! as! URL
            PlaySoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

