//
//  BombayLocationTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 21/09/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class BombayLocationTableViewCell: UITableViewCell {
    
    @IBOutlet var lblEast : UILabel?
    @IBOutlet var lblWest : UILabel?
    @IBOutlet var lblNorth : UILabel?
    @IBOutlet var lblSouth : UILabel?
    
    @IBOutlet var btnEast : UIButton?
    @IBOutlet var btnWest : UIButton?
    @IBOutlet var btnNorth : UIButton?
    @IBOutlet var btnSouth : UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
