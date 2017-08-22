//
//  FavTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 11/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class FavTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName : UILabel?
    @IBOutlet var lblDate : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
