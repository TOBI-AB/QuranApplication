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
        
        let api =  APIController.init()
        
        api.queryGlobalResults { (jsonResult) -> Void in
            
            guard let jsonResult = jsonResult as? [NSDictionary] else {
                return
            }
            
            
            
            print(jsonResult[0])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

