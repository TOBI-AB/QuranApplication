//
//  FirstSectionCell.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 17/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class FirstSectionCell: UITableViewCell {
    
    @IBOutlet weak var reciterLabel: UILabel!
    
    var reciter: Reciter! {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView() {
      
        guard let title = reciter.title as String? else {
            return
        }
        
        self.reciterLabel?.text = title
    }

}
