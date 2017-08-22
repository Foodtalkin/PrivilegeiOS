//
//  StoreImageTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 25/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class StoreImageTableViewCell: UITableViewCell {
    
    @IBOutlet var lblTitle : UILabel?
    @IBOutlet var lblArea : UILabel?
    @IBOutlet var lblDescribe : UILabel?
    @IBOutlet var imgOffer : UIImageView?
    @IBOutlet var lblRupee : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
