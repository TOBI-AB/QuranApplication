//
//  APIController.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 17/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

typealias jsonResult = AnyObject

protocol SouratesProtocol {
    func didReceiveAPIResults(results: Array<NSDictionary>)
}


class APIController: NSObject {
    
    enum APIControllerError: ErrorType {
        case CouldNotFetchingData
    }
    
    var delegate: SouratesProtocol?
    
    private var globaMushafslUrlString = "https://api.islamhouse.com/v1/JD9dL72GG4vVy81Y/quran/get-categories/ar/json"
    
    // MARK: - Properties
    let session: NSURLSession
    
    override init() {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 60.0
        configuration.timeoutIntervalForResource = 60.0
        configuration.requestCachePolicy = .ReturnCacheDataElseLoad
        
        self.session = NSURLSession(configuration: configuration)
    }
   
    // MARK: - Query Global Mushaf Data
    static func queryGlobalResults(urlString: String, callback: (jsonResult) -> Void) throws {
        
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
    
    
    //MARK: - Query Desired Mushaf Data
    static func queryDesiredMushaf(desiredMushafType: String,  callba: ([Reciter]? -> Void)) {
        
        do {
            try APIController.queryGlobalResults(APIController().globaMushafslUrlString, callback: { (mushafsArray) -> Void in
                guard let mushafsArray = mushafsArray as? Array<NSDictionary> else {
                    return
                }
                
                for mushaf in mushafsArray where (mushaf["title"] as? String) == desiredMushafType {
                 
                    guard let desiredMushafUrl = mushaf["api_url"] as? String else {
                        return
                    }
                    
                    do {
                        try APIController.queryGlobalResults(desiredMushafUrl, callback: { (desiredMushaf) -> Void in
                            guard let desiredMushaf = desiredMushaf as? NSDictionary else {
                                return
                            }
                            
                            guard let recitationsArray = desiredMushaf["recitations"] as? Array<NSDictionary> else {
                                return
                            }
                            
                            callba(Reciter.parseJSONIntorReciters(recitationsArray))

                        })
                        
                    } catch APIController.APIControllerError.CouldNotFetchingData {
                        print("Fetching Desired Mushaf Data Error")
                    }catch {
                        print(error)
                    }
                }
            })
        
        
        } catch APIController.APIControllerError.CouldNotFetchingData {
            print("Fetching Global Mushaf Data Error")
        }catch {
            print(error)
        }
    }
}







































