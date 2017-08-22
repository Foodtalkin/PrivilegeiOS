//
//  HistoryCellTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 05/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class HistoryCellTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName : UILabel?
    @IBOutlet var lblCouponUsed : UILabel?
    @IBOutlet var lblRid : UILabel?
    @IBOutlet var lbldate : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
