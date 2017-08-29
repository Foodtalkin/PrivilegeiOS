//
//  BuySignupViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 19/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
//import Instamojo
import FBSDKCoreKit
import Fabric
import Crashlytics

var transactionID = ""
var transactionResult = ""
class BuySignupViewController: UIViewController, WebServiceCallingDelegate, PGTransactionDelegate {
    
    @IBOutlet var btnBuy : UIButton?
    @IBOutlet var btnBack : UIButton?
    @IBOutlet var viewBase : UIView?
    @IBOutlet var viewPrivilage : UIView?
    
    @IBOutlet var lbl1 : UILabel?
    @IBOutlet var lbl2 : UILabel?
    @IBOutlet var lbl3 : UILabel?
    
    @IBOutlet var lblHeading : UILabel?
    @IBOutlet var lblPrivilege : UILabel?
    @IBOutlet var lblPrice : UILabel?
    @IBOutlet var lblYear : UILabel?
    @IBOutlet var viewHr : UIView?
    
    @IBOutlet var lblPay : UILabel?
    
    var accessToken: String!
    var dictParaPayTm = NSDictionary()
    var isPurchased : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBase?.layer.cornerRadius = 15
        viewBase?.layer.masksToBounds = true
        manageScreen()
        setDownLine(btnBuy!)
     //   Instamojo.setup()
        
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [ NSFontAttributeName: UIFont(name: fontAbril, size: 18)!, NSForegroundColorAttributeName: colorLightGold]
  
        
        var backImage: UIImage = UIImage(named: "fill301.png")!
        backImage = backImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "FOOD TALK"
        stopAnimation()
        self.navigationController?.isNavigationBarHidden = false
        if(isPurchased == true){
            
                self.callWebServiceSubscribe()
                isPurchased = false
        }
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            loginAs = "guest"
        }
    }
    
    func manageScreen(){
        btnBack?.frame = CGRect(x : 20, y : 25, width : 40, height : 20)
        lblHeading?.frame = CGRect(x : self.view.frame.size.width/2 - 70, y: 20,width : 139, height : 58)
        viewBase?.frame = CGRect(x: 20, y: (lblHeading?.frame.size.height)! + 20, width : self.view.frame.size.width - 40, height : self.view.frame.size.height - 180)
        if(UIScreen.main.bounds.height < 500){
            viewPrivilage?.frame = CGRect(x: 0, y : 0, width : (viewBase?.frame.size.width)!, height : 100)
            lblPrivilege?.frame = CGRect(x: 0, y : 10, width : (viewBase?.frame.size.width)!, height : 20)
            lblPrice?.frame = CGRect(x: 10, y: 35, width : (viewPrivilage?.frame.size.width)! - 20, height : 44)
            lblYear?.frame = CGRect(x: 0, y: 81, width : (viewPrivilage?.frame.size.width)!, height : 15)
            lbl1?.frame = CGRect(x: 0, y : (viewPrivilage?.frame.size.height)! + 20, width : (viewBase?.frame.size.width)!, height : 54)
             lbl2?.frame = CGRect(x: 0, y : (lbl1?.frame.origin.y)! + (lbl1?.frame.size.height)! + 10, width : (viewBase?.frame.size.width)!, height : 60)
            lbl3?.frame = CGRect(x: 0, y : (lbl2?.frame.origin.y)! + (lbl2?.frame.size.height)! + 10, width : (viewBase?.frame.size.width)!, height : 60)
        }
        else if(UIScreen.main.bounds.height < 570){
            viewPrivilage?.frame = CGRect(x: 0, y : 0, width : (viewBase?.frame.size.width)!, height : 120)
            lblPrivilege?.frame = CGRect(x: 0, y : 10, width : (viewBase?.frame.size.width)!, height : 20)
            lblPrice?.frame = CGRect(x: 0, y: 35, width : (viewPrivilage?.frame.size.width)!, height : 44)
            lblYear?.frame = CGRect(x: 0, y: 81, width : (viewPrivilage?.frame.size.width)!, height : 15)
            lbl1?.frame = CGRect(x: 10, y : (viewPrivilage?.frame.size.height)! + 20, width : (viewBase?.frame.size.width)! - 20, height : 54)
            lbl2?.frame = CGRect(x: 15, y : (lbl1?.frame.origin.y)! + (lbl1?.frame.size.height)! + 10, width : (viewBase?.frame.size.width)! - 30, height : 60)
            lbl3?.frame = CGRect(x: 10, y : (lbl2?.frame.origin.y)! + (lbl2?.frame.size.height)! + 10, width : (viewBase?.frame.size.width)! - 20, height : 60)
        }
        else if(UIScreen.main.bounds.height > 670){
            viewPrivilage?.frame = CGRect(x: 0, y : 0, width : (viewBase?.frame.size.width)!, height : 120)
            lblPrivilege?.frame = CGRect(x: 0, y : 10, width : (viewBase?.frame.size.width)!, height : 20)
            lblPrice?.frame = CGRect(x: 0, y: 35, width : (viewPrivilage?.frame.size.width)!, height : 44)
            lblYear?.frame = CGRect(x: 0, y: 81, width : (viewPrivilage?.frame.size.width)!, height : 15)
            lbl1?.frame = CGRect(x: 10, y : (viewPrivilage?.frame.size.height)! + 70, width : (viewBase?.frame.size.width)! - 20, height : 54)
            lbl2?.frame = CGRect(x: 15, y : (lbl1?.frame.origin.y)! + (lbl1?.frame.size.height)! + 50, width : (viewBase?.frame.size.width)! - 30, height : 60)
            lbl3?.frame = CGRect(x: 10, y : (lbl2?.frame.origin.y)! + (lbl2?.frame.size.height)! + 50, width : (viewBase?.frame.size.width)! - 20, height : 60)
        }
        else{
            viewPrivilage?.frame = CGRect(x: 0, y : 0, width : (viewBase?.frame.size.width)!, height : 150)
            lblPrivilege?.frame = CGRect(x: 0, y : 20, width : (viewBase?.frame.size.width)!, height : 20)
            lblPrice?.frame = CGRect(x: 0, y: 50, width : (viewPrivilage?.frame.size.width)!, height : 44)
            lblYear?.frame = CGRect(x: 0, y: 101, width : (viewPrivilage?.frame.size.width)!, height : 15)
            lbl1?.frame = CGRect(x: 0, y : (viewPrivilage?.frame.size.height)! + 40, width : (viewBase?.frame.size.width)!, height : 54)
             lbl2?.frame = CGRect(x: 15, y : (lbl1?.frame.origin.y)! + (lbl1?.frame.size.height)! + 30, width : (viewBase?.frame.size.width)! - 30, height : 60)
            lbl3?.frame = CGRect(x: 0, y : (lbl2?.frame.origin.y)! + (lbl2?.frame.size.height)! + 30, width : (viewBase?.frame.size.width)!, height : 60)
        }
        
        viewHr?.frame = CGRect(x: 0, y : (viewPrivilage?.frame.size.height)! - 1, width : (viewPrivilage?.frame.size.width)!, height : 1)
        
        btnBuy?.frame = CGRect(x: self.view.frame.size.width/2 - 80, y : self.view.frame.size.height - 80, width : 160, height : 60)
        
        lblPay?.frame = CGRect(x : self.view.frame.size.width/2 - 80, y : self.view.frame.size.height - 50, width : 160, height : 30)
    }
    
    
    func paymentCompletionCallBack() {
        comingSuccessFrom = "Payment"
        callWebServiceSubscribe()
    }
    
    @IBAction func buyTapped(_ sender : UIButton){
        if(loginAs == "user"){
            showActivityIndicator(view: self.view)
         //   callPayment()
            webCallForPaytm()
        }
        else{
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController;
        self.navigationController!.pushViewController(openPost, animated: true)
        }
    }
    
    @IBAction func back(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- webservices
    
    func callWebServiceSubscribe(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
         //   let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionInfo.object(forKey: "session_id") as! String
            let url = String(format: "%@%@?sessionid=%@", baseUrl,"subscribe", session)
            let dict = NSMutableDictionary()
            dict.setObject(transactionID, forKey: "order_id" as NSCopying)
            
            webServiceCallingPost(url, parameters: dict)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(LoginViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        
        if((dict.object(forKey: "api") as! String).contains("subscriptionPayment")){
           if(dict.object(forKey: "status") as! String == "OK"){
            if(dict.object(forKey: "status") as! String == "OK"){
                let dic = dict.object(forKey: "result") as! NSDictionary
                let orderid = (dic.object(forKey: "order") as! NSDictionary).object(forKey: "order_id") as! String
                let accessToken = dic.object(forKey: "access_token") as! String
                transactionID = (dic.object(forKey: "transaction") as! NSDictionary).object(forKey: "id") as! String
           
            }
        }
      }
        else if((dict.object(forKey: "api") as! String).contains("subscribe")){
            stopAnimation()
            if(dict.object(forKey: "message") as! String == "Success"){
                let arrSubscribe = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "subscription") as! NSArray
                let expiry = (arrSubscribe.object(at: 0) as! NSDictionary).object(forKey: "expiry") as? String
                
                let currentInstallation = PFInstallation.current()
                currentInstallation.setObject(expiry!, forKey: "expiry")
                currentInstallation.saveInBackground()
                UserDefaults.standard.setValue(expiry, forKey: "expiry")
                transactionResult = "success"
                FBSDKAppEvents.logPurchase(0.0, currency: "Rupees")
                
                Answers.logPurchase(withPrice: 1200,
                                             currency: "Ruppees",
                                             success: true,
                                             itemName: "FoodTalk Privilege",
                                             itemType: "Purchased",
                                             itemId: "fti",
                                             customAttributes: [:])
            }
            else{
                transactionResult = "failure"
            }
            
            let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Success") as! SuccessViewController;
            self.navigationController!.pushViewController(openPost, animated: true)
        }
        else if((dict.object(forKey: "api") as! String).contains("paytm_order")){
            if(dict.object(forKey: "status") as! String == "OK"){
                dictParaPayTm = dict.object(forKey: "result") as! NSDictionary
                transactionID = dictParaPayTm.object(forKey: "ORDER_ID") as! String
                callPaytm()
            }
        }
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation()
        self.view.isUserInteractionEnabled = true

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
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
    }
    

    func checkPaymentStatus() {
        
        if accessToken == nil {
            return
        }
        
        self.callWebServiceSubscribe()
        
    }
    

    
    
    //MARK:- PayTm Methods
    
    func webCallForPaytm(){
        let session = dictSessionInfo.object(forKey: "session_id") as! String
        let url = String(format: "%@%@?sessionid=%@", baseUrl,"paytm_order", session)
        let dict = NSMutableDictionary()
        dict.setObject("1", forKey: "subscription_type_id" as NSCopying)
        webServiceCallingPost(url, parameters: dict)
        delegate = self

    }
    
    func callPaytm(){
        let merchantConfig = PGMerchantConfiguration.default()
        
        
        
        let order: PGOrder = PGOrder(params: dictParaPayTm as! [AnyHashable : Any])
        
        let transactionController = PGTransactionViewController.init(transactionFor: order)
        transactionController? .serverType = eServerTypeProduction
        transactionController? .merchant = merchantConfig
        transactionController? .delegate = self
        self.showController(transactionController!)
        
    }
    
    func showController(_ controller : PGTransactionViewController){
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func removeController(_ controller : PGTransactionViewController){
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: Delegate methods.
    
    func didCancelTrasaction(_ controller: PGTransactionViewController!) {
        print("Transaction has been Cancelled")
        comingSuccessFrom = "Payment"
        transactionResult = "failure"
        self.removeController(controller)
        let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Success") as! SuccessViewController;
        self.navigationController!.pushViewController(openPost, animated: true)
    }
    
    func didFinishedResponse(_ controller: PGTransactionViewController!, response responseString: String) {
        comingSuccessFrom = "Payment"
        isPurchased = true
        self.removeController(controller)
    }
    
    func errorMisssingParameter(_ controller: PGTransactionViewController!, error: Error!) {
        print(error)
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
