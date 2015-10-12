//
//  FirstViewController.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 17/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    // MARK: -
    // MARK: == Properties ==
    // MARK: -
    
    private var recitersArray = [Reciter]()
    private let api =  APIController.init()
    
    struct URLS {
        static let globalURL   = "https://api.islamhouse.com/v1/JD9dL72GG4vVy81Y/quran/get-categories/ar/json"
        static let recitersURL = "https://api.islamhouse.com/v1/JD9dL72GG4vVy81Y/quran/get-category/364765/ar/json/"
    }
    
    struct Storyboard {
        static let cellIdentifier = "reciterCell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -
    // MARK: == View Life Cycle ==
    // MARK: -

    @IBAction func showPlayerController(sender: UIBarButtonItem) {
        
        //performSegueWithIdentifier("showPlayerViewController", sender: self)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let playerVc = storyBoard.instantiateViewControllerWithIdentifier("PlayerVC")
        showViewController(playerVc, sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tabBarItem.title = "المصاحف المجودة"
        
        fetchGlobalResults()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? FirstSectionCell, indexPath = tableView.indexPathForCell(cell) as NSIndexPath? where segue.identifier == "segueFromFirstSection" {
            
            if let souratesViewController = segue.destinationViewController as? SouratesViewController {
                souratesViewController.reciter = self.recitersArray[indexPath.row]
            }
        }
    }
    
//    @IBAction func cancelToRecitersViewController(segue: UIStoryboardSegue) {
//        
//    }
}


// MARk: -
// MARK: == Privates Function ==
// MARk: -

extension FirstViewController {
    
    func fetchGlobalResults() {
       
        api.queryGlobalResults(URLS.globalURL) {[unowned self] (jsonResult) -> Void in
            
            guard let jsonResult = jsonResult as? [NSDictionary] else {
                return
            }
            
            jsonResult.forEach({ (item) -> () in
                
                guard let title = item["title"] as? String where title == "المصاحف المجودة" else {
                    return
                }
                
                guard let urlString = item["api_url"] as? String else {
                    return
                }
                
                self.fetchRecitersFor(urlString: urlString)
            })
        }
    }
   
    
    func fetchRecitersFor(urlString urlString: String) {
        
        api.queryGlobalResults(URLS.recitersURL) {[unowned self] (jsonResult) -> Void in
            
            guard let jsonResult = jsonResult as? [String: AnyObject],
                      sectionTitle = jsonResult["title"] as? String,
                      recitationsArray = jsonResult["recitations"] as? [NSDictionary] else {
               
                        return
            }
            
            
            // Query Reciters List
            
            recitationsArray.forEach({ (reciter) -> () in
                
                guard let reciterTitle = reciter["title"] as? String, reciterUrl = reciter["api_url"] as? String else {
                    return
                }
                
                let reciter = Reciter(title: reciterTitle, api_url: reciterUrl)
                self.recitersArray.append(reciter)
                
                
                // Setup NavigationItem & TableView
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationItem.title = sectionTitle
                    self.tableView.reloadData()
                })
                
            })
        }
    }
}


// MARk: -
// MARK: == UITableViewDataSource ==
// MARk: -

extension FirstViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.recitersArray.isEmpty ? 0 : self.recitersArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellIdentifier, forIndexPath: indexPath) as! FirstSectionCell
        
        cell.reciter = self.recitersArray[indexPath.row]
        
        return cell
    }
}

// MARk: -
// MARK: == UITableViewDelegate ==
// MARk: -

extension FirstViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
















