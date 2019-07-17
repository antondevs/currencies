//
//  PairCell.swift
//  Currencies
//
//  Created by Anton Developer on 16/07/2019.
//  Copyright © 2019 Anton Developer. All rights reserved.
//

import UIKit

class PairCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
}
