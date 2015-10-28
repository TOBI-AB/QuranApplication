//
//  MushafMourTableViewCell.swift
//  QuranApplication
//
//  Created by GhaffarEtt on 18/10/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class MushafMourTableViewCell: UITableViewCell {

    @IBOutlet weak var mushafMourReciterLabel: UILabel!
    
    // MARK: - Properties
    var reciter: Reciter? {
        didSet {
            guard let newReciter = reciter as Reciter? else {
                return
            }
            
            guard let reciterTitle = newReciter.title as String? else {
                return
            }
            
            self.mushafMourReciterLabel.text = reciterTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mushafMourReciterLabel?.textAlignment = .Right
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reciter = nil
    }
}
