//
//  Help&SupportViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 04/10/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class Help_SupportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tblHelp : UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblHelp?.tableFooterView = UIView()
        tblHelp?.separatorColor = .lightGray
        
        self.title = "HELP"
        
        var backImage: UIImage = UIImage(named: "fill301.png")!
        backImage = backImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colorLightGold]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- tableview datasource and delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
        if (cell == nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
        }
        cell?.selectionStyle = .none
        cell?.accessoryType = .disclosureIndicator
        if(indexPath.row == 0){
        cell?.textLabel?.text = "HOW IT WORKS"
        }
        else if(indexPath.row == 1){
        cell?.textLabel?.text = "FAQ"
        }
        else{
        cell?.textLabel?.text = "LEGAL"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "HowItWork") as! HowItWorkViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
        else if(indexPath.row == 1){
            selectedWebType = "faq"
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Web") as! WebViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
        else{
            selectedWebType = "legal"
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Web") as! WebViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
