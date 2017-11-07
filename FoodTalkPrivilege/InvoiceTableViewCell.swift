//
//  InvoiceTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 03/11/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {
    
    @IBOutlet var lblVegNonVeg : UILabel?
    @IBOutlet var lblSubtottal : UILabel?
    @IBOutlet var lblSubtotalValue : UILabel?
    @IBOutlet var lblConvinienceFee : UILabel?
    @IBOutlet var lblTaxesValue : UILabel?
    @IBOutlet var lblTotal : UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
