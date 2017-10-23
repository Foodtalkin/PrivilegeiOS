//
//  RestaurantPinViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 26/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Crashlytics

var rid = NSNumber()
var comingSuccessFrom = ""

class RestaurantPinViewController: UIViewController, WebServiceCallingDelegate {
    
    @IBOutlet var lblBox1 : UILabel?
    @IBOutlet var lblBox2 : UILabel?
    @IBOutlet var lblBox3 : UILabel?
    @IBOutlet var lblBox4 : UILabel?
    
    @IBOutlet var btn1 : UIButton?
    @IBOutlet var btn2 : UIButton?
    @IBOutlet var btn3 : UIButton?
    @IBOutlet var btn4 : UIButton?
    @IBOutlet var btn5 : UIButton?
    @IBOutlet var btn6 : UIButton?
    @IBOutlet var btn7 : UIButton?
    @IBOutlet var btn8 : UIButton?
    @IBOutlet var btn9 : UIButton?
    @IBOutlet var btn0 : UIButton?
    @IBOutlet var btnBack : UIButton?
    
    @IBOutlet var lblNumber : UILabel?
    @IBOutlet var redeemNumber : UILabel?
    
    @IBOutlet var lblRedeem : UILabel?
    @IBOutlet var btnConfirm : UIButton?
    
    var arrValues = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblBox1?.layer.cornerRadius = 5
        lblBox1?.layer.masksToBounds = true
        
        lblBox2?.layer.cornerRadius = 5
        lblBox2?.layer.masksToBounds = true
        
        lblBox3?.layer.cornerRadius = 5
        lblBox3?.layer.masksToBounds = true
        
        lblBox4?.layer.cornerRadius = 5
        lblBox4?.layer.masksToBounds = true
        
