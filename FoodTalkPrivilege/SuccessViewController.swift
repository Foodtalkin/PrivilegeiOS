//
//  SuccessViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 26/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import MessageUI
import FBSDKCoreKit

class SuccessViewController: UIViewController, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, WebServiceCallingDelegate {
    
    @IBOutlet var lblRid : UILabel?
    @IBOutlet var btnDone : UIButton?
    @IBOutlet var imgSuccess : UIImageView?
    @IBOutlet var lblSuccess : UILabel?
    @IBOutlet var lblDescribe : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(comingSuccessFrom == "Redeem"){
         lblDescribe?.isUserInteractionEnabled = true
         imgSuccess?.image = UIImage(named : "group12.png")
         lblRid?.text = String(format: "RID : %@", rid)
         lblSuccess?.text = "Bon Appetit!"
         let describeText = "Offer redemption successful! Contact us for any queries."
         let range = (describeText as NSString).range(of: "Contact us")
        let attributedString = NSMutableAttributedString(string:(describeText))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: colorBrightSkyBlue , range: range)
        lblDescribe?.attributedText = attributedString
            
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SuccessViewController.descAction(_:)))
            lblDescribe?.addGestureRecognizer(tap)
            tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
         webServiceForSaved()
            
         btnDone?.setTitle("Done", for: .normal)
            if((UserDefaults.standard.object(forKey: "neverRate")) != nil){
                if(UserDefaults.standard.bool(forKey: "neverRate") == false){
                   showRateMe()
                }
            }
            else{
              showRateMe()
            }
        }
        else if(comingSuccessFrom == "Payment"){
         lblRid?.isHidden = true
            if(transactionResult == "success"){
               lblSuccess?.text = "Welcome aboard"
                lblDescribe?.text = "You have successfully purchased Food Talk Privilege. Say hello to a year of endless meals and deals!"

               imgSuccess?.image = UIImage(named : "paySuccess.png")
                btnDone?.setTitle("Done", for: .normal)
                btnDone?.setTitle("Start Redeeming", for: .normal)
            }
            else{
               lblSuccess?.text = "Something’s wrong"
               lblDescribe?.text = "Oops! The transaction failed. Please try again or contact our support."
               imgSuccess?.image = UIImage(named : "wrong.png")
                btnDone?.setTitle("Retry Payment", for: .normal)
            }
        }
        else if(comingSuccessFrom == "Event"){
            lblRid?.isHidden = true
            if(transactionResult == "success"){
                lblSuccess?.text = "SUCCESS"
                lblDescribe?.text = String(format : "You have successfully purchased %@ Tickets for event %@." , totalGuest,eventNamePurchased)
                
                imgSuccess?.image = UIImage(named : "paySuccess.png")
                btnDone?.setTitle("Done", for: .normal)
                btnDone?.setTitle("Go to tickets", for: .normal)
            }
            else{
                lblSuccess?.text = "Something’s wrong"
                lblDescribe?.text = "Oops! The transaction failed. Please try again or contact our support."
                imgSuccess?.image = UIImage(named : "wrong.png")
                btnDone?.setTitle("Retry Payment", for: .normal)
            }
        }
        setDownLine(btnDone!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // Receive action
    func descAction(_ gr:UITapGestureRecognizer)
    {
        contactUs()
    }
    
    //MARK:- contactUS
    
    func contactUs(){
        let emailTitle = "Contact Us"
        let messageBody = ""
        let toRecipents = ["contact@foodtalkindia.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        if (MFMailComposeViewController.canSendMail()) {
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: true)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        }
    }
    
    //MARK:- mailComposer delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender : UIButton){
        if(comingSuccessFrom == "Redeem"){
           FBSDKAppEvents.logEvent("redemption")
           let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            var ind = 0
            for vc in viewControllers{
                
                if(vc.isKind(of: HomeViewController.self)) {
                    self.navigationController!.popToViewController(viewControllers[ind], animated: true);
                    break
                }
                ind = ind + 1
            }
            
            
        }
        else{
            if(comingSuccessFrom == "Payment"){
           if(transactionResult == "success"){
            loginAs = "user"
            UserDefaults.standard.setValue(dictUserDetails, forKey: "userDetails")
            UserDefaults.standard.setValue(dictSessionInfo, forKey: "session")
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            var ind = 0
            for vc in viewControllers{
                
                if(vc.isKind(of: HomeViewController.self)) {
                    self.navigationController!.popToViewController(viewControllers[ind], animated: true);
                    break
                }
                ind = ind + 1
            }
            
            if(ind == viewControllers.count){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
            }
            
            }
           else{
            self.navigationController?.popViewController(animated: true)
           }
            }
            else if(comingSuccessFrom == "Event"){
                if(transactionResult == "success"){
                let openPost = self.storyboard!.instantiateViewController(withIdentifier: "Tickets") as! TicketsViewController;
                self.navigationController!.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
                }
                else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: "Rate Us", message: "Enjoying Food Talk Privilege, share the love by rating us on appstore.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Rate Now", style: UIAlertActionStyle.default, handler: { alertAction in
            UIApplication.shared.openURL(URL(string : "http://itunes.apple.com/app/id1246265932?mt=8")!)
            UserDefaults.standard.set(true, forKey: "neverRate")
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.default, handler: { alertAction in
            UserDefaults.standard.set(true, forKey: "neverRate")
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: { alertAction in
            UserDefaults.standard.set(true, forKey: "neverRate")
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webServiceForSaved(){
        let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
        let session = dictSessionId.object(forKey: "session_id") as! String
        
        if (isConnectedToNetwork() == true){
            let url = String(format: "%@%@sessionid=%@", baseUrl,"profile?", session)
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation(view: self.view)
            
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        if(dict.object(forKey: "status") as! String == "OK"){
            let saved = (dict.object(forKey: "result") as! NSDictionary).object(forKey: "saving") as! String
            UserDefaults.standard.set(saved, forKey: "saved")
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
