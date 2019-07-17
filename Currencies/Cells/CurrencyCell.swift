//
//  CurrencyCell.swift
//  Currencies
//
//  Created by Anton Developer on 16/07/2019.
//  Copyright © 2019 Anton Developer. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    @IBOutlet weak var labelFirstCurrency: UILabel!
    @IBOutlet weak var labelFirstDescription: UILabel!
    @IBOutlet weak var labelRate: UILabel!
    @IBOutlet weak var labelSecondCurrency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    
}
