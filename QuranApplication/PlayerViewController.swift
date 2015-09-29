//
//  PlayerViewController.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 18/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    typealias Dictionary = [String: AnyObject]
    typealias arrayDictionary = [Dictionary]
   
    var reciter: Reciter!
    var suratsArray = [Surat]()
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

// MARK: -
// MARK: == Private Functions
// MARK: -

extension PlayerViewController {
    
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
}


// MARK: -
// MARK: == UITableViewDataSource
// MARK: -

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

























