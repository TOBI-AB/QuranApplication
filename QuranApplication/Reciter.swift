//
//  MushafReciter.swift
//  QuranApplication
//
//  Created by GhaffarEtt on 21/10/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

struct Reciter {
    
    var url = ""
    var title = ""
    
    static func parseJSONIntorReciters(json : Array<NSDictionary>) -> [Reciter]? {
        
        var reciters = [Reciter]()
        
        for jsonRepo in json {
            var reciter = Reciter()
            
            guard let reciterUrl = jsonRepo["api_url"] as? String,
                      reciterTitle = jsonRepo["title"] as? String else
            {
                return nil
            }
            
            reciter.url = reciterUrl
            reciter.title = reciterTitle
           
            reciters.append(reciter)
        }
        
        return reciters
    }

}
