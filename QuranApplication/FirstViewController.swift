//
//  FirstViewController.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 17/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarItem.title = "المصاحف المجودة"
        
        let api =  APIController.init()
        
        api.queryGlobalResults {[unowned self] (jsonResult) -> Void in
            
            guard let jsonResult = jsonResult as? [NSDictionary] else {
                return
            }
            
            jsonResult.forEach({ (item) -> () in
               
                if let title = item["title"] as? String where title == "المصاحف المجودة" {
                    
                    
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

