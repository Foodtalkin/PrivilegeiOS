//
//  FilterCostTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 10/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class FilterCostTableViewCell: UITableViewCell {
    
    @IBOutlet var btnBudget : UIButton?
    @IBOutlet var btnMidRange : UIButton?
    @IBOutlet var btnSuplre : UIButton?
    
    @IBOutlet var lblBudget : UILabel?
    @IBOutlet var lblMidRange : UILabel?
    @IBOutlet var lblSuplre : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
