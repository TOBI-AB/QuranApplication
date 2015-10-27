//
//  SouratePlayerViewController.swift
//  QuranApplication
//
//  Created by GhaffarEtt on 24/10/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit
import AVFoundation

private var playerViewControllerKVOContext = 0

class SouratePlayerViewController: UIViewController {
    
    // MARK: - Statics Constants
    static let assetKeysRequiredToPlay = ["duration", "playable", "hasProtectedContent"]

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleReciterLabel: UILabel!
    @IBOutlet weak var titleSourateLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    // MARK: - Properties
    var currentSourate: Sourate? {
        didSet {
            guard let sourate = currentSourate as Sourate? else {
                fatalError()
            }
            
            getCurrentSourate(sourate.url)
        }
    }
    
    var reciter: Reciter?
    
    private var player = AVPlayer()
    
    private var audioFileUrlString: String? {
        didSet {
            guard let newAudioFileUrl = audioFileUrlString as String?, escapedSearchTerm = newAudioFileUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) as String? else {
                return
            }
            
            guard let audioFileUrl = NSURL(string: escapedSearchTerm) as NSURL? else {
                return
            }
            
            let asset = AVAsset(URL: audioFileUrl)
            
            asynchronouslyLoadURLAsset(asset)
        }
    }
    
    private var playerItem: AVPlayerItem? = nil {
        didSet {
            
            guard let newPlayerItem = self.playerItem as AVPlayerItem? else {
                return
            }
            self.player.replaceCurrentItemWithPlayerItem(newPlayerItem)
        }
    }
    
    private var timeObserverToken: AnyObject?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyValuesObserving()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        keyValuesObserving()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeKeyValuesObserving()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Deinit
    deinit {
        removeKeyValuesObserving()
    }
}


// MARK: - Private functions
extension SouratePlayerViewController {
    
    // MARK: - Get Current Sourate
    func getCurrentSourate(urlSourate: String) {
        do {
            try APIController.queryGlobalResults(urlSourate, callback: { (jsonResult) -> Void in
                
                guard let jsonResult = jsonResult as? NSDictionary, titleSourate = jsonResult["title"] as? String, audioFileUrl = jsonResult["url"] as? String else {
                    fatalError()
                }
                
                self.audioFileUrlString = audioFileUrl
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.titleSourateLabel.text = titleSourate
                    
                    if let currentReciter = self.reciter as Reciter?  {
                        self.titleReciterLabel.text = currentReciter.title
                    } else {
                        print("Invalid Recitor")
                    }
                })
                
            })
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - loadValuesAsynchronouslyForKeysForAsset
    func asynchronouslyLoadURLAsset(asset: AVAsset) {
        
        asset.loadValuesAsynchronouslyForKeys(SouratePlayerViewController.assetKeysRequiredToPlay) { () -> Void in
          
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                SouratePlayerViewController.assetKeysRequiredToPlay.forEach({ (key) -> () in
                
                    var error: NSError?

                    if asset.statusOfValueForKey(key, error: &error) == AVKeyValueStatus.Failed {
                        
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                    }
                })
                
                guard asset.playable || !asset.hasProtectedContent else {
                    return
                }
                    
                self.playerItem = AVPlayerItem(asset: asset)
            })
        }
    }
    
    // MARK: - Add KVO
    func keyValuesObserving() {
        
        player.addObserver(self, forKeyPath: "status", options: [.New, .Initial], context: &playerViewControllerKVOContext)
        player.addObserver(self, forKeyPath: "currentItem.duration", options: [.New, .Initial], context: &playerViewControllerKVOContext)
        
        let interval = CMTime(value: 1, timescale: 1)
        timeObserverToken = self.player.addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue(), usingBlock: { [weak self](time) -> Void in
            
            self?.timeSlider.value = Float(CMTimeGetSeconds(time))
            })

    }
    
    // MARK: - Remove KOV
    func removeKeyValuesObserving() {
        
        self.player.pause()
        self.playerItem = nil

        player.removeObserver(self, forKeyPath: "status", context: &playerViewControllerKVOContext)
        player.removeObserver(self, forKeyPath: "currentItem.duration", context: &playerViewControllerKVOContext)
        
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}

// MARK: - KVO
extension SouratePlayerViewController {
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard context == &playerViewControllerKVOContext else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        
        switch keyPath {
     
            // Observe Player Status
        case .Some("status"):
            let newStatus: AVPlayerItemStatus
            
            if let newStatusNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusNumber.integerValue)!
                player.play()
                
            } else {
                newStatus = .Unknown
            }
            
            if newStatus == .Failed {
                fatalError()
            }
        
            // Observe Player Duration
        case .Some("currentItem.duration"):
            // Update timeSlider and enable/disable controls when duration > 0.0
            /*
                Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
                `player.currentItem` is nil.
            */
            
            let newDuration: CMTime
            if let newDurationValue = change?[NSKeyValueChangeNewKey] as? NSValue {
                newDuration = newDurationValue.CMTimeValue
            } else {
                newDuration = kCMTimeZero
            }
            
            let hasValidDuration = newDuration.isNumeric && (newDuration.value != 0)
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            
            timeSlider.enabled = hasValidDuration
            timeSlider.maximumValue = Float(newDurationSeconds)
            timeSlider.value = hasValidDuration ? Float(CMTimeGetSeconds(player.currentTime())) : 0.0
            
            _ = Int(trunc(newDurationSeconds / 60))
            
        default:
            return
        }
        
    }
}



























    