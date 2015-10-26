//
//  SourateViewController.swift
//  QuranApplication
//
//  Created by GhaffarEtt on 22/10/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit



class SourateViewController: UIViewController {
    
    
   
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var souratesList = [Sourate]()

    var reciter: Reciter? {
        didSet {
            guard let newReciter = reciter as Reciter? else {
                return
            }
            
            querySouratesListOfReciter(newReciter)
        }
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.translateToBottom()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard segue.identifier == "showPlayerViewController" else {
            return
        }
        
        guard let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow as NSIndexPath?  else {
            fatalError()
            
        }
        
        guard let currentSourate = self.souratesList[indexPathForSelectedRow.row] as Sourate? else {
            fatalError()
        }
        
        guard let playerViewController = segue.destinationViewController as? SouratePlayerViewController else {
            return
        }
        
       playerViewController.currentSourate = currentSourate
        playerViewController.currentReciter = self.reciter
    }
}


// MARK: - UITableViewDataSource
extension SourateViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.souratesList.isEmpty ? 0 : self.souratesList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SourateCell", forIndexPath: indexPath) as! SourateTableViewCell
        
        let sourate = self.souratesList[indexPath.row]
        cell.sourate = sourate
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SourateViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - Privates Functions
extension SourateViewController {
    
    func getSourateAtIndexPath(callaback:(sourate: Sourate) -> Void) {
        
        guard let indexPath = self.tableView.indexPathForSelectedRow as NSIndexPath? else {
            return
        }
        
        guard let currentSourate = self.souratesList[indexPath.row] as Sourate? else {
            return
        }
        
        callaback(sourate: currentSourate)
    }
    
    
    private func querySouratesListOfReciter(reciter: Reciter) {
       
        do {
            guard let reciterUrl = reciter.url as String? else {
                return
            }
            try APIController.queryGlobalResults(reciterUrl) { (desiredReciterDict) -> Void in
                
                guard let desiredReciterDict = desiredReciterDict as? NSDictionary, desiredReciterTitle = desiredReciterDict["title"] as? String else {
                    return
                }
                
                guard let attachments = desiredReciterDict["attachments"] as? Array<NSDictionary> else {
                    return
                }
                
                guard let souratesList = Sourate.parseJSONIntorSouratesList(attachments) as [Sourate]? else {
                    return
                }
                
                self.souratesList = souratesList
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationItem.title = desiredReciterTitle
                    self.tableView.reloadData()

                    UIView.animateWithDuration(1.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: { () -> Void in
                        self.tableView.transform = CGAffineTransformIdentity

                        }, completion: nil)
                    
                })
            }
        } catch {
            print(error)
        }
        
    }
}























