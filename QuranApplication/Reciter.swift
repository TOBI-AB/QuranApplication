//
//  Reciter.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 18/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

struct Reciter {
    
    let title: String?
    let api_url: String?
    
    init(title: String, api_url: String) {
        self.title = title
        self.api_url = api_url
    }
}

