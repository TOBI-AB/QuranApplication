//
//  ThirdTestViewController.swift
//  QuranApplication
//
//  Created by GhaffarEtt on 28/10/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class ThirdTestViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var searchController: UISearchController!
    private var recitersList = [Reciter]()
    var searchResults = [Reciter]()
    private let mushafMouaalam = "مصاحف مترجمة"

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
       updateView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        queryMushafsType(mushafMouaalam)
        
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        guard let segueIdentifier = segue.identifier as String? where segueIdentifier == "segueFromThirdVC" else {
            return
        }
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        
        guard let sourateViewController = segue.destinationViewController as? SourateViewController else {
            return
        }
        
        sourateViewController.reciter = (self.searchController.active) ? self.searchResults[indexPath.row] : self.recitersList[indexPath.row]
    }
}


// MARK: - UITableViewDataSource
extension ThirdTestViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.searchController.active) ? self.searchResults.count : self.recitersList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MushafMouaalmCell", forIndexPath: indexPath) as! MushafMouaTableViewCell
        
        let reciter = (self.searchController.active) ? self.searchResults[indexPath.row] : self.recitersList[indexPath.row]
       
        cell.reciter = reciter
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ThirdTestViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - Handle SearchController
extension ThirdTestViewController: UISearchResultsUpdating {
   
    
    // MARK: - Udpate TableView
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text as String? else {
            return
        }
        
        filterContentForSearchText(searchText)
        self.tableView.reloadData()
    }
}

// MARK: - Private functions
extension ThirdTestViewController {
    
    func updateView() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.sizeToFit()
        self.definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.placeholder = ""
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.tableView.translateToBottom()
        let backgroundView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = backgroundView
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Filter contents
    func filterContentForSearchText(searchText: String) {
     
        self.searchResults = self.recitersList.filter({ (reciter: Reciter) -> Bool in
            
            let ttr =  reciter.title.containsString(searchText)
            print(ttr)
            return ttr
        })
        
        
    }
    
    // MARK: - Query A Specified Mushfa
    func queryMushafsType(mushafType: String) {
        
        APIController.queryDesiredMushaf(mushafType) { (reciters) -> Void in
            
            guard let reciters = reciters as [Reciter]? else {
                return
            }
            
            self.recitersList = reciters
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                
                UIView.animateWithDuration(1.25, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: { () -> Void in
                    
                    self.tableView.transform = CGAffineTransformIdentity
                    
                    }, completion: nil)
            })
        }
        
    }
}






















































