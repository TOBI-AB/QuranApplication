//
//  TestViewController.swift
//  QuranApplication
//
//  Created by GhaffarEtt on 17/10/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    // MARK: - IBOUtlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var globalUrlString = "https://api.islamhouse.com/v1/JD9dL72GG4vVy81Y/quran/get-categories/ar/json"
    private var recitersArray = [Reciter]()
    
    var urlStringMushafMoujawad: String! {
        didSet {
            fetchMushafMoujawadDataFrom(urlStringMushafMoujawad)
        }
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.tabBarItem.title = "المصاحف المجودة"
        
        let frame = CGRectMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame), 100, 100)
        let label = UILabel(frame: frame)
        label.text = "Loading..."
        label.center = self.view.center
        self.view.addSubview(label)
       
        let backgroundView = UIView(frame: CGRectZero)
        
        self.tableView.tableFooterView = backgroundView
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.transform = CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(self.tableView.frame) + 20)
        
        fetchingGlobalDataFrom(globalUrlString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension TestViewController {
    
    func fetchingGlobalDataFrom(urlString: String) {
        APIController.fetchingDataFrom(urlString) { (globalJsonDict) -> Void in
        
            if let globalJsonDict = globalJsonDict as? Array<NSDictionary> {
                for dict in globalJsonDict where (dict["title"] as? String) == "المصاحف المجودة" {
                    guard let apiUrl = dict["api_url"] as? String else {
                        return
                    }
            
                    self.urlStringMushafMoujawad = apiUrl
                }
            }
        }
    }
    
    func fetchMushafMoujawadDataFrom(urlString: String) {
        APIController.fetchingDataFrom(urlString) { (dictMushafMoujawad) -> Void in
            guard let dictMushafMoujawad = dictMushafMoujawad as? NSDictionary else {
                return
            }
            
            guard let recitationsArray = dictMushafMoujawad["recitations"] as? Array<NSDictionary> else {
                return
            }
            
            recitationsArray.forEach({ (reciterDict) -> () in
                guard let api_url = reciterDict["api_url"] as? String,
                          preparedByDict = reciterDict["prepared_by"] as? Array<NSDictionary>,
                          firstElement = preparedByDict.first as NSDictionary?,
                          title = firstElement["title"] as? String
                          else
                {
                    return
                }
                
                let reciter = Reciter(title: title, api_url: api_url)
                self.recitersArray.append(reciter)
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.tableView.reloadData()
                   
                    UIView.animateWithDuration(1.5, animations: { () -> Void in
                        self.tableView.transform = CGAffineTransformIdentity
                    })
                }
            })
        }
        
    }
}

// MARK: - UITableViewDataSource
extension TestViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recitersArray.isEmpty ? 0 : self.recitersArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MushafMoujCell", forIndexPath: indexPath) as! MushafMoujTableViewCell
        
        let reciter = self.recitersArray[indexPath.row]
        cell.reciter = reciter
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension TestViewController: UITableViewDelegate {
   
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


























