//
//  SecondViewController.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 17/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - KVO context
private var playerViewControllerKVOContext = 0


class PlayerViewController: UIViewController {
    
    var sourate: Surat!
    
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
        guard let currentItem = player.currentItem else { return 0.0 }
        
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
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let sourate = sourate as Surat?, urlString = sourate.api_url as String?, let sourateUrl = NSURL(string: urlString) else {
            return
        }
       
        player.addObserver(self, forKeyPath: "status", options: [.New, .Initial], context: &playerViewControllerKVOContext)
        
        asset = AVURLAsset(URL: sourateUrl)
        
        // TODO: Time Slider
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
        }
    }
    
    // MARK: -DEINIT
    deinit {
    
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        player.pause()
        
        if player.currentItem != nil {
            player.removeObserver(self, forKeyPath: "status", context: &playerViewControllerKVOContext)
        } else {

            return
        }
    }
}


// MARK: - Error Handling
extension PlayerViewController {
    
    func handleErrorWithMessage(message: String?, error: NSError? = nil) {
        
        let alertTitle = NSLocalizedString("alert.error.title", comment: "Alert title for errors")
        let defaultAlertMessage = NSLocalizedString("error.default.description", comment: "Default error message when no NSError provided")
        
        let alert = UIAlertController(title: alertTitle, message: message == nil ? defaultAlertMessage : alertTitle, preferredStyle: .Alert)
        
        let alertActionTitle = NSLocalizedString("alert.error.actions.OK", comment: "OK on error alert")
        
        let alertAction = UIAlertAction(title: alertActionTitle, style: .Default, handler: nil)
        
        alert.addAction(alertAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}


// MARK: - Player Observing
extension PlayerViewController {
   
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &playerViewControllerKVOContext else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        
        if keyPath == "status" {
            
            // Display an error if status becomes `.Failed`.
            
            /*
            Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
            `player.currentItem` is nil.
            */
            let newStatus: AVPlayerItemStatus
            if let newStatusAsNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.integerValue)!
                player.play()
            } else {
                newStatus = .Unknown
            }
            
            if newStatus == .Failed {
                print(player.currentItem?.error?.localizedDescription)
            }
        }
    }
}
































































