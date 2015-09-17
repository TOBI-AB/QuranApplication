//
//  APIController.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 17/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

typealias jsonResult = AnyObject


class APIController {
    
    private let session = NSURLSession.sharedSession()
    
    func queryGlobalResults(urlString: String, callback: (jsonResult) -> Void) {
        
        guard let url =  NSURL(string: urlString) else {
            return
        }
        
        let jsonQuery = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            
            guard let response = response as? NSHTTPURLResponse where response.statusCode == 200 else {
                print(error?.localizedDescription)
                return
            }
            
            guard let data = data as NSData? else {
                print(error?.localizedDescription)
                return
            }
            
            do {
                
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                callback(jsonResult)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        }
        
        jsonQuery.resume()
    }
}
