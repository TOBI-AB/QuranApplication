//
//  Surat.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 18/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit


struct Sourate {
    
    var url = ""
    var title = ""
    
    static func parseJSONIntorSouratesList(json : Array<NSDictionary>) -> [Sourate]? {
        
        var sourates = [Sourate]()
        
        for jsonRepo in json {
            var sourat = Sourate()
            
            guard let souratUrl = jsonRepo["api_url"] as? String,
                reciterTitle = jsonRepo["title"] as? String else
            {
                return nil
            }
            
            sourat.url = souratUrl
            sourat.title = reciterTitle
            
            sourates.append(sourat)
        }
        
        return sourates
    }
}

