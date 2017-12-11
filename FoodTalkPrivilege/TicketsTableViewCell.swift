//
//  TicketsTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 08/11/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class TicketsTableViewCell: UITableViewCell {
    
    @IBOutlet var lblTitle : UILabel?
    @IBOutlet var lblDate : UILabel?
    @IBOutlet var lblAddress : UILabel?
    @IBOutlet var lblNumberTickets : UILabel?
    @IBOutlet var lblTransactionId : UILabel?
    @IBOutlet var btnEvent : UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
