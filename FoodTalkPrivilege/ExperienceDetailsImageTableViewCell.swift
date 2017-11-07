//
//  ExperienceDetailsImageTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 26/10/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class ExperienceDetailsImageTableViewCell: UITableViewCell {
    
    @IBOutlet var imgView : UIImageView?
    @IBOutlet var imgMap : UIImageView?
    @IBOutlet var imgClock : UIImageView?
    @IBOutlet var lblDate : UILabel?
    @IBOutlet var lblAddress : UILabel?
    @IBOutlet var lblName : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
