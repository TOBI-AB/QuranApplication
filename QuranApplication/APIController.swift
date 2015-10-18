//
//  APIController.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 17/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

typealias jsonResult = AnyObject

class APIController: NSObject {
    
    enum APIControllerError: ErrorType {

        case CouldNotFetchingData
    }
    
    
    private func queryGlobalResults(urlString: String, callback: (jsonResult) -> Void) throws {
        
        guard let url =  NSURL(string: urlString) else {
            
            return
        }
        
        guard let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            guard let serverResponse = response as? NSHTTPURLResponse where serverResponse.statusCode == 200 else {
                print("Error Server: \(error!.localizedDescription)")
                return
            }
            
            guard let dataFromServer = data as NSData? else {
                print("Error NO Data:\(error!.localizedDescription)")
                return
            }
            
            do {
                
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataFromServer, options: NSJSONReadingOptions.AllowFragments)
                callback(jsonResult)
        
            } catch let errorParsingDataToJSON as NSError {
                print(errorParsingDataToJSON.localizedDescription)
            }
        
        }) as NSURLSessionDataTask? else {
            throw APIControllerError.CouldNotFetchingData
        }
        
        task.resume()
    }
    
    class func fetchingDataFrom(urlString: String ,callBack: (jsonResult) -> Void) {

        do {
            try APIController().queryGlobalResults(urlString, callback: { (jsonResult) -> Void in
                callBack(jsonResult)
            })
        } catch APIController.APIControllerError.CouldNotFetchingData {
            print("CouldNotFetchingData")
        } catch {
            print(error)
        }
    }
}