        redeemNumber?.text = String(format : "REDEEMING %@ COUPON", numberRedeem)
        manageView()
    }
    
    func manageView(){
        lblRedeem?.frame = CGRect(x: 0, y : 30, width : self.view.frame.size.width, height : 21)
        lblNumber?.frame = CGRect(x: 0, y: 70, width : self.view.frame.size.width, height : 49)
        lblBox3?.frame = CGRect(x: self.view.frame.size.width/2 + 5, y : 137, width: 47, height : 47)
        lblBox4?.frame = CGRect(x: (self.lblBox3?.frame.origin.x)! + (self.lblBox3?.frame.size.width)! + 10, y : 137, width: 47, height : 47)
        lblBox2?.frame = CGRect(x: self.view.frame.size.width/2 - 52, y : 137, width: 47, height : 47)
        lblBox1?.frame = CGRect(x: (self.lblBox2?.frame.origin.x)! - 57, y : 137, width: 47, height : 47)
        btnConfirm?.frame = CGRect(x: self.view.frame.size.width/2 - 82, y: (lblBox1?.frame.origin.y)! + (lblBox1?.frame.size.height)! + 15, width : 164, height : 30)
        
        if(UIScreen.main.bounds.height < 500){
        btn2?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (btnConfirm?.frame.origin.y)! + (btnConfirm?.frame.size.height)! + 10, width : 44, height : 44)
        btn3?.frame = CGRect(x: (btn2?.frame.origin.x)! + (btn2?.frame.size.width)! + 20, y : (btnConfirm?.frame.origin.y)! + (btnConfirm?.frame.size.height)! + 10, width : 44, height : 44)
        btn1?.frame = CGRect(x: (btn2?.frame.origin.x)! - 64, y : (btnConfirm?.frame.origin.y)! + (btnConfirm?.frame.size.height)! + 10, width : 44, height : 44)
        
        btn5?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (btn1?.frame.origin.y)! + (btn1?.frame.size.height)! + 20, width : 44, height : 44)
        btn6?.frame = CGRect(x: (btn5?.frame.origin.x)! + (btn5?.frame.size.width)! + 20, y : (btn1?.frame.origin.y)! + (btn1?.frame.size.height)! + 10, width : 44, height : 44)
        btn4?.frame = CGRect(x: (btn5?.frame.origin.x)! - 64, y : (btn1?.frame.origin.y)! + (btn1?.frame.size.height)! + 10, width : 44, height : 44)
        
        btn8?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (btn5?.frame.origin.y)! + (btn5?.frame.size.height)! + 20, width : 44, height : 44)
        btn9?.frame = CGRect(x: (btn8?.frame.origin.x)! + (btn8?.frame.size.width)! + 20, y : (btn5?.frame.origin.y)! + (btn5?.frame.size.height)! + 10, width : 44, height : 44)
        btn7?.frame = CGRect(x: (btn8?.frame.origin.x)! - 64, y : (btn5?.frame.origin.y)! + (btn5?.frame.size.height)! + 10, width : 44, height : 44)
        
        btn0?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (btn8?.frame.origin.y)! + (btn8?.frame.size.height)! + 20, width : 44, height : 44)
        btnBack?.frame = CGRect(x: (btn0?.frame.origin.x)! + (btn0?.frame.size.width)! + 20, y : (btn8?.frame.origin.y)! + (btn8?.frame.size.height)! + 10, width : 44, height : 44)
        }
        else if(UIScreen.main.bounds.height < 570){
            btn2?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (btnConfirm?.frame.origin.y)! + (btnConfirm?.frame.size.height)! + 20, width : 44, height : 44)
            btn3?.frame = CGRect(x: (btn2?.frame.origin.x)! + (btn2?.frame.size.width)! + 52, y : (btnConfirm?.frame.origin.y)! + (btnConfirm?.frame.size.height)! + 20, width : 44, height : 44)
            btn1?.frame = CGRect(x: (btn2?.frame.origin.x)! - 96, y : (btnConfirm?.frame.origin.y)! + (btnConfirm?.frame.size.height)! + 20, width : 44, height : 44)
            
            btn5?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (btn1?.frame.origin.y)! + (btn1?.frame.size.height)! + 45, width : 44, height : 44)
            btn6?.frame = CGRect(x: (btn5?.frame.origin.x)! + (btn5?.frame.size.width)! + 52, y : (btn1?.frame.origin.y)! + (btn1?.frame.size.height)! + 45, width : 44, height : 44)
            btn4?.frame = CGRect(x: (btn5?.frame.origin.x)! - 96, y : (btn1?.frame.origin.y)! + (btn1?.frame.size.height)! + 45, width : 44, height : 44)
            
            btn8?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (btn5?.frame.origin.y)! + (btn5?.frame.size.height)! + 45, width : 44, height : 44)
            btn9?.frame = CGRect(x: (btn8?.frame.origin.x)! + (btn8?.frame.size.width)! + 52, y : (btn5?.frame.origin.y)! + (btn5?.frame.size.height)! + 45, width : 44, height : 44)
            btn7?.frame = CGRect(x: (btn8?.frame.origin.x)! - 96, y : (btn5?.frame.origin.y)! + (btn5?.frame.size.height)! + 45, width : 44, height : 44)
            
            btn0?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (btn8?.frame.origin.y)! + (btn8?.frame.size.height)! + 45, width : 44, height : 44)
            btnBack?.frame = CGRect(x: (btn0?.frame.origin.x)! + (btn0?.frame.size.width)! + 52, y : (btn8?.frame.origin.y)! + (btn8?.frame.size.height)! + 45, width : 44, height : 44)
        }
        else{
            btn2?.frame = CGRect(x: self.view.frame.size.width / 2 - 25, y : (btnConfirm?.frame.origin.y)! + (btnConfirm?.frame.size.height)! + 20, width : 50, height : 50)
            btn3?.frame = CGRect(x: (btn2?.frame.origin.x)! + (btn2?.frame.size.width)! + 60, y : (btnConfirm?.frame.origin.y)! + (btnConfirm?.frame.size.height)! + 20, width : 50, height : 50)
            btn1?.frame = CGRect(x: (btn2?.frame.origin.x)! - 110, y : (btnConfirm?.frame.origin.y)! + (btnConfirm?.frame.size.height)! + 20, width : 50, height : 50)
            
            btn5?.frame = CGRect(x: self.view.frame.size.width / 2 - 25, y : (btn1?.frame.origin.y)! + (btn1?.frame.size.height)! + 60, width : 50, height : 50)
            btn6?.frame = CGRect(x: (btn5?.frame.origin.x)! + (btn5?.frame.size.width)! + 60, y : (btn1?.frame.origin.y)! + (btn1?.frame.size.height)! + 60, width : 50, height : 50)
            btn4?.frame = CGRect(x: (btn5?.frame.origin.x)! - 110, y : (btn1?.frame.origin.y)! + (btn1?.frame.size.height)! + 60, width : 50, height : 50)
            
            btn8?.frame = CGRect(x: self.view.frame.size.width / 2 - 25, y : (btn5?.frame.origin.y)! + (btn5?.frame.size.height)! + 60, width : 50, height : 50)
            btn9?.frame = CGRect(x: (btn8?.frame.origin.x)! + (btn8?.frame.size.width)! + 60, y : (btn5?.frame.origin.y)! + (btn5?.frame.size.height)! + 60, width : 50, height : 50)
            btn7?.frame = CGRect(x: (btn8?.frame.origin.x)! - 110, y : (btn5?.frame.origin.y)! + (btn5?.frame.size.height)! + 60, width : 50, height : 50)
            
            btn0?.frame = CGRect(x: self.view.frame.size.width / 2 - 25, y : (btn8?.frame.origin.y)! + (btn8?.frame.size.height)! + 60, width : 50, height : 50)
            btnBack?.frame = CGRect(x: (btn0?.frame.origin.x)! + (btn0?.frame.size.width)! + 60, y : (btn8?.frame.origin.y)! + (btn8?.frame.size.height)! + 60, width : 50, height : 50)
        }
    }

    
    @IBAction func numberTapped(_ sender : UIButton){
        if(arrValues.count < 4){
            if(arrValues.count == 0){
                lblBox1?.text = String(format: "%d", sender.tag)
                arrValues.add(String(format: "%d", sender.tag))
            }
            else if(arrValues.count == 1){
                lblBox2?.text = String(format: "%d", sender.tag)
                arrValues.add(String(format: "%d", sender.tag))
            }
            else if(arrValues.count == 2){
                lblBox3?.text = String(format: "%d", sender.tag)
                arrValues.add(String(format: "%d", sender.tag))
            }
            else if(arrValues.count == 3){
                lblBox4?.text = String(format: "%d", sender.tag)
                arrValues.add(String(format: "%d", sender.tag))
            }
            
        }
    }
    
    @IBAction func backTapped(_ sender : UIButton){
        if(arrValues.count > 0){
            if(arrValues.count == 4){
                lblBox4?.text = ""
                arrValues.removeObject(at: 3)
            }
            else if(arrValues.count == 3){
                lblBox3?.text = ""
                arrValues.removeObject(at: 2)
            }
            else if(arrValues.count == 2){
                lblBox2?.text = ""
                arrValues.removeObject(at: 1)
            }
            else if(arrValues.count == 1){
                lblBox1?.text = ""
                arrValues.removeObject(at: 0)
            }
        }
    }
    
    @IBAction func next(_ sender : UIButton){
        if(arrValues.count == 4){
          webServiceForRedeem()
        }
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        viewAlert.removeFromSuperview()
        DispatchQueue.main.async{
            self.webServiceForRedeem()
        }
    }
    
    func webServiceForRedeem(){
        
        showAnimationWithFrame(x: self.view.frame.size.width/2 - 30, y: self.view.frame.size.height/2 - 120, view: self.view)
        if(isConnectedToNetwork() == true){
        var otp = ""
        for index in 0..<arrValues.count{
            otp = String(format : "%@%@", otp,arrValues.object(at: index) as! String)
        }
        let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
        let session = dictSessionId.object(forKey: "session_id") as! String
        let url = String(format: "%@%@?sessionid=%@", baseUrl,"redeem", session)
        let param = NSMutableDictionary()
        let offer = dictDetails.object(forKey: "offer_id") as! String
        let outlet = dictDetails.object(forKey: "outlet_id") as! String
        param.setObject(outlet, forKey: "outlet_id" as NSCopying)
        param.setObject(offer, forKey: "offer_id" as NSCopying)
        param.setObject(numberRedeem, forKey: "offers_redeemed" as NSCopying)
        param.setObject(otp, forKey: "pin" as NSCopying)
            
        webServiceCallingPost(url, parameters: param)
        delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(RestaurantPinViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation(view: self.view)
        self.view.isUserInteractionEnabled = true
        UserDefaults.standard.setValue(nil, forKey: "userDetails")
        UserDefaults.standard.setValue(nil, forKey: "session")
        UserDefaults.standard.setValue(nil, forKey: "expiry")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        print(dict)
        stopAnimation(view: self.view)
        
        if(dict.object(forKey: "status") as! String == "OK"){
            FBSDKAppEvents.logEvent("Successfully Redeemed")
            Answers.logCustomEvent(withName: "Redemeed", customAttributes: [:])
            comingSuccessFrom = "Redeem"
            rid = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "id") as! NSNumber
         let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Success") as! SuccessViewController;
         self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
        else{
            arrValues.removeAllObjects()
            vibrateLabel()
        }
    }
    
    //MARK:- vibrate Label
    
    func vibrateLabel(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: (lblBox1?.center.x)! - 10, y: (lblBox1?.center.y)!)
        animation.toValue = CGPoint(x: (lblBox1?.center.x)! + 10, y: (lblBox1?.center.y)!)
        lblBox1?.layer.add(animation, forKey: "position")
        
        animation.fromValue = CGPoint(x: (lblBox2?.center.x)! - 10, y: (lblBox2?.center.y)!)
        animation.toValue = CGPoint(x: (lblBox2?.center.x)! + 10, y: (lblBox2?.center.y)!)
        lblBox2?.layer.add(animation, forKey: "position")
        
        animation.fromValue = CGPoint(x: (lblBox3?.center.x)! - 10, y: (lblBox3?.center.y)!)
        animation.toValue = CGPoint(x: (lblBox3?.center.x)! + 10, y: (lblBox3?.center.y)!)
        lblBox3?.layer.add(animation, forKey: "position")
        
        animation.fromValue = CGPoint(x: (lblBox4?.center.x)! - 10, y: (lblBox4?.center.y)!)
        animation.toValue = CGPoint(x: (lblBox4?.center.x)! + 10, y: (lblBox4?.center.y)!)
        lblBox4?.layer.add(animation, forKey: "position")
        
        lblBox1?.text = ""
        lblBox2?.text = ""
        lblBox3?.text = ""
        lblBox4?.text = ""
    }
    
    @IBAction func help(_ sender : UIButton){
        print(sender.tag)
    }
    
    @IBAction func backScreenTapped(_ sender : UIButton){
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
