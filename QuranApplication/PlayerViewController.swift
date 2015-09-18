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
    private let apiController = APIController.init()


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


extension PlayerViewController {
    
    func fetchSuratsForURL(urlString urlString: String) {
        
        apiController.queryGlobalResults(urlString) { (jsonResult) -> Void in
            
            if let jsonResult = jsonResult as? Dictionary, suratsArray = jsonResult["attachments"] as? arrayDictionary {
                
                suratsArray.forEach({ (surat) -> () in
                    print(surat["title"])
                })
            }
            
        
        }
    }
}




























