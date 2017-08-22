//
//  PaymentStatusViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 05/06/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

var paymentStatus = ""

class PaymentStatusViewController: UIViewController {
    
    @IBOutlet var lblHighlight : UILabel?
    @IBOutlet var imgMain : UIImageView?
    @IBOutlet var lblAlert : UILabel?
    @IBOutlet var lblThank : UILabel?
    @IBOutlet var btnPayment : UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(paymentStatus == "success"){
            imgMain?.image = UIImage(named : "paySuccess.png")
            
        }
        else{
            
        }
        setDownLine(btnPayment!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
