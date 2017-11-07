//
//  VideoExperienceTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 26/10/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class VideoExperienceTableViewCell: UITableViewCell {
    
    @IBOutlet var webView : UIWebView?
    @IBOutlet var lblTitle : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
