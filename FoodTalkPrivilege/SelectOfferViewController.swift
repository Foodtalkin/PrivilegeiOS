//
//  SelectOfferViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 24/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

var offerIds = String()

class SelectOfferViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WebServiceCallingDelegate{
    
    @IBOutlet var lblRestaurant : UILabel?
    @IBOutlet var lblRangeType : UILabel?
    @IBOutlet var tblOutlet : UITableView?
    @IBOutlet var lblAddress : UILabel?
    
    var arrOffers = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblRestaurant?.text = restaurantName
        lblRangeType?.text = strOneLiner
        lblAddress?.text = strAddress
        // Do any additional setup after loading the view.
        tblOutlet!.register(UINib(nibName: "SelectOfferTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectOffer")
        tblOutlet?.tableFooterView = UIView()
        tblOutlet?.separatorColor = .lightGray
        
        DispatchQueue.main.async{
            self.callWebServiceForRestaurant()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- tableViewdelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOffers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0){
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
            if (cell == nil) {
                cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
            }
            cell?.textLabel?.textColor = UIColor(red: 49/255, green: 51/255, blue: 53/255, alpha: 1.0)
            cell?.textLabel?.text = "SELECT AN OFFER."
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectOffer", for: indexPath) as! SelectOfferTableViewCell
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.lblHeader?.text = String(format : "%@", ((arrOffers.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "title") as? String)!)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0){
            offerIds = (arrOffers.object(at: indexPath.row - 1) as! NSDictionary).object(forKey: "offer_id") as! String
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "StoreDetails") as! StoreDetailsViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 44
        }
        return 84
    }
    
    @IBAction func backTapped(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        arrOffers.removeAllObjects()
        viewAlert.removeFromSuperview()
        DispatchQueue.main.async{
            self.callWebServiceForRestaurant()
        }
    }

    //MARK:- webServiceCalling
    
    func callWebServiceForRestaurant(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@%@", baseUrl,"outletoffer/",outletId)
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(SelectOfferViewController.alertTap), for: .touchUpInside)
        }
    }
    
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        
        stopAnimation()
        if((dict.object(forKey: "api") as! String).contains("outletoffer")){
        if(dict.object(forKey: "status") as! String == "OK"){
            arrOffers = ((dict.object(forKey: "result") as! NSDictionary).object(forKey: "offers") as! NSArray).mutableCopy() as! NSMutableArray
        }
        let area = ((dict.object(forKey: "result") as! NSDictionary).object(forKey: "outlet") as! NSDictionary).object(forKey: "area") as! String
        strAddress = area
        lblAddress?.text = strAddress
        tblOutlet?.reloadData()
        }
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation()
        self.view.isUserInteractionEnabled = true
//        var counter = UserDefaults.standard.value(forKey: "counterSessionExpire") as! Int
//        if(counter > 0){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            var ind = 0
            var isFind = false
            for vc in viewControllers{
                
                if(vc.isKind(of: ViewController.self)) {
                    UserDefaults.standard.setValue(nil, forKey: "userDetails")
                    UserDefaults.standard.setValue(nil, forKey: "session")
                    UserDefaults.standard.setValue(nil, forKey: "expiry")
                    
                    self.navigationController!.popToViewController(viewControllers[ind], animated: true);
                    isFind = true
                    break
                }
                ind = ind + 1
            }
            if(isFind == false){
                if(ind == viewControllers.count){
                    UserDefaults.standard.setValue(nil, forKey: "userDetails")
                    UserDefaults.standard.setValue(nil, forKey: "session")
                    UserDefaults.standard.setValue(nil, forKey: "expiry")
                    
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
            }
//
//            counter = 0
//            UserDefaults.standard.set(counter, forKey: "counterSessionExpire")
//        }
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
