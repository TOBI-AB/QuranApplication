//
//  SouratePlayerViewController.swift
//  QuranApplication
//
//  Created by GhaffarEtt on 24/10/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class SouratePlayerViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    
    
    // MARK: - Properties
    var currentSourate: Sourate? {
        didSet {
            guard let sourate = currentSourate as Sourate? else {
                fatalError()
            }
            
            getCurrentSourate(sourate.url)
        }
    }
    
    var currentReciter: Reciter?
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


// MARK: - Private functions
extension SouratePlayerViewController {
    func getCurrentSourate(urlSourate: String) {
        do {
            try APIController.queryGlobalResults(urlSourate, callback: { (jsonResult) -> Void in
                
                guard let jsonResult = jsonResult as? NSDictionary else {
                    fatalError()
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    <#code#>
                })
                
            })
        } catch {
            print(error)
        }
    }
}



































    