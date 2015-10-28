//
//  SecondTableViewCell.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 18/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class SourateTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var suratLabel: UILabel!

    // MARK: - Properties
    var sourate: Sourate? {
        didSet {
            guard let newSourat = sourate as Sourate?, title = newSourat.title as String? else {
                return
            }
            
            self.textLabel?.textAlignment = .Right
            self.textLabel?.text = title

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
}
