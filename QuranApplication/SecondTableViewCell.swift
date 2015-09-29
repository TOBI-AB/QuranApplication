//
//  SecondTableViewCell.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 18/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var surat: Surat? {
        didSet {
            updateView()
        }
    }
    
    @IBOutlet weak var suratLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView() {
        
        guard let surat = surat as Surat?, title = surat.title as String? else {
            return
        }
        
        self.suratLabel?.text = title
    }

}
