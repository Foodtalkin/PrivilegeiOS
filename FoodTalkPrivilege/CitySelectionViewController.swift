//
//  CitySelectionViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 13/09/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

class CitySelectionViewController: UIViewController, UIGestureRecognizerDelegate, WebServiceCallingDelegate {
    
    @IBOutlet var viewNCR : UIView?
    @IBOutlet var viewBombay : UIView?
    @IBOutlet var viewSelectNCR : UIView?
    @IBOutlet var viewSelectBombay : UIView?
    @IBOutlet var lblRestCountNCR : UILabel?
  //  @IBOutlet var lblOutletCountNCR : UILabel?
    @IBOutlet var lblRestCountBombay : UILabel?
    @IBOutlet var lblOutletCountBombay : UILabel?
    @IBOutlet var imgBombay : UIImageView?
    
    var selectedCityId = "1"
    var dictInfo = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colorLightGold]
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(CitySelectionViewController.handleTap(_:)))
        tap1.delegate = self
        viewNCR?.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(CitySelectionViewController.handleTap(_:)))
        tap2.delegate = self
        viewBombay?.addGestureRecognizer(tap2)
        
        viewSelectNCR?.isHidden = false
        viewSelectBombay?.isHidden = true
        
        if((UserDefaults.standard.object(forKey: "city_id")) != nil){
            let city_id = UserDefaults.standard.object(forKey: "city_id") as! String
            if(city_id == "1"){
                viewSelectNCR?.isHidden = false
                viewSelectBombay?.isHidden = true
            }
            else{
                viewSelectNCR?.isHidden = true
                viewSelectBombay?.isHidden = false
            }
        }
        
        webServiceCallingCity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.title = "FOOD TALK"
    }
    
    //MARK:- WebService Calling Method
    
    func webServiceCallingCity(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@", baseUrl, "cities")
            webServiceGet(url)
            delegate = self
        }
        else{
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(HomeViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func webServiceCallingCityUpdate(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@?sessionid=%@", baseUrl,"user", session)
            let dict = NSMutableDictionary()
            dict.setObject(selectedCityId, forKey: "city_id" as NSCopying)
            
            webServiceCallingPut(url, parameters: dict)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(AccountViewController.alertTap), for: .touchUpInside)
        }
    }
    
    //MARK:- SaveButtonClicked
    
    @IBAction func saveClicked(_ sender : UIButton){
        if(loginAs == "user"){
           webServiceCallingCityUpdate()
        }
        else{
            city_id = selectedCityId
            self.navigationController?.popViewController(animated: true)
        }
      
    }
    
    //MARK:- gesture delegate
    
    func handleTap(_ gesture : UIGestureRecognizer){
        if(gesture.view == viewNCR){
            viewSelectNCR?.isHidden = false
            viewSelectBombay?.isHidden = true
            selectedCityId = ((dictInfo.object(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "id") as! String
            city_id = ((dictInfo.object(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "id") as! String
        }
        else if(gesture.view == viewBombay){
            viewSelectNCR?.isHidden = true
            viewSelectBombay?.isHidden = false
            selectedCityId = ((dictInfo.object(forKey: "result") as! NSArray).object(at: 1) as! NSDictionary).object(forKey: "id") as! String
            city_id = ((dictInfo.object(forKey: "result") as! NSArray).object(at: 1) as! NSDictionary).object(forKey: "id") as! String
        }
    }
    
    //MARK:- webservice delegates
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        
        stopAnimation()
        if((dict.object(forKey: "api") as! String).contains("user")){
            if(dict.object(forKey: "status") as! String == "OK"){
              let city_id1 = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "city_id") as! String
            if(loginAs == "user"){
              UserDefaults.standard.set(city_id1, forKey: "city_id")
                
            }
              city_id = city_id1
              self.navigationController?.popViewController(animated: true)
            }
        }
        else if((dict.object(forKey: "api") as! String).contains("cities")){
        if(dict.object(forKey: "status") as! String == "OK"){
            dictInfo = dict
            lblRestCountNCR?.text = String(format : "%@ Restaurants", (((dict.object(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "outlet_count") as? String)!)
            lblRestCountBombay?.text = String(format : "%@ Restaurants", (((dict.object(forKey: "result") as! NSArray).object(at: 1) as! NSDictionary).object(forKey: "outlet_count") as? String)!)
         //   lblOutletCountNCR?.text = String(format : "%@ Outlets", (((dict.object(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "outlet_count") as? String)!)
        //    lblOutletCountBombay?.text = String(format : "%@ Outlets", (((dict.object(forKey: "result") as! NSArray).object(at: 1) as! NSDictionary).object(forKey: "outlet_count") as? String)!)
            
            let isactive = ((dict.object(forKey: "result") as! NSArray).object(at: 1) as! NSDictionary).object(forKey: "is_active") as? String
            if(isactive == "1"){
                
            }
            else{
            let templateImage = imgBombay?.image?.withRenderingMode(.alwaysTemplate)
            imgBombay?.image = templateImage
            imgBombay?.tintColor = .gray
            }
        }
        }
    }
    
    func serviceFailedWitherror(_ error: NSError) {
        
    }
    
    func serviceUploadProgress(_ myprogress: float_t) {
        
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
