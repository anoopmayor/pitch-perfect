//
//  RecordSoundsViewController.swift
//  PerfectPitch
//
//  Created by Jericho on 3/9/15.
//  Copyright (c) 2015 Jericho. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //declare buttons & labels
    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    //global variable
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //change the back button in the child screen to Re-Record to provide meaningful info
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Re-Record", style:.Plain, target:nil, action:nil)
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //ensure that only record button & tapToRecord label are displayed
        stopButton.hidden=true
        recordButton.enabled=true
        tapToRecord.hidden = false
    }

    
    
    
    @IBAction func recordAudio(sender: UIButton) {
        //following buttons and labels are hidden & enabled when recordButton is pressed
        stopButton.hidden=false
        recordingInProgress.hidden=false
        recordButton.enabled=false
        tapToRecord.hidden = true
        
        //record the users voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
            if (flag) {
                        //initialize the objec
                recordedAudio = RecordedAudio(filePathUrl:recorder.url, title: recorder.url.lastPathComponent!)
                        //set the attributes of the object
                            recordedAudio.filePathUrl = recorder.url
                            recordedAudio.title = recorder.url.lastPathComponent
                        //Move to the next scene aka perform segue
                           self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)

            }
            else {
                            println("recording was not successful")
                            recordButton.enabled = true
                            stopButton.hidden = true
                            tapToRecord.hidden = false
            }
            
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if (segue.identifier == "stopRecording") {
                                let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
                                let data = sender as RecordedAudio
                                playSoundsVC.receivedAudio = data
            }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        //hide the recording-in-progress label
        recordingInProgress.hidden=true
        
        //stop recording the users voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }

    
}

