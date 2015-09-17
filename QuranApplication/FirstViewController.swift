//
//  FirstViewController.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 17/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    private var reciters = [Reciter]()
    let api =  APIController.init()
    
    struct URLS {
        static let globalURL   = "https://api.islamhouse.com/v1/JD9dL72GG4vVy81Y/quran/get-categories/ar/json"
        static let recitersURL = "https://api.islamhouse.com/v1/JD9dL72GG4vVy81Y/quran/get-category/364765/ar/json/"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tabBarItem.title = "المصاحف المجودة"
        
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
}

// MARk: -
// MARK: == Privates Function ==
// MARk: -

extension FirstViewController {
    
    
    func fetchRecitersFor(urlString urlString: String) {
        
        api.queryGlobalResults(URLS.recitersURL) {[unowned self] (jsonResult) -> Void in
            
            guard let jsonResult = jsonResult as? [String: AnyObject],
                      sectionTitle = jsonResult["title"] as? String,
                      recitationsArray = jsonResult["recitations"] as? [NSDictionary] else {
               
                        return
            }
            
           
            // Set NavigationItem Title
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.navigationItem.title = sectionTitle
            })
            
            
            
            // Query Reciters List
            
            recitationsArray.forEach({ (reciter) -> () in
                
                guard let reciterTitle = reciter["title"] as? String, reciterUrl = reciter["api_url"] as? String else {
                    return
                }
                
                let reciter = Reciter(title: reciterTitle, api_url: reciterUrl)
                self.reciters.append(reciter)
            })
        }
    }
}






















