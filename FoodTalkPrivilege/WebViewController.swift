//
//  WebViewController.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 30/05/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import FBSDKCoreKit
var rules = ""

class WebViewController: UIViewController, UIWebViewDelegate, WebServiceCallingDelegate {
    
    @IBOutlet var webView : UIWebView?
    var url = ""
    @IBOutlet var titleL : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicator(view: self.view)
        // Do any additional setup after loading the view.
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        if(selectedWebType == "faq"){
           url = "http://foodtalk.in/app/faqios.html"
        }
        else if(selectedWebType == "legal"){
           url = "http://foodtalk.in/app/legal.html"
        }
        else if(selectedWebType == "rules"){
           url = rules
        }
        
        if(selectedWebType == "exp"){
//            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
//            let session = dictSessionId.object(forKey: "session_id") as! String
//            url = String(format : "http://foodtalk.in/pe/#!/app/%@", session)
            
            webServiceUpdate()
            delegate = self
        }
        else{
        var  urlString = ""
        if(selectedWebType != "exp"){
        urlString = url.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        }
        else{
        urlString = url
        }
        
        if(isConnectedToNetwork()){
            DispatchQueue.main.async {
                self.webView!.loadRequest(URLRequest(url: URL(string: urlString)!))
            }
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(WebViewController.alertTap), for: .touchUpInside)
        }
        }
        
    }
    
    //MARK:- alertTapped
    
    func alertTap(){
        
        viewAlert.removeFromSuperview()
        webView?.reload()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if(selectedWebType == "faq"){
            FBSDKAppEvents.logEvent("faq_view")
            self.titleL?.text = "FAQ"
        }
        else if(selectedWebType == "legal"){
            FBSDKAppEvents.logEvent("legal_view")
            self.titleL?.text = "LEGAL"
        }
        else if(selectedWebType == "exp"){
            FBSDKAppEvents.logEvent("experiences")
            self.titleL?.text = "EXPERIENCES"
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        stopAnimation()
    }
    
    func webServiceUpdate(){
        showActivityIndicator(view: self.view)
        if (isConnectedToNetwork() == true){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            let url = String(format: "%@%@?sessionid=%@", baseUrl,"profile", session)
            webServiceGet(url)
            delegate = self
        }
        else{
            stopAnimation()
            openAlertScreen(self.view)
            alerButton.addTarget(self, action: #selector(AccountViewController.alertTap), for: .touchUpInside)
        }
    }
    
    func getDataFromWebService(_ dict: NSMutableDictionary) {
        stopAnimation()
        if((dict.object(forKey: "status") as! String) == "OK"){
            let dictSessionId = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            let session = dictSessionId.object(forKey: "session_id") as! String
            url = String(format : "http://foodtalk.in/pe/#!/app/%@", session)
            
            var  urlString = ""
            if(selectedWebType != "exp"){
                urlString = url.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            }
            else{
                urlString = url
            }
            
            if(isConnectedToNetwork()){
                DispatchQueue.main.async {
                    self.webView!.loadRequest(URLRequest(url: URL(string: urlString)!))
                }
            }
            else{
                stopAnimation()
                openAlertScreen(self.view)
                alerButton.addTarget(self, action: #selector(WebViewController.alertTap), for: .touchUpInside)
            }
        }
    }
    
    func backtoNavigate(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func serviceUploadProgress(_ myprogress : float_t){
        
    }
    
    func serviceFailedWitherror(_ error : NSError){
        stopAnimation()
        self.view.isUserInteractionEnabled = true
        UserDefaults.standard.setValue(nil, forKey: "userDetails")
        UserDefaults.standard.setValue(nil, forKey: "session")
        UserDefaults.standard.setValue(nil, forKey: "expiry")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func back(_ sender : UIButton){
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
