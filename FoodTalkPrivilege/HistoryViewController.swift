//
//  HistoryViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 05/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WebServiceCallingDelegate {
    
    @IBOutlet var tblHistory : UITableView?
    var arrHistory = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblHistory!.register(UINib(nibName: "HistoryCellTableViewCell", bundle: nil), forCellReuseIdentifier: "History")
        tblHistory?.tableFooterView = UIView()
        tblHistory?.separatorColor = .lightGray
        self.title = "History"
        
        FBSDKAppEvents.logEvent("history_view")
        DispatchQueue.main.async{
          self.callWebServiceForHistory()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- tableViewdelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "History", for: indexPath) as! HistoryCellTableViewCell
            cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.lblCouponUsed?.text = String(format: "Coupon used : %@", (arrHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "offers_redeemed") as! String)
        cell.lblRid?.text = String(format: "RID : %@", (arrHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String)
        cell.lbldate?.text = String(format: "%@", (arrHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "created_at") as! String)
        cell.lblName?.text = String(format: "%@", (arrHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as! String)
        
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 122
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        
        viewAlert.removeFromSuperview()
        DispatchQueue.main.async{
            self.callWebServiceForHistory()
        }
    }
    
    func alertHistory(){
        viewAlert.subviews.forEach({ $0.removeFromSuperview() })
        viewAlert.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:- HistoryWebservice
    
    func callWebServiceForHistory(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@?%@=%@", baseUrl,"redeemhistory","sessionid",session)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HistoryViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        stopAnimation()
        if(dict.object(forKey: "status") as! String == "OK"){
            arrHistory = (dict.object(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
            tblHistory?.reloadData()
        }
        if(arrHistory.count == 0){
            problemArise = "history"
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HistoryViewController.alertHistory), for: .touchUpInside)
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
    
    @IBAction func backTapped(_ sender : UIButton){
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
