//
//  PackCollectionViewCell.swift
//  FoodTalk
//
//  Created by Ashish on 08/01/16.
//  Copyright © 2016 FoodTalkIndia. All rights reserved.
//

import UIKit

class PackCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var packCellImage : UIImageView? = UIImageView()
    @IBOutlet var lblRestaurant : UILabel?
    @IBOutlet var lblLocation : UILabel?
    @IBOutlet var lblMoney : UILabel?
    @IBOutlet var lblDistance : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
