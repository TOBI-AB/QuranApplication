//
//  UIView + Ext.swift
//  QuranApplication
//
//  Created by GhaffarEtt on 21/10/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

extension UIView {
    func animateClosure(closure: () -> Void) {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            closure()
            }, completion: nil)
    }
    
    func translateToBottom() {
       self.transform =  CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(self.frame) + 200)
    }
}


