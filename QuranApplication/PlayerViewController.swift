//
//  SecondViewController.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 17/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

// MARK: - KVO context
private var playerViewControllerKVOContext = 0


class PlayerViewController: UIViewController {
    
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    
    var sourate: Sourate!

    
    // Attempt load and test these asset keys before playing.
    static let assetKeysRequiredToPlay = ["playable", "hasProtectedContent"]
    
    var player = AVPlayer()

    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seekToTime(newTime)
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else {
            return 0.0
        }
        
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var rate: Float {
        get {
            return player.rate
        }
        set {
            player.rate = newValue
        }
    }
    
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            asynchronouslyLoadURLAsset(newAsset)
        }
    }
    
    /*
        A token obtained from calling `player`'s `addPeriodicTimeObserverForInterval(_:queue:usingBlock:)`
    method.
    */
    private var timeObserverToken: AnyObject?
    private var playerItem: AVPlayerItem? = nil {
        didSet {
            player.replaceCurrentItemWithPlayerItem(self.playerItem)
        }
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let sourate = sourate as Sourate?, urlString = sourate.url as String?, let sourateUrl = NSURL(string: urlString) else {
            return
        }
       
        asset = AVURLAsset(URL: sourateUrl)
        player.addObserver(self, forKeyPath: "status", options: [.New, .Initial], context: &playerViewControllerKVOContext)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerCurrenItemReachEnd", name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
        
        // Time Observal
        let interval = CMTimeMake(1, 1)
        timeObserverToken = player.addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue(), usingBlock: {[weak self] (time) -> Void in
            
            if  let _self = self {
                
                _self.timeSlider.value = Float(CMTimeGetSeconds(time))
            }
            })
        
//        self.albumLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
//        self.artistLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
//        self.titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
    }

    // MARK: - Remote Controller
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    
    // MARK: - Asset Loading
    func asynchronouslyLoadURLAsset(newAsset: AVURLAsset) {
     
        newAsset.loadValuesAsynchronouslyForKeys(PlayerViewController.assetKeysRequiredToPlay) { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                guard newAsset == self.asset else {
                    return
                }
                
                
                PlayerViewController.assetKeysRequiredToPlay.forEach({ (key) -> () in
                    var error: NSError?
                    
                    if newAsset.statusOfValueForKey(key, error: &error) == .Failed {
                        
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                        return
                    }
                })
                
                
                // We can't play this asset
                if !newAsset.playable || newAsset.hasProtectedContent {
                    let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")
                    
                    self.handleErrorWithMessage(message)
                    return
                }
            })
            
            self.playerItem = AVPlayerItem(asset: newAsset)
            
            // GET Album Metadata
            if let albumMetaData = AVMetadataItem.metadataItemsFromArray(newAsset.commonMetadata, withKey: AVMetadataCommonKeyAlbumName, keySpace: AVMetadataKeySpaceCommon).first as AVMetadataItem?, value = albumMetaData.value as protocol<NSCopying, NSObjectProtocol>?, albumName = String(value) as String?  {

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.albumLabel.text = albumName
                })
            }
            
            // GET Artist Metadata
            if let artistMetaData = AVMetadataItem.metadataItemsFromArray(newAsset.commonMetadata, withKey: AVMetadataCommonKeyArtist, keySpace: AVMetadataKeySpaceCommon).first as AVMetadataItem?, value = artistMetaData.value as protocol<NSCopying, NSObjectProtocol>?, artistName = String(value) as String? {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.artistLabel.text = artistName
                })
            }
            
            
            
            // GET Title Metadata
            if let titleMetaData = AVMetadataItem.metadataItemsFromArray(newAsset.commonMetadata, withKey: AVMetadataCommonKeyTitle, keySpace: AVMetadataKeySpaceCommon).first as AVMetadataItem?, value = titleMetaData.value as protocol<NSCopying, NSObjectProtocol>?, title = String(value) as String?  {
               
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.titleLabel.text = title
                    MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [MPMediaItemPropertyTitle: title]
                })
            }
            
            //getAssetMeteData(asset: Avasset)
            
        }
    }
    
    // MARK: - Time slider Did Change
    @IBAction func timeSliderDidChanged(sender: UISlider) {
        currentTime = Double(sender.value)
    }
    
    // MARK: - DEINIT
    deinit {
    
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        player.pause()
        
        if player.currentItem != nil {
            player.removeObserver(self, forKeyPath: "status", context: &playerViewControllerKVOContext)
            NSNotificationCenter.defaultCenter().removeObserver(self)
        } else {

            return
        }
    }
}



// MARK: - Player Observing & Notifications
extension PlayerViewController {
   
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &playerViewControllerKVOContext else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }

        if keyPath == "status" {
            
            let newStatus: AVPlayerItemStatus
           
            // TODO:  Correct this section
            if let newStatusAsNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
             
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.integerValue)!
                
                player.play()
                
                // Add Interruption Notification
                let theSession = AVAudioSession.sharedInstance()
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "playInterrupt:", name: AVAudioSessionInterruptionNotification, object: theSession)
                
                // Handle Background Mode
                playAudioInBackground()
                
            } else {
                newStatus = .Unknown
            }
            
            if newStatus == .Failed {
                print(player.currentItem?.error?.localizedDescription)
            }
        }
    }
    
    
    // Notification when player reach the end
    func playerCurrenItemReachEnd() {
        navigationController?.popViewControllerAnimated(true)
    }
    
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
}



// MARK: - Pirvate Functions
extension PlayerViewController {
    
    private func handleErrorWithMessage(message: String?, error: NSError? = nil) {
        
        let alertTitle = NSLocalizedString("alert.error.title", comment: "Alert title for errors")
        let defaultAlertMessage = NSLocalizedString("error.default.description", comment: "Default error message when no NSError provided")
        
        let alert = UIAlertController(title: alertTitle, message: message == nil ? defaultAlertMessage : alertTitle, preferredStyle: .Alert)
        
        let alertActionTitle = NSLocalizedString("alert.error.actions.OK", comment: "OK on error alert")
        
        let alertAction = UIAlertAction(title: alertActionTitle, style: .Default, handler: nil)
        
        alert.addAction(alertAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func getAssetMeteData(asset: AVAsset) -> (album: String, artist: String, title: String)? {
        /*
        f let albumMetaData = AVMetadataItem.metadataItemsFromArray(newAsset.commonMetadata, withKey: AVMetadataCommonKeyAlbumName, keySpace: AVMetadataKeySpaceCommon).first as AVMetadataItem?, value = albumMetaData.value as protocol<NSCopying, NSObjectProtocol>?, albumName = String(value) as String?  {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.albumLabel.text = albumName
        })
        }
        
        // GET Artist Metadata
        if let artistMetaData = AVMetadataItem.metadataItemsFromArray(newAsset.commonMetadata, withKey: AVMetadataCommonKeyArtist, keySpace: AVMetadataKeySpaceCommon).first as AVMetadataItem?, value = artistMetaData.value as protocol<NSCopying, NSObjectProtocol>?, artistName = String(value) as String? {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.artistLabel.text = artistName
        })
        }
        
        
        
        // GET Title Metadata
        if let titleMetaData = AVMetadataItem.metadataItemsFromArray(newAsset.commonMetadata, withKey: AVMetadataCommonKeyTitle, keySpace: AVMetadataKeySpaceCommon).first as AVMetadataItem?, value = titleMetaData.value as protocol<NSCopying, NSObjectProtocol>?, title = String(value) as String?  {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.titleLabel.text = title
        })
        }

        
        */
        
        
        return nil
    }
}





























































