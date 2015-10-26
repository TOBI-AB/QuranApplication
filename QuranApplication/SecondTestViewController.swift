//
//  SecondTestViewController.swift
//  QuranApplication
//
//  Created by GhaffarEtt on 17/10/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class SecondTestViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    private var recitersList = [Reciter]()
    private let mushafMour = "المصاحف المرتلة"
  
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.tabBarItem.title = mushafMour
        self.tableView.transform = CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(self.tableView.frame) + 20)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
      
        queryMushafsType(mushafMour)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let segueIdentifier = segue.identifier as String? where segueIdentifier == "segueFromSecondVC" else {
            return
        }
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        
        guard let sourateViewController = segue.destinationViewController as? SourateViewController else {
            return
        }
        
        sourateViewController.reciter = self.recitersList[indexPath.row]
    }
}


// MARK: - UITableViewDataSource
extension SecondTestViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recitersList.isEmpty ? 0 : self.recitersList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MushafMourCell", forIndexPath: indexPath) as! MushafMourTableViewCell
        
        let reciter = self.recitersList[indexPath.row]
        cell.reciter = reciter
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension SecondTestViewController: UITableViewDelegate {
    
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

// MARK: - Private functions
extension SecondTestViewController {
   
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




















