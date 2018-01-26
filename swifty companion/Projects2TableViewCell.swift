//
//  Projects2TableViewCell.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/26/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit

class Projects2TableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
