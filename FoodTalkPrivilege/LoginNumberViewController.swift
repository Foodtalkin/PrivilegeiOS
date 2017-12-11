//
//  LoginNumberViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 21/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
var mobileNumber = ""

class LoginNumberViewController: UIViewController, WebServiceCallingDelegate {
    
    @IBOutlet var lblMobileNumber : UILabel?
    @IBOutlet var btnNext : UIButton?
    @IBOutlet var lblLogin : UILabel?
    @IBOutlet var btnNav : UIButton?
    @IBOutlet var viewHr : UIView?
    @IBOutlet var lblDesc : UILabel?
    
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
    
    var arrNumbers = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
         manageViews()
        // Do any additional setup after loading the view.
        if(mobileNumber != ""){
            arrNumbers.addObjects(from: ["1","1","1","1","1","1","1","1","1","1"])
          lblMobileNumber?.text = mobileNumber
        }
    }
    
    
    
    func manageViews(){
        btnNav?.frame = CGRect(x : 0, y : 10, width : 44, height : 44)
        lblLogin?.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: 25, width : 80, height : 20)
        
        
        if(UIScreen.main.bounds.height < 500){
            lblMobileNumber?.frame = CGRect(x: 20, y : (lblLogin?.frame.origin.y)! + (lblLogin?.frame.size.height)! + 20, width : self.view.frame.size.width - 40, height : 20)
            viewHr?.frame = CGRect(x: 20, y : (lblMobileNumber?.frame.origin.y)! + (lblMobileNumber?.frame.size.height)! + 3, width : self.view.frame.size.width - 40, height : 1)
            lblDesc?.frame = CGRect(x: 10, y : (viewHr?.frame.origin.y)! + (viewHr?.frame.size.height)! + 20, width : self.view.frame.size.width - 20, height : 48)
            btnNext?.frame = CGRect(x: self.view.frame.size.width/2 - 40, y : (lblDesc?.frame.origin.y)! + (lblDesc?.frame.size.height)! + 5, width : 80, height : 44)
            
            btn2?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (btnNext?.frame.origin.y)! + (btnNext?.frame.size.height)! + 10, width : 44, height : 44)
            btn3?.frame = CGRect(x: (btn2?.frame.origin.x)! + (btn2?.frame.size.width)! + 20, y : (btnNext?.frame.origin.y)! + (btnNext?.frame.size.height)! + 10, width : 44, height : 44)
            btn1?.frame = CGRect(x: (btn2?.frame.origin.x)! - 64, y : (btnNext?.frame.origin.y)! + (btnNext?.frame.size.height)! + 10, width : 44, height : 44)
            
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
            
            lblMobileNumber?.frame = CGRect(x: 20, y : (lblLogin?.frame.origin.y)! + (lblLogin?.frame.size.height)! + 20, width : self.view.frame.size.width - 40, height : 20)
            viewHr?.frame = CGRect(x: 20, y : (lblMobileNumber?.frame.origin.y)! + (lblMobileNumber?.frame.size.height)! + 3, width : self.view.frame.size.width - 40, height : 1)
            lblDesc?.frame = CGRect(x: 10, y : (viewHr?.frame.origin.y)! + (viewHr?.frame.size.height)! + 20, width : self.view.frame.size.width - 20, height : 48)
            btnNext?.frame = CGRect(x: self.view.frame.size.width/2 - 40, y : (lblDesc?.frame.origin.y)! + (lblDesc?.frame.size.height)! + 5, width : 80, height : 44)
            
            btn2?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (btnNext?.frame.origin.y)! + (btnNext?.frame.size.height)! + 20, width : 44, height : 44)
            btn3?.frame = CGRect(x: (btn2?.frame.origin.x)! + (btn2?.frame.size.width)! + 52, y : (btnNext?.frame.origin.y)! + (btnNext?.frame.size.height)! + 20, width : 44, height : 44)
            btn1?.frame = CGRect(x: (btn2?.frame.origin.x)! - 96, y : (btnNext?.frame.origin.y)! + (btnNext?.frame.size.height)! + 20, width : 44, height : 44)
            
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
            lblMobileNumber?.frame = CGRect(x: 25, y : (lblLogin?.frame.origin.y)! + (lblLogin?.frame.size.height)! + 30, width : self.view.frame.size.width - 50, height : 20)
            viewHr?.frame = CGRect(x: 25, y : (lblMobileNumber?.frame.origin.y)! + (lblMobileNumber?.frame.size.height)! + 3, width : self.view.frame.size.width - 50, height : 1)
            lblDesc?.frame = CGRect(x: 10, y : (viewHr?.frame.origin.y)! + (viewHr?.frame.size.height)! + 20, width : self.view.frame.size.width - 20, height : 48)
            btnNext?.frame = CGRect(x: self.view.frame.size.width/2 - 40, y : (lblDesc?.frame.origin.y)! + (lblDesc?.frame.size.height)! + 5, width : 80, height : 44)
            
            btn2?.frame = CGRect(x: self.view.frame.size.width / 2 - 25, y : (btnNext?.frame.origin.y)! + (btnNext?.frame.size.height)! + 20, width : 50, height : 50)
            btn3?.frame = CGRect(x: (btn2?.frame.origin.x)! + (btn2?.frame.size.width)! + 60, y : (btnNext?.frame.origin.y)! + (btnNext?.frame.size.height)! + 20, width : 50, height : 50)
            btn1?.frame = CGRect(x: (btn2?.frame.origin.x)! - 110, y : (btnNext?.frame.origin.y)! + (btnNext?.frame.size.height)! + 20, width : 50, height : 50)
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        btnNext?.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func numberTapped(_ sender : UIButton){
        if(lblMobileNumber?.text == "Your mobile number"){
            lblMobileNumber?.text = ""
        }
        if(arrNumbers.count < 10){
            lblMobileNumber?.text = String(format : "%@%d",(lblMobileNumber?.text)!, sender.tag)
            arrNumbers.add(String(format : "%d", sender.tag))
        }
    }
    
    @IBAction func backTapped(_ sender : UIButton){
        if(arrNumbers.count > 0){
            let truncated = lblMobileNumber?.text?.substring(to: (lblMobileNumber?.text?.index(before: (lblMobileNumber?.text?.endIndex)!))!)
            lblMobileNumber?.text = truncated
            arrNumbers.removeLastObject()
        }
        else{
            lblMobileNumber?.text = "Your mobile number"
        }
    }
    
    @IBAction func pressNext(_ sender : UIButton){
        if(arrNumbers.count == 10){
         btnNext?.isHidden = true
         callWebServiceForNumber()
        }
        else{
           self.view.makeToast("Phone number is not valid..")
        }
    }
    
    @IBAction func backScreenTapped(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        lblMobileNumber?.text = ""
        viewAlert.removeFromSuperview()
    }
    
    //MARK:- WebServiceCalling
    
    func callWebServiceForNumber(){
        showAnimationWithFrame(x: self.view.frame.size.width/2 - 30, y: self.view.frame.size.height/2 - 120, view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@%@", baseUrl,"checkuser/", (lblMobileNumber?.text)!)
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(LoginNumberViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func callWebServiceForOTP(params : NSDictionary){
        showAnimationWithFrame(x: self.view.frame.size.width/2 - 30, y: self.view.frame.size.height/2 - 120, view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@", baseUrl,"getotp")
            
            webServiceCallingPost(url, parameters: params)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(LoginNumberViewController.alertTap), for: .touchUpInside)
        }
    }
    
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        
        stopAnimation(view: self.view)
        if((dict.object(forKey: "api") as! String).contains("/checkuser/")){
        if(dict.object(forKey: "status") as! String == "OK"){
            let user = dict.object(forKey: "result") as! NSDictionary
            dictUserDetails = user
            let param = NSMutableDictionary()
            param.setObject(dictUserDetails.object(forKey: "email") as! String, forKey: "email" as NSCopying)
            param.setObject(dictUserDetails.object(forKey: "name") as! String, forKey: "name" as NSCopying)
            param.setObject(dictUserDetails.object(forKey: "phone") as! String, forKey: "phone" as NSCopying)
            callWebServiceForOTP(params: param)
        }
        else{
            if(dict.object(forKey: "code") as! String == "404"){
                loginAs = "guest"
                mobileNumber = (lblMobileNumber?.text)!
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            }
        }
        else{
           if(dict.object(forKey: "status") as! String == "OK"){
            otpFrom = "login"
            strOtp = dict.object(forKey: "result") as! String
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Login") as! LoginViewController;
            self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
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
