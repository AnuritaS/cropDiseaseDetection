//
//  RemedyTableViewCell.swift
//  Vision+ML Example
//
//  Created by Anurita Srivastava on 14/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class RemedyTableViewCell: UITableViewCell {

    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stepNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stepNo.layer.cornerRadius = 25/2
        stepNo.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
