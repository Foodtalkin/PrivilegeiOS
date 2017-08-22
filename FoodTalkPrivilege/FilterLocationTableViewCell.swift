//
//  FilterLocationTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 10/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class FilterLocationTableViewCell: UITableViewCell {
    
    @IBOutlet var btnAll : UIButton?
    @IBOutlet var btnNorthDelhi : UIButton?
    @IBOutlet var btnSouthDelhi : UIButton?
    @IBOutlet var btnEastDelhi : UIButton?
    @IBOutlet var btnWestDelhi : UIButton?
    @IBOutlet var btnCentralDelhi : UIButton?
    @IBOutlet var btnNoida : UIButton?
    @IBOutlet var btnGurgaon : UIButton?
    
    @IBOutlet var lblAll : UILabel?
    @IBOutlet var lblNorthDelhi : UILabel?
    @IBOutlet var lblSouthDelhi : UILabel?
    @IBOutlet var lblEastDelhi : UILabel?
    @IBOutlet var lblWestDelhi : UILabel?
    @IBOutlet var lblCentralDelhi : UILabel?
    @IBOutlet var lblNoida : UILabel?
    @IBOutlet var lblGurgaon : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
