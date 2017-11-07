//
//  ExperienceTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 24/10/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {
    
    @IBOutlet var imgView : UIImageView?
    @IBOutlet var lblEventName : UILabel?
    @IBOutlet var lblTime : UILabel?
    @IBOutlet var lblAddress : UILabel?
    @IBOutlet var lblPrice : UILabel?
    @IBOutlet var btnWorkshop : UIButton?
    @IBOutlet var btnDetails : UIButton?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
