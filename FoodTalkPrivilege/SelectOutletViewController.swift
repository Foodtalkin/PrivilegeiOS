//
//  SelectOutletViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 24/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

var outletId = String()
var strAddress = ""

class SelectOutletViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WebServiceCallingDelegate {
    
    @IBOutlet var lblRestaurant : UILabel?
    @IBOutlet var lblRangeType : UILabel?
    @IBOutlet var tblOutlet : UITableView?
    
    var arrOutlets = NSMutableArray()
    var myMutableString = NSMutableAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblOutlet?.separatorColor = .lightGray
        tblOutlet?.tableFooterView = UIView()
        
        lblRestaurant?.text = restaurantName
        lblRangeType?.text = strOneLiner
        
        callWebServiceOutlet()
    }
    
    func callWebServiceOutlet(){
        if(latitude == ""){
            DispatchQueue.main.async{
                self.callWebServiceForRestaurant()
            }
        }
        else{
            DispatchQueue.main.async{
             self.callWebServiceForRestaurantLocation()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- tableViewdelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(arrOutlets.count > 1){
           return arrOutlets.count + 1
        }
        return arrOutlets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
        if (cell == nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
        }
        cell?.textLabel?.textColor = UIColor(red: 49/255, green: 51/255, blue: 53/255, alpha: 1.0)
        cell?.selectionStyle = .none
        if(indexPath.row == 0){
            cell?.textLabel?.text = "SELECT AN OUTLET."
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        else{
            
            if(arrOutlets.count > 0){
                
            cell?.textLabel?.frame.origin.x = 30
            cell?.textLabel?.numberOfLines = 0
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
                if(((arrOutlets.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "distance")) != nil){
                var distance = ((arrOutlets.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "distance") as? NSString)?.doubleValue
                    distance = distance! / 1000
                    
                let myString = String(format : "  %@ \n  %.1f KM", ((arrOutlets.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "area") as? String)!, distance!).uppercased()
                let area = (arrOutlets.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "area") as? NSString
                myMutableString = NSMutableAttributedString(string: myString, attributes: [NSForegroundColorAttributeName: UIColor.black])
                myMutableString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location:(area?.length)! + 4,length: myString.characters.count - ((area?.length)! + 4)))
                myMutableString.addAttribute(NSForegroundColorAttributeName, value: colorLightGold, range: NSRange(location:(area?.length)! + 4,length: myString.characters.count - ((area?.length)! + 4)))
                cell?.textLabel?.attributedText = myMutableString
                }
                else{
                   cell?.textLabel?.text = ((arrOutlets.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "area") as? String)?.uppercased()
                }
            cell?.accessoryType = .disclosureIndicator
         
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
           return 44
        }
        return 67
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0){
            outletId = (arrOutlets.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "id") as! String
            strAddress = (arrOutlets.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "area") as! String
            let offerCount = ((arrOutlets.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "offer_count") as? NSString)?.intValue
            if(offerCount! > 1){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SelectOffer") as! SelectOfferViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else{
                offerIds = ((arrOutlets.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "offer_ids") as? String)!
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "StoreDetails") as! StoreDetailsViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
        }
    }
    
    @IBAction func backTapped(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        arrOutlets.removeAllObjects()
        viewAlert.removeFromSuperview()
        DispatchQueue.main.async{
            self.callWebServiceForRestaurant()
        }
    }
    
    //MARK:- webServiceCalling
    
    func callWebServiceForRestaurant(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@%@%@", baseUrl,"restaurant/","outlets/",restaurantId)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(SelectOutletViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func callWebServiceForRestaurantLocation(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@%@%@?latitude=%@&longitude=%@", baseUrl,"restaurant/","outlets/",restaurantId,latitude,longitude)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(SelectOutletViewController.alertTap), for: .touchUpInside)
        }
    }
    
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        
        stopAnimation()
        if(dict.object(forKey: "status") as! String == "OK"){
            arrOutlets = ((dict.object(forKey: "result") as! NSDictionary).object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
        }
        tblOutlet?.reloadData()
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation()
        self.view.isUserInteractionEnabled = true
        UserDefaults.standard.setValue(nil, forKey: "userDetails")
        UserDefaults.standard.setValue(nil, forKey: "session")
        UserDefaults.standard.setValue(nil, forKey: "expiry")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
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
