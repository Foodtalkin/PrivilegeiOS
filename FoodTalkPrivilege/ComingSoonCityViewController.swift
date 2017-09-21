//
//  ComingSoonCityViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 20/09/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class ComingSoonCityViewController: UIViewController {
    
    @IBOutlet var imgView : UIImageView?
    @IBOutlet var btnBrowse : UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let templateImage = imgView?.image?.withRenderingMode(.alwaysTemplate)
        imgView?.image = templateImage
        imgView?.tintColor = .black
        
        btnBrowse?.layer.cornerRadius = 1
        btnBrowse?.layer.masksToBounds = true
        btnBrowse?.layer.borderColor = colorBrightSkyBlue.cgColor
        btnBrowse?.layer.borderWidth = 1.0
    }
    
    @IBAction func browseTapped(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
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
