//
//  PlayerViewController.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 18/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    typealias Dictionary = [String: AnyObject]
    typealias arrayDictionary = [Dictionary]
   
    var reciter: Reciter!
    private var suratsArray = [Surat]()
    private var player: AVPlayer!
    private let apiController = APIController.init()
    
    
    struct Storyboard {
        static let cellIdentifier = "suratCell"
    }
    
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = reciter.title
        
        guard let api_url = reciter.api_url as String? else {
            return
        }
        
        fetchSuratsForURL(urlString: api_url)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Private Functions

extension PlayerViewController {
    
    // Fetch Surats
    func fetchSuratsForURL(urlString urlString: String) {
        
        apiController.queryGlobalResults(urlString) { (jsonResult) -> Void in
            
            if let jsonResult = jsonResult as? Dictionary, suratsArray = jsonResult["attachments"] as? arrayDictionary {
                
                suratsArray.forEach({ (surat) -> () in
                    
                    guard let title = surat["title"] as? String else {
                        return
                    }
                    
                    guard let suratURL = surat["url"] as? String else {
                        return
                    }
                    
                    let surat = Surat(title: title, api_url: suratURL)
                    self.suratsArray.append(surat)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                })
            }
        }
    }
    
    // Play Surat At Selected Row
    func playSuratAtIndexPath(indexPath indexPath: NSIndexPath) {
        
        let surat = self.suratsArray[indexPath.row]
        print(surat.api_url)
    }

}


// MARK: - UITableViewDataSource

extension PlayerViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suratsArray.isEmpty ? 0 : self.suratsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellIdentifier, forIndexPath: indexPath) as! SecondTableViewCell
        
        cell.surat = self.suratsArray[indexPath.row]
        
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension PlayerViewController: UITableViewDelegate {
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        playSuratAtIndexPath(indexPath: indexPath)
    }
}






















