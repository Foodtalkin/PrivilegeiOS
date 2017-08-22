//
//  FavouritesViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 11/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WebServiceCallingDelegate {
    
    @IBOutlet var tblFav : UITableView?
    var arrFavList = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblFav!.register(UINib(nibName: "FavTableViewCell", bundle: nil), forCellReuseIdentifier: "Fav")
        tblFav?.tableFooterView = UIView()
        tblFav?.separatorColor = .lightGray
        self.title = "Favourite"
        self.view.backgroundColor = colorPaleGray
        FBSDKAppEvents.logEvent("favorites_view")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        DispatchQueue.main.async{
            self.callWebServiceForFavDeatils()
        }
    }
    
    //MARK:- tableViewdelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Fav", for: indexPath) as! FavTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = colorPaleGray
        cell.lblName?.text = (arrFavList.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
        cell.lblDate?.text = (arrFavList.object(at: indexPath.row) as! NSDictionary).object(forKey: "created_at") as? String
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        restaurantName = ((arrFavList.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String)!
        offerIds = (arrFavList.object(at: indexPath.row) as! NSDictionary).object(forKey: "offer_id") as! String
        outletId = (arrFavList.object(at: indexPath.row) as! NSDictionary).object(forKey: "outlet_id") as! String
        
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "StoreDetails") as! StoreDetailsViewController;
        self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 84
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        
        viewAlert.removeFromSuperview()
        DispatchQueue.main.async{
            self.callWebServiceForFavDeatils()
        }
    }
    
    func alertFav(){
        viewAlert.subviews.forEach({ $0.removeFromSuperview() })
        viewAlert.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- favWebservice
    
    func callWebServiceForFavDeatils(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@%@=%@", baseUrl,"bookmark?","sessionid",session)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(FavouritesViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
       stopAnimation()
        if(dict.object(forKey: "status") as! String == "OK"){
          arrFavList = (dict.object(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
        }
        if(arrFavList.count == 0){
            problemArise = "fav"
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(FavouritesViewController.alertFav), for: .touchUpInside)
        }
        tblFav?.reloadData()
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation()
        self.view.isUserInteractionEnabled = true
        var counter = UserDefaults.standard.value(forKey: "counterSessionExpire") as! Int
        if(counter > 0){
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            var ind = 0
            var isFind = false
            for vc in viewControllers{
                
                if(vc.isKind(of: ViewController.self)) {
                    UserDefaults.standard.setValue(nil, forKey: "userDetails")
                    UserDefaults.standard.setValue(nil, forKey: "session")
                    UserDefaults.standard.setValue(nil, forKey: "expiry")
                    UserDefaults.standard.setValue(0, forKey: "counterSessionExpire")
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
                    UserDefaults.standard.setValue(0, forKey: "counterSessionExpire")
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
            }
            
            counter = 0
            UserDefaults.standard.set(counter, forKey: "counterSessionExpire")
        }
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
