//
//  UserProfileTableViewCell.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 28/09/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName : UILabel?
    @IBOutlet var lblPhone : UILabel?
    @IBOutlet var txtName : UITextField?
    @IBOutlet var txtEmail : UITextField?
    
    @IBOutlet var btnDOB : UIButton?
    @IBOutlet var btnVegNonVeg : UIButton?
    @IBOutlet var btnGender : UIButton?
    
    @IBOutlet var lblExpire : UILabel?
    
    var datePicker = UIDatePicker()
    @IBOutlet var doneButton : UIButton?
    
    @IBOutlet var lblVersion : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
