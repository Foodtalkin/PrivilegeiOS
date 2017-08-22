//
//  LoginViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 21/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit

var dictSessionInfo = NSDictionary()


class LoginViewController: UIViewController, WebServiceCallingDelegate {
    
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
    @IBOutlet var btnResend : UIButton?
    @IBOutlet var lblTimer : UILabel?
    
    @IBOutlet var lblVerify : UILabel?
    
    var arrValues = NSMutableArray()
    
    var transactionID: String!
    var accessToken: String!
    
    var count = 30
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnResend?.isHidden = true
        lblNumber?.text = String(format: "Please enter four digit OTP sent to %@", dictUserDetails.object(forKey: "phone") as! String)
        
        // Do any additional setup after loading the view.
        lblBox1?.layer.cornerRadius = 5
        lblBox1?.layer.masksToBounds = true
        
        lblBox2?.layer.cornerRadius = 5
        lblBox2?.layer.masksToBounds = true
        
        lblBox3?.layer.cornerRadius = 5
        lblBox3?.layer.masksToBounds = true
        
        lblBox4?.layer.cornerRadius = 5
        lblBox4?.layer.masksToBounds = true
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginViewController.counter), userInfo: nil, repeats: true)
        
        manageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func manageView(){
        lblVerify?.frame = CGRect(x: self.view.frame.size.width/2 - 82, y : 22, width : 164, height : 21)
        lblNumber?.frame = CGRect(x: 20, y: 60, width : self.view.frame.size.width - 40, height : 49)
        lblBox3?.frame = CGRect(x: self.view.frame.size.width/2 + 5, y : 137, width: 47, height : 47)
        lblBox4?.frame = CGRect(x: (self.lblBox3?.frame.origin.x)! + (self.lblBox3?.frame.size.width)! + 10, y : 137, width: 47, height : 47)
        lblBox2?.frame = CGRect(x: self.view.frame.size.width/2 - 52, y : 137, width: 47, height : 47)
        lblBox1?.frame = CGRect(x: (self.lblBox2?.frame.origin.x)! - 57, y : 137, width: 47, height : 47)
        btnResend?.frame = CGRect(x: self.view.frame.size.width/2 - 82, y: (lblBox1?.frame.origin.y)! + (lblBox1?.frame.size.height)! + 5, width : 164, height : 30)
        lblTimer?.frame = CGRect(x: 20, y: (lblBox1?.frame.origin.y)! + (lblBox1?.frame.size.height)! + 15, width : self.view.frame.size.width - 40, height : 20)
        if(UIScreen.main.bounds.height < 500){
        btn2?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (lblTimer?.frame.origin.y)! + (lblTimer?.frame.size.height)! + 10, width : 44, height : 44)
        btn3?.frame = CGRect(x: (btn2?.frame.origin.x)! + (btn2?.frame.size.width)! + 20, y : (lblTimer?.frame.origin.y)! + (lblTimer?.frame.size.height)! + 10, width : 44, height : 44)
        btn1?.frame = CGRect(x: (btn2?.frame.origin.x)! - 64, y : (lblTimer?.frame.origin.y)! + (lblTimer?.frame.size.height)! + 10, width : 44, height : 44)
        
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
            btn2?.frame = CGRect(x: self.view.frame.size.width / 2 - 22, y : (lblTimer?.frame.origin.y)! + (lblTimer?.frame.size.height)! + 20, width : 44, height : 44)
            btn3?.frame = CGRect(x: (btn2?.frame.origin.x)! + (btn2?.frame.size.width)! + 52, y : (lblTimer?.frame.origin.y)! + (lblTimer?.frame.size.height)! + 20, width : 44, height : 44)
            btn1?.frame = CGRect(x: (btn2?.frame.origin.x)! - 96, y : (lblTimer?.frame.origin.y)! + (lblTimer?.frame.size.height)! + 20, width : 44, height : 44)
            
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
            btn2?.frame = CGRect(x: self.view.frame.size.width / 2 - 25, y : (lblTimer?.frame.origin.y)! + (lblTimer?.frame.size.height)! + 20, width : 50, height : 50)
            btn3?.frame = CGRect(x: (btn2?.frame.origin.x)! + (btn2?.frame.size.width)! + 60, y : (lblTimer?.frame.origin.y)! + (lblTimer?.frame.size.height)! + 20, width : 50, height : 50)
            btn1?.frame = CGRect(x: (btn2?.frame.origin.x)! - 110, y : (lblTimer?.frame.origin.y)! + (lblTimer?.frame.size.height)! + 20, width : 50, height : 50)
            
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
    
    func counter() {
        
        count -= 1
        // 9
        if count >= 1 {
            
            lblTimer?.text = String(format : "Request another OTP in %d seconds", count)
            
        }
        else {
            resetPressed()
        }
        
    }
    
    func resetPressed() {
        // 11
        timer.invalidate()
        
        count = 30
        
        btnResend?.isHidden = false
        lblTimer?.isHidden = true
    }
    
    func changeRoot(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
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
            if(arrValues.count == 4){
                checkOTP()
            }
        }
    }
    
    func checkOTP(){
        resetPressed()
        btnResend?.isHidden = true
        var otp = ""
        for index in 0..<arrValues.count{
            otp = String(format : "%@%@", otp,arrValues.object(at: index) as! String)
        }

        let phone = dictUserDetails.object(forKey: "phone") as! String
        let param = NSMutableDictionary()
        param.setObject(phone, forKey: "phone" as NSCopying)
        param.setObject(otp, forKey: "otp" as NSCopying)
        
        callWebServiceForOTP(params: param)
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        lblBox1?.text = ""
        lblBox2?.text = ""
        lblBox3?.text = ""
        lblBox4?.text = ""
        arrValues.removeAllObjects()
        viewAlert.removeFromSuperview()
    }
    
    func callWebServiceForOTP(params : NSDictionary){
        showAnimationWithFrame(x: self.view.frame.size.width/2 - 30, y: self.view.frame.size.height/2 - 120, view: self.view)
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@", baseUrl,"userlogin")
            
            webServiceCallingPost(url, parameters: params)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(LoginViewController.alertTap), for: .touchUpInside)
        }
    }
    
    //MARK:- webservices
    
    func callWebServiceSubscribe(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@?sessionid=%@", baseUrl,"subscription", session)
            let dict = NSMutableDictionary()
            dict.setObject(self.transactionID, forKey: "payment_id" as NSCopying)
            webServiceCallingPost(url, parameters: dict)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(LoginViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func resendOTPWeb(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let phone = dictUserDetails.object(forKey: "phone") as! String
            let url = String(format: "%@%@%@", baseUrl,"resendotp/",phone)
            
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(LoginViewController.alertTap), for: .touchUpInside)
        }

    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        stopAnimation()
     //   print(dict)
        if((dict.object(forKey: "api") as! String).contains("userlogin")){
        if(dict.object(forKey: "status") as! String == "OK"){
            
          dictUserDetails = dict.object(forKey: "result") as! NSDictionary
          dictSessionInfo = dictUserDetails.object(forKey: "session") as! NSDictionary
            let newInfo = NSMutableDictionary()
            newInfo.setObject(dictUserDetails.object(forKey: "name") as! String, forKey: "name" as NSCopying)
            newInfo.setObject(dictUserDetails.object(forKey: "phone") as! String, forKey: "phone" as NSCopying)
            newInfo.setObject(dictUserDetails.object(forKey: "dob") as! String, forKey: "dob" as NSCopying)
            newInfo.setObject(dictUserDetails.object(forKey: "email") as! String, forKey: "email" as NSCopying)
            newInfo.setObject(dictUserDetails.object(forKey: "gender") as! String, forKey: "gender" as NSCopying)
            newInfo.setObject(dictUserDetails.object(forKey: "preference") as! String, forKey: "preference" as NSCopying)
            
            
            let arrSubscribe = dictUserDetails.object(forKey: "subscription") as! NSArray
            if(arrSubscribe.count > 0){
                
                let savedMoney = dictUserDetails.object(forKey: "saving") as! String
                UserDefaults.standard.set(savedMoney, forKey: "saved")

                loginAs = "user"
                let expiry = (arrSubscribe.object(at: 0) as! NSDictionary).object(forKey: "expiry") as? String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let s = dateFormatter.date(from:expiry!)
                
                let currentInstallation = PFInstallation.current()
                currentInstallation.setObject(s!, forKey: "expiry")
                currentInstallation.saveInBackground()
                
                let token = dictSessionInfo.object(forKey: "refresh_token") as! String
                let userId = dictSessionInfo.object(forKey: "user_id") as! String
                let currentInstallation1 = PFInstallation.current()
                currentInstallation1.setObject(userId, forKey: "userId")
                currentInstallation1.saveInBackground()
                UserDefaults.standard.setValue(expiry, forKey: "expiry")
                UserDefaults.standard.setValue(newInfo, forKey: "userDetails")
                UserDefaults.standard.setValue(dictSessionInfo, forKey: "session")
                UserDefaults.standard.setValue(token, forKey: "token")
                counterSessionExpire = 0
                UserDefaults.standard.setValue(counterSessionExpire, forKey: "counterSessionExpire")
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            else{
                if(otpFrom == "login"){
                let msg = "Profile is already registered, would you like to proceed to Payment?"
                
                let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "PAY NOW", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    loginAs = "user"
                    UserDefaults.standard.setValue(nil, forKey: "userDetails")
                    UserDefaults.standard.setValue(nil, forKey: "session")
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "BuySignup") as! BuySignupViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
                let cancelAction = UIAlertAction(title: "LOGOUT", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    loginAs = "guest"
                    UserDefaults.standard.setValue(nil, forKey: "userDetails")
                    UserDefaults.standard.setValue(nil, forKey: "session")
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                }
                else{
                    loginAs = "user"
                    UserDefaults.standard.setValue(nil, forKey: "userDetails")
                    UserDefaults.standard.setValue(nil, forKey: "session")
                    let openPost = self.storyboard!.instantiateViewController(withIdentifier: "BuySignup") as! BuySignupViewController;
                    self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
            }
           // callWebServiceSubscribe()
        }
        else if(dict.object(forKey: "status") as! String == "ERROR"){
            if(dict.object(forKey: "code") as! String == "406"){
                arrValues.removeAllObjects()
                vibrateLabel()
                lblTimer?.isHidden = false
                btnResend?.isHidden = true
                count = 30
                lblTimer?.text = String(format : "Request another OTP in %d seconds", count)
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginViewController.counter), userInfo: nil, repeats: true)
            }
        }
        }
        
        else{
            if(dict.object(forKey: "status") as! String == "OK"){
                
            }
        }
    }
    
    
    func refundTheAmount(amount: String, transctionID: String) {
        let url: String = "https://sample-sdk-server.instamojo.com/refund/"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        let session = URLSession.shared
        let env = "Test Environment"
        let params = ["env": env, "transaction_id": transctionID, "amount": "1200", "type": "PTH", "body": "Refund the Amount"] as [String : Any]
        request.setBodyContent(parameters: params)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {_, _, error -> Void in
            if error == nil {
                print("Refund intiated successfully")
            } else {
                print("Failed to intiate refund")
            }
        })
        task.resume()
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
                //    FBSDKAppEvents.logEvent("logout")

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
    
    //ResendOTP
    
    @IBAction func otpResendTapped(_ sender : UIButton){
        DispatchQueue.main.async {
          self.resendOTPWeb()
        }
        lblTimer?.isHidden = false
        btnResend?.isHidden = true
        count = 30
        lblTimer?.text = String(format : "Request another OTP in %d seconds", count)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginViewController.counter), userInfo: nil, repeats: true)
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
