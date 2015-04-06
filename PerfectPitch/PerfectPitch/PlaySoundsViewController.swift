//
//  PlaySoundsViewController.swift
//  PerfectPitch
//
//  Created by Jericho on 3/24/15.
//  Copyright (c) 2015 Jericho. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //declare variables
    var audioPlayer: AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!
    
    var receivedAudio: RecordedAudio!
    var audioFile:AVAudioFile!
    
    var audioEngine: AVAudioEngine!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        //create additional copy for the echo feature of the app
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer2.enableRate = true

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StopAudio(sender: UIButton) {
        
        //stop all audio
        audioPlayer.stop()
        audioPlayer2.stop()

        audioEngine.stop()
        audioEngine.reset()

    }
    
    
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        //call function to adjust pitch
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func PlayChipmunkAudio(sender: UIButton) {
       //call function to adjust pitch
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        //stop audio before playing with variable pitch
        audioPlayer.stop()
        audioPlayer2.stop()

        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func PlayAudioEcho(sender: UIButton) {
        //stop audio before playing echo
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //first play 1st copy of audio
        audioPlayer.rate = 1.0
        audioPlayer.currentTime = 0;
        audioPlayer.play()
        
        //play 2nd copy of audio after .1sec and 80% less volume than the 1st copy
        let delay:NSTimeInterval = 0.1
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
        
    }
    
    
    @IBAction func PlayFastAudio(sender: UIButton) {
        //call func to change audio rate with 1.5 value
        ChangeAudioRate(1.5)
    }
    
    @IBAction func PlaySlowAudio(sender: UIButton) {
        //call func to change audio rate with .5 value
        ChangeAudioRate(0.5)
    }
    
    func ChangeAudioRate (ARate: Float) {
        //stop audio before changing rate & playing audio
        audioPlayer.stop()
        audioPlayer2.stop()
        
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = ARate
        audioPlayer.currentTime = 0.0 //start at beginning
        audioPlayer.play()
    }

}
