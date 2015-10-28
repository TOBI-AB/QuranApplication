//
//  Player.swift
//  QuranApplication
//
//  Created by GhaffarEtt on 21/10/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit
import AVFoundation

private var statusContext = 0
class Player: AVPlayer {

    
    var asset: AVAsset?
  
    var observer: NSObject!
    
     init(observer: NSObject, asset: AVAsset) {
        super.init()

        self.observer = observer
        self.asset = asset
        self.addObserver(observer, forKeyPath: "status", options: [.Initial, .New], context: &statusContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        print("observ")
        
        if keyPath == "status" {
        
        let newStatus: AVPlayerItemStatus
        
        // TODO:  Correct this section
        if let newStatusAsNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
        
        newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.integerValue)!
        
        self.play()
        
        // Add Interruption Notification
//        let theSession = AVAudioSession.sharedInstance()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playInterrupt:", name: AVAudioSessionInterruptionNotification, object: theSession)
        
        // Handle Background Mode
        //playAudioInBackground()
        
        } else {
        newStatus = .Unknown
        }
        
        if newStatus == .Failed {
        print(self.currentItem?.error?.localizedDescription)
        }
        }
        
        
        /*
        // Handle Interruption Notification
        func playInterrupt(notification: NSNotification) {
        if notification.name == AVAudioSessionInterruptionNotification && notification.userInfo != nil {
        let info = notification.userInfo!
        var intValue: UInt = 0
        
        guard let interruptionTypeKey = info[AVAudioSessionInterruptionTypeKey] as? NSValue else {
        return
        }
        
        interruptionTypeKey.getValue(&intValue)
        if let type = AVAudioSessionInterruptionType(rawValue: intValue) {
        switch type {
        case .Began:
        player.pause()
        case .Ended:
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "resumeNow:", userInfo: nil, repeats: false)
        }
        }
        }
        }
        
        // Resume Audio Session
        func resumeNow(timer : NSTimer) {
        player.play()
        }
        
        // Handle Background Mode
        func playAudioInBackground() {
        do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        do {
        try AVAudioSession.sharedInstance().setActive(true)
        
        } catch let error as NSError {
        print("Active Error: \(error.localizedDescription)")
        }
        } catch let error as NSError {
        print("Session Error: \(error.localizedDescription)")
        }
        }

        
        */
    }
    
    deinit {
        self.removeObserver(self.observer, forKeyPath: "status", context: &statusContext)
    }
}
